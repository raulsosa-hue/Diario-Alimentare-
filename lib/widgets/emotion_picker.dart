import 'package:flutter/material.dart';
import '../models/emotions.dart';
import '../styles.dart';

class EmotionPicker extends StatefulWidget {
  const EmotionPicker({
    super.key,
    required this.selected,
    required this.onChanged,
    this.selectedColor = DS.chipSelectedMeal,
    this.title,
  });

  final String? selected;
  final ValueChanged<String?> onChanged;
  final Color selectedColor;
  final String? title;

  @override
  State<EmotionPicker> createState() => _EmotionPickerState();
}

class _EmotionPickerState extends State<EmotionPicker> {
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
        title: const Text('Altra emozione'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Scrivi qui\u2026'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annulla'),
          ),
          FilledButton(
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

    // Dispose after the framework finishes tearing down the dialog.
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.dispose());

    final text = result?.trim();
    if (text != null && text.isNotEmpty) {
      widget.onChanged(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCustom = widget.selected != null && !kEmotions.any((e) => e.label == widget.selected);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: DS.surfaceWhite35,
        borderRadius: BorderRadius.circular(DS.radiusField),
        border: Border.all(color: DS.borderFaint),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null) ...[
            Text(widget.title!, style: DS.sectionLabel.copyWith(color: DS.textPrimary)),
            const SizedBox(height: 10),
          ],
          Wrap(
            spacing: DS.chipWrapSpacing,
            runSpacing: DS.chipWrapRunSpacing,
            children: [
              for (final e in kEmotions)
                FilterChip(
                  label: Text('${e.emoji}  ${e.label}', style: DS.filterChipLabel),
                  selected: widget.selected == e.label,
                  onSelected: (_) => _toggle(e.label),
                  showCheckmark: false,
                  selectedColor: widget.selectedColor,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DS.radiusPill),
                    side: BorderSide(
                      color: widget.selected == e.label ? DS.borderEmphasis : DS.borderLight,
                    ),
                  ),
                ),
              if (isCustom)
                FilterChip(
                  label: Text('\u2022  ${widget.selected}', style: DS.filterChipLabel),
                  selected: true,
                  onSelected: (_) => _toggle(widget.selected!),
                  showCheckmark: false,
                  selectedColor: widget.selectedColor,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DS.radiusPill),
                    side: const BorderSide(color: DS.borderEmphasis),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _addCustom,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DS.radiusPill),
                ),
                side: const BorderSide(color: DS.borderLight),
                backgroundColor: Colors.white,
              ),
              child: Text(
                'Altra emozione',
                style: DS.sectionLabel.copyWith(color: DS.textPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
