import 'package:flutter/material.dart';
import '../models/emotions.dart';
import '../styles.dart';

class EmotionPicker extends StatefulWidget {
  const EmotionPicker({
    super.key,
    required this.selected,
    required this.onChanged,
    this.selectedColor = DS.chipSelectedMeal,
    this.accentColor = DS.textPrimary,
    this.softColor = Colors.white,
    this.title,
  });

  final String? selected;
  final ValueChanged<String?> onChanged;
  final Color selectedColor;
  final Color accentColor;
  final Color softColor;
  final String? title;

  @override
  State<EmotionPicker> createState() => _EmotionPickerState();
}

class _EmotionPickerState extends State<EmotionPicker> {
  static const Map<String, List<String>> _sections = {
    'Piacevoli': [
      'Gioia',
      'Orgoglio',
    ],

    'Affettive profonde': [
      "Fame d'amore",
      'Vuoto',
      'Nostalgia',
    ],

    'Difficili': [
      'Tristezza',
      'Rabbia',
      'Paura',
      'Ansia',
      'Disgusto',
      'Frustrazione',
      'Solitudine',
    ],

    'Miste o neutre': [
      'Sorpresa',
      'Imbarazzo / Vergogna',
      'Invidia / Gelosia',
      'Colpa / Rimorso',
      'Apatia',
    ],
  };

  void _toggle(String label) {
    if (widget.selected == label) {
      widget.onChanged(null);
    } else {
      widget.onChanged(label);
    }
  }

  Future<void> _addCustom() async {
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFFFFCF7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
        title: const Text(
          'Altra emozione',
          style: TextStyle(
            fontWeight: FontWeight.w900,
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
                color: Colors.black.withOpacity(0.10),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: widget.accentColor.withOpacity(0.70),
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
              backgroundColor: widget.accentColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('Aggiungi'),
          ),
        ],
      ),
    );

    if (!mounted) {
      controller.dispose();
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => controller.dispose());

    final text = result?.trim();
    if (text != null && text.isNotEmpty) {
      widget.onChanged(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final allSectionLabels = _sections.values.expand((e) => e).toSet();

    final otherEmotions = kEmotions
        .where((e) => !allSectionLabels.contains(e.label))
        .toList(growable: false);

    final isCustom = widget.selected != null &&
        !kEmotions.any((e) => e.label == widget.selected);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.82),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: Colors.black.withOpacity(0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null) ...[
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: widget.softColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    Icons.mood_rounded,
                    color: widget.accentColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.title!,
                    style: const TextStyle(
                      fontSize: 21,
                      height: 1.1,
                      fontWeight: FontWeight.w900,
                      color: DS.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Scegli l’emozione che senti più vicina in questo momento.',
              style: TextStyle(
                fontSize: 14.5,
                height: 1.35,
                fontWeight: FontWeight.w500,
                color: DS.textPrimary.withOpacity(0.70),
              ),
            ),
            const SizedBox(height: 18),
          ],

          for (final entry in _sections.entries) ...[
            _emotionSection(
              title: entry.key,
              labels: entry.value,
            ),
            const SizedBox(height: 18),
          ],

          if (otherEmotions.isNotEmpty) ...[
            _sectionTitle('Altre'),
            const SizedBox(height: 10),
            Wrap(
              spacing: DS.chipWrapSpacing,
              runSpacing: DS.chipWrapRunSpacing,
              children: [
                for (final e in otherEmotions)
                  _emotionChip(
                    label: e.label,
                    emoji: e.emoji,
                  ),
              ],
            ),
            const SizedBox(height: 18),
          ],

          if (isCustom) ...[
            _sectionTitle('Personalizzata'),
            const SizedBox(height: 10),
            _emotionChip(
              label: widget.selected!,
              emoji: '•',
            ),
            const SizedBox(height: 18),
          ],

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _addCustom,
                  icon: Icon(
                    Icons.add_rounded,
                    color: widget.accentColor,
                    size: 22,
                  ),
                  label: const Text('Altra emozione'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    foregroundColor: DS.textPrimary,
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: Colors.black.withOpacity(0.10),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(DS.radiusPill),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 50,
                width: 54,
                child: OutlinedButton(
                  onPressed: widget.selected == null
                      ? null
                      : () => widget.onChanged(null),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.white,
                    disabledForegroundColor: Colors.black.withOpacity(0.18),
                    side: BorderSide(
                      color: Colors.black.withOpacity(0.10),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(DS.radiusPill),
                    ),
                  ),
                  child: const Icon(Icons.close_rounded),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emotionSection({
    required String title,
    required List<String> labels,
  }) {
    final emotions = kEmotions
        .where((e) => labels.contains(e.label))
        .toList(growable: false);

    if (emotions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(title),
        const SizedBox(height: 10),
        Wrap(
          spacing: DS.chipWrapSpacing,
          runSpacing: DS.chipWrapRunSpacing,
          children: [
            for (final e in emotions)
              _emotionChip(
                label: e.label,
                emoji: e.emoji,
              ),
          ],
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w900,
        color: DS.textPrimary.withOpacity(0.92),
      ),
    );
  }

  Widget _emotionChip({
    required String label,
    required String emoji,
  }) {
    final selected = widget.selected == label;

    return FilterChip(
      label: Text(
        '$emoji  $label',
        style: TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.w800,
          color: selected ? DS.textPrimary : Colors.black87,
        ),
      ),
      selected: selected,
      onSelected: (_) => _toggle(label),
      showCheckmark: false,
      selectedColor: widget.selectedColor,
      backgroundColor: Colors.white,
      side: BorderSide(
        color: selected
            ? widget.accentColor.withOpacity(0.55)
            : Colors.black.withOpacity(0.13),
        width: selected ? 1.4 : 1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DS.radiusPill),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 9,
      ),
    );
  }
}
