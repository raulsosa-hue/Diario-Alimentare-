import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/exercise.dart';
import '../models/meal.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static const _dbName = 'diario_alimentare.db';
  static const _dbVersion = 1;

  Future<Database>? _dbFuture;

  Future<Database> get database => _dbFuture ??= _initDb();

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    if (kDebugMode) {
      debugPrint('DatabaseHelper — path: $path');
    }
    return openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS meals (
        id                         INTEGER PRIMARY KEY AUTOINCREMENT,
        created_at                 TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
        updated_at                 TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
        date_time                  TEXT NOT NULL,
        meal_type                  TEXT NOT NULL DEFAULT 'Colazione',
        location                   TEXT,
        with_whom                  TEXT,
        body_sensations_before     TEXT,
        emotional_intensity_before INTEGER NOT NULL DEFAULT 0,
        emotion_before             TEXT,
        thought_before             TEXT,
        start_time                 TEXT NOT NULL,
        end_time                   TEXT NOT NULL,
        what_eaten                 TEXT,
        body_sensations_after      TEXT,
        emotional_intensity_after  INTEGER NOT NULL DEFAULT 0,
        emotion_after              TEXT,
        thought_after              TEXT
      )
    ''');

    await db.execute('''
      CREATE TRIGGER IF NOT EXISTS meals_updated_at
      AFTER UPDATE ON meals
      WHEN NEW.updated_at = OLD.updated_at
      BEGIN
        UPDATE meals
        SET updated_at = strftime('%Y-%m-%dT%H:%M:%fZ', 'now')
        WHERE id = NEW.id;
      END
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS exercises (
        id                         INTEGER PRIMARY KEY AUTOINCREMENT,
        created_at                 TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
        updated_at                 TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
        date_time                  TEXT NOT NULL,
        exercise_type              TEXT,
        duration_minutes           INTEGER NOT NULL DEFAULT 20,
        intention                  TEXT,
        emotional_intensity_before INTEGER NOT NULL DEFAULT 0,
        emotion_before             TEXT,
        thought_before             TEXT,
        outcome                    TEXT,
        body_sensations_after      TEXT,
        emotional_intensity_after  INTEGER NOT NULL DEFAULT 0,
        emotion_after              TEXT,
        thought_after              TEXT
      )
    ''');

    await db.execute('''
      CREATE TRIGGER IF NOT EXISTS exercises_updated_at
      AFTER UPDATE ON exercises
      WHEN NEW.updated_at = OLD.updated_at
      BEGIN
        UPDATE exercises
        SET updated_at = strftime('%Y-%m-%dT%H:%M:%fZ', 'now')
        WHERE id = NEW.id;
      END
    ''');
  }

  // ---------------------------------------------------------------------------
  // Meals
  // ---------------------------------------------------------------------------

  Future<int> insertMeal(Meal meal) async {
    final db = await database;
    return db.insert('meals', meal.toMap());
  }

  Future<List<Meal>> getAllMeals() async {
    final db = await database;
    final rows = await db.query('meals', orderBy: 'date_time DESC');
    return rows.map(Meal.fromMap).toList();
  }

  Future<int> updateMeal(Meal meal) async {
    final db = await database;
    return db.update('meals', meal.toMap(), where: 'id = ?', whereArgs: [meal.id]);
  }

  Future<int> deleteMeal(int id) async {
    final db = await database;
    return db.delete('meals', where: 'id = ?', whereArgs: [id]);
  }

  // ---------------------------------------------------------------------------
  // Exercises
  // ---------------------------------------------------------------------------

  Future<int> insertExercise(Exercise exercise) async {
    final db = await database;
    return db.insert('exercises', exercise.toMap());
  }

  Future<List<Exercise>> getAllExercises() async {
    final db = await database;
    final rows = await db.query('exercises', orderBy: 'date_time DESC');
    return rows.map(Exercise.fromMap).toList();
  }

  Future<int> updateExercise(Exercise exercise) async {
    final db = await database;
    return db.update('exercises', exercise.toMap(), where: 'id = ?', whereArgs: [exercise.id]);
  }

  Future<int> deleteExercise(int id) async {
    final db = await database;
    return db.delete('exercises', where: 'id = ?', whereArgs: [id]);
  }
}
