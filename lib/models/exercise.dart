import 'package:flutter/foundation.dart';

import 'base_model.dart';

/// Immutable domain model for an exercise diary entry.
///
/// [exerciseType], [intention], and [outcome] include their emoji prefix
/// as displayed in the UI, e.g. "🚶‍♂️ Camminata", "✅ Benessere / Energia".
/// [dateTime] is the user-selected diary timestamp (local time).
/// [createdAt] and [updatedAt] are UTC audit timestamps managed by the DB
/// (null before the first DB round-trip).
///
/// The DB table name: `exercises`
@immutable
final class Exercise implements BaseModel {
  const Exercise({
    required this.dateTime,
    this.exerciseType,
    this.durationMinutes = 20,
    this.intention,
    this.emotionalIntensityBefore = 0,
    this.emotionBefore,
    this.thoughtBefore,
    this.outcome,
    this.bodySensationsAfter,
    this.emotionalIntensityAfter = 0,
    this.emotionAfter,
    this.thoughtAfter,
  })  : id = null,
        createdAt = null,
        updatedAt = null;

  /// Internal constructor used by [fromMap] and [copyWith] to hydrate
  /// DB-managed fields that the public constructor intentionally hides.
  const Exercise._({
    this.id,
    this.createdAt,
    this.updatedAt,
    required this.dateTime,
    this.exerciseType,
    this.durationMinutes = 20,
    this.intention,
    this.emotionalIntensityBefore = 0,
    this.emotionBefore,
    this.thoughtBefore,
    this.outcome,
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

  // --- Exercise identification ---
  final String? exerciseType; // e.g. "🚶‍♂️ Camminata" or custom text
  final int durationMinutes; // default 20

  // --- Before exercise ---
  final String? intention; // e.g. "✅ Benessere / Energia"
  final int emotionalIntensityBefore; // 0–10
  final String? emotionBefore; // e.g. "😊  Gioia"
  final String? thoughtBefore;

  // --- After exercise ---
  final String? outcome; // e.g. "✅ Più libero / leggero"
  final String? bodySensationsAfter;
  final int emotionalIntensityAfter; // 0–10
  final String? emotionAfter; // e.g. "😊  Gioia"
  final String? thoughtAfter;

  // ---------------------------------------------------------------------------
  // copyWith — uses sentinel to allow nullable fields to be explicitly cleared.
  // ---------------------------------------------------------------------------

  Exercise copyWith({
    DateTime? dateTime,
    Object? exerciseType = absent,
    int? durationMinutes,
    Object? intention = absent,
    int? emotionalIntensityBefore,
    Object? emotionBefore = absent,
    Object? thoughtBefore = absent,
    Object? outcome = absent,
    Object? bodySensationsAfter = absent,
    int? emotionalIntensityAfter,
    Object? emotionAfter = absent,
    Object? thoughtAfter = absent,
  }) {
    return Exercise._(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      dateTime: dateTime ?? this.dateTime,
      exerciseType: identical(exerciseType, absent) ? this.exerciseType : exerciseType as String?,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      intention: identical(intention, absent) ? this.intention : intention as String?,
      emotionalIntensityBefore: emotionalIntensityBefore ?? this.emotionalIntensityBefore,
      emotionBefore: identical(emotionBefore, absent) ? this.emotionBefore : emotionBefore as String?,
      thoughtBefore: identical(thoughtBefore, absent) ? this.thoughtBefore : thoughtBefore as String?,
      outcome: identical(outcome, absent) ? this.outcome : outcome as String?,
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
      'exercise_type': exerciseType,
      'duration_minutes': durationMinutes,
      'intention': intention,
      'emotional_intensity_before': emotionalIntensityBefore,
      'emotion_before': emotionBefore,
      'thought_before': thoughtBefore,
      'outcome': outcome,
      'body_sensations_after': bodySensationsAfter,
      'emotional_intensity_after': emotionalIntensityAfter,
      'emotion_after': emotionAfter,
      'thought_after': thoughtAfter,
    };
  }

  factory Exercise.fromMap(Map<String, Object?> map) {
    return Exercise._(
      id: map['id'] as int?,
      createdAt: map['created_at'] == null ? null : DateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] == null ? null : DateTime.parse(map['updated_at'] as String),
      dateTime: DateTime.parse(map['date_time'] as String).toLocal(),
      exerciseType: map['exercise_type'] as String?,
      durationMinutes: (map['duration_minutes'] as num?)?.toInt() ?? 20,
      intention: map['intention'] as String?,
      emotionalIntensityBefore: (map['emotional_intensity_before'] as num?)?.toInt() ?? 0,
      emotionBefore: map['emotion_before'] as String?,
      thoughtBefore: map['thought_before'] as String?,
      outcome: map['outcome'] as String?,
      bodySensationsAfter: map['body_sensations_after'] as String?,
      emotionalIntensityAfter: (map['emotional_intensity_after'] as num?)?.toInt() ?? 0,
      emotionAfter: map['emotion_after'] as String?,
      thoughtAfter: map['thought_after'] as String?,
    );
  }

  // ---------------------------------------------------------------------------
  // Object overrides — identity equality keyed on id, dateTime, and exerciseType.
  // DB-managed audit timestamps are excluded (null before first round-trip).
  // ---------------------------------------------------------------------------

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Exercise &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          dateTime == other.dateTime &&
          exerciseType == other.exerciseType;

  @override
  int get hashCode => Object.hash(id, dateTime, exerciseType);

  @override
  String toString() => 'Exercise(id: $id, exerciseType: $exerciseType, durationMinutes: $durationMinutes)';
}
