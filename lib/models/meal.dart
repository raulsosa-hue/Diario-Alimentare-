import 'package:flutter/foundation.dart';

import 'base_model.dart';

/// Immutable domain model for a meal diary entry.
///
/// [startTime] and [endTime] are stored as "HH:mm" strings (24-hour format).
/// [dateTime] is the user-selected diary timestamp (local time).
/// [createdAt] and [updatedAt] are UTC audit timestamps managed by the DB
/// (null before the first DB round-trip).
///
/// Canonical list of meal types used across the app.
const kMealTypes = <String>[
  'Colazione',
  'Spuntino',
  'Pranzo',
  'Merenda',
  'Cena',
];

/// The DB table name: `meals`
@immutable
final class Meal implements BaseModel {
  const Meal({
    required this.dateTime,
    this.mealType = 'Colazione',
    this.location,
    this.withWhom,
    this.bodySensationsBefore,
    this.emotionalIntensityBefore = 0,
    this.emotionBefore,
    this.thoughtBefore,
    required this.startTime,
    required this.endTime,
    this.whatEaten,
    this.bodySensationsAfter,
    this.emotionalIntensityAfter = 0,
    this.emotionAfter,
    this.thoughtAfter,
  })  : id = null,
        createdAt = null,
        updatedAt = null;

  /// Internal constructor used by [fromMap] and [copyWith] to hydrate
  /// DB-managed fields that the public constructor intentionally hides.
  const Meal._({
    this.id,
    this.createdAt,
    this.updatedAt,
    required this.dateTime,
    this.mealType = 'Colazione',
    this.location,
    this.withWhom,
    this.bodySensationsBefore,
    this.emotionalIntensityBefore = 0,
    this.emotionBefore,
    this.thoughtBefore,
    required this.startTime,
    required this.endTime,
    this.whatEaten,
    this.bodySensationsAfter,
    this.emotionalIntensityAfter = 0,
    this.emotionAfter,
    this.thoughtAfter,
  });

  // --- Audit / identity ---
  @override
  final int? id;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  // --- Diary timestamp ---
  final DateTime dateTime;

  // --- Meal identification ---
  final String mealType; // e.g. "Colazione", "Pranzo"

  // --- Before meal ---
  final String? location;
  final String? withWhom;
  final String? bodySensationsBefore;
  final int emotionalIntensityBefore; // 0–10
  final String? emotionBefore; // e.g. "😊  Gioia"
  final String? thoughtBefore;

  // --- During meal ---
  final String startTime; // "HH:mm"
  final String endTime; // "HH:mm"
  final String? whatEaten;

  // --- After meal ---
  final String? bodySensationsAfter;
  final int emotionalIntensityAfter; // 0–10
  final String? emotionAfter; // e.g. "😊  Gioia"
  final String? thoughtAfter;

  // ---------------------------------------------------------------------------
  // copyWith — uses sentinel to allow nullable fields to be explicitly cleared.
  // ---------------------------------------------------------------------------

  Meal copyWith({
    DateTime? dateTime,
    String? mealType,
    Object? location = absent,
    Object? withWhom = absent,
    Object? bodySensationsBefore = absent,
    int? emotionalIntensityBefore,
    Object? emotionBefore = absent,
    Object? thoughtBefore = absent,
    String? startTime,
    String? endTime,
    Object? whatEaten = absent,
    Object? bodySensationsAfter = absent,
    int? emotionalIntensityAfter,
    Object? emotionAfter = absent,
    Object? thoughtAfter = absent,
  }) {
    return Meal._(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      dateTime: dateTime ?? this.dateTime,
      mealType: mealType ?? this.mealType,
      location: identical(location, absent) ? this.location : location as String?,
      withWhom: identical(withWhom, absent) ? this.withWhom : withWhom as String?,
      bodySensationsBefore: identical(bodySensationsBefore, absent) ? this.bodySensationsBefore : bodySensationsBefore as String?,
      emotionalIntensityBefore: emotionalIntensityBefore ?? this.emotionalIntensityBefore,
      emotionBefore: identical(emotionBefore, absent) ? this.emotionBefore : emotionBefore as String?,
      thoughtBefore: identical(thoughtBefore, absent) ? this.thoughtBefore : thoughtBefore as String?,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      whatEaten: identical(whatEaten, absent) ? this.whatEaten : whatEaten as String?,
      bodySensationsAfter: identical(bodySensationsAfter, absent) ? this.bodySensationsAfter : bodySensationsAfter as String?,
      emotionalIntensityAfter: emotionalIntensityAfter ?? this.emotionalIntensityAfter,
      emotionAfter: identical(emotionAfter, absent) ? this.emotionAfter : emotionAfter as String?,
      thoughtAfter: identical(thoughtAfter, absent) ? this.thoughtAfter : thoughtAfter as String?,
    );
  }

  // ---------------------------------------------------------------------------
  // Serialisation
  // ---------------------------------------------------------------------------

  @override
  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt!.toUtc().toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toUtc().toIso8601String(),
      'date_time': dateTime.toUtc().toIso8601String(),
      'meal_type': mealType,
      'location': location,
      'with_whom': withWhom,
      'body_sensations_before': bodySensationsBefore,
      'emotional_intensity_before': emotionalIntensityBefore,
      'emotion_before': emotionBefore,
      'thought_before': thoughtBefore,
      'start_time': startTime,
      'end_time': endTime,
      'what_eaten': whatEaten,
      'body_sensations_after': bodySensationsAfter,
      'emotional_intensity_after': emotionalIntensityAfter,
      'emotion_after': emotionAfter,
      'thought_after': thoughtAfter,
    };
  }

  factory Meal.fromMap(Map<String, Object?> map) {
    return Meal._(
      id: map['id'] as int?,
      createdAt: map['created_at'] == null ? null : DateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] == null ? null : DateTime.parse(map['updated_at'] as String),
      dateTime: DateTime.parse(map['date_time'] as String).toLocal(),
      mealType: (map['meal_type'] as String?) ?? 'Colazione',
      location: map['location'] as String?,
      withWhom: map['with_whom'] as String?,
      bodySensationsBefore: map['body_sensations_before'] as String?,
      emotionalIntensityBefore: (map['emotional_intensity_before'] as num?)?.toInt() ?? 0,
      emotionBefore: map['emotion_before'] as String?,
      thoughtBefore: map['thought_before'] as String?,
      startTime: map['start_time'] as String,
      endTime: map['end_time'] as String,
      whatEaten: map['what_eaten'] as String?,
      bodySensationsAfter: map['body_sensations_after'] as String?,
      emotionalIntensityAfter: (map['emotional_intensity_after'] as num?)?.toInt() ?? 0,
      emotionAfter: map['emotion_after'] as String?,
      thoughtAfter: map['thought_after'] as String?,
    );
  }

  // ---------------------------------------------------------------------------
  // Object overrides — identity equality keyed on id, dateTime, and mealType.
  // DB-managed audit timestamps are excluded (null before first round-trip).
  // ---------------------------------------------------------------------------

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Meal && runtimeType == other.runtimeType && id == other.id && dateTime == other.dateTime && mealType == other.mealType;

  @override
  int get hashCode => Object.hash(id, dateTime, mealType);

  @override
  String toString() => 'Meal(id: $id, mealType: $mealType, dateTime: $dateTime)';
}
