import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/database_helper.dart';
import '../models/emotions.dart';
import '../models/exercise.dart';
import '../models/labeled_emoji.dart';
import '../models/mindfulness_suggestions.dart';
import '../widgets/common_buttons.dart';
import '../widgets/diary/diary_form_common.dart';
import '../widgets/exercise/exercise_choice_tile.dart';
import '../widgets/exercise/exercise_duration_button.dart';
import '../widgets/exercise/exercise_info_box.dart';

class AddExercisePage extends StatefulWidget {
  const AddExercisePage({super.key});

  @override
  State<AddExercisePage> createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  static const String _draftKey = 'add_exercise_draft_v1';

  DateTime _dateTime = DateTime.now();

  final List<LabeledEmoji> _exerciseTypes = const [
    LabeledEmoji('Camminata', '🚶‍♂️'),
    LabeledEmoji('Corsa / Running', '🏃'),
    LabeledEmoji('Bici', '🚴'),
    LabeledEmoji('Palestra / Pesi', '🏋️'),
    LabeledEmoji('Stretching / Mobilità', '🧘'),
    LabeledEmoji('Yoga / Pilates', '🧘‍♂️'),
    LabeledEmoji('Nuoto', '🏊'),
    LabeledEmoji('Trekking / Camminata lunga', '🥾'),
    LabeledEmoji('Sport di squadra', '⚽'),
    LabeledEmoji('Allenamento a casa', '🏠'),
  ];

  String? _selectedExerciseType;
  bool _isOtherExerciseSelected = false;
  final TextEditingController _otherExerciseCtrl = TextEditingController();
  int _durationMinutes = 20;

  final List<LabeledEmoji> _intentionOptions = const [
    LabeledEmoji('Benessere / Energia', '✅'),
    LabeledEmoji('Gestire emozioni / Stress', '🧠'),
    LabeledEmoji('Bruciare / Rimediare al cibo', '⚠️'),
    LabeledEmoji('Controllo / Punizione', '❗'),
  ];

  String? _selectedIntention;
  double _intensityBefore = 0;
  String? _emotionsBefore;
  final TextEditingController _thoughtBeforeCtrl = TextEditingController();

  final List<LabeledEmoji> _outcomeOptions = const [
    LabeledEmoji('Più libero / leggero', '✅'),
    LabeledEmoji('Uguale', '😐'),
    LabeledEmoji('Più in colpa / più rigido', '⚠️'),
    LabeledEmoji('Ansia peggiorata / urgenza', '❗'),
  ];

  String? _selectedOutcome;
  double _intensityAfter = 0;
  String? _emotionsAfter;
  final TextEditingController _bodyAfterCtrl = TextEditingController();
  final TextEditingController _thoughtAfterCtrl = TextEditingController();

  int _currentStep = 0;

  late String _suggestionBeforeExercise;
  late String _suggestionAfterExercise;

  Color get _stepAccent => EntryFormColors.accent(_currentStep);
  Color get _stepSoft => EntryFormColors.soft(_currentStep);
  Color get _stepPanel => EntryFormColors.panel(_currentStep);

  String get _exerciseDisplayName {
    if (_isOtherExerciseSelected && _otherExerciseCtrl.text.trim().isNotEmpty) {
      return _otherExerciseCtrl.text.trim();
    }

    return _selectedExerciseType ?? 'Scegli esercizio';
  }

  @override
  void initState() {
    super.initState();
    _suggestionBeforeExercise = pickSuggestion(MindfulnessMoment.beforeExercise);
    _suggestionAfterExercise = pickSuggestion(MindfulnessMoment.afterExercise);
    _loadDraft();
  }

  @override
  void dispose() {
    _otherExerciseCtrl.dispose();
    _thoughtBeforeCtrl.dispose();
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

        _selectedExerciseType =
            EntryDraftTools.readString(decoded, 'selectedExerciseType');

        _isOtherExerciseSelected =
            decoded['isOtherExerciseSelected'] == true;

        _otherExerciseCtrl.text =
            EntryDraftTools.readString(decoded, 'otherExercise') ?? '';

        if (_isOtherExerciseSelected) {
          _selectedExerciseType = null;
        }

        _durationMinutes = EntryDraftTools.readInt(
          decoded,
          'durationMinutes',
          fallback: 20,
          min: 5,
          max: 300,
        );

        _selectedIntention =
            EntryDraftTools.readString(decoded, 'selectedIntention');

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

        _selectedOutcome =
            EntryDraftTools.readString(decoded, 'selectedOutcome');

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
      'selectedExerciseType': _selectedExerciseType,
      'isOtherExerciseSelected': _isOtherExerciseSelected,
      'otherExercise': _otherExerciseCtrl.text.trim(),
      'durationMinutes': _durationMinutes,
      'selectedIntention': _selectedIntention,
      'intensityBefore': _intensityBefore,
      'emotionsBefore': _emotionsBefore,
      'thoughtBefore': _thoughtBeforeCtrl.text.trim(),
      'selectedOutcome': _selectedOutcome,
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
      sheetTitle: 'Data dell\'esercizio',
      accentColor: _stepAccent,
      softColor: _stepSoft,
      textDark: EntryFormColors.textDark,
      textMuted: EntryFormColors.textMuted,
    );

    if (!mounted || picked == null) return;

    setState(() => _dateTime = picked);
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

  Future<void> _addOtherExerciseDialog() async {
    final controller = TextEditingController(
      text: _otherExerciseCtrl.text.trim(),
    );

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFFFCF7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          title: const Text(
            'Altro esercizio',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: EntryFormColors.textDark,
            ),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Scrivi qui…',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: Colors.black.withValues(alpha: 0.10),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: _stepAccent.withValues(alpha: 0.70),
                  width: 1.4,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Annulla'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: _stepAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(ctx, controller.text),
              child: const Text('Aggiungi'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    final text = result?.trim();

    if (text != null && text.isNotEmpty) {
      setState(() {
        _isOtherExerciseSelected = true;
        _selectedExerciseType = null;
        _otherExerciseCtrl.text = text;
      });
    }
  }

  Future<void> _openExerciseTypeSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.72,
          minChildSize: 0.45,
          maxChildSize: 0.92,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
              decoration: const BoxDecoration(
                color: Color(0xFFFFFCF7),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: ListView(
                controller: scrollController,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(99),
                      ),
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
                          Icons.directions_run_rounded,
                          color: _stepAccent,
                          size: 25,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Tipo di esercizio',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: EntryFormColors.textDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Scegli il movimento che descrive meglio quello che hai fatto.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.35,
                      fontWeight: FontWeight.w500,
                      color: EntryFormColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 18),
                  ..._exerciseTypes.map((ex) {
                    final selected = !_isOtherExerciseSelected &&
                        _selectedExerciseType == ex.label;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _isOtherExerciseSelected = false;
                            _otherExerciseCtrl.clear();
                            _selectedExerciseType = ex.label;
                          });
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
                              Text(
                                ex.emoji,
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  ex.label,
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
                  const SizedBox(height: 6),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!mounted) return;
                        _addOtherExerciseDialog();
                      });
                    },
                    icon: Icon(
                      Icons.add_rounded,
                      color: _stepAccent,
                    ),
                    label: const Text('Altro esercizio'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: EntryFormColors.textDark,
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      side: BorderSide(
                        color: Colors.black.withValues(alpha: 0.10),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
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

  String? _buildLabeledEmojiValue(
      String? label,
      List<LabeledEmoji> options,
      ) {
    if (label == null) return null;

    final matches = options.where((e) => e.label == label);

    if (matches.isEmpty) return label;

    final match = matches.first;
    return '${match.emoji} ${match.label}';
  }

  String? _buildExerciseTypeValue() {
    if (_isOtherExerciseSelected) {
      final text = _otherExerciseCtrl.text.trim();
      return text.isEmpty ? null : text;
    }

    if (_selectedExerciseType == null) return null;

    return _buildLabeledEmojiValue(_selectedExerciseType, _exerciseTypes);
  }

  Future<void> _save() async {
    final exercise = Exercise(
      dateTime: _dateTime,
      exerciseType: _buildExerciseTypeValue(),
      durationMinutes: _durationMinutes,
      intention: _buildLabeledEmojiValue(_selectedIntention, _intentionOptions),
      emotionalIntensityBefore: _intensityBefore.round(),
      emotionBefore: buildEmotionStorageValue(_emotionsBefore),
      thoughtBefore: nullIfEmpty(_thoughtBeforeCtrl),
      outcome: _buildLabeledEmojiValue(_selectedOutcome, _outcomeOptions),
      bodySensationsAfter: nullIfEmpty(_bodyAfterCtrl),
      emotionalIntensityAfter: _intensityAfter.round(),
      emotionAfter: buildEmotionStorageValue(_emotionsAfter),
      thoughtAfter: nullIfEmpty(_thoughtAfterCtrl),
    );

    try {
      await DatabaseHelper.instance.insertExercise(exercise);
      await _clearDraft();
    } catch (e) {
      if (!mounted) return;
      showSaveError(context, e);
      return;
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  Widget _setupExerciseCard() {
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
            onTap: _openExerciseTypeSheet,
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
                    Icons.directions_run_rounded,
                    color: _stepAccent,
                    size: 27,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Text(
                    _exerciseDisplayName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color:
                      _selectedExerciseType == null && !_isOtherExerciseSelected
                          ? Colors.black.withValues(alpha: 0.45)
                          : Colors.black,
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
          const EntryCardDivider(),
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _stepSoft,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  Icons.timer_outlined,
                  color: _stepAccent,
                  size: 27,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  '$_durationMinutes min',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: EntryFormColors.textDark,
                  ),
                ),
              ),
              ExerciseDurationButton(
                key: const Key('exercise_duration_minus'),
                icon: Icons.remove_rounded,
                softColor: _stepSoft,
                accentColor: _stepAccent,
                onTap: () {
                  setState(() {
                    _durationMinutes = (_durationMinutes - 5).clamp(5, 300);
                  });
                },
              ),
              const SizedBox(width: 8),
              ExerciseDurationButton(
                key: const Key('exercise_duration_plus'),
                icon: Icons.add_rounded,
                softColor: _stepSoft,
                accentColor: _stepAccent,
                onTap: () {
                  setState(() {
                    _durationMinutes = (_durationMinutes + 5).clamp(5, 300);
                  });
                },
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _currentStepBody() {
    if (_currentStep == 0) return _beforeStep();
    if (_currentStep == 1) return _exerciseStep();
    return _afterStep();
  }

  Widget _beforeStep() {
    return EntryGuidedPanel(
      title: 'Prima dell’esercizio',
      subtitle: 'Osserva perché vuoi muoverti e come ti senti.',
      icon: Icons.self_improvement_rounded,
      accentColor: _stepAccent,
      softColor: _stepSoft,
      panelColor: _stepPanel,
      textDark: EntryFormColors.textDark,
      textMuted: EntryFormColors.textMuted,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const EntrySmallLabel('Intenzione'),
          const SizedBox(height: 10),

          for (final it in _intentionOptions)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ExerciseChoiceTile(
                label: it.label,
                emoji: it.emoji,
                selected: _selectedIntention == it.label,
                accentColor: _stepAccent,
                textDark: EntryFormColors.textDark,
                onTap: () {
                  setState(() => _selectedIntention = it.label);
                },
              ),
            ),

          const SizedBox(height: 12),

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

  Widget _exerciseStep() {
    return EntryGuidedPanel(
      title: 'Esercizio',
      subtitle: 'Registra il tipo di movimento e la durata.',
      icon: Icons.directions_run_rounded,
      accentColor: _stepAccent,
      softColor: _stepSoft,
      panelColor: _stepPanel,
      textDark: EntryFormColors.textDark,
      textMuted: EntryFormColors.textMuted,
      child: ExerciseInfoBox(
        icon: Icons.info_outline_rounded,
        text:
        'Scegli sopra il tipo di esercizio svolto e indica per quanto tempo ti sei mosso.',
        accentColor: _stepAccent,
        textMuted: EntryFormColors.textMuted,
      ),
    );
  }

  Widget _afterStep() {
    return EntryGuidedPanel(
      title: 'Dopo l’esercizio',
      subtitle: 'Osserva cosa è cambiato dopo il movimento.',
      icon: Icons.favorite_border_rounded,
      accentColor: _stepAccent,
      softColor: _stepSoft,
      panelColor: _stepPanel,
      textDark: EntryFormColors.textDark,
      textMuted: EntryFormColors.textMuted,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const EntrySmallLabel('Esito'),
          const SizedBox(height: 10),

          for (final o in _outcomeOptions)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ExerciseChoiceTile(
                label: o.label,
                emoji: o.emoji,
                selected: _selectedOutcome == o.label,
                accentColor: _stepAccent,
                textDark: EntryFormColors.textDark,
                onTap: () {
                  setState(() => _selectedOutcome = o.label);
                },
              ),
            ),

          const SizedBox(height: 12),

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
            hint: 'Che pensiero rimane dopo il movimento?',
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
                  Icons.directions_run_rounded,
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
                        title: 'Nuovo esercizio',
                        subtitle: 'Registra movimento, emozioni e sensazioni',
                        accentColor: _stepAccent,
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
                            label: 'Esercizio',
                            icon: Icons.directions_run_rounded,
                          ),
                          EntryStepData(
                            label: 'Dopo',
                            icon: Icons.favorite_border_rounded,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _setupExerciseCard(),
                      const SizedBox(height: 16),
                      EntrySuggestionCard(
                        suggestion: _currentStep == 2
                            ? _suggestionAfterExercise
                            : _suggestionBeforeExercise,
                        accentColor: _stepAccent,
                        softColor: _stepSoft,
                        textDark: EntryFormColors.textDark,
                        textMuted: EntryFormColors.textMuted,
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