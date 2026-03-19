import 'package:flutter/material.dart';
import '../services/timeline_store.dart';
import '../styles.dart';

class AddExercisePage extends StatefulWidget {
  const AddExercisePage({super.key});

  @override
  State<AddExercisePage> createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  DateTime _dateTime = DateTime.now();

  // ====== ESERCIZIO (oggettivo) ======
  final List<_LabeledEmoji> _exerciseTypes = const [
    _LabeledEmoji('Camminata', '🚶‍♂️'),
    _LabeledEmoji('Corsa / Running', '🏃'),
    _LabeledEmoji('Bici', '🚴'),
    _LabeledEmoji('Palestra / Pesi', '🏋️'),
    _LabeledEmoji('Stretching / Mobilità', '🧘'),
    _LabeledEmoji('Yoga / Pilates', '🧘‍♂️'),
    _LabeledEmoji('Nuoto', '🏊'),
    _LabeledEmoji('Trekking / Camminata lunga', '🥾'),
    _LabeledEmoji('Sport di squadra', '⚽'),
    _LabeledEmoji('Allenamento a casa', '🏠'),
  ];

  String? _selectedExerciseType;
  bool _isOtherExerciseSelected = false;
  final TextEditingController _otherExerciseCtrl = TextEditingController();

  int _durationMinutes = 20;

  // ====== INTENZIONE (prima) ======
  final List<_LabeledEmoji> _intentionOptions = const [
    _LabeledEmoji('Benessere / Energia', '✅'),
    _LabeledEmoji('Gestire emozioni / Stress', '🧠'),
    _LabeledEmoji('Bruciare / Rimediare al cibo', '⚠️'),
    _LabeledEmoji('Controllo / Punizione', '❗'),
  ];
  String? _selectedIntention;

  double _intensityBefore = 0;

  // ====== EMOZIONI (uguali al pasto) ======
  final List<_EmotionItem> _baseEmotions = const [
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
  ];

  final Set<String> _emotionsBefore = <String>{};
  final Set<String> _emotionsAfter = <String>{};

  final TextEditingController _thoughtBeforeCtrl = TextEditingController();

  // ====== ESITO (dopo) ======
  final List<_LabeledEmoji> _outcomeOptions = const [
    _LabeledEmoji('Più libero / leggero', '✅'),
    _LabeledEmoji('Uguale', '😐'),
    _LabeledEmoji('Più in colpa / più rigido', '⚠️'),
    _LabeledEmoji('Peggio (ansia, urgenza,\nOvalutore del controllo)', '❗'),
  ];
  String? _selectedOutcome;

  final TextEditingController _physicalAfterCtrl = TextEditingController();
  double _intensityAfter = 0;
  final TextEditingController _thoughtAfterCtrl = TextEditingController();

  // ====== UI COLORS (page-specific) ======
  static const Color _pageBg = Color(0xFFEFEFF7);

  static const Color _cardBlue = Color(0xFFD9E9FF); // ESERCIZIO
  static const Color _cardPeach = Color(0xFFF3DCCB); // INTENZIONE (prima)
  static const Color _cardGreen = Color(0xFFDFF1D7); // ESITO (dopo)

  static const Color _saveGreen = Color(0xFFDFF1D7);

  // ====== HELPERS ======
  String _two(int n) => n.toString().padLeft(2, '0');

  String _formatDateTime(DateTime dt) {
    return '${_two(dt.day)}/${_two(dt.month)}/${dt.year}  ${_two(dt.hour)}:${_two(dt.minute)}';
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dateTime),
    );
    if (time == null || !mounted) return;

    setState(() {
      _dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
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

  Future<void> _addCustomEmotionDialog({required bool isBefore}) async {
    final controller = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Altra emozione'),
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
                    if (isBefore) {
                      _emotionsBefore.add(text);
                    } else {
                      _emotionsAfter.add(text);
                    }
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

  // ====== WIDGETS ======
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

  Widget _slider01({
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

  Widget _inputFill({
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

  Widget _emotionsRow(Set<String> selected, {required bool isBefore}) {
    final chips = <Widget>[];

    for (final e in _baseEmotions) {
      chips.add(_emotionChip(
        label: e.label,
        emoji: e.emoji,
        selected: selected.contains(e.label),
        onTap: () {
          setState(() {
            if (selected.contains(e.label)) {
              selected.remove(e.label);
            } else {
              selected.add(e.label);
            }
          });
        },
      ));
    }

    // Aggiunte custom (se presenti)
    for (final s in selected.where((x) => !_baseEmotions.any((b) => b.label == x)).toList()) {
      chips.add(_emotionChip(
        label: s,
        emoji: '•',
        selected: true,
        onTap: () {
          setState(() => selected.remove(s));
        },
      ));
    }

    chips.add(_emotionAddChip(
      onTap: () => _addCustomEmotionDialog(isBefore: isBefore),
    ));

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: chips,
      ),
    );
  }

  Widget _emotionChip({
    required String label,
    required String emoji,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(DS.radiusChip),
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minWidth: 140),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? DS.chipSelectedExercise : DS.surfaceWhite65,
          borderRadius: BorderRadius.circular(DS.radiusChip),
          border: Border.all(color: DS.borderLight),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: DS.emojiText),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: DS.chipLabel.copyWith(color: DS.textDark),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emotionAddChip({required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(DS.radiusChip),
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minWidth: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: DS.surfaceWhite65,
          borderRadius: BorderRadius.circular(DS.radiusChip),
          border: Border.all(color: DS.borderLight),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('+', style: DS.sectionLabel),
            const SizedBox(width: 10),
            Text(
              'Altra emozione',
              style: DS.sectionLabel.copyWith(color: DS.textDark),
            ),
          ],
        ),
      ),
    );
  }

  // ====== SAVE (scrive in TIMELINE) ======
  Future<void> _save() async {
    // 1) Tipo esercizio scelto
    final String type = _isOtherExerciseSelected ? _otherExerciseCtrl.text.trim() : (_selectedExerciseType ?? '');

    // 2) Creo result (utile anche se vuoi usare Navigator.pop)
    final Map<String, dynamic> result = {
      'dateTime': _dateTime.toIso8601String(),

      // Dati base esercizio
      'tipoEsercizio': type,
      'durataMinuti': _durationMinutes,

      // PRIMA
      'intenzione': _selectedIntention ?? '',
      'intensitaPrima': _intensityBefore.round(),
      'emozioniPrima': _emotionsBefore.toList(),
      'pensieroPrima': _thoughtBeforeCtrl.text.trim(),

      // DOPO
      'esito': _selectedOutcome ?? '',
      'sensazioniFisicheDopo': _physicalAfterCtrl.text.trim(),
      'intensitaDopo': _intensityAfter.round(),
      'emozioniDopo': _emotionsAfter.toList(),
      'pensieroDopo': _thoughtAfterCtrl.text.trim(),
    };

    // 3) Scrivo nella TIMELINE (formato Map come il tuo TimelineStore)
    //    Metto anche campi "tipo/categoria" per aiutare export futuro.
    await TimelineStore.instance.addEntry({
      'dateTime': result['dateTime'],
      'type': 'Esercizio',
      'category': type,
      // duplicati comodi per export/pick
      'Intenzione': result['intenzione'],
      'Emozioni': {
        'prima': result['emozioniPrima'],
        'dopo': result['emozioniDopo'],
      },
      'Intensità': {
        'prima': result['intensitaPrima'],
        'dopo': result['intensitaDopo'],
      },
      'Pensiero': {
        'prima': result['pensieroPrima'],
        'dopo': result['pensieroDopo'],
      },
      'Esito': result['esito'],
      'Sensazioni': result['sensazioniFisicheDopo'],
      'DurataMinuti': result['durataMinuti'],
      'data': result, // salvo tutto anche qui (completo)
    });

    if (!mounted) return;
    Navigator.pop(context, result);
  }

  @override
  void dispose() {
    _otherExerciseCtrl.dispose();
    _thoughtBeforeCtrl.dispose();
    _physicalAfterCtrl.dispose();
    _thoughtAfterCtrl.dispose();
    super.dispose();
  }

  // ====== UI ======
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      appBar: AppBar(
        title: const Text('Nuovo esercizio'),
        backgroundColor: Colors.white,
        elevation: 0.6,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 28),
        child: Column(
          children: [
            const SizedBox(height: 14),

            // ===== DATA/ORA card =====
            _card(
              color: Colors.white.withOpacity(0.70),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data e ora: ${_formatDateTime(_dateTime)}',
                      style: DS.bodyText,
                    ),
                    const SizedBox(height: 14),
                    Center(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: _pickDateTime,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                          decoration: BoxDecoration(
                            color: DS.surfaceWhite65,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: DS.borderLight),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.calendar_month, size: 26),
                              const SizedBox(width: 10),
                              Text(
                                'Cambia data/ora',
                                style: DS.bodyTextBold.copyWith(color: Colors.teal.shade700),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ===== ESERCIZIO card =====
            _card(
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
            ),

            // ===== INTENZIONE (prima) card =====
            _card(
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
                  _slider01(
                    value: _intensityBefore,
                    onChanged: (v) => setState(() => _intensityBefore = v),
                  ),
                  _titleH3('Quali emozioni sento? (prima)'),
                  _emotionsRow(_emotionsBefore, isBefore: true),
                  _inputFill(
                    hint: 'Quale pensiero ho? (prima)',
                    controller: _thoughtBeforeCtrl,
                  ),
                ],
              ),
            ),

            // ===== ESITO (dopo) card =====
            _card(
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
                  _inputFill(
                    hint: 'Quali sensazioni fisiche provo…',
                    controller: _physicalAfterCtrl,
                  ),
                  _titleH3("Qual è l\u2019intensità emotiva? (dopo)"),
                  _slider01(
                    value: _intensityAfter,
                    onChanged: (v) => setState(() => _intensityAfter = v),
                  ),
                  _titleH3('Quali emozioni sento? (dopo)'),
                  _emotionsRow(_emotionsAfter, isBefore: false),
                  _inputFill(
                    hint: 'Quale pensiero ho? (dopo)',
                    controller: _thoughtAfterCtrl,
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: _save,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 18),
                        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                        decoration: BoxDecoration(
                          color: _saveGreen,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: const [DS.cardShadow],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.save, color: DS.accentDark),
                            const SizedBox(width: 12),
                            Text(
                              'Salva',
                              style: DS.buttonPrimary.copyWith(color: Colors.teal.shade800),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

// ======= MODELS =======
class _LabeledEmoji {
  final String label;
  final String emoji;
  const _LabeledEmoji(this.label, this.emoji);
}

class _EmotionItem {
  final String label;
  final String emoji;
  const _EmotionItem(this.label, this.emoji);
}
