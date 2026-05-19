import 'package:flutter/material.dart';

class ExerciseChoiceTile extends StatelessWidget {
  final String label;
  final String emoji;
  final bool selected;
  final VoidCallback onTap;
  final Color accentColor;
  final Color textDark;

  const ExerciseChoiceTile({
    super.key,
    required this.label,
    required this.emoji,
    required this.selected,
    required this.onTap,
    required this.accentColor,
    required this.textDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.white.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? accentColor.withValues(alpha: 0.65) : Colors.black.withValues(alpha: 0.08),
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 23),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                  color: textDark,
                ),
              ),
            ),
            if (selected)
              Icon(
                Icons.check_circle_rounded,
                color: accentColor,
                size: 23,
              ),
          ],
        ),
      ),
    );
  }
}
