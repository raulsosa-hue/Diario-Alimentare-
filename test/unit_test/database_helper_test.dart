import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:mi_ascolto/data/database_helper.dart';
import 'package:mi_ascolto/models/exercise.dart';
import 'package:mi_ascolto/models/meal.dart';

void main() {
  late DatabaseHelper dbHelper;

  Future<void> clearDatabase() async {
    final db = await dbHelper.database;
    await db.delete('meals');
    await db.delete('exercises');
  }

  Meal sampleMeal({
    DateTime? dateTime,
    String mealType = 'Pranzo',
  }) {
    return Meal(
      dateTime: dateTime ?? DateTime(2026, 5, 18, 13, 15),
      mealType: mealType,
      location: 'Casa',
      withWhom: 'Da solo',
      bodySensationsBefore: 'Fame leggera',
      emotionalIntensityBefore: 6,
      emotionBefore: '😌 Orgoglio',
      thoughtBefore: 'Mi sento abbastanza tranquillo',
      startTime: '13:15',
      endTime: '13:45',
      whatEaten: 'Pasta al pomodoro',
      bodySensationsAfter: 'Sazietà',
      emotionalIntensityAfter: 7,
      emotionAfter: '😊 Serenità',
      thoughtAfter: 'Mi sento meglio',
    );
  }

  Exercise sampleExercise({
    DateTime? dateTime,
    String? exerciseType = '🚶‍♂️ Camminata',
  }) {
    return Exercise(
      dateTime: dateTime ?? DateTime(2026, 5, 18, 11, 26),
      exerciseType: exerciseType,
      durationMinutes: 35,
      intention: '✅ Benessere / Energia',
      emotionalIntensityBefore: 7,
      emotionBefore: '😌 Orgoglio',
      thoughtBefore: 'Voglio muovermi un po’',
      outcome: '✅ Più libero / leggero',
      bodySensationsAfter: 'Gambe più leggere',
      emotionalIntensityAfter: 8,
      emotionAfter: '😊 Serenità',
      thoughtAfter: 'Sono contento di averlo fatto',
    );
  }

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'diario_alimentare.db');
    await deleteDatabase(path);

    dbHelper = DatabaseHelper.instance;
  });

  setUp(() async {
    await clearDatabase();
  });

  group('DatabaseHelper - meals', () {
    test('inserisce e recupera i pasti ordinati per data decrescente', () async {
      final oldMeal = sampleMeal(
        dateTime: DateTime(2026, 5, 17, 20, 0),
        mealType: 'Cena',
      );

      final newMeal = sampleMeal(
        dateTime: DateTime(2026, 5, 18, 13, 15),
        mealType: 'Pranzo',
      );

      await dbHelper.insertMeal(oldMeal);
      await dbHelper.insertMeal(newMeal);

      final meals = await dbHelper.getAllMeals();

      expect(meals, hasLength(2));

      expect(meals[0].mealType, 'Pranzo');
      expect(meals[0].dateTime, DateTime(2026, 5, 18, 13, 15));
      expect(meals[0].id, isNotNull);
      expect(meals[0].createdAt, isNotNull);
      expect(meals[0].updatedAt, isNotNull);

      expect(meals[1].mealType, 'Cena');
      expect(meals[1].dateTime, DateTime(2026, 5, 17, 20, 0));
    });

    test('aggiorna un pasto esistente', () async {
      await dbHelper.insertMeal(sampleMeal());

      final savedMeal = (await dbHelper.getAllMeals()).single;

      final updatedMeal = savedMeal.copyWith(
        mealType: 'Cena',
        whatEaten: 'Riso con verdure',
        emotionalIntensityAfter: 9,
      );

      final affectedRows = await dbHelper.updateMeal(updatedMeal);

      expect(affectedRows, 1);

      final meals = await dbHelper.getAllMeals();

      expect(meals, hasLength(1));
      expect(meals.single.mealType, 'Cena');
      expect(meals.single.whatEaten, 'Riso con verdure');
      expect(meals.single.emotionalIntensityAfter, 9);
    });

    test('elimina un pasto esistente', () async {
      final id = await dbHelper.insertMeal(sampleMeal());

      var meals = await dbHelper.getAllMeals();
      expect(meals, hasLength(1));

      final affectedRows = await dbHelper.deleteMeal(id);

      expect(affectedRows, 1);

      meals = await dbHelper.getAllMeals();
      expect(meals, isEmpty);
    });
  });

  group('DatabaseHelper - exercises', () {
    test('inserisce e recupera gli esercizi ordinati per data decrescente', () async {
      final oldExercise = sampleExercise(
        dateTime: DateTime(2026, 5, 17, 9, 0),
        exerciseType: '🏃 Corsa',
      );

      final newExercise = sampleExercise(
        dateTime: DateTime(2026, 5, 18, 11, 26),
        exerciseType: '🚶‍♂️ Camminata',
      );

      await dbHelper.insertExercise(oldExercise);
      await dbHelper.insertExercise(newExercise);

      final exercises = await dbHelper.getAllExercises();

      expect(exercises, hasLength(2));

      expect(exercises[0].exerciseType, '🚶‍♂️ Camminata');
      expect(exercises[0].dateTime, DateTime(2026, 5, 18, 11, 26));
      expect(exercises[0].id, isNotNull);
      expect(exercises[0].createdAt, isNotNull);
      expect(exercises[0].updatedAt, isNotNull);

      expect(exercises[1].exerciseType, '🏃 Corsa');
      expect(exercises[1].dateTime, DateTime(2026, 5, 17, 9, 0));
    });

    test('aggiorna un esercizio esistente', () async {
      await dbHelper.insertExercise(sampleExercise());

      final savedExercise = (await dbHelper.getAllExercises()).single;

      final updatedExercise = savedExercise.copyWith(
        exerciseType: '🏃 Corsa',
        durationMinutes: 50,
        emotionalIntensityAfter: 9,
      );

      final affectedRows = await dbHelper.updateExercise(updatedExercise);

      expect(affectedRows, 1);

      final exercises = await dbHelper.getAllExercises();

      expect(exercises, hasLength(1));
      expect(exercises.single.exerciseType, '🏃 Corsa');
      expect(exercises.single.durationMinutes, 50);
      expect(exercises.single.emotionalIntensityAfter, 9);
    });

    test('elimina un esercizio esistente', () async {
      final id = await dbHelper.insertExercise(sampleExercise());

      var exercises = await dbHelper.getAllExercises();
      expect(exercises, hasLength(1));

      final affectedRows = await dbHelper.deleteExercise(id);

      expect(affectedRows, 1);

      exercises = await dbHelper.getAllExercises();
      expect(exercises, isEmpty);
    });

    test('exercises inserisce, aggiorna e cancella un esercizio', () async {
      final exercise = Exercise(
        dateTime: DateTime(2026, 5, 18, 18, 30),
        exerciseType: '🏃‍♂️ Corsa',
        durationMinutes: 30,
        intention: '✅ Benessere / Energia',
        emotionalIntensityBefore: 4,
        emotionBefore: '🙂 Serenità',
        thoughtBefore: 'Voglio scaricare un po’ la giornata',
        outcome: '✅ Più libero / leggero',
        bodySensationsAfter: 'Gambe leggere',
        emotionalIntensityAfter: 2,
        emotionAfter: '😊 Gioia',
        thoughtAfter: 'Mi sento meglio',
      );

      final id = await dbHelper.insertExercise(exercise);

      final exercises = await dbHelper.getAllExercises();

      final saved = exercises.firstWhere((e) => e.id == id);

      expect(saved.id, id);
      expect(saved.exerciseType, '🏃‍♂️ Corsa');
      expect(saved.durationMinutes, 30);
      expect(saved.intention, '✅ Benessere / Energia');
      expect(saved.emotionalIntensityBefore, 4);
      expect(saved.emotionBefore, '🙂 Serenità');
      expect(saved.thoughtBefore, 'Voglio scaricare un po’ la giornata');
      expect(saved.outcome, '✅ Più libero / leggero');
      expect(saved.bodySensationsAfter, 'Gambe leggere');
      expect(saved.emotionalIntensityAfter, 2);
      expect(saved.emotionAfter, '😊 Gioia');
      expect(saved.thoughtAfter, 'Mi sento meglio');

      final updated = saved.copyWith(
        durationMinutes: 45,
        outcome: '✅ Molto meglio',
        emotionalIntensityAfter: 1,
      );

      final updatedRows = await dbHelper.updateExercise(updated);

      expect(updatedRows, 1);

      final afterUpdate = await dbHelper.getAllExercises();
      final updatedSaved = afterUpdate.firstWhere((e) => e.id == id);

      expect(updatedSaved.durationMinutes, 45);
      expect(updatedSaved.outcome, '✅ Molto meglio');
      expect(updatedSaved.emotionalIntensityAfter, 1);

      final deletedRows = await dbHelper.deleteExercise(id);

      expect(deletedRows, 1);

      final afterDelete = await dbHelper.getAllExercises();

      expect(afterDelete.where((e) => e.id == id), isEmpty);
    });
  });
}