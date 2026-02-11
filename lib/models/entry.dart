
class DiaryEntry {
  final DateTime dateTime;
  final String type; // 'pasto', 'pasto_aggiuntivo', 'esercizio'
  final String category; // colazione, pranzo, cena, spuntino, corsa, camminata...
  final String content; // cosa mangio / tipo esercizio extra
  final int? durationMinutes; // solo per esercizio
  final String? intensity; // solo per esercizio
  final String? place;
  final String? company;
  final String? mood;
  final String? notes;

  DiaryEntry({
    required this.dateTime,
    required this.type,
    required this.category,
    required this.content,
    this.durationMinutes,
    this.intensity,
    this.place,
    this.company,
    this.mood,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'type': type,
      'category': category,
      'content': content,
      'durationMinutes': durationMinutes,
      'intensity': intensity,
      'place': place,
      'company': company,
      'mood': mood,
      'notes': notes,
    };
  }

  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(
      dateTime: DateTime.parse(json['dateTime'] as String),
      type: json['type'] as String,
      category: json['category'] as String,
      content: json['content'] as String,
      durationMinutes: json['durationMinutes'] as int?,
      intensity: json['intensity'] as String?,
      place: json['place'] as String?,
      company: json['company'] as String?,
      mood: json['mood'] as String?,
      notes: json['notes'] as String?,
    );
  }
}
