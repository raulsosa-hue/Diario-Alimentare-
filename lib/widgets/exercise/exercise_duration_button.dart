import 'package:flutter/material.dart';

class ExerciseDurationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color softColor;
  final Color accentColor;

  const ExerciseDurationButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.softColor,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: softColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Icon(
          icon,
          color: accentColor,
          size: 25,
        ),
      ),
    );
  }
}
