import 'package:flutter_test/flutter_test.dart';
import 'package:mi_ascolto/repository/diary_repository.dart';
import 'package:mi_ascolto/utils/test_utils.dart';



void main() {
  group('mondayOf', () {
    test('restituisce il lunedì della stessa settimana', () {
      final result = mondayOf(DateTime(2026, 5, 21)); // Giovedì

      expect(result, DateTime(2026, 5, 18));
    });

    test('se la data è già lunedì restituisce la stessa data senza orario', () {
      final result = mondayOf(DateTime(2026, 5, 18, 15, 30));

      expect(result, DateTime(2026, 5, 18));
    });

    test('funziona anche quando la settimana attraversa due mesi', () {
      final result = mondayOf(DateTime(2026, 6, 3)); // Mercoledì

      expect(result, DateTime(2026, 6, 1));
    });

    test('funziona anche quando la settimana attraversa due anni', () {
      final result = mondayOf(DateTime(2026, 1, 1)); // Giovedì

      expect(result, DateTime(2025, 12, 29));
    });
  });

  group('buildDiaryWeekGroups', () {
    test('se la lista è vuota restituisce una lista vuota', () {
      final groups = buildDiaryWeekGroups([]);

      expect(groups, isEmpty);
    });

    test('raggruppa pasti ed esercizi della stessa settimana nello stesso gruppo', () {
      final entries = <DiaryEntry>[
        MealDiaryEntry(mealAt(DateTime(2026, 5, 18, 12, 30))),
        ExerciseDiaryEntry(exerciseAt(DateTime(2026, 5, 20, 18, 0))),
      ];

      final groups = buildDiaryWeekGroups(entries);

      expect(groups, hasLength(1));
      expect(groups.first.monday, DateTime(2026, 5, 18));
      expect(groups.first.eventCount, 2);
    });

    test('divide eventi di settimane diverse in gruppi diversi', () {
      final entries = <DiaryEntry>[
        MealDiaryEntry(mealAt(DateTime(2026, 5, 18, 12, 30))),
        ExerciseDiaryEntry(exerciseAt(DateTime(2026, 5, 25, 18, 0))),
      ];

      final groups = buildDiaryWeekGroups(entries);

      expect(groups, hasLength(2));
      expect(groups[0].monday, DateTime(2026, 5, 25));
      expect(groups[1].monday, DateTime(2026, 5, 18));
    });

    test('ordina le settimane dalla più recente alla meno recente', () {
      final entries = <DiaryEntry>[
        MealDiaryEntry(mealAt(DateTime(2026, 5, 4, 12, 30))),
        MealDiaryEntry(mealAt(DateTime(2026, 5, 18, 12, 30))),
        MealDiaryEntry(mealAt(DateTime(2026, 5, 11, 12, 30))),
      ];

      final groups = buildDiaryWeekGroups(entries);

      expect(
        groups.map((group) => group.monday).toList(),
        [
          DateTime(2026, 5, 18),
          DateTime(2026, 5, 11),
          DateTime(2026, 5, 4),
        ],
      );
    });

    test('raggruppa eventi dello stesso giorno nello stesso DiaryDayGroup', () {
      final entries = <DiaryEntry>[
        MealDiaryEntry(mealAt(DateTime(2026, 5, 18, 12, 30))),
        ExerciseDiaryEntry(exerciseAt(DateTime(2026, 5, 18, 18, 0))),
      ];

      final groups = buildDiaryWeekGroups(entries);

      expect(groups, hasLength(1));
      expect(groups.first.days, hasLength(1));
      expect(groups.first.days.first.day, DateTime(2026, 5, 18));
      expect(groups.first.days.first.entries, hasLength(2));
    });

    test('ordina i giorni dentro la settimana dal meno recente al più recente', () {
      final entries = <DiaryEntry>[
        MealDiaryEntry(mealAt(DateTime(2026, 5, 20, 12, 30))),
        MealDiaryEntry(mealAt(DateTime(2026, 5, 18, 12, 30))),
        MealDiaryEntry(mealAt(DateTime(2026, 5, 19, 12, 30))),
      ];

      final groups = buildDiaryWeekGroups(entries);

      expect(
        groups.first.days.map((dayGroup) => dayGroup.day).toList(),
        [
          DateTime(2026, 5, 18),
          DateTime(2026, 5, 19),
          DateTime(2026, 5, 20),
        ],
      );
    });

    test('ordina gli eventi dello stesso giorno per orario crescente', () {
      final entries = <DiaryEntry>[
        ExerciseDiaryEntry(exerciseAt(DateTime(2026, 5, 18, 18, 0))),
        MealDiaryEntry(mealAt(DateTime(2026, 5, 18, 8, 30), mealType: 'Colazione')),
        MealDiaryEntry(mealAt(DateTime(2026, 5, 18, 13, 0), mealType: 'Pranzo')),
      ];

      final groups = buildDiaryWeekGroups(entries);
      final dayEntries = groups.first.days.first.entries;

      expect(
        dayEntries.map((entry) => entry.dateTime).toList(),
        [
          DateTime(2026, 5, 18, 8, 30),
          DateTime(2026, 5, 18, 13, 0),
          DateTime(2026, 5, 18, 18, 0),
        ],
      );
    });

    test('mantiene correttamente il tipo MealDiaryEntry ed ExerciseDiaryEntry', () {
      final entries = <DiaryEntry>[
        MealDiaryEntry(mealAt(DateTime(2026, 5, 18, 12, 30))),
        ExerciseDiaryEntry(exerciseAt(DateTime(2026, 5, 18, 18, 0))),
      ];

      final groups = buildDiaryWeekGroups(entries);
      final dayEntries = groups.first.days.first.entries;

      expect(dayEntries[0], isA<MealDiaryEntry>());
      expect(dayEntries[1], isA<ExerciseDiaryEntry>());
    });
  });
}