import 'package:flutter/material.dart';

import '../styles.dart';

/// Zero-pads an integer to two digits, e.g. 5 → "05".
String twoDigit(int n) => n.toString().padLeft(2, '0');

/// Trims a [TextEditingController]'s text, returning `null` when empty.
String? nullIfEmpty(TextEditingController ctrl) {
  final text = ctrl.text.trim();
  return text.isEmpty ? null : text;
}

/// Shows a floating error SnackBar for a failed save operation.
void showSaveError(BuildContext context, Object error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Errore nel salvataggio: $error'),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

/// Formats a [DateTime] as "dd/MM/yyyy  HH:mm" for display.
String formatDateTime(DateTime dt) {
  return '${twoDigit(dt.day)}/${twoDigit(dt.month)}/${dt.year}\n${twoDigit(dt.hour)}:${twoDigit(dt.minute)}';
}

/// Shared AppBar style used across all pages.
AppBar appAppBar(String title, {TextStyle? titleStyle}) {
  return AppBar(
    title: Text(title, style: titleStyle),
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    elevation: 0.5,
  );
}

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
