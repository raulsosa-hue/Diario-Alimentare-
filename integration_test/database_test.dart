import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:mi_ascolto/data/database_helper.dart';
import 'package:mi_ascolto/models/exercise.dart';
import 'package:mi_ascolto/models/meal.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Database reale su smartphone', () {
    late DatabaseHelper dbHelper;

    setUp(() async {
      dbHelper = DatabaseHelper.instance;

      final db = await dbHelper.database;
      await db.delete('meals');
      await db.delete('exercises');
    });

    testWidgets('inserisce e recupera un pasto nel database reale', (tester) async {
      final meal = Meal(
        dateTime: DateTime(2026, 5, 18, 13, 15),
        mealType: 'Pranzo',
        location: 'Casa',
        withWhom: 'Da solo',
        bodySensationsBefore: 'Fame leggera',
        emotionalIntensityBefore: 6,
        emotionBefore: 'Serenità',
        thoughtBefore: 'Mi sento tranquillo',
        startTime: '13:15',
        endTime: '13:45',
        whatEaten: 'Pasta al pomodoro',
        bodySensationsAfter: 'Sazietà',
        emotionalIntensityAfter: 7,
        emotionAfter: 'Serenità',
        thoughtAfter: 'Mi sento meglio',
      );

      final id = await dbHelper.insertMeal(meal);

      final meals = await dbHelper.getAllMeals();
      final saved = meals.firstWhere((m) => m.id == id);

      expect(saved.id, id);
      expect(saved.mealType, 'Pranzo');
      expect(saved.location, 'Casa');
      expect(saved.whatEaten, 'Pasta al pomodoro');
      expect(saved.emotionalIntensityBefore, 6);
      expect(saved.emotionalIntensityAfter, 7);
    });

    testWidgets('inserisce, aggiorna e cancella un esercizio nel database reale', (tester) async {
      final exercise = Exercise(
        dateTime: DateTime(2026, 5, 18, 18, 30),
        exerciseType: 'Corsa',
        durationMinutes: 30,
        intention: 'Benessere / Energia',
        emotionalIntensityBefore: 4,
        emotionBefore: 'Serenità',
        thoughtBefore: 'Voglio scaricare la giornata',
        outcome: 'Più libero / leggero',
        bodySensationsAfter: 'Gambe leggere',
        emotionalIntensityAfter: 2,
        emotionAfter: 'Gioia',
        thoughtAfter: 'Mi sento meglio',
      );

      final id = await dbHelper.insertExercise(exercise);

      final exercises = await dbHelper.getAllExercises();
      final saved = exercises.firstWhere((e) => e.id == id);

      expect(saved.id, id);
      expect(saved.exerciseType, 'Corsa');
      expect(saved.durationMinutes, 30);
      expect(saved.intention, 'Benessere / Energia');

      final updated = saved.copyWith(
        durationMinutes: 45,
        outcome: 'Molto meglio',
        emotionalIntensityAfter: 1,
      );

      final updatedRows = await dbHelper.updateExercise(updated);
      expect(updatedRows, 1);

      final afterUpdate = await dbHelper.getAllExercises();
      final updatedSaved = afterUpdate.firstWhere((e) => e.id == id);

      expect(updatedSaved.durationMinutes, 45);
      expect(updatedSaved.outcome, 'Molto meglio');
      expect(updatedSaved.emotionalIntensityAfter, 1);

      final deletedRows = await dbHelper.deleteExercise(id);
      expect(deletedRows, 1);

      final afterDelete = await dbHelper.getAllExercises();
      expect(afterDelete.where((e) => e.id == id), isEmpty);
    });
  });
}