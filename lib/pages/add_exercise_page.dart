import 'package:flutter/material.dart';

import '../data/database_helper.dart';
import '../models/emotions.dart';
import '../models/exercise.dart';
import '../models/labeled_emoji.dart';
import '../models/mindfulness_suggestions.dart';
import '../styles.dart';
import '../widgets/common_buttons.dart';
import '../widgets/emotion_picker.dart';
import '../widgets/mindfulness_card.dart';

class AddExercisePage extends StatefulWidget {
  const AddExercisePage({super.key});

  @override
  State<AddExercisePage> createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  // ====== DATA FIELDS ======
  DateTime _dateTime = DateTime.now();

  // -- Esercizio (oggettivo) --
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

  // -- Intenzione (prima) --
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

  // -- Esito (dopo) --
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

  late String _suggestionBeforeExercise;
  late String _suggestionAfterExercise;

  // ====== UI COLORS ======
  static const Color _pageBg = Color(0xFFEFEFF7);
  static const Color _cardBlue = Color(0xFFD9E9FF); // ESERCIZIO
  static const Color _cardPeach = Color(0xFFF3DCCB); // INTENZIONE (prima)
  static const Color _cardGreen = Color(0xFFDFF1D7); // ESITO (dopo)

  // ====== LIFECYCLE ======
  @override
  void initState() {
    super.initState();
    _suggestionBeforeExercise = pickSuggestion(MindfulnessMoment.beforeExercise);
    _suggestionAfterExercise = pickSuggestion(MindfulnessMoment.afterExercise);
  }

  @override
  void dispose() {
    _otherExerciseCtrl.dispose();
    _thoughtBeforeCtrl.dispose();
    _bodyAfterCtrl.dispose();
    _thoughtAfterCtrl.dispose();
    super.dispose();
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

  Future<void> _addOtherExerciseDialog() async {
    final controller = TextEditingController(text: _otherExerciseCtrl.text.trim());
    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Altro esercizio'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Scrivi qui…',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Annulla'),
            ),
            ElevatedButton(
              onPressed: () {
                final text = controller.text.trim();
                if (text.isNotEmpty) {
                  setState(() {
                    _isOtherExerciseSelected = true;
                    _selectedExerciseType = null;
                    _otherExerciseCtrl.text = text;
                  });
                }
                Navigator.pop(ctx);
              },
              child: const Text('Aggiungi'),
            ),
          ],
        );
      },
    );
  }

  String? _buildLabeledEmojiValue(String? label, List<LabeledEmoji> options) {
    if (label == null) return null;
    final match = options.cast<LabeledEmoji?>().firstWhere(
          (e) => e!.label == label,
      orElse: () => null,
    );
    if (match == null) return label;
    return '${match.emoji} ${match.label}'; // single space
  }

  String? _buildExerciseTypeValue() {
    if (_isOtherExerciseSelected) {
      final text = _otherExerciseCtrl.text.trim();
      return text.isEmpty ? null : text; // custom — store as-is
    }
    if (_selectedExerciseType == null) return null;
    return _buildLabeledEmojiValue(_selectedExerciseType, _exerciseTypes);
  }

  void _save() async {
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
    } catch (e) {
      if (mounted) showSaveError(context, e);
      return;
    }
    if (mounted) Navigator.pop(context);
  }

  // ====== WIDGET BUILDERS ======
  Widget _card({
    required Color color,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(DS.radiusCard),
        boxShadow: const [DS.cardShadow],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DS.radiusCard),
        child: child,
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: DS.borderLight,
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline),
          const SizedBox(width: 10),
          Text(
            title,
            style: DS.sectionLabel,
          ),
        ],
      ),
    );
  }

  Widget _chipButton({
    required String label,
    required String emoji,
    required bool selected,
    required VoidCallback onTap,
    bool fullWidth = false,
  }) {
    final child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: selected ? DS.chipSelectedExercise : DS.surfaceWhite65,
        borderRadius: BorderRadius.circular(DS.radiusChip),
        border: Border.all(color: DS.borderLight),
      ),
      child: Row(
        mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Text(emoji, style: DS.emojiText),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: DS.chipLabel.copyWith(color: DS.textDark),
            ),
          ),
        ],
      ),
    );

    return InkWell(
      borderRadius: BorderRadius.circular(DS.radiusChip),
      onTap: onTap,
      child: child,
    );
  }

  Widget _titleH2(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: Text(
        text,
        style: DS.sectionLabel,
      ),
    );
  }

  Widget _titleH3(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: Text(
        text,
        style: DS.sectionLabel.copyWith(color: DS.textMuted),
      ),
    );
  }

  Widget _sliderBlock({
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Text('0', style: DS.sectionLabel),
          Expanded(
            child: Slider(
              value: value,
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: onChanged,
            ),
          ),
          const Text('10', style: DS.sectionLabel),
        ],
      ),
    );
  }

  Widget _textField({
    required String hint,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: DS.surfaceWhite65,
          borderRadius: BorderRadius.circular(DS.radiusCard),
          border: Border.all(color: DS.borderLight),
        ),
        child: TextField(
          controller: controller,
          maxLines: null,
          style: DS.bodyText,
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  // ====== SECTIONS ======
  Widget _dateTimeSection() {
    return _card(
      color: Colors.white.withOpacity(0.70),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data e ora: ${formatDateTime(_dateTime)}',
              style: DS.bodyText,
            ),
            const SizedBox(height: 14),
            ChangeDateTimeButton(onPressed: _pickDateTime),
          ],
        ),
      ),
    );
  }

  Widget _exerciseSection() {
    return _card(
      color: _cardBlue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionHeader('ESERCIZIO'),

          _titleH2('Tipo esercizio'),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final ex in _exerciseTypes)
                  SizedBox(
                    width: 240,
                    child: _chipButton(
                      label: ex.label,
                      emoji: ex.emoji,
                      selected: (!_isOtherExerciseSelected && _selectedExerciseType == ex.label),
                      onTap: () {
                        setState(() {
                          _isOtherExerciseSelected = false;
                          _otherExerciseCtrl.clear();
                          _selectedExerciseType = ex.label;
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: InkWell(
              borderRadius: BorderRadius.circular(DS.radiusChip),
              onTap: _addOtherExerciseDialog,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: DS.surfaceWhite65,
                  borderRadius: BorderRadius.circular(DS.radiusChip),
                  border: Border.all(color: DS.borderLight),
                ),
                child: Row(
                  children: [
                    const Text('+', style: DS.sectionLabel),
                    const SizedBox(width: 10),
                    Text(
                      'Altro esercizio',
                      style: DS.sectionLabel.copyWith(color: DS.textDark),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // mostra selezione altro esercizio (se presente)
          if (_isOtherExerciseSelected && _otherExerciseCtrl.text.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: _chipButton(
                label: _otherExerciseCtrl.text.trim(),
                emoji: '+',
                selected: true,
                onTap: () {
                  setState(() {
                    _isOtherExerciseSelected = false;
                    _otherExerciseCtrl.clear();
                  });
                },
                fullWidth: true,
              ),
            ),

          // Durata
          _titleH2('Durata'),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
            child: Row(
              children: [
                const SizedBox(width: 4),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: DS.surfaceWhite65,
                      borderRadius: BorderRadius.circular(DS.radiusChip),
                      border: Border.all(color: DS.borderLight),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _durationMinutes = (_durationMinutes - 5).clamp(5, 300);
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text('−', style: DS.controlButton),
                          ),
                        ),
                        Text(
                          '$_durationMinutes min',
                          style: DS.displayMedium,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _durationMinutes = (_durationMinutes + 5).clamp(5, 300);
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text('+', style: DS.controlButton),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _intentionSection() {
    return _card(
      color: _cardPeach,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionHeader('INTENZIONE (prima di\nallenarti)'),
          _titleH2('Perché sto facendo esercizio?'),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
            child: Column(
              children: [
                for (final it in _intentionOptions)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _chipButton(
                      label: it.label,
                      emoji: it.emoji,
                      selected: _selectedIntention == it.label,
                      onTap: () {
                        setState(() {
                          _selectedIntention = it.label;
                        });
                      },
                      fullWidth: true,
                    ),
                  ),
              ],
            ),
          ),
          _titleH3("Qual è l\u2019intensità emotiva? (prima)"),
          _sliderBlock(
            value: _intensityBefore,
            onChanged: (v) => setState(() => _intensityBefore = v),
          ),
          _titleH3('Quali emozioni sento? (prima)'),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
            child: EmotionPicker(
              selected: _emotionsBefore,
              selectedColor: DS.chipSelectedExercise,
              onChanged: (v) => setState(() => _emotionsBefore = v),
            ),
          ),
          _textField(
            hint: 'Quale pensiero ho? (prima)',
            controller: _thoughtBeforeCtrl,
          ),
        ],
      ),
    );
  }

  Widget _outcomeSection() {
    return _card(
      color: _cardGreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionHeader('ESITO (dopo l\'esercizio)'),
          _titleH2("Dopo l\u2019esercizio mi sento\u2026"),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
            child: Column(
              children: [
                for (final o in _outcomeOptions)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _chipButton(
                      label: o.label,
                      emoji: o.emoji,
                      selected: _selectedOutcome == o.label,
                      onTap: () => setState(() => _selectedOutcome = o.label),
                      fullWidth: true,
                    ),
                  ),
              ],
            ),
          ),
          _textField(
            hint: 'Quali sensazioni fisiche provo…',
            controller: _bodyAfterCtrl,
          ),
          _titleH3("Qual è l\u2019intensità emotiva? (dopo)"),
          _sliderBlock(
            value: _intensityAfter,
            onChanged: (v) => setState(() => _intensityAfter = v),
          ),
          _titleH3('Quali emozioni sento? (dopo)'),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
            child: EmotionPicker(
              selected: _emotionsAfter,
              selectedColor: DS.chipSelectedExercise,
              onChanged: (v) => setState(() => _emotionsAfter = v),
            ),
          ),
          _textField(
            hint: 'Quale pensiero ho? (dopo)',
            controller: _thoughtAfterCtrl,
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
      appBar: appAppBar('Nuovo esercizio'),
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
              constraints: BoxConstraints(maxWidth: 520),
              child: Column(
                children: [
                  _dateTimeSection(),
                  const SizedBox(height: 14),
                  _exerciseSection(),
                  const SizedBox(height: 14),
                  MindfulnessCard(suggestion: _suggestionBeforeExercise),
                  _intentionSection(),
                  const SizedBox(height: 14),
                  MindfulnessCard(suggestion: _suggestionAfterExercise),
                  _outcomeSection(),
                  const SizedBox(height: 14),
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
            child: SaveButton(
              onPressed: _save,
            ),
          ),
        ),
      ),
    );
  }
}
