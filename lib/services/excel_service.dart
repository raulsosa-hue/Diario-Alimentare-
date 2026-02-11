
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/entry.dart';

class ExcelService {
  Future<File> exportToCsv(List<DiaryEntry> entries) async {
    final buffer = StringBuffer();
buffer.writeln("Data,Ora,Tipo,Categoria,Contenuto,Durata(min),Intensita,Dove,Con chi,Stato d'animo,Note");



    for (final e in entries) {
      final date = e.dateTime.toIso8601String().split('T').first;
      final time = e.dateTime.toIso8601String().split('T').last.substring(0,5);
      buffer.writeln([
        date,
        time,
        e.type,
        e.category,
        e.content.replaceAll(',', ';'),
        e.durationMinutes?.toString() ?? '',
        e.intensity ?? '',
        e.place ?? '',
        e.company ?? '',
        e.mood ?? '',
        e.notes?.replaceAll(',', ';') ?? '',
      ].map((v) => '"$v"').join(','));
    }

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/diario_${DateTime.now().millisecondsSinceEpoch}.csv');
    return file.writeAsString(buffer.toString());
  }
}
