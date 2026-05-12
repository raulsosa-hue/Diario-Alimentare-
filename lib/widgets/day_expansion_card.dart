import 'package:flutter/material.dart';

import '../repository/diary_repository.dart';
import 'diary_compact_event_card.dart';
import '../utils/diary_formatters.dart';

class DayExpansionCard extends StatefulWidget {
  final DiaryDayGroup dayGroup;
  final bool initiallyExpanded;
  final ValueChanged<DiaryEntry> onEntryTap;

  const DayExpansionCard({
    super.key,
    required this.dayGroup,
    required this.initiallyExpanded,
    required this.onEntryTap,
  });

  @override
  State<DayExpansionCard> createState() => _DayExpansionCardState();
}

class _DayExpansionCardState extends State<DayExpansionCard> {
  late bool _expanded;

  static const Color _textDark = Color(0xFF22312B);
  static const Color _textMuted = Color(0xFF6A746E);

  static const Color _green = Color(0xFF5B9E4D);
  static const Color _greenSoft = Color(0xFFF1F8EF);

  static const Color _cream = Color(0xFFFFF9F1);
  static const Color _creamBorder = Color(0xFFF0E2C3);

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final day = widget.dayGroup.day;
    final entries = widget.dayGroup.entries;
    final eventsCount = entries.length;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      width: double.infinity,
      decoration: BoxDecoration(
        color: _cream,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: _creamBorder.withOpacity(0.75),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Column(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() => _expanded = !_expanded);
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 15, 14, 15),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _greenSoft,
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: _green,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              formatDiaryFullDay(day),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 20,
                                height: 1.1,
                                fontWeight: FontWeight.w900,
                                color: _textDark,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              diaryEventCountLabel(eventsCount),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: _textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),

                      AnimatedRotation(
                        duration: const Duration(milliseconds: 180),
                        turns: _expanded ? 0.5 : 0,
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: _green,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            AnimatedCrossFade(
              duration: const Duration(milliseconds: 220),
              sizeCurve: Curves.easeOutCubic,
              firstCurve: Curves.easeOut,
              secondCurve: Curves.easeOut,
              crossFadeState: _expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
                child: Column(
                  children: [
                    for (int i = 0; i < entries.length; i++) ...[
                      DiaryCompactEventCard(
                        entry: entries[i],
                        onTap: () => widget.onEntryTap(entries[i]),
                      ),
                      if (i != entries.length - 1)
                        const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}