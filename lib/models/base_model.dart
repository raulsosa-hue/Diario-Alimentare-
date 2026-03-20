/// Sentinel used by `copyWith` implementations to distinguish "not provided"
/// from an explicit `null`, allowing nullable fields to be explicitly cleared.
const absent = Object();

/// Shared contract for all persisted domain objects.
///
/// Implementing classes must provide [toMap] returning a flat map
/// compatible with the DB persistence layer.
///
/// Column conventions:
///   - [id]        → INTEGER PRIMARY KEY AUTOINCREMENT (null before insert — the DB assigns it)
///   - [createdAt] → TEXT ISO-8601 UTC, DEFAULT (strftime) (null before insert — the DB assigns it)
///   - [updatedAt] → TEXT ISO-8601 UTC, DEFAULT + AFTER UPDATE trigger — (the DB manages it on INSERT/UPDATE)
///
/// Because all three audit columns are managed by the DB, they are null in
/// newly constructed Dart objects and populated only after a DB round-trip.
/// [toMap] omits them when null so that the DB defaults take effect.
abstract interface class BaseModel {
  int? get id;
  DateTime? get createdAt;
  DateTime? get updatedAt;

  /// Serialises the entry to a flat map ready for sqflite insert/update.
  /// All [DateTime] values are stored as ISO-8601 UTC strings.
  /// Null optional fields are represented as null map values (SQL NULL).
  /// DB-managed columns ([id], [createdAt], [updatedAt]) are omitted when
  /// null so that the DB defaults and triggers take effect.
  Map<String, Object?> toMap();
}
