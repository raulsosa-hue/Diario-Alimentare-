import 'package:flutter/material.dart';

import '../../models/exercise.dart';
import '../../models/meal.dart';
import '../../repository/diary_repository.dart';
import '../../styles.dart';
import '../../utils/diary_formatters.dart';

class DiaryCompactEventCard extends StatelessWidget {
  final DiaryEntry entry;
  final VoidCallback onTap;

  const DiaryCompactEventCard({
    super.key,
    required this.entry,
    required this.onTap,
  });

  static const Color _mealColor = Color(0xFFF28C28);
  static const Color _exerciseColor = Color(0xFF4F9B65);

  static const Color _beforeColor = Color(0xFFE98926);
  static const Color _afterColor = Color(0xFF4F9B65);

  @override
  Widget build(BuildContext context) {
    final accentColor = _accentColor(entry);
    final title = _title(entry);
    final time = formatDiaryTime(entry.dateTime);
    final lines = _summaryLines(entry);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(15, 14, 12, 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.96),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.045),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.13),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _icon(entry),
                        color: accentColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                    _SmallLabelBadge(
                      label: _entryKind(entry),
                      color: accentColor,
                    ),
                    const Spacer(),
                    Text(
                      time,
                      style: DS.bodyText.copyWith(
                        color: DS.textPrimary.withValues(alpha: 0.78),
                        fontSize: 13.5,
                        height: 1,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: accentColor.withValues(alpha: 0.55),
                      size: 27,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: DS.bodyText.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    height: 1.08,
                    color: DS.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                for (final line in lines)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: _CompactInfoRow(
                      label: line.label,
                      value: line.value,
                      accentColor: _lineColor(line.label, accentColor),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Color _lineColor(String label, Color fallbackColor) {
    switch (label.toUpperCase()) {
      case 'PRIMA':
        return _beforeColor;
      case 'DOPO':
        return _afterColor;
      case 'CIBO':
      case 'PASTO':
        return _mealColor;
      case 'ESERCIZIO':
        return _exerciseColor;
      default:
        return fallbackColor;
    }
  }
}

class _SmallLabelBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _SmallLabelBadge({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: color.withValues(alpha: 0.26),
          width: 1,
        ),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: DS.bodyText.copyWith(
          fontSize: 12,
          height: 1,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.7,
          color: color,
        ),
      ),
    );
  }
}

class _CompactInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color accentColor;

  const _CompactInfoRow({
    required this.label,
    required this.value,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 62,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 7,
                vertical: 3,
              ),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.24),
                  width: 1,
                ),
              ),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: DS.bodyText.copyWith(
                  fontSize: 11.2,
                  height: 1,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.45,
                  color: accentColor.withValues(alpha: 0.90),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: DS.bodyText.copyWith(
              fontSize: 14.5,
              height: 1.25,
              fontWeight: FontWeight.w800,
              color: DS.textPrimary,
            ),
          ),
        ),
      ],
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
    ExerciseDiaryEntry(exercise: final exercise) => _exerciseSummaryLines(exercise),
  };
}

List<_CompactLine> _mealSummaryLines(Meal meal) {
  final beforeAfterLines = _beforeAfterPriorityLines(
    emotionBefore: meal.emotionBefore,
    intensityBefore: meal.emotionalIntensityBefore,
    thoughtBefore: meal.thoughtBefore,
    emotionAfter: meal.emotionAfter,
    intensityAfter: meal.emotionalIntensityAfter,
    thoughtAfter: meal.thoughtAfter,
  );

  if (beforeAfterLines.isNotEmpty) {
    return beforeAfterLines;
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
  final beforeAfterLines = _beforeAfterPriorityLines(
    emotionBefore: exercise.emotionBefore,
    intensityBefore: exercise.emotionalIntensityBefore,
    thoughtBefore: exercise.thoughtBefore,
    emotionAfter: exercise.emotionAfter,
    intensityAfter: exercise.emotionalIntensityAfter,
    thoughtAfter: exercise.thoughtAfter,
  );

  if (beforeAfterLines.isNotEmpty) {
    return beforeAfterLines;
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

List<_CompactLine> _beforeAfterPriorityLines({
  required String? emotionBefore,
  required int? intensityBefore,
  required String? thoughtBefore,
  required String? emotionAfter,
  required int? intensityAfter,
  required String? thoughtAfter,
}) {
  final before = _emotionOrThoughtValue(
    emotion: emotionBefore,
    intensity: intensityBefore,
    thought: thoughtBefore,
  );

  final after = _emotionOrThoughtValue(
    emotion: emotionAfter,
    intensity: intensityAfter,
    thought: thoughtAfter,
  );

  return [
    if (before != null) _CompactLine('PRIMA', before),
    if (after != null) _CompactLine('DOPO', after),
  ];
}

String? _emotionOrThoughtValue({
  required String? emotion,
  required int? intensity,
  required String? thought,
}) {
  final cleanEmotion = cleanDiaryValueOrNull(emotion);

  if (cleanEmotion != null) {
    return _emotionWithIntensity(cleanEmotion, intensity);
  }

  final cleanThought = cleanDiaryValueOrNull(thought);

  if (cleanThought != null) {
    return '“$cleanThought”';
  }

  final hasOnlyIntensity = intensity != null && intensity > 0;

  if (hasOnlyIntensity) {
    return '$intensity/10';
  }

  return null;
}

String _emotionWithIntensity(String emotion, int? intensity) {
  final hasIntensity = intensity != null && intensity > 0;

  if (!hasIntensity) return emotion;

  return '$emotion · $intensity/10';
}

String _title(DiaryEntry entry) {
  return switch (entry) {
    MealDiaryEntry(meal: final meal) =>
    cleanDiaryValueOrNull(meal.mealType) ?? 'Pasto',
    ExerciseDiaryEntry(exercise: final exercise) =>
    cleanDiaryValueOrNull(exercise.exerciseType) ?? 'Esercizio',
  };
}

String _entryKind(DiaryEntry entry) {
  return switch (entry) {
    MealDiaryEntry() => 'PASTO',
    ExerciseDiaryEntry() => 'ESERCIZIO',
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
    MealDiaryEntry() => DiaryCompactEventCard._mealColor,
    ExerciseDiaryEntry() => DiaryCompactEventCard._exerciseColor,
  };
}