const diaryWeekdaysFull = [
  'Lunedì',
  'Martedì',
  'Mercoledì',
  'Giovedì',
  'Venerdì',
  'Sabato',
  'Domenica',
];

const diaryMonthsFull = [
  'Gennaio',
  'Febbraio',
  'Marzo',
  'Aprile',
  'Maggio',
  'Giugno',
  'Luglio',
  'Agosto',
  'Settembre',
  'Ottobre',
  'Novembre',
  'Dicembre',
];

String cleanDiaryValue(String? value) {
  if (value == null) return '';

  final trimmed = value.trim();

  if (trimmed.isEmpty) return '';
  if (trimmed.toUpperCase() == 'N/D') return '';

  return trimmed;
}

String? cleanDiaryValueOrNull(String? value) {
  final cleaned = cleanDiaryValue(value);
  return cleaned.isEmpty ? null : cleaned;
}

bool hasDiaryValue(String? value) {
  return cleanDiaryValue(value).isNotEmpty;
}

String formatDiaryTime(DateTime dt) {
  return '${_two(dt.hour)}:${_two(dt.minute)}';
}

String formatDiaryFullDay(DateTime date) {
  final weekday = diaryWeekdaysFull[date.weekday - 1];
  final month = diaryMonthsFull[date.month - 1];

  return '$weekday ${date.day} $month';
}

String formatDiaryWeekRange(DateTime monday) {
  final sunday = monday.add(const Duration(days: 6));

  final startMonth = diaryMonthsFull[monday.month - 1];
  final endMonth = diaryMonthsFull[sunday.month - 1];

  if (monday.month == sunday.month && monday.year == sunday.year) {
    return '${monday.day} – ${sunday.day} $endMonth ${sunday.year}';
  }

  return '${monday.day} $startMonth ${monday.year} – ${sunday.day} $endMonth ${sunday.year}';
}

String diaryPlural(int count, String singular, String plural) {
  return count == 1 ? singular : plural;
}

String diaryEventCountLabel(int count) {
  return count == 1 ? '1 evento' : '$count eventi';
}

int isoWeekNumber(DateTime date) {
  final current = DateTime(date.year, date.month, date.day);

  final thursday = current.add(Duration(days: 4 - current.weekday));
  final firstThursday = DateTime(thursday.year, 1, 4);
  final firstWeekMonday = firstThursday.subtract(
    Duration(days: firstThursday.weekday - 1),
  );

  return 1 + thursday.difference(firstWeekMonday).inDays ~/ 7;
}

String _two(int n) {
  return n.toString().padLeft(2, '0');
}