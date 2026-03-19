import 'package:flutter/material.dart';
import '../styles.dart';

class MindfulnessCard extends StatelessWidget {
  final String suggestion;

  const MindfulnessCard({super.key, required this.suggestion});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFAEDD8),
        borderRadius: BorderRadius.circular(DS.radiusCard),
        boxShadow: const [DS.cardShadow],
        border: Border.all(color: DS.borderSubtle),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFE8A54B),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb_outline,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: DS.bodyText.copyWith(
                  color: DS.textPrimary,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                ),
                children: [
                  TextSpan(
                    text: 'Suggerimento: ',
                    style: DS.bodyText.copyWith(
                      fontWeight: FontWeight.w800,
                      color: DS.textPrimary,
                      height: 1.35,
                    ),
                  ),
                  TextSpan(text: suggestion),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
