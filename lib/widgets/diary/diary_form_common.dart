import 'package:flutter/material.dart';

import '../../utils/diary_formatters.dart';
import '../app_icon_mark.dart';
import '../common_buttons.dart';
import '../emotion_picker.dart';

class EntryFormColors {
  static const Color pageBg = Color(0xFFFCFAF5);

  static const Color textDark = Color(0xFF22312B);
  static const Color textMuted = Color(0xFF6A746E);

  static const Color orange = Color(0xFFF28A2E);
  static const Color orangeSoft = Color(0xFFFFF2E5);
  static const Color orangePanel = Color(0xFFF8D4B2);

  static const Color green = Color(0xFF5B9E4D);
  static const Color greenSoft = Color(0xFFF1F8EF);
  static const Color greenPanel = Color(0xFFDDEED7);

  static const Color blue = Color(0xFF5B9BD5);
  static const Color blueSoft = Color(0xFFF0F7FF);
  static const Color bluePanel = Color(0xFFD6E8F8);

  static const Color border = Color(0xFFF0E2C3);

  static Color accent(int step) {
    if (step == 0) return orange;
    if (step == 1) return green;
    return blue;
  }

  static Color soft(int step) {
    if (step == 0) return orangeSoft;
    if (step == 1) return greenSoft;
    return blueSoft;
  }

  static Color panel(int step) {
    if (step == 0) return orangePanel;
    if (step == 1) return greenPanel;
    return bluePanel;
  }
}

class EntryDraftTools {
  const EntryDraftTools._();

  static String? readString(Map<String, dynamic> data, String key) {
    final value = data[key];
    return value is String && value.trim().isNotEmpty ? value : null;
  }

  static int readInt(
      Map<String, dynamic> data,
      String key, {
        required int fallback,
        required int min,
        required int max,
      }) {
    final value = data[key];
    final intValue = value is num ? value.toInt() : fallback;

    if (intValue < min) return min;
    if (intValue > max) return max;
    return intValue;
  }

  static double readDouble(
      Map<String, dynamic> data,
      String key, {
        required double fallback,
        required double min,
        required double max,
      }) {
    final value = data[key];
    final doubleValue = value is num ? value.toDouble() : fallback;

    if (doubleValue < min) return min;
    if (doubleValue > max) return max;
    return doubleValue;
  }

  static int? timeToMinutes(TimeOfDay? time) {
    if (time == null) return null;
    return time.hour * 60 + time.minute;
  }

  static TimeOfDay? minutesToTime(dynamic value) {
    if (value is! num) return null;

    final minutes = value.toInt();

    if (minutes < 0 || minutes >= 24 * 60) return null;

    return TimeOfDay(
      hour: minutes ~/ 60,
      minute: minutes % 60,
    );
  }
}

class EntryDateTimePicker {
  const EntryDateTimePicker._();

  static Future<DateTime?> pick({
    required BuildContext context,
    required DateTime currentDateTime,
    required String sheetTitle,
    required Color accentColor,
    required Color softColor,
    required Color textDark,
    required Color textMuted,
  }) async {
    final date = await _pickDateInSheet(
      context: context,
      currentDateTime: currentDateTime,
      sheetTitle: sheetTitle,
      accentColor: accentColor,
      softColor: softColor,
      textDark: textDark,
      textMuted: textMuted,
    );

    if (date == null) return null;
    if (!context.mounted) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(currentDateTime),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: accentColor,
              onPrimary: Colors.white,
              surface: const Color(0xFFFFFCF7),
              onSurface: Colors.black87,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: const Color(0xFFFFFCF7),
              hourMinuteColor: softColor,
              hourMinuteTextColor: textDark,
              dialHandColor: accentColor,
              dialBackgroundColor: softColor,
              entryModeIconColor: accentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: accentColor,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (time == null) return null;

    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  static Future<DateTime?> _pickDateInSheet({
    required BuildContext context,
    required DateTime currentDateTime,
    required String sheetTitle,
    required Color accentColor,
    required Color softColor,
    required Color textDark,
    required Color textMuted,
  }) async {
    DateTime tempDate = currentDateTime;

    return showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              top: false,
              child: Container(
                margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 16),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFCF7),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(32),
                    bottom: Radius.circular(32),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 42,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: softColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.calendar_month_rounded,
                            color: accentColor,
                            size: 25,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            sheetTitle,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: textDark,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            Icons.close_rounded,
                            color: Colors.black.withValues(alpha: 0.55),
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: softColor,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: accentColor.withValues(alpha: 0.14),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.event_available_rounded,
                            color: accentColor,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              formatPrettyDate(tempDate),
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: textDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: accentColor,
                          onPrimary: Colors.white,
                          surface: const Color(0xFFFFFCF7),
                          onSurface: textDark,
                        ),
                        datePickerTheme: DatePickerThemeData(
                          backgroundColor: const Color(0xFFFFFCF7),
                          surfaceTintColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          dayStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                          weekdayStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: textMuted.withValues(alpha: 0.85),
                          ),
                          yearStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      child: CalendarDatePicker(
                        initialDate: tempDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                        onDateChanged: (date) {
                          setModalState(() => tempDate = date);
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 52,
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: textDark,
                                backgroundColor: Colors.white,
                                side: BorderSide(
                                  color: Colors.black.withValues(alpha: 0.10),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              child: const Text('Annulla'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(tempDate);
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: accentColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              child: const Text('Continua'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class EntryEmotionSheet {
  const EntryEmotionSheet._();

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String? selected,
    required Color accentColor,
    required Color softColor,
    required Color textDark,
    required Color textMuted,
    required ValueChanged<String?> onChanged,
  }) async {
    String subtitleForTitle(String title) {
      final lower = title.toLowerCase();

      if (lower.contains('prima')) {
        return 'Scegli l’emozione che senti più vicina prima.';
      }

      if (lower.contains('dopo')) {
        return 'Osserva cosa è cambiato dopo.';
      }

      return 'Scegli l’emozione che senti più vicina in questo momento.';
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.42),
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.72,
          minChildSize: 0.45,
          maxChildSize: 0.92,
          builder: (context, scrollController) {
            final bottomSafe = MediaQuery.of(context).padding.bottom;

            return SafeArea(
              top: false,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFCF7),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: 42,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 12, 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: softColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.mood_rounded,
                              color: accentColor,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 22,
                                    height: 1.12,
                                    fontWeight: FontWeight.w900,
                                    color: textDark,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  subtitleForTitle(title),
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    height: 1.35,
                                    fontWeight: FontWeight.w500,
                                    color: textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(sheetContext).pop(),
                            icon: Icon(
                              Icons.close_rounded,
                              color: Colors.black.withValues(alpha: 0.55),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: EdgeInsets.fromLTRB(
                          18,
                          4,
                          18,
                          bottomSafe + 38,
                        ),
                        children: [
                          EmotionPicker(
                            selected: selected,
                            selectedColor: accentColor.withValues(alpha: 0.16),
                            accentColor: accentColor,
                            softColor: softColor,
                            onChanged: (value) {
                              onChanged(value);
                              Navigator.of(sheetContext).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class EntryFormHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color accentColor;
  final double titleFontSize;
  final FontWeight titleFontWeight;

  const EntryFormHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    this.titleFontSize = 27,
    this.titleFontWeight = FontWeight.w900,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 44,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    size: 26,
                    color: Colors.black,
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(6, 0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Mi Ascolto',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                          color: accentColor,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(width: 2),
                      AppIconMark(
                        size: 40,
                        color: accentColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: titleFontSize,
            height: 1.1,
            fontWeight: titleFontWeight,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            height: 1.25,
            fontWeight: FontWeight.w500,
            color: EntryFormColors.textMuted,
          ),
        ),
      ],
    );
  }
}

class EntryStepData {
  final String label;
  final IconData icon;

  const EntryStepData({
    required this.label,
    required this.icon,
  });
}

class EntryFormStepper extends StatelessWidget {
  final int currentStep;
  final Color accentColor;
  final Color textMuted;
  final List<EntryStepData> steps;
  final ValueChanged<int> onStepTap;

  const EntryFormStepper({
    super.key,
    required this.currentStep,
    required this.accentColor,
    required this.textMuted,
    required this.steps,
    required this.onStepTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 8),
      child: Row(
        children: [
          for (int i = 0; i < steps.length; i++) ...[
            Expanded(
              child: _stepItem(
                index: i,
                label: steps[i].label,
                icon: steps[i].icon,
              ),
            ),
            if (i < steps.length - 1) _stepLine(i),
          ],
        ],
      ),
    );
  }

  Widget _stepLine(int beforeStep) {
    final active = currentStep > beforeStep;

    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: active
              ? accentColor.withValues(alpha: 0.55)
              : Colors.black.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(99),
        ),
      ),
    );
  }

  Widget _stepItem({
    required int index,
    required String label,
    required IconData icon,
  }) {
    final active = currentStep == index;
    final done = currentStep > index;

    final color = active || done
        ? accentColor
        : textMuted.withValues(alpha: 0.55);

    return GestureDetector(
      onTap: () => onStepTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? accentColor : const Color(0xFFF0ECE3),
              boxShadow: active
                  ? [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.24),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ]
                  : null,
            ),
            child: Center(
              child: done
                  ? const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 21,
              )
                  : active
                  ? Icon(
                icon,
                color: Colors.white,
                size: 21,
              )
                  : Icon(
                icon,
                color: color,
                size: 21,
              ),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: active ? FontWeight.w800 : FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class EntrySetupCard extends StatelessWidget {
  final DateTime dateTime;
  final Color accentColor;
  final Color softColor;
  final Color textDark;
  final VoidCallback onDateTap;
  final List<Widget> children;

  const EntrySetupCard({
    super.key,
    required this.dateTime,
    required this.accentColor,
    required this.softColor,
    required this.textDark,
    required this.onDateTap,
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.055),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            InkWell(
              onTap: onDateTap,
              borderRadius: BorderRadius.circular(24),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: softColor,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      Icons.calendar_month_rounded,
                      color: accentColor,
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Text(
                      formatDateTime(dateTime),
                      style: TextStyle(
                        fontSize: 18,
                        height: 1.15,
                        fontWeight: FontWeight.w800,
                        color: textDark,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 13,
                    ),
                    decoration: BoxDecoration(
                      color: softColor,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Text(
                      'Cambia',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: accentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}

class EntryCardDivider extends StatelessWidget {
  const EntryCardDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 18),
        Container(
          height: 1,
          color: Colors.black.withValues(alpha: 0.05),
        ),
        const SizedBox(height: 18),
      ],
    );
  }
}

class EntrySuggestionCard extends StatelessWidget {
  final String suggestion;
  final Color accentColor;
  final Color softColor;
  final Color textDark;
  final Color textMuted;
  final Color? borderColor;

  const EntrySuggestionCard({
    super.key,
    required this.suggestion,
    required this.accentColor,
    required this.softColor,
    required this.textDark,
    required this.textMuted,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: softColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: borderColor ?? accentColor.withValues(alpha: 0.16),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.13),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lightbulb_outline_rounded,
              color: accentColor,
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Suggerimento',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  suggestion,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                    color: textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EntryGuidedPanel extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final Color softColor;
  final Color panelColor;
  final Color textDark;
  final Color textMuted;
  final Widget child;

  const EntryGuidedPanel({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.softColor,
    required this.panelColor,
    required this.textDark,
    required this.textMuted,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: softColor,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.12),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            decoration: BoxDecoration(
              color: panelColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(26),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.42),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: textDark,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 22,
                          height: 1.08,
                          fontWeight: FontWeight.w900,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.25,
                          fontWeight: FontWeight.w600,
                          color: textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: child,
          ),
        ],
      ),
    );
  }
}

class EntrySmallLabel extends StatelessWidget {
  final String text;

  const EntrySmallLabel(
      this.text, {
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w900,
        color: EntryFormColors.textDark,
      ),
    );
  }
}

class EntrySoftTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final Color accentColor;

  const EntrySoftTextField({
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

class EntrySelectorTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final Color accentColor;
  final Color textDark;
  final VoidCallback onTap;

  const EntrySelectorTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.accentColor,
    required this.textDark,
    required this.onTap,
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
                  color: hasValue
                      ? textDark
                      : Colors.black.withValues(alpha: 0.46),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EntrySliderCard extends StatelessWidget {
  final String label;
  final double value;
  final Color accentColor;
  final Color textDark;
  final ValueChanged<double> onChanged;

  const EntrySliderCard({
    super.key,
    required this.label,
    required this.value,
    required this.accentColor,
    required this.textDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.70),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: textDark,
                  ),
                ),
              ),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    value.round().toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: accentColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: accentColor,
              inactiveTrackColor: accentColor.withValues(alpha: 0.16),
              thumbColor: accentColor,
              overlayColor: accentColor.withValues(alpha: 0.12),
            ),
            child: Slider(
              value: value,
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class EntryTimeBox extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;
  final bool hasError;

  const EntryTimeBox({
    super.key,
    required this.title,
    required this.value,
    required this.onTap,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: hasError
              ? const Color(0xFFFFE8E8)
              : Colors.white.withValues(alpha: 0.86),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: hasError ? Colors.red : Colors.black.withValues(alpha: 0.10),
            width: hasError ? 1.4 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: EntryFormColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: EntryFormColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EntryBottomControls extends StatelessWidget {
  final double horizontalPadding;
  final Color pageBg;
  final Color accentColor;
  final Color softColor;
  final Color textDark;
  final bool isFirstStep;
  final bool isLastStep;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onSaveDraft;

  const EntryBottomControls({
    super.key,
    required this.horizontalPadding,
    required this.pageBg,
    required this.accentColor,
    required this.softColor,
    required this.textDark,
    required this.isFirstStep,
    required this.isLastStep,
    required this.onBack,
    required this.onNext,
    required this.onSaveDraft,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        color: pageBg.withValues(alpha: 0.96),
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          10,
          horizontalPadding,
          12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 54,
                    child: isFirstStep
                        ? OutlinedButton(
                      onPressed: onBack,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textDark,
                        side: BorderSide(
                          color: Colors.black.withValues(alpha: 0.10),
                        ),
                        backgroundColor:
                        Colors.white.withValues(alpha: 0.72),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      child: const Text('Esci'),
                    )
                        : OutlinedButton.icon(
                      onPressed: onBack,
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 22,
                      ),
                      label: const Text('Indietro'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textDark,
                        side: BorderSide(
                          color: Colors.black.withValues(alpha: 0.10),
                        ),
                        backgroundColor:
                        Colors.white.withValues(alpha: 0.72),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: SizedBox(
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: onNext,
                      icon: Icon(
                        isLastStep
                            ? Icons.save_rounded
                            : Icons.arrow_forward_rounded,
                        size: 22,
                      ),
                      label: Text(isLastStep ? 'Salva' : 'Avanti'),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: TextButton.icon(
                onPressed: onSaveDraft,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Salva e continua dopo'),
                style: TextButton.styleFrom(
                  foregroundColor: accentColor,
                  backgroundColor: softColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: accentColor.withValues(alpha: 0.10),
                    ),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}