import 'package:flutter/material.dart';

import '../../styles.dart';
import '../common_buttons.dart';

final _ndStyle = DS.diaryFieldValue.copyWith(color: DS.textNd);

/// Shared card shell used by both DiaryMealCard and DiaryExerciseCard.
Widget diaryCard({
  required Color color,
  required Color headerColor,
  required Color sectionBarColor,
  required String headerDateTime,
  required String typeLabel,
  required List<Widget> bodyFields,
  required List<Widget> primaFields,
  required List<Widget> dopoFields,
}) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(DS.radiusCard),
    ),
    color: color,
    elevation: 0,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        diaryCardHeader(headerDateTime, typeLabel, headerColor),
        const SizedBox(height: 4),
        ...bodyFields,
        const SizedBox(height: 6),
        diarySectionBar('Prima', color: sectionBarColor),
        const SizedBox(height: 2),
        ...primaFields,
        const SizedBox(height: 6),
        diarySectionBar('Dopo', color: sectionBarColor),
        const SizedBox(height: 2),
        ...dopoFields,
        const SizedBox(height: 10),
      ],
    ),
  );
}

/// Header row for diary cards: date/time left-aligned, type label right-aligned.
Widget diaryCardHeader(
  String dateTimeFormatted,
  String typeLabel,
  Color backgroundColor,
) {
  return Container(
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(DS.radiusCard),
        topRight: Radius.circular(DS.radiusCard),
      ),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(dateTimeFormatted, style: DS.diaryCardHeaderText),
        ),
        const SizedBox(width: 8),
        Text(typeLabel, style: DS.diaryCardHeaderText),
      ],
    ),
  );
}

/// Section bar for "Prima" / "Dopo" headers, tinted to match the card.
Widget diarySectionBar(String title, {required Color color}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
    decoration: BoxDecoration(color: color),
    child: Text(title, style: DS.diaryFieldLabel),
  );
}

/// Label/value field row. Null or empty values display "N/D" in muted style.
Widget diaryFieldRow(String label, String? value) {
  final hasValue = value != null && value.trim().isNotEmpty;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ', style: DS.diaryFieldLabel),
        Expanded(
          child: Text(
            hasValue ? value : 'N/D',
            style: hasValue ? DS.diaryFieldValue : _ndStyle,
          ),
        ),
      ],
    ),
  );
}

// --- Italian date formatting helpers ---

const _weekdaysShort = ['Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom'];

const _monthsFull = [
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

/// Formats a DateTime for card headers, e.g. "Lun 23, 12:16".
String formatDiaryCardDateTime(DateTime dt) {
  final wd = _weekdaysShort[dt.weekday - 1];
  return '$wd ${dt.day}, ${twoDigit(dt.hour)}:${twoDigit(dt.minute)}';
}

/// Formats a Monday date for week headers, e.g. "Settimana del 23 Marzo 2026".
String formatWeekHeader(DateTime monday) {
  final month = _monthsFull[monday.month - 1];
  return 'Settimana del ${monday.day} $month ${monday.year}';
}
