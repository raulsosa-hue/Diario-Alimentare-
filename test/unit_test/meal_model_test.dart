import 'package:flutter_test/flutter_test.dart';
import 'package:mi_ascolto/models/meal.dart';

void main() {
  group('Meal model', () {
    test('crea un Meal con valori obbligatori e default corretti', () {
      final date = DateTime(2026, 5, 18, 12, 30);

      final meal = Meal(
        dateTime: date,
        startTime: '12:30',
        endTime: '13:00',
      );

      expect(meal.id, isNull);
      expect(meal.createdAt, isNull);
      expect(meal.updatedAt, isNull);

      expect(meal.dateTime, date);
      expect(meal.mealType, 'Colazione');
      expect(meal.startTime, '12:30');
      expect(meal.endTime, '13:00');

      expect(meal.emotionalIntensityBefore, 0);
      expect(meal.emotionalIntensityAfter, 0);

      expect(meal.location, isNull);
      expect(meal.withWhom, isNull);
      expect(meal.whatEaten, isNull);
    });

    test('toMap converte correttamente il Meal in mappa per il database', () {
      final date = DateTime(2026, 5, 18, 12, 30);

      final meal = Meal(
        dateTime: date,
        mealType: 'Pranzo',
        location: 'Casa',
        withWhom: 'Famiglia',
        bodySensationsBefore: 'Fame',
        emotionalIntensityBefore: 6,
        emotionBefore: '😊 Gioia',
        thoughtBefore: 'Ho fame',
        startTime: '12:30',
        endTime: '13:00',
        whatEaten: 'Pasta',
        bodySensationsAfter: 'Sazio',
        emotionalIntensityAfter: 8,
        emotionAfter: '😌 Calma',
        thoughtAfter: 'Sto meglio',
      );

      final map = meal.toMap();

      expect(map['date_time'], date.toUtc().toIso8601String());
      expect(map['meal_type'], 'Pranzo');
      expect(map['location'], 'Casa');
      expect(map['with_whom'], 'Famiglia');
      expect(map['body_sensations_before'], 'Fame');
      expect(map['emotional_intensity_before'], 6);
      expect(map['emotion_before'], '😊 Gioia');
      expect(map['thought_before'], 'Ho fame');
      expect(map['start_time'], '12:30');
      expect(map['end_time'], '13:00');
      expect(map['what_eaten'], 'Pasta');
      expect(map['body_sensations_after'], 'Sazio');
      expect(map['emotional_intensity_after'], 8);
      expect(map['emotion_after'], '😌 Calma');
      expect(map['thought_after'], 'Sto meglio');

      expect(map.containsKey('id'), isFalse);
      expect(map.containsKey('created_at'), isFalse);
      expect(map.containsKey('updated_at'), isFalse);
    });

    test('fromMap ricostruisce correttamente un Meal dal database', () {
      final date = DateTime(2026, 5, 18, 12, 30);
      final createdAt = DateTime.utc(2026, 5, 18, 10, 0);
      final updatedAt = DateTime.utc(2026, 5, 18, 11, 0);

      final meal = Meal.fromMap({
        'id': 7,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'date_time': date.toUtc().toIso8601String(),
        'meal_type': 'Pranzo',
        'location': 'Casa',
        'with_whom': 'Famiglia',
        'body_sensations_before': 'Fame',
        'emotional_intensity_before': 6,
        'emotion_before': '😊 Gioia',
        'thought_before': 'Ho fame',
        'start_time': '12:30',
        'end_time': '13:00',
        'what_eaten': 'Pasta',
        'body_sensations_after': 'Sazio',
        'emotional_intensity_after': 8,
        'emotion_after': '😌 Calma',
        'thought_after': 'Sto meglio',
      });

      expect(meal.id, 7);
      expect(meal.createdAt, createdAt);
      expect(meal.updatedAt, updatedAt);
      expect(meal.dateTime, date);

      expect(meal.mealType, 'Pranzo');
      expect(meal.location, 'Casa');
      expect(meal.withWhom, 'Famiglia');
      expect(meal.bodySensationsBefore, 'Fame');
      expect(meal.emotionalIntensityBefore, 6);
      expect(meal.emotionBefore, '😊 Gioia');
      expect(meal.thoughtBefore, 'Ho fame');
      expect(meal.startTime, '12:30');
      expect(meal.endTime, '13:00');
      expect(meal.whatEaten, 'Pasta');
      expect(meal.bodySensationsAfter, 'Sazio');
      expect(meal.emotionalIntensityAfter, 8);
      expect(meal.emotionAfter, '😌 Calma');
      expect(meal.thoughtAfter, 'Sto meglio');
    });

    test('fromMap usa i valori di default quando alcuni campi sono null', () {
      final date = DateTime(2026, 5, 18, 8, 15);

      final meal = Meal.fromMap({
        'id': null,
        'created_at': null,
        'updated_at': null,
        'date_time': date.toUtc().toIso8601String(),
        'meal_type': null,
        'location': null,
        'with_whom': null,
        'body_sensations_before': null,
        'emotional_intensity_before': null,
        'emotion_before': null,
        'thought_before': null,
        'start_time': '08:15',
        'end_time': '08:30',
        'what_eaten': null,
        'body_sensations_after': null,
        'emotional_intensity_after': null,
        'emotion_after': null,
        'thought_after': null,
      });

      expect(meal.mealType, 'Colazione');
      expect(meal.emotionalIntensityBefore, 0);
      expect(meal.emotionalIntensityAfter, 0);
      expect(meal.startTime, '08:15');
      expect(meal.endTime, '08:30');
    });

    test('copyWith modifica solo i campi indicati', () {
      final date = DateTime(2026, 5, 18, 12, 30);
      final newDate = DateTime(2026, 5, 19, 20, 15);

      final meal = Meal(
        dateTime: date,
        mealType: 'Pranzo',
        location: 'Casa',
        startTime: '12:30',
        endTime: '13:00',
        whatEaten: 'Pasta',
      );

      final updated = meal.copyWith(
        dateTime: newDate,
        mealType: 'Cena',
        startTime: '20:15',
        endTime: '20:45',
        whatEaten: 'Pizza',
        emotionalIntensityAfter: 9,
      );

      expect(updated.dateTime, newDate);
      expect(updated.mealType, 'Cena');
      expect(updated.startTime, '20:15');
      expect(updated.endTime, '20:45');
      expect(updated.whatEaten, 'Pizza');
      expect(updated.emotionalIntensityAfter, 9);

      expect(updated.location, 'Casa');
      expect(updated.emotionalIntensityBefore, 0);
    });

    test('copyWith permette di cancellare campi nullable', () {
      final meal = Meal(
        dateTime: DateTime(2026, 5, 18, 12, 30),
        mealType: 'Pranzo',
        location: 'Casa',
        withWhom: 'Famiglia',
        startTime: '12:30',
        endTime: '13:00',
        whatEaten: 'Pasta',
      );

      final updated = meal.copyWith(
        location: null,
        withWhom: null,
        whatEaten: null,
      );

      expect(updated.location, isNull);
      expect(updated.withWhom, isNull);
      expect(updated.whatEaten, isNull);

      expect(updated.mealType, 'Pranzo');
      expect(updated.startTime, '12:30');
      expect(updated.endTime, '13:00');
    });

    test('due Meal uguali hanno stessa equality e stesso hashCode', () {
      final date = DateTime(2026, 5, 18, 12, 30);

      final first = Meal(
        dateTime: date,
        mealType: 'Pranzo',
        startTime: '12:30',
        endTime: '13:00',
      );

      final second = Meal(
        dateTime: date,
        mealType: 'Pranzo',
        startTime: '12:45',
        endTime: '13:15',
      );

      expect(first, second);
      expect(first.hashCode, second.hashCode);
    });

    test('due Meal con tipo pasto diverso non sono uguali', () {
      final date = DateTime(2026, 5, 18, 12, 30);

      final first = Meal(
        dateTime: date,
        mealType: 'Pranzo',
        startTime: '12:30',
        endTime: '13:00',
      );

      final second = Meal(
        dateTime: date,
        mealType: 'Cena',
        startTime: '20:00',
        endTime: '20:30',
      );

      expect(first == second, isFalse);
    });
  });
}