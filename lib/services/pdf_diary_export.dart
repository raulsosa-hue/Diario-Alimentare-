import 'dart:typed_data';
import 'dart:ui' show Color;

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/exercise.dart';
import '../models/meal.dart';
import '../styles.dart';
import '../widgets/diary/diary_card_helpers.dart';

// Colors — derived from DS constants in styles.dart

PdfColor _toPdf(Color c) => PdfColor.fromInt(c.toARGB32());

final _mealHeader = _toPdf(DS.diaryMealHeader);
final _mealAccent = _toPdf(DS.diaryMealAccent);
final _mealSectionBar = _toPdf(DS.diaryMealSectionBar);

final _exerciseHeader = _toPdf(DS.diaryExerciseHeader);
final _exerciseAccent = _toPdf(DS.diaryExerciseAccent);
final _exerciseSectionBar = _toPdf(DS.diaryExerciseSectionBar);

final _textPrimary = _toPdf(DS.textPrimary);
final _textDark = _toPdf(DS.textDark);
final _textNd = _toPdf(DS.textNd);

// Text styles (scaled down from DS for denser A4 layout)

// Mirrors DS.diaryCardHeaderText (16pt → 13pt)
final _headerStyle = pw.TextStyle(
  fontSize: 13,
  fontWeight: pw.FontWeight.bold,
  color: _textPrimary,
);

// Mirrors DS.diaryFieldLabel (14pt → 11pt)
final _labelStyle = pw.TextStyle(
  fontSize: 11,
  fontWeight: pw.FontWeight.bold,
  color: _textPrimary,
);

// Mirrors DS.diaryFieldValue (14pt → 11pt)
final _valueStyle = pw.TextStyle(
  fontSize: 11,
  color: _textDark,
);

final _ndStyle = pw.TextStyle(
  fontSize: 11,
  color: _textNd,
);

// Public API
pw.Font? _cachedRegular;
pw.Font? _cachedBold;
List<pw.Font>? _cachedFontFallback;

Future<({pw.Font regular, pw.Font bold, List<pw.Font> fallback})> _loadFonts() async {
  if (_cachedRegular != null && _cachedBold != null && _cachedFontFallback != null) {
    return (
    regular: _cachedRegular!,
    bold: _cachedBold!,
    fallback: _cachedFontFallback!,
    );
  }

  try {
    final regularData = await rootBundle.load('assets/fonts/NotoSans-Regular.ttf');
    final boldData = await rootBundle.load('assets/fonts/NotoSans-Bold.ttf');

    _cachedRegular = pw.Font.ttf(regularData);
    _cachedBold = pw.Font.ttf(boldData);

    final fallback = <pw.Font>[];

    try {
      final emojiData = await rootBundle.load('assets/fonts/NotoEmoji-Regular.ttf');
      fallback.add(pw.Font.ttf(emojiData));
    } catch (_) {
      // Il PDF viene comunque generato anche se il font emoji non è compatibile.
    }

    _cachedFontFallback = fallback;

    return (
    regular: _cachedRegular!,
    bold: _cachedBold!,
    fallback: _cachedFontFallback!,
    );
  } catch (_) {
    // Fallback utile soprattutto nei test o se i font asset hanno problemi.
    _cachedRegular = pw.Font.helvetica();
    _cachedBold = pw.Font.helveticaBold();
    _cachedFontFallback = <pw.Font>[];

    return (
    regular: _cachedRegular!,
    bold: _cachedBold!,
    fallback: _cachedFontFallback!,
    );
  }
}

/// Generates a PDF for one week of diary entries, returning the raw bytes.
Future<Uint8List> generateWeeklyDiaryPdf({
  required DateTime monday,
  required List<Meal> meals,
  required List<Exercise> exercises,
}) async {
  final fonts = await _loadFonts();

  // Build card widgets tagged with dateTime for sorting.
  final cards = <({DateTime dt, pw.Widget card})>[
    for (final m in meals) (dt: m.dateTime, card: _mealCard(m)),
    for (final e in exercises) (dt: e.dateTime, card: _exerciseCard(e)),
  ]..sort((a, b) => a.dt.compareTo(b.dt));

  final doc = pw.Document();
  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      theme: pw.ThemeData.withFont(
        base: fonts.regular,
        bold: fonts.bold,
        fontFallback: fonts.fallback,
      ),
      header: (_) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 12),
        child: pw.Text(
          formatWeekHeader(monday),
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: _textPrimary,
          ),
        ),
      ),
      footer: (context) => pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Text(
          '${context.pageNumber} / ${context.pagesCount}',
          style: pw.TextStyle(fontSize: 10, color: _textNd),
        ),
      ),
      build: (_) => [for (final c in cards) c.card],
    ),
  );

  return doc.save();
}

// Card builders

pw.Widget _mealCard(Meal meal) {
  return _card(
    headerColor: _mealHeader,
    accentColor: _mealAccent,
    sectionBarColor: _mealSectionBar,
    headerDateTime: formatDiaryCardDateTime(meal.dateTime),
    typeLabel: meal.mealType,
    bodyFields: [
      _fieldRow('Orario', '${meal.startTime} – ${meal.endTime}'),
      _fieldRow('Dove', meal.location),
      _fieldRow('Con chi', meal.withWhom),
      _fieldRow('Cosa mangiato', meal.whatEaten),
    ],
    primaFields: [
      _fieldRow('Sensazioni', meal.bodySensationsBefore),
      _fieldRow('Intensità emotiva', '${meal.emotionalIntensityBefore}/10'),
      _fieldRow('Emozione', meal.emotionBefore),
      _fieldRow('Pensiero', meal.thoughtBefore),
    ],
    dopoFields: [
      _fieldRow('Sensazioni', meal.bodySensationsAfter),
      _fieldRow('Intensità emotiva', '${meal.emotionalIntensityAfter}/10'),
      _fieldRow('Emozione', meal.emotionAfter),
      _fieldRow('Pensiero', meal.thoughtAfter),
    ],
  );
}

pw.Widget _exerciseCard(Exercise exercise) {
  return _card(
    headerColor: _exerciseHeader,
    accentColor: _exerciseAccent,
    sectionBarColor: _exerciseSectionBar,
    headerDateTime: formatDiaryCardDateTime(exercise.dateTime),
    typeLabel: exercise.exerciseType ?? 'N/D',
    bodyFields: [
      _fieldRow('Durata', '${exercise.durationMinutes} min'),
    ],
    primaFields: [
      _fieldRow('Perché', exercise.intention),
      _fieldRow('Intensità emotiva', '${exercise.emotionalIntensityBefore}/10'),
      _fieldRow('Emozione', exercise.emotionBefore),
      _fieldRow('Pensiero', exercise.thoughtBefore),
    ],
    dopoFields: [
      _fieldRow('Esito', exercise.outcome),
      _fieldRow('Sensazioni', exercise.bodySensationsAfter),
      _fieldRow('Intensità emotiva', '${exercise.emotionalIntensityAfter}/10'),
      _fieldRow('Emozione', exercise.emotionAfter),
      _fieldRow('Pensiero', exercise.thoughtAfter),
    ],
  );
}

// Prevent cards from being split across pages

class _KeepTogether extends pw.StatelessWidget {
  _KeepTogether({required this.child});
  final pw.Widget child;

  @override
  bool get canSpan => false;

  @override
  pw.Widget build(pw.Context context) => child;
}

// Shared card layout

pw.Widget _card({
  required PdfColor headerColor,
  required PdfColor accentColor,
  required PdfColor sectionBarColor,
  required String headerDateTime,
  required String typeLabel,
  required List<pw.Widget> bodyFields,
  required List<pw.Widget> primaFields,
  required List<pw.Widget> dopoFields,
}) {
  return _KeepTogether(
      child: pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 4),
    child: pw.ClipRRect(
      horizontalRadius: 10,
      verticalRadius: 10,
      child: pw.Container(
        decoration: pw.BoxDecoration(color: accentColor),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            // Header row: date/time left, type right.
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: pw.BoxDecoration(color: headerColor),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    child: pw.Text(headerDateTime, style: _headerStyle),
                  ),
                  pw.SizedBox(width: 8),
                  pw.Text(typeLabel, style: _headerStyle),
                ],
              ),
            ),
            pw.SizedBox(height: 3),
            ...bodyFields,
            pw.SizedBox(height: 4),
            // Prima section
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 5,
              ),
              decoration: pw.BoxDecoration(color: sectionBarColor),
              child: pw.Text('Prima', style: _labelStyle),
            ),
            pw.SizedBox(height: 2),
            ...primaFields,
            pw.SizedBox(height: 4),
            // Dopo section
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 5,
              ),
              decoration: pw.BoxDecoration(color: sectionBarColor),
              child: pw.Text('Dopo', style: _labelStyle),
            ),
            pw.SizedBox(height: 2),
            ...dopoFields,
            pw.SizedBox(height: 8),
          ],
        ),
      ),
    ),
  ));
}

/// Label/value field row. Null or empty values display "N/D" in muted style.
pw.Widget _fieldRow(String label, String? value) {
  final hasValue = value != null && value.trim().isNotEmpty;
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 2),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('$label: ', style: _labelStyle),
        pw.Expanded(
          child: pw.Text(
            hasValue ? value : 'N/D',
            style: hasValue ? _valueStyle : _ndStyle,
          ),
        ),
      ],
    ),
  );
}
