import 'package:flutter/material.dart';

import '../data/database_helper.dart';
import '../models/emotions.dart';
import '../models/meal.dart';
import '../models/mindfulness_suggestions.dart';
import '../widgets/common_buttons.dart';
import '../widgets/emotion_picker.dart';

class AddMealPage extends StatefulWidget {
  const AddMealPage({super.key});

  @override
  State<AddMealPage> createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  DateTime _dateTime = DateTime.now();

  String _mealType = kMealTypes.first;

  final TextEditingController _whereCtrl = TextEditingController();
  final TextEditingController _withWhoCtrl = TextEditingController();
  final TextEditingController _bodyBeforeCtrl = TextEditingController();
  double _intensityBefore = 0;
  String? _emotionsBefore;
  final TextEditingController _thoughtBeforeCtrl = TextEditingController();

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  final TextEditingController _whatEatCtrl = TextEditingController();

  final TextEditingController _bodyAfterCtrl = TextEditingController();
  double _intensityAfter = 0;
  String? _emotionsAfter;
  final TextEditingController _thoughtAfterCtrl = TextEditingController();

  bool _showTimeErrors = false;
  int _currentStep = 0;

  late String _suggestionBeforeMeal;
  late String _suggestionAfterMeal;

  static const Color _pageBg = Color(0xFFFCFAF5);

  static const Color _textDark = Color(0xFF22312B);
  static const Color _textMuted = Color(0xFF6A746E);

  static const Color _orange = Color(0xFFF28A2E);
  static const Color _orangeSoft = Color(0xFFFFF2E5);
  static const Color _orangePanel = Color(0xFFF8D4B2);

  static const Color _green = Color(0xFF5B9E4D);
  static const Color _greenSoft = Color(0xFFF1F8EF);
  static const Color _greenPanel = Color(0xFFDDEED7);

  static const Color _blue = Color(0xFF5B9BD5);
  static const Color _blueSoft = Color(0xFFF0F7FF);
  static const Color _bluePanel = Color(0xFFD6E8F8);

  static const Color border = Color(0xFFF0E2C3);

  Color get _stepAccent {
    if (_currentStep == 0) return _orange;
    if (_currentStep == 1) return _green;
    return _blue;
  }

  Color get _stepSoft {
    if (_currentStep == 0) return _orangeSoft;
    if (_currentStep == 1) return _greenSoft;
    return _blueSoft;
  }

  Color get _stepPanel {
    if (_currentStep == 0) return _orangePanel;
    if (_currentStep == 1) return _greenPanel;
    return _bluePanel;
  }

  IconData _mealIcon(String meal) {
    switch (meal.toLowerCase()) {
      case 'colazione':
        return Icons.free_breakfast_rounded;
      case 'spuntino':
        return Icons.bakery_dining_rounded;
      case 'pranzo':
        return Icons.lunch_dining_rounded;
      case 'merenda':
        return Icons.local_cafe_rounded;
      case 'cena':
        return Icons.dinner_dining_rounded;
      default:
        return Icons.restaurant_menu_rounded;
    }
  }

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

  String _formatTimeOfDay(TimeOfDay? t) {
    if (t == null) return '--:--';
    return '${twoDigit(t.hour)}:${twoDigit(t.minute)}';
  }

  String _formatPrettyDate(DateTime date) {
    const days = [
      'Lunedì',
      'Martedì',
      'Mercoledì',
      'Giovedì',
      'Venerdì',
      'Sabato',
      'Domenica',
    ];

    const months = [
      'Gennaio',
      'Febbraio',
      'Marzo',
      'Aprile',
      'Maggio',
      'Giugno',
      'Luglio',
      'Agosto',
      'Settembre',
      'Ottobre',
      'Novembre',
      'Dicembre',
    ];

    return '${days[date.weekday - 1]} ${date.day} ${months[date.month - 1]}';
  }

  Future<DateTime?> _pickDateInSheet() async {
    DateTime tempDate = _dateTime;

    return showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              top: false,
              child: Container(
                margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 16),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFCF7),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(32),
                    bottom: Radius.circular(32),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 42,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),

                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: _stepSoft,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.calendar_month_rounded,
                            color: _stepAccent,
                            size: 25,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Data del pasto',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: _textDark,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            Icons.close_rounded,
                            color: Colors.black.withOpacity(0.55),
                            size: 28,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: _stepSoft,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: _stepAccent.withOpacity(0.14),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.event_available_rounded,
                            color: _stepAccent,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _formatPrettyDate(tempDate),
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: _textDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: _stepAccent,
                          onPrimary: Colors.white,
                          surface: const Color(0xFFFFFCF7),
                          onSurface: _textDark,
                        ),
                        datePickerTheme: DatePickerThemeData(
                          backgroundColor: const Color(0xFFFFFCF7),
                          surfaceTintColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          dayStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                          weekdayStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: _textMuted.withOpacity(0.85),
                          ),
                          yearStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      child: CalendarDatePicker(
                        initialDate: tempDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                        onDateChanged: (date) {
                          setModalState(() => tempDate = date);
                        },
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 52,
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: _textDark,
                                backgroundColor: Colors.white,
                                side: BorderSide(
                                  color: Colors.black.withOpacity(0.10),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              child: const Text('Annulla'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(tempDate);
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: _stepAccent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              child: const Text('Continua'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _pickDateTime() async {
    final date = await _pickDateInSheet();

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dateTime),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _stepAccent,
              onPrimary: Colors.white,
              surface: const Color(0xFFFFFCF7),
              onSurface: Colors.black87,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: const Color(0xFFFFFCF7),
              hourMinuteColor: _stepSoft,
              hourMinuteTextColor: _textDark,
              dialHandColor: _stepAccent,
              dialBackgroundColor: _stepSoft,
              entryModeIconColor: _stepAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: _stepAccent,
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

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      _save();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.of(context).pop();
    }
  }

  void _save() async {
    if (_startTime == null || _endTime == null) {
      setState(() {
        _currentStep = 1;
        _showTimeErrors = true;
      });

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
      startTime: _formatTimeOfDay(_startTime),
      endTime: _formatTimeOfDay(_endTime),
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

  Future<void> _openEmotionSheet({
    required String title,
    required String? selected,
    required ValueChanged<String?> onChanged,
  }) async {
    String subtitleForTitle(String title) {
      final lower = title.toLowerCase();

      if (lower.contains('prima')) {
        return 'Scegli l’emozione che senti più vicina prima di mangiare.';
      }

      if (lower.contains('dopo')) {
        return 'Osserva cosa è cambiato dopo il pasto.';
      }

      return 'Scegli l’emozione che senti più vicina in questo momento.';
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.42),
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.72,
          minChildSize: 0.45,
          maxChildSize: 0.92,
          builder: (context, scrollController) {
          final bottomSafe = MediaQuery.of(context).padding.bottom;

          return SafeArea(
            top: false,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFFFCF7),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 12, 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: _stepSoft,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.mood_rounded,
                            color: _stepAccent,
                            size: 26,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 22,
                                  height: 1.12,
                                  fontWeight: FontWeight.w900,
                                  color: _textDark,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                subtitleForTitle(title),
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  height: 1.35,
                                  fontWeight: FontWeight.w500,
                                  color: _textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          onPressed: () => Navigator.of(sheetContext).pop(),
                          icon: Icon(
                            Icons.close_rounded,
                            color: Colors.black.withOpacity(0.55),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: EdgeInsets.fromLTRB(
                        18,
                        4,
                        18,
                        bottomSafe + 38,
                      ),
                      children: [
                        EmotionPicker(
                          selected: selected,
                          selectedColor: _stepAccent.withOpacity(0.16),
                          accentColor: _stepAccent,
                          softColor: _stepSoft,
                          onChanged: (value) {
                            onChanged(value);
                            Navigator.of(sheetContext).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        );
      },
    );
  }

  Future<void> _openMealTypeSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
            decoration: const BoxDecoration(
              color: Color(0xFFFFFCF7),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),

                Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: _stepSoft,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.restaurant_menu_rounded,
                        color: _stepAccent,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Tipo di pasto',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: _textDark,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                ...kMealTypes.map((meal) {
                  final selected = meal == _mealType;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () {
                        setState(() => _mealType = meal);
                        Navigator.of(context).pop();
                      },
                      borderRadius: BorderRadius.circular(22),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          color: selected ? _stepSoft : Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: selected
                                ? _stepAccent.withOpacity(0.45)
                                : Colors.black.withOpacity(0.08),
                            width: selected ? 1.4 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _mealIcon(meal),
                              color: selected ? _stepAccent : _textMuted,
                              size: 24,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                meal,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: selected ? _textDark : Colors.black87,
                                ),
                              ),
                            ),
                            if (selected)
                              Icon(
                                Icons.check_circle_rounded,
                                color: _stepAccent,
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _topHeader() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 44,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    size: 26,
                    color: Colors.black,
                  ),
                ),
              ),

              Transform.translate(
                offset: const Offset(6, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Mi Ascolto',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        color: _stepAccent,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.eco_rounded,
                      color: _stepAccent,
                      size: 26,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          'Nuovo pasto principale',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            height: 1.1,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 7),

        const Text(
          'Prenditi un momento per ascoltarti',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            height: 1.25,
            fontWeight: FontWeight.w500,
            color: _textMuted,
          ),
        ),
      ],
    );
  }

  Widget _stepper() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 8),
      child: Row(
        children: [
          Expanded(child: _stepItem(0, 'Prima', Icons.circle_outlined)),
          _stepLine(0),
          Expanded(child: _stepItem(1, 'Pasto', Icons.restaurant_rounded)),
          _stepLine(1),
          Expanded(child: _stepItem(2, 'Dopo', Icons.favorite_border_rounded)),
        ],
      ),
    );
  }

  Widget _stepLine(int beforeStep) {
    final active = _currentStep > beforeStep;

    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: active ? _stepAccent.withOpacity(0.55) : Colors.black.withOpacity(0.10),
          borderRadius: BorderRadius.circular(99),
        ),
      ),
    );
  }

  Widget _stepItem(int index, String label, IconData icon) {
    final active = _currentStep == index;
    final done = _currentStep > index;

    final color = active || done ? _stepAccent : _textMuted.withOpacity(0.55);

    return GestureDetector(
      onTap: () => setState(() => _currentStep = index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? _stepAccent : const Color(0xFFF0ECE3),
              boxShadow: active
                  ? [
                BoxShadow(
                  color: _stepAccent.withOpacity(0.24),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ]
                  : null,
            ),
            child: Center(
              child: done
                  ? const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 21,
              )
                  : active
                  ? Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              )
                  : Icon(
                icon,
                color: color,
                size: 21,
              ),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: active ? FontWeight.w800 : FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _setupMealCard() {
    final bool showMealType = _currentStep == 1;

    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.055),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            InkWell(
              onTap: _pickDateTime,
              borderRadius: BorderRadius.circular(24),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _stepSoft,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      Icons.calendar_month_rounded,
                      color: _stepAccent,
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Text(
                      formatDateTime(_dateTime),
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.15,
                        fontWeight: FontWeight.w800,
                        color: _textDark,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 13,
                    ),
                    decoration: BoxDecoration(
                      color: _stepSoft,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Text(
                      'Cambia',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: _stepAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (showMealType) ...[
              const SizedBox(height: 18),
              Container(
                height: 1,
                color: Colors.black.withOpacity(0.05),
              ),
              const SizedBox(height: 18),

              InkWell(
                onTap: _openMealTypeSheet,
                borderRadius: BorderRadius.circular(24),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: _stepSoft,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(
                        _mealIcon(_mealType),
                        color: _stepAccent,
                        size: 27,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Text(
                        _mealType,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.black.withOpacity(0.60),
                      size: 30,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _suggestionCard() {
    final suggestion = _currentStep == 2 ? _suggestionAfterMeal : _suggestionBeforeMeal;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16,14,16,14),
      decoration: BoxDecoration(
        color: _stepSoft,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _stepAccent.withOpacity(0.13),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lightbulb_outline_rounded,
              color: _stepAccent,
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Suggerimento',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  suggestion,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                    color: _textMuted,
                  ),
                ),
              ]
            ),
          ),
        ]
      ),
    );
  }

  Widget _currentStepBody() {
    if (_currentStep == 0) return _beforeStep();
    if (_currentStep == 1) return _mealStep();
    return _afterStep();
  }

  Widget _beforeStep() {
    return _guidedPanel(
      title: 'Come mi sento prima di mangiare?',
      subtitle: 'Racconta il momento prima di mangiare.',
      icon: Icons.self_improvement_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _smallLabel('Contesto'),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _softTextField(
                  controller: _whereCtrl,
                  hint: 'Dove sono?',
                  icon: Icons.location_on_outlined,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _softTextField(
                  controller: _withWhoCtrl,
                  hint: 'Con chi sono?',
                  icon: Icons.people_outline_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _smallLabel('Corpo'),
          const SizedBox(height: 10),
          _softTextField(
            controller: _bodyBeforeCtrl,
            hint: 'Che sensazioni fisiche noto?',
            icon: Icons.accessibility_new_rounded,
          ),
          const SizedBox(height: 18),
          _sliderCard(
            label: 'Intensità emotiva 0–10',
            value: _intensityBefore,
            onChanged: (v) => setState(() => _intensityBefore = v),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _selectorTile(
                  icon: Icons.mood_rounded,
                  title: 'Emozioni',
                  value: _emotionsBefore,
                  onTap: () => _openEmotionSheet(
                    title: 'Emozioni prima',
                    selected: _emotionsBefore,
                    onChanged: (v) => setState(() => _emotionsBefore = v),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _softTextField(
                  controller: _thoughtBeforeCtrl,
                  hint: 'Pensiero',
                  icon: Icons.chat_bubble_outline_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mealStep() {
    return _guidedPanel(
      title: 'Pasto',
      subtitle: 'Registra il momento del pasto.',
      icon: Icons.restaurant_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _smallLabel('Orario'),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _timeBox(
                  title: 'Inizio',
                  value: _formatTimeOfDay(_startTime),
                  hasError: _showTimeErrors && _startTime == null,
                  onTap: _pickStartTime,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _timeBox(
                  title: 'Fine',
                  value: _formatTimeOfDay(_endTime),
                  hasError: _showTimeErrors && _endTime == null,
                  onTap: _pickEndTime,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _smallLabel('Cosa mangio'),
          const SizedBox(height: 10),
          _softTextField(
            controller: _whatEatCtrl,
            hint: 'Descrivi il pasto...',
            icon: Icons.edit_note_rounded,
          ),
        ],
      ),
    );
  }

  Widget _afterStep() {
    return _guidedPanel(
      title: 'Come mi sento dopo il pasto?',
      subtitle: 'Osserva come stai dopo aver mangiato.',
      icon: Icons.favorite_border_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _smallLabel('Corpo'),
          const SizedBox(height: 10),
          _softTextField(
            controller: _bodyAfterCtrl,
            hint: 'Che sensazioni fisiche noto?',
            icon: Icons.accessibility_new_rounded,
          ),
          const SizedBox(height: 18),
          _sliderCard(
            label: 'Intensità emotiva 0–10',
            value: _intensityAfter,
            onChanged: (v) => setState(() => _intensityAfter = v),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _selectorTile(
                  icon: Icons.mood_rounded,
                  title: 'Emozioni',
                  value: _emotionsAfter,
                  onTap: () => _openEmotionSheet(
                    title: 'Emozioni dopo',
                    selected: _emotionsAfter,
                    onChanged: (v) => setState(() => _emotionsAfter = v),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _softTextField(
                  controller: _thoughtAfterCtrl,
                  hint: 'Pensiero',
                  icon: Icons.chat_bubble_outline_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _guidedPanel({
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _stepSoft,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: _stepAccent.withOpacity(0.12),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            decoration: BoxDecoration(
              color: _stepPanel,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(26),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.42),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: _textDark,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 22,
                          height: 1.08,
                          fontWeight: FontWeight.w900,
                          color: _textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.25,
                          fontWeight: FontWeight.w600,
                          color: _textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _smallLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w900,
        color: _textDark,
      ),
    );
  }

  Widget _softTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      minLines: 1,
      maxLines: 3,
      style: const TextStyle(
        fontSize: 15.5,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 15.5,
          fontWeight: FontWeight.w700,
          color: Colors.black.withOpacity(0.42),
        ),
        prefixIcon: Icon(
          icon,
          color: _stepAccent,
          size: 22,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.86),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.10),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.10),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: _stepAccent.withOpacity(0.75),
            width: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _selectorTile({
    required IconData icon,
    required String title,
    required String? value,
    required VoidCallback onTap,
  }) {
    final hasValue = value != null && value.trim().isNotEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.86),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.black.withOpacity(0.10),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: _stepAccent,
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                hasValue ? value : title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                  color: hasValue ? _textDark : Colors.black.withOpacity(0.46),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sliderCard({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.70),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.black.withOpacity(0.08),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: _textDark,
                  ),
                ),
              ),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _stepAccent.withOpacity(0.14),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    value.round().toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: _stepAccent,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _stepAccent,
              inactiveTrackColor: _stepAccent.withOpacity(0.16),
              thumbColor: _stepAccent,
              overlayColor: _stepAccent.withOpacity(0.12),
            ),
            child: Slider(
              value: value,
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeBox({
    required String title,
    required String value,
    required VoidCallback onTap,
    bool hasError = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: hasError ? const Color(0xFFFFE8E8) : Colors.white.withOpacity(0.86),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: hasError ? Colors.red : Colors.black.withOpacity(0.10),
            width: hasError ? 1.4 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: _textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: _textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomControls(double horizontalPadding) {
    final isLastStep = _currentStep == 2;

    return SafeArea(
      top: false,
      child: Container(
        color: _pageBg.withOpacity(0.96),
        padding: EdgeInsets.fromLTRB(horizontalPadding, 10, horizontalPadding, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 54,
                    child: _currentStep == 0 ?
                    OutlinedButton(
                        onPressed: _previousStep,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _textDark,
                          side: BorderSide(
                            color: Colors.black.withOpacity(0.10),
                          ),
                          backgroundColor: Colors.white.withOpacity(0.72),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        child: const Text('Esci')
                    ) : OutlinedButton.icon(
                      onPressed: _previousStep,
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 22,),
                      label: const Text('Indietro'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _textDark,
                        side: BorderSide(
                          color: Colors.black.withOpacity(0.10),
                        ),
                        backgroundColor: Colors.white.withOpacity(0.72),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    )
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: SizedBox(
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: _nextStep,
                      icon: Icon(
                        isLastStep ? Icons.save_rounded : Icons.arrow_forward_rounded,
                        size: 22,
                      ),
                      label: Text(isLastStep ? 'Salva' : 'Avanti'),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: _stepAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: TextButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Salva e continua dopo'),
                style: TextButton.styleFrom(
                  foregroundColor: _stepAccent,
                  backgroundColor: _stepSoft,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: _stepAccent.withOpacity(0.10),
                    ),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;

    final horizontalPadding = (width * 0.055).clamp(18.0, 26.0);

    return Scaffold(
      backgroundColor: _pageBg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned(
              top: 60,
              right: -28,
              child: Opacity(
                opacity: 0.12,
                child: Icon(
                  Icons.eco_rounded,
                  size: 130,
                  color: _stepAccent,
                ),
              ),
            ),
            SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                8,
                horizontalPadding,
                50,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    children: [
                      _topHeader(),
                      _stepper(),
                      const SizedBox(height: 20),
                      _setupMealCard(),
                      const SizedBox(height: 16),
                      _suggestionCard(),
                      const SizedBox(height: 16),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
                        child: KeyedSubtree(
                          key: ValueKey(_currentStep),
                          child: _currentStepBody(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomControls(horizontalPadding),
    );
  }
}