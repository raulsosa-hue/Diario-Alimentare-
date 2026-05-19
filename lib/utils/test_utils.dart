import '../models/exercise.dart';
import '../models/meal.dart';
import '../repository/diary_repository.dart';

Meal sampleMeal() {
  return Meal(
    dateTime: DateTime(2026, 1, 14, 12, 30),
    mealType: 'Pranzo',
    startTime: '12:30',
    endTime: '12:50',
    whatEaten: 'Pasta al pomodoro',
    location: 'Casa',
    withWhom: 'Famiglia',
  );
}

Exercise sampleExercise() {
  return Exercise(
    dateTime: DateTime(2026, 1, 14, 18, 15),
    exerciseType: '🏃 Corsa / Running',
    durationMinutes: 30,
    intention: '✅ Benessere / Energia',
    outcome: '✅ Più libero / leggero',
  );
}

Meal mealAt(
    DateTime dateTime, {
      String mealType = 'Pranzo',
    }) {
  return Meal(
    dateTime: dateTime,
    mealType: mealType,
    startTime: '12:00',
    endTime: '12:30',
    whatEaten: 'Pasta',
    emotionalIntensityBefore: 5,
    emotionalIntensityAfter: 7,
  );
}

Exercise exerciseAt(
    DateTime dateTime, {
      String exerciseType = '🏃 Corsa',
    }) {
  return Exercise(
    dateTime: dateTime,
    exerciseType: exerciseType,
    durationMinutes: 30,
    emotionalIntensityBefore: 4,
    emotionalIntensityAfter: 8,
  );
}

DiaryWeekGroup sampleWeekGroup() {
  final mealEntry = MealDiaryEntry(sampleMeal());
  final exerciseEntry = ExerciseDiaryEntry(sampleExercise());

  return DiaryWeekGroup(
    monday: DateTime(2026, 1, 12),
    days: [
      DiaryDayGroup(
        day: DateTime(2026, 1, 14),
        entries: [
          mealEntry,
          exerciseEntry,
        ],
      ),
    ],
  );
}