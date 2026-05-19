import 'package:flutter/material.dart';

class ExerciseSoftTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final Color accentColor;

  const ExerciseSoftTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: 1,
      maxLines: 3,
      style: const TextStyle(
        fontSize: 15.5,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 15.5,
          fontWeight: FontWeight.w700,
          color: Colors.black.withValues(alpha: 0.42),
        ),
        prefixIcon: Icon(
          icon,
          color: accentColor,
          size: 22,
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.86),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Colors.black.withValues(alpha: 0.10),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Colors.black.withValues(alpha: 0.10),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: accentColor.withValues(alpha: 0.75),
            width: 1.4,
          ),
        ),
      ),
    );
  }
}
