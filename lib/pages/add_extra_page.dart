
import 'package:flutter/material.dart';
import '../models/entry.dart';
import '../services/storage_service.dart';

class AddExtraPage extends StatefulWidget {
  const AddExtraPage({super.key});

  @override
  State<AddExtraPage> createState() => _AddExtraPageState();
}

class _AddExtraPageState extends State<AddExtraPage> {
  final _formKey = GlobalKey<FormState>();
  final _placeController = TextEditingController();
  final _companyController = TextEditingController();
  final _contentController = TextEditingController();
  final _moodController = TextEditingController();
  final _notesController = TextEditingController();
  String _category = 'Spuntino mattina';
  DateTime _selectedDateTime = DateTime.now();
  final _storage = StorageService();

  @override
  void dispose() {
    _placeController.dispose();
    _companyController.dispose();
    _contentController.dispose();
    _moodController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final entry = DiaryEntry(
      dateTime: _selectedDateTime,
      type: 'pasto_aggiuntivo',
      category: _category,
      content: _contentController.text.trim(),
      place: _placeController.text.trim().isEmpty ? null : _placeController.text.trim(),
      company: _companyController.text.trim().isEmpty ? null : _companyController.text.trim(),
      mood: _moodController.text.trim().isEmpty ? null : _moodController.text.trim(),
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    await _storage.addEntry(entry);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pasto aggiuntivo salvato')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatted = '${_selectedDateTime.day.toString().padLeft(2, '0')}/'
        '${_selectedDateTime.month.toString().padLeft(2, '0')}/'
        '${_selectedDateTime.year} '
        '${_selectedDateTime.hour.toString().padLeft(2, '0')}:'
        '${_selectedDateTime.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuovo pasto aggiuntivo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Data e ora: $formatted'),
              TextButton.icon(
                onPressed: _pickDateTime,
                icon: const Icon(Icons.calendar_today),
                label: const Text('Cambia data/ora'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _category,
                items: const [
                  DropdownMenuItem(value: 'Spuntino mattina', child: Text('Spuntino mattina')),
                  DropdownMenuItem(value: 'Spuntino pomeriggio', child: Text('Spuntino pomeriggio')),
                  DropdownMenuItem(value: 'Snack serale', child: Text('Snack serale')),
                  DropdownMenuItem(value: 'Pasto libero', child: Text('Pasto libero')),
                  DropdownMenuItem(value: 'Altro', child: Text('Altro')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _category = val;
                    });
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Tipo pasto aggiuntivo',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Cosa mangi?',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Scrivi cosa hai mangiato';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _placeController,
                decoration: const InputDecoration(
                  labelText: 'Dove sei?',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(
                  labelText: 'Con chi sei?',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _moodController,
                decoration: const InputDecoration(
                  labelText: 'Come ti senti?',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Note',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('Salva pasto aggiuntivo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
