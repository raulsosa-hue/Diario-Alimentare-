import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/database_helper.dart';
import '../models/emotions.dart';
import '../models/meal.dart';
import '../models/mindfulness_suggestions.dart';
import '../utils/diary_formatters.dart';
import '../widgets/common_buttons.dart';
import '../widgets/diary/diary_form_common.dart';

class AddMealPage extends StatefulWidget {
  const AddMealPage({super.key});

  @override
  State<AddMealPage> createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  static const String _draftKey = 'add_meal_draft_v1';

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

  Color get _stepAccent => EntryFormColors.accent(_currentStep);
  Color get _stepSoft => EntryFormColors.soft(_currentStep);
  Color get _stepPanel => EntryFormColors.panel(_currentStep);

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

    _loadDraft();
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

  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final rawDraft = prefs.getString(_draftKey);

    if (rawDraft == null) return;

    try {
      final decoded = jsonDecode(rawDraft);

      if (decoded is! Map<String, dynamic>) return;
      if (!mounted) return;

      setState(() {
        final dateMillis = decoded['dateTimeMillis'];

        if (dateMillis is num) {
          _dateTime = DateTime.fromMillisecondsSinceEpoch(dateMillis.toInt());
        }

        final savedMealType =
        EntryDraftTools.readString(decoded, 'mealType');

        if (savedMealType != null && kMealTypes.contains(savedMealType)) {
          _mealType = savedMealType;
        }

        _whereCtrl.text = EntryDraftTools.readString(decoded, 'where') ?? '';
        _withWhoCtrl.text =
            EntryDraftTools.readString(decoded, 'withWho') ?? '';
        _bodyBeforeCtrl.text =
            EntryDraftTools.readString(decoded, 'bodyBefore') ?? '';

        _intensityBefore = EntryDraftTools.readDouble(
          decoded,
          'intensityBefore',
          fallback: 0,
          min: 0,
          max: 10,
        );

        _emotionsBefore =
            EntryDraftTools.readString(decoded, 'emotionsBefore');

        _thoughtBeforeCtrl.text =
            EntryDraftTools.readString(decoded, 'thoughtBefore') ?? '';

        _startTime =
            EntryDraftTools.minutesToTime(decoded['startTimeMinutes']) ??
                _startTime;

        _endTime = EntryDraftTools.minutesToTime(decoded['endTimeMinutes']);

        _whatEatCtrl.text =
            EntryDraftTools.readString(decoded, 'whatEat') ?? '';

        _bodyAfterCtrl.text =
            EntryDraftTools.readString(decoded, 'bodyAfter') ?? '';

        _intensityAfter = EntryDraftTools.readDouble(
          decoded,
          'intensityAfter',
          fallback: 0,
          min: 0,
          max: 10,
        );

        _emotionsAfter = EntryDraftTools.readString(decoded, 'emotionsAfter');

        _thoughtAfterCtrl.text =
            EntryDraftTools.readString(decoded, 'thoughtAfter') ?? '';

        _showTimeErrors = false;

        _currentStep = EntryDraftTools.readInt(
          decoded,
          'currentStep',
          fallback: 0,
          min: 0,
          max: 2,
        );
      });
    } catch (_) {
      await prefs.remove(_draftKey);
    }
  }

  Future<void> _saveDraftAndExit() async {
    final prefs = await SharedPreferences.getInstance();

    final draft = {
      'dateTimeMillis': _dateTime.millisecondsSinceEpoch,
      'mealType': _mealType,
      'where': _whereCtrl.text.trim(),
      'withWho': _withWhoCtrl.text.trim(),
      'bodyBefore': _bodyBeforeCtrl.text.trim(),
      'intensityBefore': _intensityBefore,
      'emotionsBefore': _emotionsBefore,
      'thoughtBefore': _thoughtBeforeCtrl.text.trim(),
      'startTimeMinutes': EntryDraftTools.timeToMinutes(_startTime),
      'endTimeMinutes': EntryDraftTools.timeToMinutes(_endTime),
      'whatEat': _whatEatCtrl.text.trim(),
      'bodyAfter': _bodyAfterCtrl.text.trim(),
      'intensityAfter': _intensityAfter,
      'emotionsAfter': _emotionsAfter,
      'thoughtAfter': _thoughtAfterCtrl.text.trim(),
      'currentStep': _currentStep,
    };

    await prefs.setString(_draftKey, jsonEncode(draft));

    if (!mounted) return;

    Navigator.of(context).pop();
  }

  Future<void> _clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_draftKey);
  }

  Future<void> _pickDateTime() async {
    final picked = await EntryDateTimePicker.pick(
      context: context,
      currentDateTime: _dateTime,
      sheetTitle: 'Data del pasto',
      accentColor: _stepAccent,
      softColor: _stepSoft,
      textDark: EntryFormColors.textDark,
      textMuted: EntryFormColors.textMuted,
    );

    if (!mounted || picked == null) return;

    setState(() => _dateTime = picked);
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

  Future<void> _save() async {
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
      startTime: formatTimeOfDay(_startTime),
      endTime: formatTimeOfDay(_endTime),
      whatEaten: nullIfEmpty(_whatEatCtrl),
      bodySensationsAfter: nullIfEmpty(_bodyAfterCtrl),
      emotionalIntensityAfter: _intensityAfter.round(),
      emotionAfter: buildEmotionStorageValue(_emotionsAfter),
      thoughtAfter: nullIfEmpty(_thoughtAfterCtrl),
    );

    try {
      await DatabaseHelper.instance.insertMeal(meal);
      await _clearDraft();
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
    await EntryEmotionSheet.show(
      context: context,
      title: title,
      selected: selected,
      accentColor: _stepAccent,
      softColor: _stepSoft,
      textDark: EntryFormColors.textDark,
      textMuted: EntryFormColors.textMuted,
      onChanged: onChanged,
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
                    color: Colors.black.withValues(alpha: 0.14),
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
                          color: EntryFormColors.textDark,
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
                                ? _stepAccent.withValues(alpha: 0.45)
                                : Colors.black.withValues(alpha: 0.08),
                            width: selected ? 1.4 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _mealIcon(meal),
                              color: selected
                                  ? _stepAccent
                                  : EntryFormColors.textMuted,
                              size: 24,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                meal,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: selected
                                      ? EntryFormColors.textDark
                                      : Colors.black87,
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

  Widget _setupMealCard() {
    return EntrySetupCard(
      dateTime: _dateTime,
      accentColor: _stepAccent,
      softColor: _stepSoft,
      textDark: EntryFormColors.textDark,
      onDateTap: _pickDateTime,
      children: [
        if (_currentStep == 1) ...[
          const EntryCardDivider(),
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
                  color: Colors.black.withValues(alpha: 0.60),
                  size: 30,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _currentStepBody() {
    if (_currentStep == 0) return _beforeStep();
    if (_currentStep == 1) return _mealStep();
    return _afterStep();
  }

  Widget _beforeStep() {
    return EntryGuidedPanel(
      title: 'Come mi sento prima di mangiare?',
      subtitle: 'Racconta il momento prima di mangiare.',
      icon: Icons.self_improvement_rounded,
      accentColor: _stepAccent,
      softColor: _stepSoft,
      panelColor: _stepPanel,
      textDark: EntryFormColors.textDark,
      textMuted: EntryFormColors.textMuted,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const EntrySmallLabel('Contesto'),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: EntrySoftTextField(
                  controller: _whereCtrl,
                  hint: 'Dove sono?',
                  icon: Icons.location_on_outlined,
                  accentColor: _stepAccent,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: EntrySoftTextField(
                  controller: _withWhoCtrl,
                  hint: 'Con chi sono?',
                  icon: Icons.people_outline_rounded,
                  accentColor: _stepAccent,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          const EntrySmallLabel('Corpo'),
          const SizedBox(height: 10),

          EntrySoftTextField(
            controller: _bodyBeforeCtrl,
            hint: 'Che sensazioni fisiche noto?',
            icon: Icons.accessibility_new_rounded,
            accentColor: _stepAccent,
          ),

          const SizedBox(height: 18),

          const EntrySmallLabel('Emozione'),
          const SizedBox(height: 10),

          EntrySelectorTile(
            icon: Icons.mood_rounded,
            title: 'Che emozione sento?',
            value: _emotionsBefore,
            accentColor: _stepAccent,
            textDark: EntryFormColors.textDark,
            onTap: () => _openEmotionSheet(
              title: 'Emozioni prima',
              selected: _emotionsBefore,
              onChanged: (v) => setState(() => _emotionsBefore = v),
            ),
          ),

          const SizedBox(height: 18),

          EntrySliderCard(
            label: 'Quanto è forte quest\u2019emozione',
            value: _intensityBefore,
            accentColor: _stepAccent,
            textDark: EntryFormColors.textDark,
            onChanged: (v) => setState(() => _intensityBefore = v),
          ),

          const SizedBox(height: 18),

          const EntrySmallLabel('Pensiero'),
          const SizedBox(height: 10),

          EntrySoftTextField(
            controller: _thoughtBeforeCtrl,
            hint: 'Che pensiero passa in questo momento?',
            icon: Icons.chat_bubble_outline_rounded,
            accentColor: _stepAccent,
          ),
        ],
      ),
    );
  }

  Widget _mealStep() {
    return EntryGuidedPanel(
      title: 'Pasto',
      subtitle: 'Registra il momento del pasto.',
      icon: Icons.restaurant_rounded,
      accentColor: _stepAccent,
      softColor: _stepSoft,
      panelColor: _stepPanel,
      textDark: EntryFormColors.textDark,
      textMuted: EntryFormColors.textMuted,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const EntrySmallLabel('Orario'),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: EntryTimeBox(
                  title: 'Inizio',
                  value: formatTimeOfDay(_startTime),
                  hasError: _showTimeErrors && _startTime == null,
                  onTap: _pickStartTime,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: EntryTimeBox(
                  title: 'Fine',
                  value: formatTimeOfDay(_endTime),
                  hasError: _showTimeErrors && _endTime == null,
                  onTap: _pickEndTime,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const EntrySmallLabel('Cosa mangio'),
          const SizedBox(height: 10),
          EntrySoftTextField(
            controller: _whatEatCtrl,
            hint: 'Descrivi il pasto...',
            icon: Icons.edit_note_rounded,
            accentColor: _stepAccent,
          ),
        ],
      ),
    );
  }

  Widget _afterStep() {
    return EntryGuidedPanel(
      title: 'Come mi sento dopo il pasto?',
      subtitle: 'Osserva come stai dopo aver mangiato.',
      icon: Icons.favorite_border_rounded,
      accentColor: _stepAccent,
      softColor: _stepSoft,
      panelColor: _stepPanel,
      textDark: EntryFormColors.textDark,
      textMuted: EntryFormColors.textMuted,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const EntrySmallLabel('Corpo'),
          const SizedBox(height: 10),

          EntrySoftTextField(
            controller: _bodyAfterCtrl,
            hint: 'Che sensazioni fisiche noto?',
            icon: Icons.accessibility_new_rounded,
            accentColor: _stepAccent,
          ),

          const SizedBox(height: 18),

          const EntrySmallLabel('Emozione'),
          const SizedBox(height: 10),

          EntrySelectorTile(
            icon: Icons.mood_rounded,
            title: 'Che emozione sento adesso?',
            value: _emotionsAfter,
            accentColor: _stepAccent,
            textDark: EntryFormColors.textDark,
            onTap: () => _openEmotionSheet(
              title: 'Emozioni dopo',
              selected: _emotionsAfter,
              onChanged: (v) => setState(() => _emotionsAfter = v),
            ),
          ),

          const SizedBox(height: 18),

          EntrySliderCard(
            label: 'Quanto è forte quest\u2019emozione',
            value: _intensityAfter,
            accentColor: _stepAccent,
            textDark: EntryFormColors.textDark,
            onChanged: (v) => setState(() => _intensityAfter = v),
          ),

          const SizedBox(height: 18),

          const EntrySmallLabel('Pensiero'),
          const SizedBox(height: 10),

          EntrySoftTextField(
            controller: _thoughtAfterCtrl,
            hint: 'Che pensiero rimane dopo il pasto?',
            icon: Icons.chat_bubble_outline_rounded,
            accentColor: _stepAccent,
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = (width * 0.055).clamp(18.0, 26.0);

    return Scaffold(
      backgroundColor: EntryFormColors.pageBg,
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
                  Icons.restaurant_rounded,
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
                      EntryFormHeader(
                        title: 'Nuovo pasto principale',
                        subtitle: 'Prenditi un momento per ascoltarti',
                        accentColor: _stepAccent,
                        titleFontSize: 25,
                        titleFontWeight: FontWeight.w800,
                      ),
                      EntryFormStepper(
                        currentStep: _currentStep,
                        accentColor: _stepAccent,
                        textMuted: EntryFormColors.textMuted,
                        onStepTap: (index) {
                          setState(() => _currentStep = index);
                        },
                        steps: const [
                          EntryStepData(
                            label: 'Prima',
                            icon: Icons.self_improvement_rounded,
                          ),
                          EntryStepData(
                            label: 'Pasto',
                            icon: Icons.restaurant_rounded,
                          ),
                          EntryStepData(
                            label: 'Dopo',
                            icon: Icons.favorite_border_rounded,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _setupMealCard(),
                      const SizedBox(height: 16),
                      EntrySuggestionCard(
                        suggestion: _currentStep == 2
                            ? _suggestionAfterMeal
                            : _suggestionBeforeMeal,
                        accentColor: _stepAccent,
                        softColor: _stepSoft,
                        textDark: EntryFormColors.textDark,
                        textMuted: EntryFormColors.textMuted,
                        borderColor: EntryFormColors.border,
                      ),
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
      bottomNavigationBar: EntryBottomControls(
        horizontalPadding: horizontalPadding,
        pageBg: EntryFormColors.pageBg,
        accentColor: _stepAccent,
        softColor: _stepSoft,
        textDark: EntryFormColors.textDark,
        isFirstStep: _currentStep == 0,
        isLastStep: _currentStep == 2,
        onBack: _previousStep,
        onNext: _nextStep,
        onSaveDraft: _saveDraftAndExit,
      ),
    );
  }
}