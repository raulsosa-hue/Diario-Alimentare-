import '../data/database_helper.dart';
import '../models/meal.dart';
import '../models/exercise.dart';

sealed class DiaryEntry {
  DateTime get dateTime;
}

final class MealDiaryEntry extends DiaryEntry {
  final Meal meal;

  MealDiaryEntry(this.meal);

  @override
  DateTime get dateTime => meal.dateTime;
}

final class ExerciseDiaryEntry extends DiaryEntry {
  final Exercise exercise;

  ExerciseDiaryEntry(this.exercise);

  @override
  DateTime get dateTime => exercise.dateTime;
}

class DiaryDayGroup {
  final DateTime day;
  final List<DiaryEntry> entries;

  const DiaryDayGroup({
    required this.day,
    required this.entries,
  });
}

class DiaryWeekGroup {
  final DateTime monday;
  final List<DiaryDayGroup> days;

  const DiaryWeekGroup({
    required this.monday,
    required this.days,
  });

  int get eventCount {
    return days.fold(0, (sum, day) => sum + day.entries.length);
  }
}

class DiaryRepository {
  final DatabaseHelper _db;

  DiaryRepository({DatabaseHelper? db}) : _db = db ?? DatabaseHelper.instance;

  Future<List<DiaryEntry>> getDiaryEntries() async {
    final (meals, exercises) = await (
    _db.getAllMeals(),
    _db.getAllExercises(),
    ).wait;

    final entries = <DiaryEntry>[
      ...meals.map(MealDiaryEntry.new),
      ...exercises.map(ExerciseDiaryEntry.new),
    ];

    entries.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return entries;
  }
}

List<DiaryWeekGroup> buildDiaryWeekGroups(List<DiaryEntry> entries) {
  final byWeek = <DateTime, List<DiaryEntry>>{};

  for (final entry in entries) {
    final monday = mondayOf(entry.dateTime);
    (byWeek[monday] ??= []).add(entry);
  }

  final weekGroups = <DiaryWeekGroup>[];

  for (final weekEntry in byWeek.entries) {
    final byDay = <DateTime, List<DiaryEntry>>{};

    for (final entry in weekEntry.value) {
      final day = DateTime(
        entry.dateTime.year,
        entry.dateTime.month,
        entry.dateTime.day,
      );

      (byDay[day] ??= []).add(entry);
    }

    final dayGroups = byDay.entries.map((dayEntry) {
      final dayEntries = dayEntry.value
        ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

      return DiaryDayGroup(
        day: dayEntry.key,
        entries: dayEntries,
      );
    }).toList()
      ..sort((a, b) => a.day.compareTo(b.day));

    weekGroups.add(
      DiaryWeekGroup(
        monday: weekEntry.key,
        days: dayGroups,
      ),
    );
  }

  weekGroups.sort((a, b) => b.monday.compareTo(a.monday));
  return weekGroups;
}

DateTime mondayOf(DateTime d) {
  final day = d.subtract(Duration(days: d.weekday - 1));
  return DateTime(day.year, day.month, day.day);
}