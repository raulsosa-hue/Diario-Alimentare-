import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_ascolto/repository/diary_repository.dart';
import 'package:mi_ascolto/utils/test_utils.dart';
import 'package:mi_ascolto/widgets/diary/diary_compact_event_card.dart';
import 'package:mi_ascolto/widgets/diary/week_expansion_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpWeekExpansionCard(
      WidgetTester tester, {
        required DiaryWeekGroup group,
        bool initiallyExpanded = true,
        bool isSharing = false,
        VoidCallback? onShare,
        ValueChanged<DiaryEntry>? onEntryTap,
      }) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: WeekExpansionCard(
                  group: group,
                  initiallyExpanded: initiallyExpanded,
                  isSharing: isSharing,
                  onShare: onShare ?? () {},
                  onEntryTap: onEntryTap ?? (_) {},
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pump();
  }

  group('WeekExpansionCard', () {
    testWidgets('mostra intestazione settimana e conteggi', (tester) async {
      await pumpWeekExpansionCard(
        tester,
        group: sampleWeekGroup(),
      );

      expect(find.textContaining('SETTIMANA'), findsOneWidget);
      expect(find.textContaining('1 giorno · 2 eventi'), findsOneWidget);
      expect(find.text('2 eventi'), findsOneWidget);
    });

    testWidgets('WeekExpansionCard mostra gli eventi quando inizialmente espansa', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeekExpansionCard(
              group: sampleWeekGroup(),
              initiallyExpanded: true,
              isSharing: false,
              onShare: () {},
              onEntryTap: (_) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(DiaryCompactEventCard), findsNWidgets(2));

      expect(find.textContaining('PASTO'), findsWidgets);
      expect(find.textContaining('ESERCIZIO'), findsWidgets);

      expect(find.textContaining('Pranzo'), findsWidgets);
      expect(find.textContaining('Corsa'), findsWidgets);
    });

    testWidgets('WeekExpansionCard se initiallyExpanded è false parte chiusa', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeekExpansionCard(
              group: sampleWeekGroup(),
              initiallyExpanded: false,
              isSharing: false,
              onShare: () {},
              onEntryTap: (_) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(WeekExpansionCard), findsOneWidget);

      // La settimana esiste
      expect(find.textContaining('SETTIMANA'), findsOneWidget);

      // Ma gli eventi non devono essere visibili subito
      expect(find.byType(DiaryCompactEventCard), findsNothing);
    });

    testWidgets('WeekExpansionCard apre gli eventi quando tocchi la settimana', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeekExpansionCard(
              group: sampleWeekGroup(),
              initiallyExpanded: false,
              isSharing: false,
              onShare: () {},
              onEntryTap: (_) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(WeekExpansionCard), findsOneWidget);
      expect(find.byType(DiaryCompactEventCard), findsNothing);
      expect(find.text('Pranzo'), findsNothing);
      expect(find.textContaining('Corsa'), findsNothing);

      await tester.tap(find.textContaining('SETTIMANA'));
      await tester.pumpAndSettle();

      expect(find.byType(DiaryCompactEventCard), findsNWidgets(2));
      expect(find.text('Pranzo'), findsWidgets);
      expect(find.textContaining('Corsa'), findsWidgets);
    });

    testWidgets('tap sulla settimana apre e chiude gli eventi', (tester) async {
      await pumpWeekExpansionCard(
        tester,
        group: sampleWeekGroup(),
        initiallyExpanded: false,
      );

      expect(find.text('Pranzo'), findsNothing);

      await tester.tap(find.textContaining('SETTIMANA'));
      await tester.pumpAndSettle();

      expect(find.text('Pranzo'), findsOneWidget);
      expect(find.text('Pasta al pomodoro'), findsOneWidget);

      await tester.tap(find.textContaining('SETTIMANA'));
      await tester.pumpAndSettle();

      expect(find.text('Pranzo'), findsNothing);
      expect(find.text('Pasta al pomodoro'), findsNothing);
    });

    testWidgets('tap su un evento chiama onEntryTap', (tester) async {
      DiaryEntry? tappedEntry;

      await pumpWeekExpansionCard(
        tester,
        group: sampleWeekGroup(),
        initiallyExpanded: true,
        onEntryTap: (entry) {
          tappedEntry = entry;
        },
      );

      final firstCard = find.byType(DiaryCompactEventCard).first;

      await tester.ensureVisible(firstCard);
      await tester.tap(firstCard);
      await tester.pumpAndSettle();

      expect(tappedEntry, isNotNull);
      expect(tappedEntry, isA<MealDiaryEntry>());
    });

    testWidgets('tap sul bottone share chiama onShare', (tester) async {
      var shareCalled = false;

      await pumpWeekExpansionCard(
        tester,
        group: sampleWeekGroup(),
        onShare: () {
          shareCalled = true;
        },
      );

      final shareButton = find.byIcon(Icons.ios_share_rounded);

      expect(shareButton, findsOneWidget);

      await tester.tap(shareButton);
      await tester.pumpAndSettle();

      expect(shareCalled, isTrue);
    });

    testWidgets('se isSharing è true mostra il loader al posto dello share', (
        tester,
        ) async {
      await pumpWeekExpansionCard(
        tester,
        group: sampleWeekGroup(),
        isSharing: true,
      );

      expect(find.byIcon(Icons.ios_share_rounded), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}