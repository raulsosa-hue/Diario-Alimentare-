class EmotionItem {
  final String label;
  final String emoji;
  const EmotionItem(this.label, this.emoji);
}

const List<EmotionItem> kEmotions = <EmotionItem>[
  EmotionItem("Fame d'amore", '❤️'),
  EmotionItem('Gioia', '😊'),
  EmotionItem('Tristezza', '😢'),
  EmotionItem('Rabbia', '😠'),
  EmotionItem('Paura', '😨'),
  EmotionItem('Ansia', '😰'),
  EmotionItem('Disgusto', '🤢'),
  EmotionItem('Sorpresa', '😮'),
  EmotionItem('Orgoglio', '😌'),
  EmotionItem('Imbarazzo / Vergogna', '😳'),
  EmotionItem('Invidia / Gelosia', '😒'),
  EmotionItem('Nostalgia', '🥲'),
  EmotionItem('Colpa / Rimorso', '😔'),
  EmotionItem('Frustrazione', '😤'),
  EmotionItem('Solitudine', '😔'),
  EmotionItem('Apatia', '😐'),
  EmotionItem('Vuoto', '🫥'),
  EmotionItem('Calma', '🧘'),
];

/// Formats a selected emotion label as "emoji label" for DB storage.
/// Returns the label as-is for custom emotions, null for empty input.
String? buildEmotionStorageValue(String? label) {
  if (label == null || label.isEmpty) return null;
  final match = kEmotions.cast<EmotionItem?>().firstWhere(
        (e) => e!.label == label,
        orElse: () => null,
      );
  if (match == null) return label; // custom emotion — store as-is
  return '${match.emoji} ${match.label}';
}
