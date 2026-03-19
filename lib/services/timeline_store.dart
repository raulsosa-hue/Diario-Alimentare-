import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class TimelineStore {
  TimelineStore._();
  static final TimelineStore instance = TimelineStore._();

  final List<Map<String, dynamic>> _events = [];
  bool _loaded = false;

  List<Map<String, dynamic>> get events => List.unmodifiable(_events);

  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/timeline_events.json');
  }

  Future<void> load() async {
    if (_loaded) return;
    _loaded = true;

    final f = await _file();
    if (!await f.exists()) return;

    final content = await f.readAsString();
    if (content.trim().isEmpty) return;

    final decoded = jsonDecode(content);
    if (decoded is List) {
      _events
        ..clear()
        ..addAll(decoded.cast<Map<String, dynamic>>());
    }
  }

  Future<void> _save() async {
    final f = await _file();
    await f.writeAsString(jsonEncode(_events));
  }

  Future<void> addEntry(Map<String, dynamic> entry) async {
    await load();
    _events.add(entry);
    await _save();
  }

  /// TEST: aggiunge un evento "Pasto" semplice (per collegare subito Salva → Export)
  Future<void> addMealTest() async {
    await load();

    final now = DateTime.now();

    final event = <String, dynamic>{
      'date': '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
      'time': '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      'type': 'Pasto',
      'category': 'Pasto principale',
      'intention': '',
      'emotions': '',
      'intensity': '',
      'sensations': '',
      'thought': '',
      'outcome': '',
      'notes': 'Test collegamento Salva → Export',
    };

    _events.add(event);
    await _save();
  }
}
