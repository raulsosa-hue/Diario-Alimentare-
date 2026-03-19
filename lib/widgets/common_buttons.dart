import 'package:flutter/material.dart';
import '../styles.dart';

/// Full-width save button used on form pages (meal, exercise).
class SaveButton extends StatelessWidget {
  final VoidCallback onPressed;
  const SaveButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.save),
        label: const Text('Salva', style: DS.buttonPrimary),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DS.radiusCard),
          ),
        ),
      ),
    );
  }
}

/// Pill-shaped "Cambia data/ora" button used on form pages.
class ChangeDateTimeButton extends StatelessWidget {
  final VoidCallback onPressed;
  const ChangeDateTimeButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onPressed,
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
    );
  }
}
