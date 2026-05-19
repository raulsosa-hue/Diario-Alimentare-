import 'package:flutter/material.dart';

class ExerciseSelectorTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final VoidCallback onTap;
  final Color accentColor;
  final Color textDark;

  const ExerciseSelectorTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
    required this.accentColor,
    required this.textDark,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.trim().isNotEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.86),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.10),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: accentColor,
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                hasValue ? value! : title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                  color: hasValue ? textDark : Colors.black.withValues(alpha: 0.46),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
