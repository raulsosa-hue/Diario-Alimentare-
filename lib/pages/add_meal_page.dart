import 'package:flutter/material.dart';
import '../services/Timeline_store.dart';



class AddMealPage extends StatefulWidget {
  const AddMealPage({super.key});

  @override
  State<AddMealPage> createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  DateTime _dateTime = DateTime.now();

  // ✅ TIPO PASTO
  final List<String> _mealTypes = const <String>[
    'Colazione',
    'Spuntino',
    'Pranzo',
    'Merenda',
    'Cena',
    'Pasti aggiuntivi',
  ];
  String _mealType = 'Colazione';

  // -------------------------
  // PRIMA DEL PASTO
  // -------------------------
  final TextEditingController _whereCtrl = TextEditingController();
  final TextEditingController _withWhoCtrl = TextEditingController();
  final TextEditingController _beforeBodyCtrl = TextEditingController();
  double _beforeIntensity = 0;
  final TextEditingController _beforeThoughtCtrl = TextEditingController();

  final Set<String> _beforeEmojis = <String>{};
  String _beforeCustomEmotion = '';

  // -------------------------
  // PASTO
  // -------------------------
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  final TextEditingController _whatEatCtrl = TextEditingController();

  // -------------------------
  // DOPO IL PASTO
  // -------------------------
  final TextEditingController _afterBodyCtrl = TextEditingController();
  double _afterIntensity = 0;
  final TextEditingController _afterThoughtCtrl = TextEditingController();

  final Set<String> _afterEmojis = <String>{};
  String _afterCustomEmotion = '';

  // -------------------------
  // EMOZIONI (preimpostate)
  // -------------------------
  final List<_EmotionItem> _emotions = const <_EmotionItem>[
    _EmotionItem("Fame d'amore", '❤️'),
    _EmotionItem('Gioia', '😊'),
    _EmotionItem('Tristezza', '😢'),
    _EmotionItem('Rabbia', '😠'),
    _EmotionItem('Paura', '😨'),
    _EmotionItem('Ansia', '😰'),
    _EmotionItem('Disgusto', '🤢'),
    _EmotionItem('Sorpresa', '😮'),
    _EmotionItem('Orgoglio', '😌'),
    _EmotionItem('Imbarazzo / Vergogna', '😳'),
    _EmotionItem('Invidia / Gelosia', '😒'),
    _EmotionItem('Nostalgia', '🥲'),
    _EmotionItem('Colpa / Rimorso', '😔'),
    _EmotionItem('Frustrazione', '😤'),
    _EmotionItem('Solitudine', '😔'),
    _EmotionItem('Apatia', '😐'),
    _EmotionItem('Vuoto', '🫥'),
    _EmotionItem('Calma', '🧘'),
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startTime = TimeOfDay(hour: now.hour, minute: now.minute);
  }

  @override
  void dispose() {
    _whereCtrl.dispose();
    _withWhoCtrl.dispose();
    _beforeBodyCtrl.dispose();
    _beforeThoughtCtrl.dispose();
    _whatEatCtrl.dispose();
    _afterBodyCtrl.dispose();
    _afterThoughtCtrl.dispose();
    super.dispose();
  }

  // -------------------------
  // REGOLE DI PREVALENZA
  // -------------------------
  bool get _beforeUsesCustom => _beforeCustomEmotion.trim().isNotEmpty;
  bool get _afterUsesCustom => _afterCustomEmotion.trim().isNotEmpty;

  void _toggleBeforeEmoji(String label) {
    if (_beforeUsesCustom) {
      setState(() {
        _beforeCustomEmotion = '';
        _beforeEmojis.clear();
        _beforeEmojis.add(label);
      });
      return;
    }

    setState(() {
      if (_beforeEmojis.contains(label)) {
        _beforeEmojis.remove(label);
      } else {
        _beforeEmojis.add(label);
      }
    });
  }

  void _toggleAfterEmoji(String label) {
    if (_afterUsesCustom) {
      setState(() {
        _afterCustomEmotion = '';
        _afterEmojis.clear();
        _afterEmojis.add(label);
      });
      return;
    }

    setState(() {
      if (_afterEmojis.contains(label)) {
        _afterEmojis.remove(label);
      } else {
        _afterEmojis.add(label);
      }
    });
  }

  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dateTime),
    );
    if (pickedTime == null) return;

    setState(() {
      _dateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  Future<void> _pickStartTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );
    if (t == null) return;
    setState(() => _startTime = t);
  }

  Future<void> _pickEndTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: _endTime ?? _startTime ?? TimeOfDay.now(),
    );
    if (t == null) return;
    setState(() => _endTime = t);
  }

  String _formatDateTime(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.day)}/${two(dt.month)}/${dt.year}  ${two(dt.hour)}:${two(dt.minute)}';
  }

  String _formatTimeOfDay(TimeOfDay? t) {
    if (t == null) return '--:--';
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(t.hour)}:${two(t.minute)}';
  }

  Map<String, dynamic> _buildPayload() {
    final beforeEmotionValue =
        _beforeUsesCustom ? _beforeCustomEmotion.trim() : _beforeEmojis.join(', ');
    final afterEmotionValue =
        _afterUsesCustom ? _afterCustomEmotion.trim() : _afterEmojis.join(', ');

    return <String, dynamic>{
      'type': 'meal',
      'mealType': _mealType, // ✅ aggiunto
      'dateTime': _dateTime.toIso8601String(),
      'before': {
        'where': _whereCtrl.text.trim(),
        'withWho': _withWhoCtrl.text.trim(),
        'body': _beforeBodyCtrl.text.trim(),
        'intensity': _beforeIntensity.round(),
        'emotion': beforeEmotionValue,
        'emotion_mode': _beforeUsesCustom ? 'custom' : 'emoji',
        'thought': _beforeThoughtCtrl.text.trim(),
      },
      'meal': {
        'start': _formatTimeOfDay(_startTime),
        'what': _whatEatCtrl.text.trim(),
        'end': _formatTimeOfDay(_endTime),
      },
      'after': {
        'body': _afterBodyCtrl.text.trim(),
        'intensity': _afterIntensity.round(),
        'emotion': afterEmotionValue,
        'emotion_mode': _afterUsesCustom ? 'custom' : 'emoji',
        'thought': _afterThoughtCtrl.text.trim(),
      },
    };
  }

  Future<void> _save() async {
    final payload = _buildPayload();
    await TimelineStore.instance.addEntry(payload);

    if (!mounted) return;
    Navigator.of(context).pop(payload);
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFEFF2F6);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('Nuovo pasto principale'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
          child: Column(
            children: [
              _dateTimeCard(),
              const SizedBox(height: 12),

              // ✅ NUOVO: TIPO PASTO (tra data/ora e PRIMA)
              _mealTypeCard(),
              const SizedBox(height: 14),

              _segmentBefore(),
              const SizedBox(height: 14),
              _segmentMeal(),
              const SizedBox(height: 14),
              _segmentAfter(),
              const SizedBox(height: 18),
              _saveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateTimeCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 6),
            color: Color(0x14000000),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Data e ora: ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              Expanded(
                child: Text(
                  _formatDateTime(_dateTime),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _pickDateTime,
              icon: const Icon(Icons.calendar_month, color: Color(0xFF1D7A6A)),
              label: const Text(
                'Cambia data/ora',
                style: TextStyle(
                  color: Color(0xFF1D7A6A),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Color(0x22000000)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                backgroundColor: const Color(0xFFF3F5F9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Card “Tipo pasto”
  Widget _mealTypeCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 6),
            color: Color(0x14000000),
          ),
        ],
        border: Border.all(color: const Color(0x14000000)),
      ),
      child: Row(
        children: [
          const Text(
            'Tipo pasto: ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0x22000000)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _mealType,
                  isExpanded: true,
                  items: _mealTypes
                      .map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(
                              e,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                            ),
                          ))
                      .toList(),
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() => _mealType = v);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _segmentHeader(String title, IconData icon, Color barColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: barColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black87),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _segmentContainer({required Widget child, required Color bodyColor}) {
    return Container(
      decoration: BoxDecoration(
        color: bodyColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 6),
            color: Color(0x14000000),
          ),
        ],
        border: Border.all(color: const Color(0x14000000)),
      ),
      child: child,
    );
  }

  Widget _segmentBefore() {
    const headerColor = Color(0xFFF2CFAE);
    const bodyColor = Color(0xFFF7E2CC);

    return _segmentContainer(
      bodyColor: bodyColor,
      child: Column(
        children: [
          _segmentHeader('Prima del pasto', Icons.circle_outlined, headerColor),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _textField(_whereCtrl, 'Dove sono (prima)...')),
                    const SizedBox(width: 10),
                    Expanded(child: _textField(_withWhoCtrl, 'Con chi sono (prima)...')),
                  ],
                ),
                const SizedBox(height: 10),
                _textField(_beforeBodyCtrl, 'Sensazioni fisiche (prima)...'),
                const SizedBox(height: 14),
                _sliderBlock(
                  label: 'Intensità emotiva (prima) 0–10',
                  value: _beforeIntensity,
                  onChanged: (v) => setState(() => _beforeIntensity = v),
                ),
                const SizedBox(height: 12),
                _emotionBlockBefore(),
                const SizedBox(height: 12),
                _textField(_beforeThoughtCtrl, 'Pensiero (prima)...'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _segmentMeal() {
    const headerColor = Color(0xFFBBD8B4);
    const bodyColor = Color(0xFFE2F0DD);

    return _segmentContainer(
      bodyColor: bodyColor,
      child: Column(
        children: [
          _segmentHeader('Pasto', Icons.restaurant, headerColor),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _timeCard('Ora inizio (pasto)', _formatTimeOfDay(_startTime), _pickStartTime),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _timeCard('Ora fine (pasto)', _formatTimeOfDay(_endTime), _pickEndTime),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _textField(_whatEatCtrl, 'Cosa mangio (pasto)...'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _segmentAfter() {
    const headerColor = Color(0xFF9CC0E6);
    const bodyColor = Color(0xFFD6E7F8);

    return _segmentContainer(
      bodyColor: bodyColor,
      child: Column(
        children: [
          _segmentHeader('Dopo il pasto', Icons.favorite_border, headerColor),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                _textField(_afterBodyCtrl, 'Sensazioni fisiche (dopo)...'),
                const SizedBox(height: 14),
                _sliderBlock(
                  label: 'Intensità emotiva (dopo) 0–10',
                  value: _afterIntensity,
                  onChanged: (v) => setState(() => _afterIntensity = v),
                ),
                const SizedBox(height: 12),
                _emotionBlockAfter(),
                const SizedBox(height: 12),
                _textField(_afterThoughtCtrl, 'Pensiero (dopo)...'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emotionBlockBefore() {
    return _emotionBlock(
      title: 'Emozioni (prima) – scegli emoticon oppure scrivi tu',
      emotions: _emotions,
      selected: _beforeEmojis,
      isCustomActive: _beforeUsesCustom,
      onToggle: _toggleBeforeEmoji,
      addButtonText: '➕ Altra emozione (prima)',
      customValue: _beforeCustomEmotion,
      onOpenCustom: () async {
        final res = await _openCustomEmotionDialog(
          title: 'Altra emozione (prima)',
          initial: _beforeCustomEmotion,
        );
        if (res == null) return;

        setState(() {
          _beforeCustomEmotion = res.trim();
          if (_beforeUsesCustom) _beforeEmojis.clear();
        });
      },
    );
  }

  Widget _emotionBlockAfter() {
    return _emotionBlock(
      title: 'Emozioni (dopo) – scegli emoticon oppure scrivi tu',
      emotions: _emotions,
      selected: _afterEmojis,
      isCustomActive: _afterUsesCustom,
      onToggle: _toggleAfterEmoji,
      addButtonText: '➕ Altra emozione (dopo)',
      customValue: _afterCustomEmotion,
      onOpenCustom: () async {
        final res = await _openCustomEmotionDialog(
          title: 'Altra emozione (dopo)',
          initial: _afterCustomEmotion,
        );
        if (res == null) return;

        setState(() {
          _afterCustomEmotion = res.trim();
          if (_afterUsesCustom) _afterEmojis.clear();
        });
      },
    );
  }

  Widget _emotionBlock({
    required String title,
    required List<_EmotionItem> emotions,
    required Set<String> selected,
    required bool isCustomActive,
    required void Function(String label) onToggle,
    required String addButtonText,
    required String customValue,
    required Future<void> Function() onOpenCustom,
  }) {
    final chipOpacity = isCustomActive ? 0.35 : 1.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x1A000000)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: emotions.map((e) {
              final isOn = selected.contains(e.label);
              return Opacity(
                opacity: chipOpacity,
                child: FilterChip(
                  label: Text('${e.emoji}  ${e.label}', style: const TextStyle(fontWeight: FontWeight.w700)),
                  selected: isOn,
                  onSelected: isCustomActive ? null : (_) => onToggle(e.label),
                  showCheckmark: false,
                  selectedColor: const Color(0xFFBFE3D8),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                    side: BorderSide(color: isOn ? const Color(0x55000000) : const Color(0x22000000)),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () async => onOpenCustom(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                side: const BorderSide(color: Color(0x22000000)),
                backgroundColor: Colors.white,
              ),
              child: Text(
                addButtonText,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
              ),
            ),
          ),
          if (customValue.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              'Scelta attiva: "${customValue.trim()}"',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ],
        ],
      ),
    );
  }

  Future<String?> _openCustomEmotionDialog({
    required String title,
    required String initial,
  }) async {
    final ctrl = TextEditingController(text: initial);
    final res = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: ctrl,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              hintText: 'Scrivi un’emozione...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(null),
              child: const Text('Annulla'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(ctrl.text),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    ctrl.dispose();
    return res;
  }

  Widget _textField(TextEditingController ctrl, String hint) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.65),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0x22000000)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0x22000000)),
        ),
      ),
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
    );
  }

  Widget _sliderBlock({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        Slider(
          value: value,
          min: 0,
          max: 10,
          divisions: 10,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _timeCard(String title, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0x22000000)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.black87)),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }

  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: _save,
        icon: const Icon(Icons.save),
        label: const Text('Salva', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
    );
  }
}

class _EmotionItem {
  final String label;
  final String emoji;
  const _EmotionItem(this.label, this.emoji);
}
