import 'package:flutter/material.dart';

import '../../models/exercise.dart';
import '../../styles.dart';
import 'diary_card_helpers.dart';

class DiaryExerciseCard extends StatelessWidget {
  final Exercise exercise;
  const DiaryExerciseCard({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return diaryCard(
      color: DS.diaryExerciseAccent,
      headerColor: DS.diaryExerciseHeader,
      sectionBarColor: DS.diaryExerciseSectionBar,
      headerDateTime: formatDiaryCardDateTime(exercise.dateTime),
      typeLabel: exercise.exerciseType ?? 'N/D',
      bodyFields: [
        diaryFieldRow('Durata', '${exercise.durationMinutes} min'),
      ],
      primaFields: [
        diaryFieldRow('Perché', exercise.intention),
        diaryFieldRow('Emozione', exercise.emotionBefore),
        diaryFieldRow(
          'Intensità emotiva',
          '${exercise.emotionalIntensityBefore}/10',
        ),
        diaryFieldRow('Pensiero', exercise.thoughtBefore),
      ],
      dopoFields: [
        diaryFieldRow('Esito', exercise.outcome),
        diaryFieldRow('Sensazioni', exercise.bodySensationsAfter),
        diaryFieldRow('Emozione', exercise.emotionAfter),
        diaryFieldRow(
          'Intensità emotiva',
          '${exercise.emotionalIntensityAfter}/10',
        ),
        diaryFieldRow('Pensiero', exercise.thoughtAfter),
      ],
    );
  }
}
