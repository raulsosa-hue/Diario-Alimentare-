import 'package:flutter/material.dart';

import '../services/mindfulness_notification_service.dart';
import 'mindfulness_reminder_switch.dart';

class MindfulnessReminderButton extends StatefulWidget {
  const MindfulnessReminderButton({super.key});

  @override
  State<MindfulnessReminderButton> createState() =>
      _MindfulnessReminderButtonState();
}

class _MindfulnessReminderButtonState extends State<MindfulnessReminderButton> {
  bool _enabled = false;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final enabled =
    await MindfulnessNotificationService.instance.areNotificationsEnabled();

    if (!mounted) return;

    setState(() {
      _enabled = enabled;
    });
  }

  Future<void> _openReminderSettings() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return const SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: MindfulnessReminderSwitch(),
          ),
        );
      },
    );

    await _loadState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _openReminderSettings,
      tooltip: 'Promemoria',
      icon: Icon(
        _enabled ? Icons.notifications_active : Icons.notifications_none,
        color: const Color(0xFF2F7D46),
        size: 28,
      ),
    );
  }
}