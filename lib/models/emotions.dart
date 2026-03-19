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
