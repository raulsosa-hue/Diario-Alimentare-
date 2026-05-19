import 'package:flutter/material.dart';

import '../../repository/diary_repository.dart';
import '../../utils/diary_formatters.dart';
import 'diary_compact_event_card.dart';

class WeekExpansionCard extends StatefulWidget {
  final DiaryWeekGroup group;
  final bool initiallyExpanded;
  final bool isSharing;
  final VoidCallback onShare;
  final ValueChanged<DiaryEntry> onEntryTap;

  const WeekExpansionCard({
    super.key,
    required this.group,
    required this.initiallyExpanded,
    required this.isSharing,
    required this.onShare,
    required this.onEntryTap,
  });

  @override
  State<WeekExpansionCard> createState() => _WeekExpansionCardState();
}

class _WeekExpansionCardState extends State<WeekExpansionCard> {
  late bool _expanded;
  final Set<int> _expandedDays = {};

  static const Color _textDark = Color(0xFF22312B);
  static const Color _textMuted = Color(0xFF6A746E);

  static const Color _green = Color(0xFF5B9E4D);
  static const Color _greenDark = Color(0xFF173D2C);
  static const Color _greenSoft = Color(0xFFF1F8EF);

  static const Color _cream = Color(0xFFFFF9F1);
  static const Color _creamBorder = Color(0xFFF0E2C3);

  @override
  void initState() {
    super.initState();

    _expanded = widget.initiallyExpanded;

    if (_expanded && widget.group.days.isNotEmpty) {
      _expandedDays.add(0);
    }
  }

  int get _eventsCount {
    return widget.group.days.fold<int>(
      0,
      (sum, day) => sum + day.entries.length,
    );
  }

  void _toggleWeek() {
    setState(() {
      _expanded = !_expanded;

      if (_expanded && _expandedDays.isEmpty && widget.group.days.isNotEmpty) {
        _expandedDays.add(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final monday = widget.group.monday;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.9),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.055),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Column(
          children: [
            InkWell(
              onTap: _toggleWeek,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 18, 18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SETTIMANA ${isoWeekNumber(monday)}',
                            style: const TextStyle(
                              fontSize: 22,
                              height: 1.05,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.3,
                              color: _greenDark,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${formatDiaryWeekRange(monday)} · '
                            '${widget.group.days.length} ${diaryPlural(widget.group.days.length, 'giorno', 'giorni')} · '
                            '$_eventsCount ${diaryPlural(_eventsCount, 'evento', 'eventi')}',
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.3,
                              fontWeight: FontWeight.w700,
                              color: _textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    _roundIconButton(
                      icon: Icons.ios_share_rounded,
                      isLoading: widget.isSharing,
                      onTap: widget.onShare,
                    ),
                    const SizedBox(width: 8),
                    _roundIconButton(
                      icon: _expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                      onTap: _toggleWeek,
                    ),
                  ],
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              child: _expanded
                  ? Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
                child: Column(
                  children: [
                    for (int i = 0; i < widget.group.days.length; i++) ...[
                      _dayCard(i),
                      if (i != widget.group.days.length - 1)
                        const SizedBox(height: 10),
                    ],
                  ],
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dayCard(int index) {
    final day = widget.group.days[index];
    final isOpen = _expandedDays.contains(index);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      width: double.infinity,
      decoration: BoxDecoration(
        color: _cream,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: _creamBorder.withValues(alpha: 0.65),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(26),
            onTap: () {
              setState(() {
                if (isOpen) {
                  _expandedDays.remove(index);
                } else {
                  _expandedDays.add(index);
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 17, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatDiaryFullDay(day.day),
                          style: const TextStyle(
                            fontSize: 21,
                            height: 1.1,
                            fontWeight: FontWeight.w900,
                            color: _textDark,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          diaryEventCountLabel(day.entries.length),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: _textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isOpen ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: _green,
                    size: 32,
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            child: isOpen
                ? Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                children: [
                  for (int i = 0; i < day.entries.length; i++) ...[
                    DiaryCompactEventCard(
                      entry: day.entries[i],
                      onTap: () => widget.onEntryTap(day.entries[i]),
                    ),
                    if (i != day.entries.length - 1)
                      const SizedBox(height: 10),
                  ],
                ],
              ),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _roundIconButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isLoading = false,
  }) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: _greenSoft,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 19,
                  height: 19,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: _green,
                  ),
                )
              : Icon(
                  icon,
                  color: _green,
                  size: 25,
                ),
        ),
      ),
    );
  }
}
