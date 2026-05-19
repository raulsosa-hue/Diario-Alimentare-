import 'package:flutter_test/flutter_test.dart';
import 'package:mi_ascolto/models/exercise.dart';

void main() {
  group('Exercise model', () {
    test('crea un Exercise con i valori base corretti', () {
      final date = DateTime(2026, 5, 18, 11, 26);

      final exercise = Exercise(
        dateTime: date,
        exerciseType: '🚶‍♂️ Camminata',
        durationMinutes: 35,
        intention: '✅ Benessere / Energia',
        emotionalIntensityBefore: 6,
        emotionBefore: '😌 Orgoglio',
        thoughtBefore: 'Voglio muovermi un po’',
        outcome: '✅ Più libero / leggero',
        bodySensationsAfter: 'Corpo più sciolto',
        emotionalIntensityAfter: 8,
        emotionAfter: '😌 Orgoglio',
        thoughtAfter: 'Sono contento di averlo fatto',
      );

      expect(exercise.id, isNull);
      expect(exercise.createdAt, isNull);
      expect(exercise.updatedAt, isNull);

      expect(exercise.dateTime, date);
      expect(exercise.exerciseType, '🚶‍♂️ Camminata');
      expect(exercise.durationMinutes, 35);
      expect(exercise.intention, '✅ Benessere / Energia');
      expect(exercise.emotionalIntensityBefore, 6);
      expect(exercise.emotionBefore, '😌 Orgoglio');
      expect(exercise.thoughtBefore, 'Voglio muovermi un po’');
      expect(exercise.outcome, '✅ Più libero / leggero');
      expect(exercise.bodySensationsAfter, 'Corpo più sciolto');
      expect(exercise.emotionalIntensityAfter, 8);
      expect(exercise.emotionAfter, '😌 Orgoglio');
      expect(exercise.thoughtAfter, 'Sono contento di averlo fatto');
    });

    test('usa i valori di default quando non vengono specificati', () {
      final exercise = Exercise(
        dateTime: DateTime(2026, 5, 18, 11, 26),
      );

      expect(exercise.exerciseType, isNull);
      expect(exercise.durationMinutes, 20);
      expect(exercise.intention, isNull);
      expect(exercise.emotionalIntensityBefore, 0);
      expect(exercise.emotionBefore, isNull);
      expect(exercise.thoughtBefore, isNull);
      expect(exercise.outcome, isNull);
      expect(exercise.bodySensationsAfter, isNull);
      expect(exercise.emotionalIntensityAfter, 0);
      expect(exercise.emotionAfter, isNull);
      expect(exercise.thoughtAfter, isNull);
    });

    test('toMap converte correttamente Exercise in mappa', () {
      final date = DateTime(2026, 5, 18, 11, 26);

      final exercise = Exercise(
        dateTime: date,
        exerciseType: '🏃‍♂️ Corsa',
        durationMinutes: 45,
        intention: '✅ Scaricare tensione',
        emotionalIntensityBefore: 7,
        emotionBefore: '😟 Ansia',
        thoughtBefore: 'Ho bisogno di sfogarmi',
        outcome: '✅ Più calmo',
        bodySensationsAfter: 'Stanco ma meglio',
        emotionalIntensityAfter: 4,
        emotionAfter: '😌 Serenità',
        thoughtAfter: 'Mi sento più leggero',
      );

      final map = exercise.toMap();

      expect(map['date_time'], date.toUtc().toIso8601String());
      expect(map['exercise_type'], '🏃‍♂️ Corsa');
      expect(map['duration_minutes'], 45);
      expect(map['intention'], '✅ Scaricare tensione');
      expect(map['emotional_intensity_before'], 7);
      expect(map['emotion_before'], '😟 Ansia');
      expect(map['thought_before'], 'Ho bisogno di sfogarmi');
      expect(map['outcome'], '✅ Più calmo');
      expect(map['body_sensations_after'], 'Stanco ma meglio');
      expect(map['emotional_intensity_after'], 4);
      expect(map['emotion_after'], '😌 Serenità');
      expect(map['thought_after'], 'Mi sento più leggero');

      expect(map.containsKey('id'), isFalse);
      expect(map.containsKey('created_at'), isFalse);
      expect(map.containsKey('updated_at'), isFalse);
    });

    test('fromMap ricostruisce correttamente Exercise', () {
      final date = DateTime(2026, 5, 18, 11, 26);
      final createdAt = DateTime.utc(2026, 5, 18, 9, 0);
      final updatedAt = DateTime.utc(2026, 5, 18, 10, 0);

      final map = <String, Object?>{
        'id': 1,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'date_time': date.toUtc().toIso8601String(),
        'exercise_type': '🚶‍♂️ Camminata',
        'duration_minutes': 30,
        'intention': '✅ Benessere / Energia',
        'emotional_intensity_before': 6,
        'emotion_before': '😌 Orgoglio',
        'thought_before': 'Voglio camminare',
        'outcome': '✅ Più leggero',
        'body_sensations_after': 'Gambe più sciolte',
        'emotional_intensity_after': 8,
        'emotion_after': '😌 Orgoglio',
        'thought_after': 'È andata bene',
      };

      final exercise = Exercise.fromMap(map);

      expect(exercise.id, 1);
      expect(exercise.createdAt, createdAt);
      expect(exercise.updatedAt, updatedAt);
      expect(exercise.dateTime, date);
      expect(exercise.exerciseType, '🚶‍♂️ Camminata');
      expect(exercise.durationMinutes, 30);
      expect(exercise.intention, '✅ Benessere / Energia');
      expect(exercise.emotionalIntensityBefore, 6);
      expect(exercise.emotionBefore, '😌 Orgoglio');
      expect(exercise.thoughtBefore, 'Voglio camminare');
      expect(exercise.outcome, '✅ Più leggero');
      expect(exercise.bodySensationsAfter, 'Gambe più sciolte');
      expect(exercise.emotionalIntensityAfter, 8);
      expect(exercise.emotionAfter, '😌 Orgoglio');
      expect(exercise.thoughtAfter, 'È andata bene');
    });

    test('fromMap usa i default quando alcuni valori numerici mancano', () {
      final date = DateTime(2026, 5, 18, 11, 26);

      final map = <String, Object?>{
        'date_time': date.toUtc().toIso8601String(),
        'exercise_type': '🚶‍♂️ Camminata',
      };

      final exercise = Exercise.fromMap(map);

      expect(exercise.dateTime, date);
      expect(exercise.exerciseType, '🚶‍♂️ Camminata');
      expect(exercise.durationMinutes, 20);
      expect(exercise.emotionalIntensityBefore, 0);
      expect(exercise.emotionalIntensityAfter, 0);
    });

    test('copyWith modifica solo i campi indicati', () {
      final original = Exercise(
        dateTime: DateTime(2026, 5, 18, 11, 26),
        exerciseType: '🚶‍♂️ Camminata',
        durationMinutes: 20,
        emotionBefore: '😐 Neutro',
      );

      final updated = original.copyWith(
        exerciseType: '🏃‍♂️ Corsa',
        durationMinutes: 40,
        emotionalIntensityBefore: 7,
      );

      expect(updated.exerciseType, '🏃‍♂️ Corsa');
      expect(updated.durationMinutes, 40);
      expect(updated.emotionalIntensityBefore, 7);

      expect(updated.dateTime, original.dateTime);
      expect(updated.emotionBefore, '😐 Neutro');
      expect(updated.emotionalIntensityAfter, 0);
    });

    test('copyWith permette di svuotare campi nullable', () {
      final original = Exercise(
        dateTime: DateTime(2026, 5, 18, 11, 26),
        exerciseType: '🚶‍♂️ Camminata',
        intention: '✅ Benessere / Energia',
        emotionBefore: '😌 Orgoglio',
        thoughtBefore: 'Voglio muovermi',
        outcome: '✅ Più leggero',
        bodySensationsAfter: 'Meglio',
        emotionAfter: '😌 Serenità',
        thoughtAfter: 'Sto bene',
      );

      final updated = original.copyWith(
        exerciseType: null,
        intention: null,
        emotionBefore: null,
        thoughtBefore: null,
        outcome: null,
        bodySensationsAfter: null,
        emotionAfter: null,
        thoughtAfter: null,
      );

      expect(updated.exerciseType, isNull);
      expect(updated.intention, isNull);
      expect(updated.emotionBefore, isNull);
      expect(updated.thoughtBefore, isNull);
      expect(updated.outcome, isNull);
      expect(updated.bodySensationsAfter, isNull);
      expect(updated.emotionAfter, isNull);
      expect(updated.thoughtAfter, isNull);
    });

    test('due Exercise uguali hanno stessa equality e stesso hashCode', () {
      final date = DateTime(2026, 5, 18, 11, 26);

      final exercise1 = Exercise(
        dateTime: date,
        exerciseType: '🚶‍♂️ Camminata',
      );

      final exercise2 = Exercise(
        dateTime: date,
        exerciseType: '🚶‍♂️ Camminata',
      );

      expect(exercise1, exercise2);
      expect(exercise1.hashCode, exercise2.hashCode);
    });

    test('toString contiene informazioni principali', () {
      final exercise = Exercise(
        dateTime: DateTime(2026, 5, 18, 11, 26),
        exerciseType: '🚶‍♂️ Camminata',
        durationMinutes: 25,
      );

      expect(exercise.toString(), contains('Exercise'));
      expect(exercise.toString(), contains('🚶‍♂️ Camminata'));
      expect(exercise.toString(), contains('25'));
    });
  });
}