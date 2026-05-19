import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_ascolto/utils/test_utils.dart';

import 'package:mi_ascolto/widgets/diary/diary_compact_event_card.dart';
import 'package:mi_ascolto/repository/diary_repository.dart';


void main() {
  group('DiaryCompactEventCard', () {
    Future<void> pumpDiaryCompactEventCard(
        WidgetTester tester, {
          required DiaryEntry entry,
          VoidCallback? onTap,
        }) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DiaryCompactEventCard(
              entry: entry,
              onTap: onTap ?? () {},
            ),
          ),
        ),
      );

      await tester.pump();
    }

    testWidgets('mostra correttamente una card pasto', (tester) async {
      final group = sampleWeekGroup();

      final mealEntry = group.days
          .expand((day) => day.entries)
          .whereType<MealDiaryEntry>()
          .first;

      await pumpDiaryCompactEventCard(
        tester,
        entry: mealEntry,
      );

      expect(find.text('PASTO'), findsOneWidget);
      expect(find.text('Pranzo'), findsWidgets);
    });

    testWidgets('mostra correttamente una card esercizio', (tester) async {
      final group = sampleWeekGroup();

      final exerciseEntry = group.days
          .expand((day) => day.entries)
          .whereType<ExerciseDiaryEntry>()
          .first;

      await pumpDiaryCompactEventCard(
        tester,
        entry: exerciseEntry,
      );

      expect(find.text('ESERCIZIO'), findsWidgets);
      expect(find.textContaining('Corsa'), findsWidgets);
    });

    testWidgets('quando tocchi la card chiama onTap', (tester) async {
      final group = sampleWeekGroup();

      final entry = group.days.first.entries.first;

      var tapped = false;

      await pumpDiaryCompactEventCard(
        tester,
        entry: entry,
        onTap: () {
          tapped = true;
        },
      );

      await tester.tap(find.byType(DiaryCompactEventCard));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });
}