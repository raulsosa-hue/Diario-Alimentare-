import 'package:flutter/material.dart';

class ExerciseInfoBox extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color accentColor;
  final Color textMuted;

  const ExerciseInfoBox({
    super.key,
    required this.icon,
    required this.text,
    required this.accentColor,
    required this.textMuted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.76),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: accentColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                height: 1.35,
                fontWeight: FontWeight.w600,
                color: textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
