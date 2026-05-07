import 'package:flutter/material.dart';

import '../data/database_helper.dart';
import '../models/emotions.dart';
import '../models/meal.dart';
import '../models/mindfulness_suggestions.dart';
import '../styles.dart';
import '../widgets/common_buttons.dart';
import '../widgets/emotion_picker.dart';
import '../widgets/mindfulness_card.dart';

class AddMealPage extends StatefulWidget {
  const AddMealPage({super.key});

  @override
  State<AddMealPage> createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  // ====== DATA FIELDS ======
  DateTime _dateTime = DateTime.now();

  // -- Tipo pasto --
  String _mealType = kMealTypes.first;

  // -- Prima del pasto --
  final TextEditingController _whereCtrl = TextEditingController();
  final TextEditingController _withWhoCtrl = TextEditingController();
  final TextEditingController _bodyBeforeCtrl = TextEditingController();
  double _intensityBefore = 0;
  String? _emotionsBefore;
  final TextEditingController _thoughtBeforeCtrl = TextEditingController();

  // -- Pasto --
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  final TextEditingController _whatEatCtrl = TextEditingController();

  // -- Dopo il pasto --
  final TextEditingController _bodyAfterCtrl = TextEditingController();
  double _intensityAfter = 0;
  String? _emotionsAfter;
  final TextEditingController _thoughtAfterCtrl = TextEditingController();

  bool _showTimeErrors = false;

  late String _suggestionBeforeMeal;
  late String _suggestionAfterMeal;

  static final _mealTypeItems = kMealTypes
      .map((e) => DropdownMenuItem<String>(
    value: e,
    child: Text(e, style: DS.bodyTextBold),
  ))
      .toList(growable: false);

  // ====== UI COLORS ======
  static const Color _pageBg = Color(0xFFEFF2F6);
  static const Color _headerPeach = Color(0xFFF2CFAE); // PRIMA
  static const Color _cardPeach = Color(0xFFF7E2CC); // PRIMA
  static const Color _headerGreen = Color(0xFFBBD8B4); // PASTO
  static const Color _cardGreen = Color(0xFFE2F0DD); // PASTO
  static const Color _headerBlue = Color(0xFF9CC0E6); // DOPO
  static const Color _cardBlue = Color(0xFFD6E7F8); // DOPO

  // ====== LIFECYCLE ======
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startTime = TimeOfDay(hour: now.hour, minute: now.minute);
    _suggestionBeforeMeal = pickSuggestion(MindfulnessMoment.beforeMeal);
    _suggestionAfterMeal = pickSuggestion(MindfulnessMoment.afterMeal);
  }

  @override
  void dispose() {
    _whereCtrl.dispose();
    _withWhoCtrl.dispose();
    _bodyBeforeCtrl.dispose();
    _thoughtBeforeCtrl.dispose();
    _whatEatCtrl.dispose();
    _bodyAfterCtrl.dispose();
    _thoughtAfterCtrl.dispose();
    super.dispose();
  }

  // ====== HELPERS ======
  String _formatTimeOfDay(TimeOfDay? t) {
    if (t == null) return '--:--';
    return '${twoDigit(t.hour)}:${twoDigit(t.minute)}';
  }

  // ====== ACTIONS ======
  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: DS.accent,
              onPrimary: Colors.white,
              surface: Color(0xFFF8FAFC),
              onSurface: Colors.black87,
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: const Color(0xFFF8FAFC),
              headerBackgroundColor: const Color(0xFFD6EBDD),
              headerForegroundColor: Colors.black87,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              dayBackgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
                if (states.contains(WidgetState.selected)) {
                  return DS.accent;
                }
                return null;
              }),
              dayForegroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white;
                }
                return Colors.black87;
              }),
              todayForegroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white;
                }
                return DS.accentDark;
              },
              ),
              todayBorder: const BorderSide(
                color: DS.accentDark,
                width: 1.4,
              ),
              yearForegroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white;
                }
                return Colors.black87;
              }),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: DS.accentDark,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dateTime),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: DS.accent,
              onPrimary: Colors.white,
              surface: Color(0xFFF8FAFC),
              onSurface: Colors.black87,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: const Color(0xFFF8FAFC),
              hourMinuteColor: const Color(0xFFE3F2E7),
              hourMinuteTextColor: Colors.black87,
              dialHandColor: DS.accent,
              dialBackgroundColor: const Color(0xFFEFF6F3),
              entryModeIconColor: DS.accentDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: DS.accentDark,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (time == null) return;

    setState(() {
      _dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _pickStartTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );
    if (t == null) return;
    setState(() {
      _startTime = t;
      _showTimeErrors = false;
    });
  }

  Future<void> _pickEndTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: _endTime ?? _startTime ?? TimeOfDay.now(),
    );
    if (t == null) return;
    setState(() {
      _endTime = t;
      _showTimeErrors = false;
    });
  }

  void _save() async {
    if (_startTime == null || _endTime == null) {
      setState(() => _showTimeErrors = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inserisci ora di inizio e fine del pasto'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final meal = Meal(
      dateTime: _dateTime,
      mealType: _mealType,
      location: nullIfEmpty(_whereCtrl),
      withWhom: nullIfEmpty(_withWhoCtrl),
      bodySensationsBefore: nullIfEmpty(_bodyBeforeCtrl),
      emotionalIntensityBefore: _intensityBefore.round(),
      emotionBefore: buildEmotionStorageValue(_emotionsBefore),
      thoughtBefore: nullIfEmpty(_thoughtBeforeCtrl),
      startTime: _formatTimeOfDay(_startTime!),
      endTime: _formatTimeOfDay(_endTime!),
      whatEaten: nullIfEmpty(_whatEatCtrl),
      bodySensationsAfter: nullIfEmpty(_bodyAfterCtrl),
      emotionalIntensityAfter: _intensityAfter.round(),
      emotionAfter: buildEmotionStorageValue(_emotionsAfter),
      thoughtAfter: nullIfEmpty(_thoughtAfterCtrl),
    );

    try {
      await DatabaseHelper.instance.insertMeal(meal);
    } catch (e) {
      if (mounted) showSaveError(context, e);
      return;
    }
    if (mounted) Navigator.of(context).pop();
  }

  // ====== WIDGET BUILDERS ======
  Widget _card({required Color color, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(DS.radiusCard),
        boxShadow: const [DS.cardShadow],
        border: Border.all(color: DS.borderSubtle),
      ),
      child: child,
    );
  }

  Widget _sectionHeader(String title, IconData icon, Color barColor) {
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

  Widget _textField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
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

  Widget _timeCard(String title, String value, VoidCallback onTap, {bool hasError = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(DS.radiusField),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: hasError ? const Color(0x1AFF0000) : DS.surfaceWhite65,
          borderRadius: BorderRadius.circular(DS.radiusField),
          border: Border.all(color: hasError ? Colors.red : DS.borderLight, width: hasError ? 1.5 : 1.0),
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

  // ====== SECTIONS ======
  Widget _dateTimeSection() {
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
                  formatDateTime(_dateTime),
                  style: DS.bodyText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ChangeDateTimeButton(onPressed: _pickDateTime),
        ],
      ),
    );
  }

  Widget _mealTypeSection() {
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
                  items: _mealTypeItems,
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

  Widget _beforeSection() {
    return _card(
      color: _cardPeach,
      child: Column(
        children: [
          _sectionHeader('Prima del pasto', Icons.circle_outlined, _headerPeach),
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
                _textField(_bodyBeforeCtrl, 'Sensazioni fisiche (prima)...'),
                const SizedBox(height: 14),
                _sliderBlock(
                  label: 'Intensità emotiva (prima) 0–10',
                  value: _intensityBefore,
                  onChanged: (v) => setState(() => _intensityBefore = v),
                ),
                const SizedBox(height: 12),
                EmotionPicker(
                  title: 'Emozioni (prima) – scegli emoticon oppure scrivi tu',
                  selected: _emotionsBefore,
                  selectedColor: DS.chipSelectedMeal,
                  onChanged: (v) => setState(() => _emotionsBefore = v),
                ),
                const SizedBox(height: 12),
                _textField(_thoughtBeforeCtrl, 'Pensiero (prima)...'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mealSection() {
    return _card(
      color: _cardGreen,
      child: Column(
        children: [
          _sectionHeader('Pasto', Icons.restaurant, _headerGreen),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _timeCard('Ora inizio (pasto)', _formatTimeOfDay(_startTime), _pickStartTime,
                          hasError: _showTimeErrors && _startTime == null),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _timeCard('Ora fine (pasto)', _formatTimeOfDay(_endTime), _pickEndTime,
                          hasError: _showTimeErrors && _endTime == null),
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

  Widget _afterSection() {
    return _card(
      color: _cardBlue,
      child: Column(
        children: [
          _sectionHeader('Dopo il pasto', Icons.favorite_border, _headerBlue),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                _textField(_bodyAfterCtrl, 'Sensazioni fisiche (dopo)...'),
                const SizedBox(height: 14),
                _sliderBlock(
                  label: 'Intensità emotiva (dopo) 0–10',
                  value: _intensityAfter,
                  onChanged: (v) => setState(() => _intensityAfter = v),
                ),
                const SizedBox(height: 12),
                EmotionPicker(
                  title: 'Emozioni (dopo) – scegli emoticon oppure scrivi tu',
                  selected: _emotionsAfter,
                  selectedColor: DS.chipSelectedMeal,
                  onChanged: (v) => setState(() => _emotionsAfter = v),
                ),
                const SizedBox(height: 12),
                _textField(_thoughtAfterCtrl, 'Pensiero (dopo)...'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ====== BUILD ======
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    final horizontalPadding = (width * 0.045).clamp(14.0,22.0);
    final verticalPadding = (height * 0.03).clamp(16.0,28.0);
    final bottomButtonHeight = (height * 0.07).clamp(42.0,56.0);
    final bottomButtonPadding = bottomButtonHeight + 15;
    return Scaffold(
      backgroundColor: _pageBg,
      appBar: appAppBar('Nuovo pasto principale'),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            verticalPadding,
            horizontalPadding,
            bottomButtonPadding,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                children: [
                  _dateTimeSection(),
                  const SizedBox(height: 12),
                  _mealTypeSection(),
                  const SizedBox(height: 14),
                  MindfulnessCard(suggestion: _suggestionBeforeMeal),
                  const SizedBox(height: 14),
                  _beforeSection(),
                  const SizedBox(height: 14),
                  _mealSection(),
                  const SizedBox(height: 14),
                  MindfulnessCard(suggestion: _suggestionAfterMeal),
                  const SizedBox(height: 14),
                  _afterSection(),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          color: _pageBg,
          padding: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 12),
          child: SizedBox(
            height: bottomButtonHeight,
            child: SaveButton(onPressed: _save),
          ),
        ),
      ),
    );
  }
}
