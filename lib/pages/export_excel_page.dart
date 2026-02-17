import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../services/Timeline_store.dart';

class ExportTimelinePage extends StatefulWidget {
  const ExportTimelinePage({super.key});

  @override
  State<ExportTimelinePage> createState() => _ExportTimelinePageState();
}

class _ExportTimelinePageState extends State<ExportTimelinePage> {
  bool _isExporting = false;

  String _two(int n) => n.toString().padLeft(2, '0');

  /// Cerca una stringa in una mappa (anche annidata) con una lista di "path"
  /// Esempio path: ['before', 'emotion'] oppure ['note']
  String _pickPath(Map<String, dynamic> root, List<String> path) {
    dynamic cur = root;
    for (final key in path) {
      if (cur is Map && cur.containsKey(key)) {
        cur = cur[key];
      } else {
        return '';
      }
    }
    if (cur == null) return '';
    final s = cur.toString().trim();
    return s;
  }

  /// Prova più path finché ne trova uno non vuoto
  String _pickAny(Map<String, dynamic> root, List<List<String>> paths) {
    for (final p in paths) {
      final v = _pickPath(root, p);
      if (v.trim().isNotEmpty) return v.trim();
    }
    return '';
  }

  DateTime _parseEventDateTime(Map<String, dynamic> e) {
    // Caso principale: ISO string (come nel tuo AddMealPage: dateTime.toIso8601String())
    final iso = (e['dateTime'] ?? e['datetime'] ?? e['DateTime'])?.toString().trim();
    if (iso != null && iso.isNotEmpty) {
      try {
        return DateTime.parse(iso);
      } catch (_) {}
    }

    // Fallback: 'date' + 'time'
    final date = (e['date'] ?? e['Date'])?.toString().trim() ?? '';
    final time = (e['time'] ?? e['Time'])?.toString().trim() ?? '';
    if (date.isNotEmpty) {
      try {
        // date tipo "YYYY-MM-DD"
        if (time.isNotEmpty) {
          return DateTime.parse('${date}T$time:00');
        }
        return DateTime.parse(date);
      } catch (_) {}
    }

    // Ultimo fallback
    return DateTime.now();
  }

  String _tipoEvento(Map<String, dynamic> e) {
    final t = (e['type'] ?? e['eventType'] ?? '').toString().trim().toLowerCase();
    if (t == 'meal') return 'Pasto';
    if (t == 'exercise') return 'Esercizio';
    if (t == 'therapy' || t == 'note' || t == 'notes') return 'Terapia/Note';
    if (t.isNotEmpty) return t;
    return '';
  }

  String _categoria(Map<String, dynamic> e) {
    // Pasto: mealType
    final mealType = (e['mealType'] ?? e['category'] ?? '').toString().trim();
    if (mealType.isNotEmpty) return mealType;

    // Esercizio: exerciseType / typeLabel ecc.
    final ex = (e['exerciseType'] ?? e['exercise'] ?? e['activity'] ?? '').toString().trim();
    if (ex.isNotEmpty) return ex;

    return '';
  }

  Future<void> _exportTimeline() async {
    setState(() => _isExporting = true);

    try {
      // ✅ IMPORTANTISSIMO: carico dal file prima di leggere events
      await TimelineStore.instance.load();
      final events = TimelineStore.instance.events;

      if (events.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nessun evento salvato in TIMELINE (lista vuota).'),
            backgroundColor: Color(0xFFC62828),
          ),
        );
        return;
      }

      final excel = Excel.createExcel();
      final sheet = excel['TIMELINE'];

      sheet.appendRow([
        'Data',
        'Ora',
        'Tipo evento',
        'Categoria',
        'Intenzione',
        'Emozioni',
        'Intensità emotiva',
        'Sensazioni fisiche',
        'Pensiero',
        'Esito / Dopo',
        'Note libere',
      ]);

      for (final e in events) {
        final dt = _parseEventDateTime(e);

        final data = '${_two(dt.day)}/${_two(dt.month)}/${dt.year}';
        final ora = '${_two(dt.hour)}:${_two(dt.minute)}';

        final tipoEvento = _tipoEvento(e);
        final categoria = _categoria(e);

        // ======= MAPPATURA (pasto PRIMA come "principale") =======
        // Intenzione: se non c’è, resta vuota
        final intenzione = _pickAny(e, [
          ['intention'],
          ['Intenzione'],
          ['before', 'intention'],
          ['before', 'Intenzione'],
        ]);

        // Emozioni: per Pasto uso "before.emotion" (come nel tuo payload)
        final emozioni = _pickAny(e, [
          ['before', 'emotion'],
          ['before', 'Emozioni'],
          ['emotion'],
          ['emotions'],
        ]);

        // Intensità: per Pasto uso "before.intensity"
        final intensita = _pickAny(e, [
          ['before', 'intensity'],
          ['intensity'],
          ['Intensità'],
          ['intensita'],
        ]);

        // Sensazioni fisiche: per Pasto uso "before.body"
        final sensazioni = _pickAny(e, [
          ['before', 'body'],
          ['sensations'],
          ['Sensazioni'],
          ['Sensazioni fisiche'],
        ]);

        // Pensiero: per Pasto uso "before.thought"
        final pensiero = _pickAny(e, [
          ['before', 'thought'],
          ['thought'],
          ['Pensiero'],
        ]);

        // Esito/Dopo: per Pasto compongo da "after"
        final afterBody = _pickAny(e, [
          ['after', 'body'],
        ]);
        final afterEmotion = _pickAny(e, [
          ['after', 'emotion'],
        ]);
        final afterThought = _pickAny(e, [
          ['after', 'thought'],
        ]);

        String esito = _pickAny(e, [
          ['outcome'],
          ['esito'],
          ['after', 'outcome'],
        ]);

        // Se non c’è un campo "esito" vero, compongo io con DOPO
        if (esito.trim().isEmpty) {
          final parts = <String>[];
          if (afterBody.trim().isNotEmpty) parts.add('Corpo: $afterBody');
          if (afterEmotion.trim().isNotEmpty) parts.add('Emozioni: $afterEmotion');
          if (afterThought.trim().isNotEmpty) parts.add('Pensiero: $afterThought');
          esito = parts.join(' | ');
        }

        // Note: per Pasto metto anche "meal.what" se esiste
        final noteBase = _pickAny(e, [
          ['note'],
          ['notes'],
          ['Note'],
          ['Note libere'],
        ]);
        final cosaMangio = _pickAny(e, [
          ['meal', 'what'],
          ['meal', 'cosa'],
          ['what'],
        ]);

        String note = noteBase;
        if (cosaMangio.trim().isNotEmpty) {
          note = note.trim().isEmpty ? 'Cosa mangio: $cosaMangio' : '$note | Cosa mangio: $cosaMangio';
        }

        sheet.appendRow([
          data,
          ora,
          tipoEvento,
          categoria,
          intenzione,
          emozioni,
          intensita,
          sensazioni,
          pensiero,
          esito,
          note,
        ]);
      }

      final directory = await getApplicationDocumentsDirectory();
      final now = DateTime.now();
      final fileName = 'TIMELINE_${now.year}_${_two(now.month)}_${_two(now.day)}.xlsx';
      final filePath = '${directory.path}/$fileName';

      final fileBytes = excel.encode();
      if (fileBytes == null) {
        throw Exception('Errore nella generazione del file');
      }

      final file = File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);

      final box = context.findRenderObject() as RenderBox;

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Esportazione TIMELINE',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Export TIMELINE completato (${events.length} eventi)'),
          backgroundColor: const Color(0xFF2E7D32),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Errore export: $e'),
          backgroundColor: const Color(0xFFC62828),
        ),
      );
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Esporta TIMELINE'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ElevatedButton.icon(
            icon: _isExporting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.timeline),
            label: Text(
              _isExporting ? 'Esportazione…' : 'Esporta TIMELINE',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: _isExporting ? null : _exportTimeline,
          ),
        ),
      ),
    );
  }
}
