
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/entry.dart';

class StorageService {
  static const _keyEntries = 'diary_entries';

  Future<List<DiaryEntry>> getEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_keyEntries) ?? [];
    return raw.map((e) {
      final Map<String, dynamic> map = jsonDecode(e);
      return DiaryEntry.fromJson(map);
    }).toList();
  }

  Future<void> addEntry(DiaryEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyEntries) ?? [];
    list.add(jsonEncode(entry.toJson()));
    await prefs.setStringList(_keyEntries, list);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyEntries);
  }
}
