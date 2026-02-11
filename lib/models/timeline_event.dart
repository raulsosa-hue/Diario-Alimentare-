class TimelineEvent {
  final DateTime dateTime;

  /// Tipo evento: "Pasto" oppure "Esercizio" (o altri in futuro).
  final String eventType;

  /// Fase: "Prima" / "Pasto" / "Dopo" (per il pasto). Per esercizio puoi mettere "".
  final String phase;

  /// Categoria: es. "Colazione", "Pranzo", "Cena"...
  final String category;

  /// Dati liberi (testi / numeri) da esportare.
  final Map<String, dynamic> data;

  TimelineEvent({
    required this.dateTime,
    required this.eventType,
    required this.phase,
    required this.category,
    required this.data,
  });
}
