import 'package:flutter/material.dart';

import '../../models/meal.dart';
import '../../styles.dart';
import 'diary_card_helpers.dart';

class DiaryMealCard extends StatelessWidget {
  final Meal meal;
  const DiaryMealCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return diaryCard(
      color: DS.diaryMealAccent,
      headerColor: DS.diaryMealHeader,
      sectionBarColor: DS.diaryMealSectionBar,
      headerDateTime: formatDiaryCardDateTime(meal.dateTime),
      typeLabel: meal.mealType,
      bodyFields: [
        diaryFieldRow('Orario', '${meal.startTime} – ${meal.endTime}'),
        diaryFieldRow('Dove', meal.location),
        diaryFieldRow('Con chi', meal.withWhom),
        diaryFieldRow('Cosa mangiato', meal.whatEaten),
      ],
      primaFields: [
        diaryFieldRow('Sensazioni', meal.bodySensationsBefore),
        diaryFieldRow(
          'Intensità emotiva',
          '${meal.emotionalIntensityBefore}/10',
        ),
        diaryFieldRow('Emozione', meal.emotionBefore),
        diaryFieldRow('Pensiero', meal.thoughtBefore),
      ],
      dopoFields: [
        diaryFieldRow('Sensazioni', meal.bodySensationsAfter),
        diaryFieldRow(
          'Intensità emotiva',
          '${meal.emotionalIntensityAfter}/10',
        ),
        diaryFieldRow('Emozione', meal.emotionAfter),
        diaryFieldRow('Pensiero', meal.thoughtAfter),
      ],
    );
  }
}
