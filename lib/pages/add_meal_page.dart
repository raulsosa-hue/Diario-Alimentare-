import 'package:flutter/material.dart';
import '../styles.dart';
import '../widgets/emotion_picker.dart';

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

  String? _beforeEmojis;

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

  String? _afterEmojis;

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

  void _save() {
    Navigator.of(context).pop();
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
      body: SingleChildScrollView(
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
    );
  }

  Widget _dateTimeCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(DS.radiusCard),
        boxShadow: const [DS.cardShadow],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Data e ora: ',
                style: DS.bodyText,
              ),
              Expanded(
                child: Text(
                  _formatDateTime(_dateTime),
                  style: DS.bodyText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _pickDateTime,
              icon: const Icon(Icons.calendar_month, color: DS.accent),
              label: Text(
                'Cambia data/ora',
                style: DS.bodyTextBold.copyWith(color: DS.accent),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: DS.borderLight),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DS.radiusField)),
                backgroundColor: DS.surfaceMuted,
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
        color: DS.surfaceWhite85,
        borderRadius: BorderRadius.circular(DS.radiusCard),
        boxShadow: const [DS.cardShadow],
        border: Border.all(color: DS.borderSubtle),
      ),
      child: Row(
        children: [
          const Text(
            'Tipo pasto: ',
            style: DS.bodyTextBold,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(DS.radiusField),
                border: Border.all(color: DS.borderLight),
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
                              style: DS.bodyTextBold,
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
        borderRadius: const BorderRadius.vertical(top: Radius.circular(DS.radiusCard)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black87),
          const SizedBox(width: 8),
          Text(title, style: DS.sectionLabel),
        ],
      ),
    );
  }

  Widget _segmentContainer({required Widget child, required Color bodyColor}) {
    return Container(
      decoration: BoxDecoration(
        color: bodyColor,
        borderRadius: BorderRadius.circular(DS.radiusCard),
        boxShadow: const [DS.cardShadow],
        border: Border.all(color: DS.borderSubtle),
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
                EmotionPicker(
                  title: 'Emozioni (prima) – scegli emoticon oppure scrivi tu',
                  selected: _beforeEmojis,
                  selectedColor: DS.chipSelectedMeal,
                  onChanged: (v) => setState(() => _beforeEmojis = v),
                ),
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
                EmotionPicker(
                  title: 'Emozioni (dopo) – scegli emoticon oppure scrivi tu',
                  selected: _afterEmojis,
                  selectedColor: DS.chipSelectedMeal,
                  onChanged: (v) => setState(() => _afterEmojis = v),
                ),
                const SizedBox(height: 12),
                _textField(_afterThoughtCtrl, 'Pensiero (dopo)...'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _textField(TextEditingController ctrl, String hint) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: DS.surfaceWhite65,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DS.radiusField),
          borderSide: const BorderSide(color: DS.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DS.radiusField),
          borderSide: const BorderSide(color: DS.borderLight),
        ),
      ),
      style: DS.bodyText,
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
        Text(label, style: DS.sectionLabel),
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
      borderRadius: BorderRadius.circular(DS.radiusField),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: DS.surfaceWhite65,
          borderRadius: BorderRadius.circular(DS.radiusField),
          border: Border.all(color: DS.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: DS.captionBold),
            const SizedBox(height: 6),
            Text(value, style: DS.displayLarge),
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
        label: const Text('Salva', style: DS.buttonPrimary),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DS.radiusCard)),
        ),
      ),
    );
  }
}
