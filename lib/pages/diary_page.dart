import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../data/database_helper.dart';
import '../models/exercise.dart';
import '../models/meal.dart';
import '../styles.dart';
import '../widgets/common_buttons.dart';
import '../widgets/diary_card_helpers.dart';
import '../widgets/diary_exercise_card.dart';
import '../widgets/diary_meal_card.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  bool _isLoading = true;
  List<_WeekGroup> _weekGroups = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final db = DatabaseHelper.instance;
      final (meals, exercises) = await (db.getAllMeals(), db.getAllExercises()).wait;

      // Merge into a unified list sorted by dateTime DESC.
      final entries = <_DiaryEntry>[
        ...meals.map(_MealEntry.new),
        ...exercises.map(_ExerciseEntry.new),
      ]..sort((a, b) => b.dateTime.compareTo(a.dateTime));

      // Group by week (Monday-start).
      final groups = <DateTime, List<_DiaryEntry>>{};
      for (final entry in entries) {
        final monday = _mondayOf(entry.dateTime);
        (groups[monday] ??= []).add(entry);
      }

      final weekGroups = groups.entries.map((e) => _WeekGroup(monday: e.key, entries: e.value)).toList()
        ..sort((a, b) => b.monday.compareTo(a.monday));

      if (!mounted) return;
      setState(() {
        _weekGroups = weekGroups;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  static DateTime _mondayOf(DateTime d) {
    final day = d.subtract(Duration(days: d.weekday - 1));
    return DateTime(day.year, day.month, day.day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appAppBar('Diario', titleStyle: DS.pageTitle),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _weekGroups.isEmpty
              ? const Center(
                  child: Text(
                    'Nessuna registrazione',
                    style: DS.bodyText,
                  ),
                )
              : CustomScrollView(
                  slivers: [
                    for (final group in _weekGroups)
                      SliverStickyHeader(
                        header: _WeekHeader(monday: group.monday),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final entry = group.entries[index];
                              return switch (entry) {
                                _MealEntry(meal: final m) => DiaryMealCard(meal: m),
                                _ExerciseEntry(exercise: final e) => DiaryExerciseCard(exercise: e),
                              };
                            },
                            childCount: group.entries.length,
                          ),
                        ),
                      ),
                  ],
                ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private data types
// ---------------------------------------------------------------------------

sealed class _DiaryEntry {
  DateTime get dateTime;
}

class _MealEntry extends _DiaryEntry {
  final Meal meal;
  _MealEntry(this.meal);

  @override
  DateTime get dateTime => meal.dateTime;
}

class _ExerciseEntry extends _DiaryEntry {
  final Exercise exercise;
  _ExerciseEntry(this.exercise);

  @override
  DateTime get dateTime => exercise.dateTime;
}

class _WeekGroup {
  final DateTime monday;
  final List<_DiaryEntry> entries;
  const _WeekGroup({required this.monday, required this.entries});
}

// ---------------------------------------------------------------------------
// Week header widget
// ---------------------------------------------------------------------------

class _WeekHeader extends StatelessWidget {
  final DateTime monday;
  const _WeekHeader({required this.monday});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DS.surfaceMuted,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              formatWeekHeader(monday),
              style: DS.weekHeaderTitle,
            ),
          ),
          const Icon(Icons.ios_share, size: 22, color: DS.textMuted),
        ],
      ),
    );
  }
}
