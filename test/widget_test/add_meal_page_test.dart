import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mi_ascolto/models/meal.dart';
import 'package:mi_ascolto/pages/add_meal_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpAddMealPage(
      WidgetTester tester, {
        Map<String, Object> prefs = const {},
      }) async {
    SharedPreferences.setMockInitialValues(prefs);

    await tester.pumpWidget(
      const MaterialApp(
        home: AddMealPage(),
      ),
    );

    await tester.pump();
    await tester.pumpAndSettle();
  }

  Finder textFieldWithHint(String hint) {
    return find.byWidgetPredicate((widget) {
      return widget is TextField && widget.decoration?.hintText == hint;
    });
  }

  Future<void> tapVisibleText(
      WidgetTester tester,
      String text, {
        bool last = false,
      }) async {
    final finder = find.text(text);
    expect(finder, findsWidgets);

    final target = last ? finder.last : finder.first;

    await tester.ensureVisible(target);
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  group('AddMealPage', () {
    testWidgets('mostra lo step Prima con i campi iniziali', (tester) async {
      await pumpAddMealPage(tester);

      expect(find.text('Nuovo pasto principale'), findsOneWidget);
      expect(find.text('Prenditi un momento per ascoltarti'), findsOneWidget);

      expect(find.text('Prima'), findsOneWidget);
      expect(find.text('Pasto'), findsOneWidget);
      expect(find.text('Dopo'), findsOneWidget);

      expect(find.text('Come mi sento prima di mangiare?'), findsOneWidget);
      expect(find.text('Racconta il momento prima di mangiare.'), findsOneWidget);

      expect(find.text('Contesto'), findsOneWidget);
      expect(textFieldWithHint('Dove sono?'), findsOneWidget);
      expect(textFieldWithHint('Con chi sono?'), findsOneWidget);

      expect(find.text('Corpo'), findsOneWidget);
      expect(textFieldWithHint('Che sensazioni fisiche noto?'), findsOneWidget);

      expect(find.text('Intensità emotiva 0–10'), findsOneWidget);
      expect(find.text('Emozioni'), findsOneWidget);
      expect(textFieldWithHint('Pensiero'), findsOneWidget);
    });

    testWidgets('passa allo step Pasto e mostra i campi del pasto', (tester) async {
      await pumpAddMealPage(tester);

      await tapVisibleText(tester, 'Pasto');

      expect(find.text('Pasto'), findsWidgets);
      expect(find.text('Registra il momento del pasto.'), findsOneWidget);

      expect(find.text('Orario'), findsOneWidget);
      expect(find.text('Inizio'), findsOneWidget);
      expect(find.text('Fine'), findsOneWidget);

      expect(find.text('Cosa mangio'), findsOneWidget);
      expect(textFieldWithHint('Descrivi il pasto...'), findsOneWidget);

      expect(find.text(kMealTypes.first), findsOneWidget);
    });

    testWidgets('permette di cambiare il tipo di pasto', (tester) async {
      await pumpAddMealPage(tester);

      await tapVisibleText(tester, 'Pasto');

      expect(find.text(kMealTypes.first), findsOneWidget);

      await tapVisibleText(tester, kMealTypes.first);

      expect(find.text('Tipo di pasto'), findsOneWidget);

      final newMealType = kMealTypes.contains('Cena') ? 'Cena' : kMealTypes.last;

      await tapVisibleText(tester, newMealType, last: true);

      expect(find.text(newMealType), findsOneWidget);
    });

    testWidgets('permette di scrivere cosa mangio', (tester) async {
      await pumpAddMealPage(tester);

      await tapVisibleText(tester, 'Pasto');

      final foodField = textFieldWithHint('Descrivi il pasto...');
      expect(foodField, findsOneWidget);

      await tester.enterText(foodField, 'Pasta al pomodoro');
      await tester.pump();

      expect(find.text('Pasta al pomodoro'), findsOneWidget);
    });

    testWidgets('passa allo step Dopo e mostra i campi dopo pasto', (tester) async {
      await pumpAddMealPage(tester);

      await tapVisibleText(tester, 'Dopo');

      expect(find.text('Come mi sento dopo il pasto?'), findsOneWidget);
      expect(find.text('Osserva come stai dopo aver mangiato.'), findsOneWidget);

      expect(find.text('Corpo'), findsOneWidget);
      expect(textFieldWithHint('Che sensazioni fisiche noto?'), findsOneWidget);

      expect(find.text('Intensità emotiva 0–10'), findsOneWidget);
      expect(find.text('Emozioni'), findsOneWidget);
      expect(textFieldWithHint('Pensiero'), findsOneWidget);
    });

    testWidgets(
      'mostra errore se provo a salvare senza ora di fine',
          (tester) async {
        await pumpAddMealPage(tester);

        await tapVisibleText(tester, 'Dopo');

        final saveButton = find.text('Salva');
        expect(saveButton, findsOneWidget);

        await tester.tap(saveButton);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(
          find.text('Inserisci ora di inizio e fine del pasto'),
          findsOneWidget,
        );

        expect(find.text('Registra il momento del pasto.'), findsOneWidget);
        expect(find.text('Fine'), findsOneWidget);
      },
    );

    testWidgets('carica una bozza salvata da SharedPreferences', (tester) async {
      final mealType = kMealTypes.contains('Cena') ? 'Cena' : kMealTypes.last;

      final draft = jsonEncode({
        'dateTimeMillis': DateTime(2026, 1, 10, 20, 30).millisecondsSinceEpoch,
        'mealType': mealType,
        'where': 'Casa',
        'withWho': 'Da solo',
        'bodyBefore': 'Ho fame',
        'intensityBefore': 4,
        'emotionsBefore': null,
        'thoughtBefore': 'Mangio qualcosa di semplice',
        'startTimeMinutes': 20 * 60 + 30,
        'endTimeMinutes': 20 * 60 + 45,
        'whatEat': 'Yogurt e frutta',
        'bodyAfter': 'Mi sento sazio',
        'intensityAfter': 2,
        'emotionsAfter': null,
        'thoughtAfter': 'Sto meglio',
        'currentStep': 1,
      });

      await pumpAddMealPage(
        tester,
        prefs: {
          'add_meal_draft_v1': draft,
        },
      );

      expect(find.text('Registra il momento del pasto.'), findsOneWidget);
      expect(find.text(mealType), findsOneWidget);
      expect(find.text('Yogurt e frutta'), findsOneWidget);
    });
  });
}