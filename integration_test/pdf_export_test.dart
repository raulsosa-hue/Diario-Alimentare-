import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';

import 'package:mi_ascolto/models/exercise.dart';
import 'package:mi_ascolto/models/meal.dart';
import 'package:mi_ascolto/services/pdf_diary_export.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('PDF export reale su smartphone', () {
    testWidgets('genera e salva un PDF settimanale reale', (tester) async {
      final bytes = await generateWeeklyDiaryPdf(
        monday: DateTime(2026, 5, 18),
        meals: [
          Meal(
            dateTime: DateTime(2026, 5, 18, 13, 15),
            mealType: 'Pranzo',
            location: 'Casa',
            withWhom: 'Da solo',
            bodySensationsBefore: 'Fame leggera',
            emotionalIntensityBefore: 6,
            emotionBefore: 'Serenità',
            thoughtBefore: 'Mi sento tranquillo',
            startTime: '13:15',
            endTime: '13:45',
            whatEaten: 'Pasta al pomodoro',
            bodySensationsAfter: 'Sazietà',
            emotionalIntensityAfter: 7,
            emotionAfter: 'Serenità',
            thoughtAfter: 'Mi sento meglio',
          ),
        ],
        exercises: [
          Exercise(
            dateTime: DateTime(2026, 5, 18, 18, 30),
            exerciseType: 'Corsa',
            durationMinutes: 30,
            intention: 'Benessere / Energia',
            emotionalIntensityBefore: 4,
            emotionBefore: 'Serenità',
            thoughtBefore: 'Voglio scaricare la giornata',
            outcome: 'Più libero / leggero',
            bodySensationsAfter: 'Gambe leggere',
            emotionalIntensityAfter: 2,
            emotionAfter: 'Gioia',
            thoughtAfter: 'Mi sento meglio',
          ),
        ],
      );

      expect(bytes, isA<Uint8List>());
      expect(bytes.length, greaterThan(0));
      expect(String.fromCharCodes(bytes.take(4)), '%PDF');

      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/weekly_diary_test.pdf');

      await file.writeAsBytes(bytes, flush: true);

      expect(await file.exists(), isTrue);

      final savedBytes = await file.readAsBytes();

      expect(savedBytes.length, bytes.length);
      expect(String.fromCharCodes(savedBytes.take(4)), '%PDF');

      await file.delete();
    });
  });
}