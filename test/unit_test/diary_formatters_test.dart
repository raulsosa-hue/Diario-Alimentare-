import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_ascolto/utils/diary_formatters.dart';

void main() {
  group('cleanDiaryValue', () {
    test('restituisce stringa vuota se il valore è null', () {
      expect(cleanDiaryValue(null), '');
    });

    test('restituisce stringa vuota se il valore è vuoto', () {
      expect(cleanDiaryValue(''), '');
      expect(cleanDiaryValue('   '), '');
    });

    test('rimuove gli spazi iniziali e finali', () {
      expect(cleanDiaryValue('  Corsa  '), 'Corsa');
    });

    test('restituisce stringa vuota se il valore è N/D', () {
      expect(cleanDiaryValue('N/D'), '');
      expect(cleanDiaryValue('n/d'), '');
      expect(cleanDiaryValue('  N/D  '), '');
    });
  });

  group('cleanDiaryValueOrNull', () {
    test('restituisce null se il valore pulito è vuoto', () {
      expect(cleanDiaryValueOrNull(null), isNull);
      expect(cleanDiaryValueOrNull(''), isNull);
      expect(cleanDiaryValueOrNull('N/D'), isNull);
    });

    test('restituisce il testo pulito se valido', () {
      expect(cleanDiaryValueOrNull('  Pranzo  '), 'Pranzo');
    });
  });

  group('hasDiaryValue', () {
    test('restituisce false se il valore non è valido', () {
      expect(hasDiaryValue(null), isFalse);
      expect(hasDiaryValue(''), isFalse);
      expect(hasDiaryValue('   '), isFalse);
      expect(hasDiaryValue('N/D'), isFalse);
    });

    test('restituisce true se il valore è valido', () {
      expect(hasDiaryValue('Camminata'), isTrue);
      expect(hasDiaryValue('  Camminata  '), isTrue);
    });
  });

  group('formatDiaryTime', () {
    test('formatta ora e minuti con due cifre', () {
      final date = DateTime(2026, 5, 18, 9, 5);

      expect(formatDiaryTime(date), '09:05');
    });

    test('formatta correttamente orari già a due cifre', () {
      final date = DateTime(2026, 5, 18, 14, 30);

      expect(formatDiaryTime(date), '14:30');
    });
  });

  group('formatDiaryFullDay', () {
    test('formatta giorno completo in italiano', () {
      final date = DateTime(2026, 5, 18);

      expect(formatDiaryFullDay(date), 'Lunedì 18 Maggio');
    });

    test('formatta correttamente una domenica', () {
      final date = DateTime(2026, 5, 24);

      expect(formatDiaryFullDay(date), 'Domenica 24 Maggio');
    });
  });

  group('formatDiaryWeekRange', () {
    test('formatta una settimana nello stesso mese', () {
      final monday = DateTime(2026, 5, 18);

      expect(formatDiaryWeekRange(monday), '18 – 24 Maggio 2026');
    });

    test('formatta una settimana che attraversa due mesi', () {
      final monday = DateTime(2026, 6, 29);

      expect(formatDiaryWeekRange(monday), '29 Giugno 2026 – 5 Luglio 2026');
    });

    test('formatta una settimana che attraversa due anni', () {
      final monday = DateTime(2024, 12, 30);

      expect(formatDiaryWeekRange(monday), '30 Dicembre 2024 – 5 Gennaio 2025');
    });
  });

  group('diaryPlural', () {
    test('restituisce singolare con count uguale a 1', () {
      expect(diaryPlural(1, 'evento', 'eventi'), 'evento');
    });

    test('restituisce plurale con count diverso da 1', () {
      expect(diaryPlural(0, 'evento', 'eventi'), 'eventi');
      expect(diaryPlural(2, 'evento', 'eventi'), 'eventi');
    });
  });

  group('diaryEventCountLabel', () {
    test('restituisce etichetta singolare', () {
      expect(diaryEventCountLabel(1), '1 evento');
    });

    test('restituisce etichetta plurale', () {
      expect(diaryEventCountLabel(0), '0 eventi');
      expect(diaryEventCountLabel(3), '3 eventi');
    });
  });

  group('isoWeekNumber', () {
    test('calcola correttamente la settimana 21 del 2026', () {
      final date = DateTime(2026, 5, 18);

      expect(isoWeekNumber(date), 21);
    });

    test('calcola correttamente la settimana ISO a inizio anno', () {
      final date = DateTime(2026, 1, 1);

      expect(isoWeekNumber(date), 1);
    });

    test('calcola correttamente una settimana ISO che appartiene al nuovo anno', () {
      final date = DateTime(2024, 12, 30);

      expect(isoWeekNumber(date), 1);
    });
  });

  group('formatTimeOfDay', () {
    test('restituisce placeholder se TimeOfDay è null', () {
      expect(formatTimeOfDay(null), '--:--');
    });

    test('formatta TimeOfDay con due cifre', () {
      const time = TimeOfDay(hour: 7, minute: 4);

      expect(formatTimeOfDay(time), '07:04');
    });
  });

  group('formatPrettyDate', () {
    test('formatta una data leggibile in italiano', () {
      final date = DateTime(2026, 5, 18);

      expect(formatPrettyDate(date), 'Lunedì 18 Maggio');
    });
  });
}