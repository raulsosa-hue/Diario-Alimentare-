import 'package:flutter/material.dart';

import '../models/exercise.dart';
import '../models/meal.dart';
import '../repository/diary_repository.dart';
import '../styles.dart';
import '../utils/diary_formatters.dart';

class DiaryCompactEventCard extends StatelessWidget {
  final DiaryEntry entry;
  final VoidCallback onTap;

  const DiaryCompactEventCard({
    super.key,
    required this.entry,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = _accentColor(entry);
    final title = _title(entry);
    final time = formatDiaryTime(entry.dateTime);
    final lines = _summaryLines(entry);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Material(
        color: Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 13, 10, 13),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.96),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: accentColor.withOpacity(0.16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.035),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.13),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _icon(entry),
                    color: accentColor,
                    size: 25,
                  ),
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: DS.bodyText.copyWith(
                                fontWeight: FontWeight.w900,
                                fontSize: 17,
                                height: 1.15,
                                color: DS.textPrimary,
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          Text(
                            time,
                            style: DS.bodyText.copyWith(
                              color: DS.textMuted,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 9),

                      for (final line in lines)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: RichText(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              style: DS.bodyText.copyWith(
                                fontSize: 14.5,
                                height: 1.25,
                                color: DS.textPrimary,
                              ),
                              children: [
                                TextSpan(
                                  text: '${line.label}  ',
                                  style: DS.bodyText.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    color: accentColor.withOpacity(0.72),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                TextSpan(
                                  text: line.value,
                                  style: DS.bodyText.copyWith(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w700,
                                    color: DS.textPrimary,
                                    height: 1.25,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(width: 4),

                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: accentColor.withOpacity(0.7),
                    size: 29,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CompactLine {
  final String label;
  final String value;

  const _CompactLine(this.label, this.value);
}

List<_CompactLine> _summaryLines(DiaryEntry entry) {
  return switch (entry) {
    MealDiaryEntry(meal: final meal) => _mealSummaryLines(meal),
    ExerciseDiaryEntry(exercise: final exercise) =>
        _exerciseSummaryLines(exercise),
  };
}

List<_CompactLine> _mealSummaryLines(Meal meal) {
  final thoughtBefore = cleanDiaryValueOrNull(meal.thoughtBefore);
  final thoughtAfter = cleanDiaryValueOrNull(meal.thoughtAfter);

  if (thoughtBefore != null || thoughtAfter != null) {
    return [
      if (thoughtBefore != null) _CompactLine('PRIMA', '“$thoughtBefore”'),
      if (thoughtAfter != null) _CompactLine('DOPO', '“$thoughtAfter”'),
    ];
  }

  final emotionBefore = _emotionWithIntensity(
    meal.emotionBefore,
    meal.emotionalIntensityBefore,
  );

  final emotionAfter = _emotionWithIntensity(
    meal.emotionAfter,
    meal.emotionalIntensityAfter,
  );

  if (emotionBefore != null || emotionAfter != null) {
    return [
      if (emotionBefore != null) _CompactLine('PRIMA', emotionBefore),
      if (emotionAfter != null) _CompactLine('DOPO', emotionAfter),
    ];
  }

  final food = cleanDiaryValueOrNull(meal.whatEaten);
  if (food != null) {
    return [
      _CompactLine('CIBO', food),
    ];
  }

  final location = cleanDiaryValueOrNull(meal.location);
  if (location != null) {
    return [
      _CompactLine('DOVE', location),
    ];
  }

  final withWhom = cleanDiaryValueOrNull(meal.withWhom);
  if (withWhom != null) {
    return [
      _CompactLine('CON CHI', withWhom),
    ];
  }

  final sensations = cleanDiaryValueOrNull(meal.bodySensationsBefore);
  if (sensations != null) {
    return [
      _CompactLine('SENSAZIONI', sensations),
    ];
  }

  return const [
    _CompactLine('EVENTO', 'Pasto registrato'),
  ];
}

List<_CompactLine> _exerciseSummaryLines(Exercise exercise) {
  final thoughtBefore = cleanDiaryValueOrNull(exercise.thoughtBefore);
  final thoughtAfter = cleanDiaryValueOrNull(exercise.thoughtAfter);

  if (thoughtBefore != null || thoughtAfter != null) {
    return [
      if (thoughtBefore != null) _CompactLine('PRIMA', '“$thoughtBefore”'),
      if (thoughtAfter != null) _CompactLine('DOPO', '“$thoughtAfter”'),
    ];
  }

  final emotionBefore = _emotionWithIntensity(
    exercise.emotionBefore,
    exercise.emotionalIntensityBefore,
  );

  final emotionAfter = _emotionWithIntensity(
    exercise.emotionAfter,
    exercise.emotionalIntensityAfter,
  );

  if (emotionBefore != null || emotionAfter != null) {
    return [
      if (emotionBefore != null) _CompactLine('PRIMA', emotionBefore),
      if (emotionAfter != null) _CompactLine('DOPO', emotionAfter),
    ];
  }

  final type = cleanDiaryValueOrNull(exercise.exerciseType);
  if (type != null) {
    return [
      _CompactLine(
        'ESERCIZIO',
        '$type · ${exercise.durationMinutes} min',
      ),
    ];
  }

  final intention = cleanDiaryValueOrNull(exercise.intention);
  if (intention != null) {
    return [
      _CompactLine('PERCHÉ', intention),
    ];
  }

  final outcome = cleanDiaryValueOrNull(exercise.outcome);
  if (outcome != null) {
    return [
      _CompactLine('ESITO', outcome),
    ];
  }

  final sensations = cleanDiaryValueOrNull(exercise.bodySensationsAfter);
  if (sensations != null) {
    return [
      _CompactLine('SENSAZIONI', sensations),
    ];
  }

  return const [
    _CompactLine('EVENTO', 'Esercizio registrato'),
  ];
}

String? _emotionWithIntensity(String? emotion, int? intensity) {
  final cleanEmotion = cleanDiaryValueOrNull(emotion);
  final hasIntensity = intensity != null && intensity > 0;

  if (cleanEmotion == null && !hasIntensity) return null;
  if (cleanEmotion == null) return '$intensity/10';
  if (!hasIntensity) return cleanEmotion;

  return '$cleanEmotion · $intensity/10';
}

String _title(DiaryEntry entry) {
  return switch (entry) {
    MealDiaryEntry(meal: final meal) =>
    cleanDiaryValueOrNull(meal.mealType) ?? 'Pasto',
    ExerciseDiaryEntry(exercise: final exercise) =>
    cleanDiaryValueOrNull(exercise.exerciseType) ?? 'Esercizio',
  };
}

IconData _icon(DiaryEntry entry) {
  return switch (entry) {
    MealDiaryEntry() => Icons.restaurant_rounded,
    ExerciseDiaryEntry() => Icons.directions_run_rounded,
  };
}

Color _accentColor(DiaryEntry entry) {
  return switch (entry) {
    MealDiaryEntry() => DS.diaryMealHeader,
    ExerciseDiaryEntry() => DS.diaryExerciseHeader,
  };
}