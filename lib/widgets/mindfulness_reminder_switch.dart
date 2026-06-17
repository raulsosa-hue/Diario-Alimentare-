import 'package:flutter/material.dart';

import '../services/mindfulness_notification_service.dart';

class MindfulnessReminderSwitch extends StatefulWidget {
  const MindfulnessReminderSwitch({super.key});

  @override
  State<MindfulnessReminderSwitch> createState() =>
      _MindfulnessReminderSwitchState();
}

class _MindfulnessReminderSwitchState extends State<MindfulnessReminderSwitch> {
  bool _enabled = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationState();
  }

  Future<void> _loadNotificationState() async {
    final enabled =
    await MindfulnessNotificationService.instance.areNotificationsEnabled();

    if (!mounted) return;

    setState(() {
      _enabled = enabled;
      _loading = false;
    });
  }

  Future<void> _onChanged(bool value) async {
    setState(() {
      _loading = true;
    });

    if (value) {
      final enabled =
      await MindfulnessNotificationService.instance.enableRandomReminders();

      if (!mounted) return;

      setState(() {
        _enabled = enabled;
        _loading = false;
      });

      if (!enabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Permesso notifiche non concesso. Puoi abilitarlo dalle impostazioni del telefono.',
            ),
          ),
        );
      }
    } else {
      await MindfulnessNotificationService.instance.disableRandomReminders();

      if (!mounted) return;

      setState(() {
        _enabled = false;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: _enabled,
      onChanged: _loading ? null : _onChanged,
      title: const Text('Promemoria settimanali'),
      subtitle: const Text(
        'Ricevi 3 notifiche casuali a settimana per fermarti un momento e ascoltarti.',
      ),
    );
  }
}