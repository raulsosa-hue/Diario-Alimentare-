import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_ascolto/pages/add_exercise_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildTestPage() {
    return const MaterialApp(
      home: AddExercisePage(),
    );
  }

  Future<void> pumpAddExercisePage(WidgetTester tester) async {
    await tester.pumpWidget(buildTestPage());
    await tester.pumpAndSettle();
  }

  group('AddExercisePage', () {
    testWidgets('mostra correttamente lo step Prima', (tester) async {
      await pumpAddExercisePage(tester);

      expect(find.text('Nuovo esercizio'), findsOneWidget);
      expect(
        find.text('Registra movimento, emozioni e sensazioni'),
        findsOneWidget,
      );

      expect(find.text('Prima dell’esercizio'), findsOneWidget);
      expect(
        find.text('Osserva perché vuoi muoverti e come ti senti.'),
        findsOneWidget,
      );

      expect(find.text('Intenzione'), findsOneWidget);
      expect(find.text('Benessere / Energia'), findsOneWidget);
      expect(find.text('Gestire emozioni / Stress'), findsOneWidget);
      expect(find.text('Bruciare / Rimediare al cibo'), findsOneWidget);
      expect(find.text('Controllo / Punizione'), findsOneWidget);

      expect(find.text('Intensità emotiva 0–10'), findsOneWidget);
      expect(find.text('Emozioni'), findsOneWidget);
      expect(find.text('Pensiero'), findsOneWidget);
    });

    testWidgets('permette di scrivere un pensiero nello step Prima', (
        tester,
        ) async {
      await pumpAddExercisePage(tester);

      final textFieldFinder = find.byType(TextField);

      expect(textFieldFinder, findsOneWidget);

      await tester.enterText(textFieldFinder, 'Mi sento un po’ agitato');
      await tester.pump();

      expect(find.text('Mi sento un po’ agitato'), findsOneWidget);
    });

    testWidgets('passando allo step Esercizio mostra scelta esercizio e durata', (
        tester,
        ) async {
      await pumpAddExercisePage(tester);

      await tester.tap(find.text('Esercizio'));
      await tester.pumpAndSettle();

      expect(find.text('Registra il tipo di movimento e la durata.'), findsOneWidget);

      expect(find.text('Scegli esercizio'), findsOneWidget);
      expect(find.text('20 min'), findsOneWidget);

      expect(
        find.text(
          'Scegli sopra il tipo di esercizio svolto e indica per quanto tempo ti sei mosso.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('la durata aumenta e diminuisce di 5 minuti', (tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await pumpAddExercisePage(tester);

      await tester.tap(find.text('Esercizio'));
      await tester.pumpAndSettle();

      expect(find.text('20 min'), findsOneWidget);

      final addButton = find.byIcon(Icons.add_rounded).last;

      await tester.ensureVisible(addButton);
      await tester.pumpAndSettle();

      await tester.tap(addButton, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.text('25 min'), findsOneWidget);
      expect(find.text('20 min'), findsNothing);

      final removeButton = find.byIcon(Icons.remove_rounded).last;

      await tester.ensureVisible(removeButton);
      await tester.pumpAndSettle();

      await tester.tap(removeButton, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.text('20 min'), findsOneWidget);
      expect(find.text('25 min'), findsNothing);
    });

    testWidgets('la durata non scende sotto i 5 minuti', (tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await pumpAddExercisePage(tester);

      await tester.tap(find.text('Esercizio'));
      await tester.pumpAndSettle();

      expect(find.text('20 min'), findsOneWidget);

      final minusButton = find.byKey(const Key('exercise_duration_minus'));

      await tester.ensureVisible(minusButton);
      await tester.pumpAndSettle();

      for (var i = 0; i < 10; i++) {
        await tester.tap(minusButton);
        await tester.pumpAndSettle();
      }

      expect(find.text('5 min'), findsOneWidget);
      expect(find.text('0 min'), findsNothing);
    });

    testWidgets('apre il bottom sheet e permette di scegliere un esercizio', (
        tester,
        ) async {
      await pumpAddExercisePage(tester);

      await tester.tap(find.text('Esercizio'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Scegli esercizio'));
      await tester.pumpAndSettle();

      expect(find.text('Tipo di esercizio'), findsOneWidget);
      expect(
        find.text('Scegli il movimento che descrive meglio quello che hai fatto.'),
        findsOneWidget,
      );

      expect(find.text('Camminata'), findsOneWidget);
      expect(find.text('Corsa / Running'), findsOneWidget);
      expect(find.text('Bici'), findsOneWidget);
      expect(find.text('Palestra / Pesi'), findsOneWidget);

      await tester.tap(find.text('Corsa / Running'));
      await tester.pumpAndSettle();

      expect(find.text('Corsa / Running'), findsOneWidget);
      expect(find.text('Scegli esercizio'), findsNothing);
    });

    testWidgets('permette di inserire un esercizio personalizzato', (
        tester,
        ) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await pumpAddExercisePage(tester);

      await tester.tap(find.text('Esercizio'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Scegli esercizio'));
      await tester.pumpAndSettle();

      expect(find.text('Tipo di esercizio'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Altro esercizio'),
        300,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Altro esercizio'));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Altro esercizio'), findsOneWidget);
      expect(find.text('Scrivi qui…'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Padel');
      await tester.pump();

      await tester.tap(find.text('Aggiungi'));
      await tester.pumpAndSettle();

      expect(find.text('Padel'), findsOneWidget);
      expect(find.text('Scegli esercizio'), findsNothing);
    });

    testWidgets('passando allo step Dopo mostra i campi corretti', (
        tester,
        ) async {
      await pumpAddExercisePage(tester);

      await tester.tap(find.text('Dopo'));
      await tester.pumpAndSettle();

      expect(find.text('Dopo l’esercizio'), findsOneWidget);
      expect(
        find.text('Osserva cosa è cambiato dopo il movimento.'),
        findsOneWidget,
      );

      expect(find.text('Esito'), findsOneWidget);
      expect(find.text('Più libero / leggero'), findsOneWidget);
      expect(find.text('Uguale'), findsOneWidget);
      expect(find.text('Più in colpa / più rigido'), findsOneWidget);
      expect(find.text('Ansia peggiorata / urgenza'), findsOneWidget);

      expect(find.text('Corpo'), findsOneWidget);
      expect(find.text('Che sensazioni fisiche noto?'), findsOneWidget);

      expect(find.text('Intensità emotiva 0–10'), findsOneWidget);
      expect(find.text('Emozioni'), findsOneWidget);
      expect(find.text('Pensiero'), findsOneWidget);
    });

    testWidgets('permette di scrivere corpo e pensiero nello step Dopo', (
        tester,
        ) async {
      await pumpAddExercisePage(tester);

      await tester.tap(find.text('Dopo'));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);

      expect(textFields, findsNWidgets(2));

      await tester.enterText(textFields.at(0), 'Gambe leggere');
      await tester.enterText(textFields.at(1), 'Mi sento più tranquillo');
      await tester.pump();

      expect(find.text('Gambe leggere'), findsOneWidget);
      expect(find.text('Mi sento più tranquillo'), findsOneWidget);
    });
  });
}
