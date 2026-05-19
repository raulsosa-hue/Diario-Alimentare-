import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mi_ascolto/models/exercise.dart';
import 'package:mi_ascolto/models/meal.dart';
import 'package:mi_ascolto/services/pdf_diary_export.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('generateWeeklyDiaryPdf', () {
    test('genera un PDF valido con pasti ed esercizi', () async {
      final bytes = await generateWeeklyDiaryPdf(
        monday: DateTime(2026, 5, 18),
        meals: [
          Meal(
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
          ),
        ],
        exercises: [
          Exercise(
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
          ),
        ],
      );

      expect(bytes, isA<Uint8List>());
      expect(bytes.length, greaterThan(0));
      expect(String.fromCharCodes(bytes.take(4)), '%PDF');
    });

    test('genera un PDF valido anche senza eventi', () async {
      final bytes = await generateWeeklyDiaryPdf(
        monday: DateTime(2026, 5, 18),
        meals: [],
        exercises: [],
      );

      expect(bytes, isA<Uint8List>());
      expect(bytes.length, greaterThan(0));
      expect(String.fromCharCodes(bytes.take(4)), '%PDF');
    });

    test('gestisce campi null o vuoti senza errori', () async {
      final bytes = await generateWeeklyDiaryPdf(
        monday: DateTime(2026, 5, 18),
        meals: [
          Meal(
            dateTime: DateTime(2026, 5, 18, 20, 0),
            mealType: 'Cena',
            startTime: '20:00',
            endTime: '20:30',
          ),
        ],
        exercises: [
          Exercise(
            dateTime: DateTime(2026, 5, 19, 9, 0),
          ),
        ],
      );

      expect(bytes, isA<Uint8List>());
      expect(bytes.length, greaterThan(0));
      expect(String.fromCharCodes(bytes.take(4)), '%PDF');
    });
  });
}