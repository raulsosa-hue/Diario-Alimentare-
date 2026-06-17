import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MindfulnessNotificationService {
  MindfulnessNotificationService._();

  static final MindfulnessNotificationService instance =
  MindfulnessNotificationService._();

  final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  final Random _random = Random();

  bool _initialized = false;

  static const String _enabledKey = 'mindfulness_notifications_enabled';
  static const String _timezoneKey = 'mindfulness_timezone';

  static const int _baseNotificationId = 800000;
  static const int _weeksAhead = 20;
  static const int _notificationsPerWeek = 3;
  static const int _maxScheduledNotifications =
      _weeksAhead * _notificationsPerWeek;

  static const String _channelId = 'mindfulness_random_reminders';
  static const String _channelName = 'Promemoria Mi Ascolto';
  static const String _channelDescription =
      'Promemoria casuali per prendersi un momento per sé.';

  static const List<String> _phrases = [
    'Come mi sento oggi?',
    'Mi fermo un attimo?',
    'Va bene anche rallentare.',
    'Non devo capire tutto subito.',
    'Posso prendermi un momento per me.',
    'Come sto in questo momento?',
    'Come mi sento adesso?',
    'Posso rallentare un attimo?',
    'Mi prendo un piccolo spazio per me.',
    'Mi fermo solo per un momento.',
  ];

  static const List<String> _titles = [
    'Un pensiero per te',
    'Momento di ascolto',
    'Promemoria gentile',
    'Nota leggera',
    'Piccolo spazio',
    'Tempo per sentire',
    'Una domanda semplice',
    'Pausa tranquilla',
    'Ascolto del giorno',
    'Solo per te',
  ];

  Future<void> init() async {
    if (_initialized) return;

    await _configureLocalTimeZone();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings: initializationSettings,
    );

    _initialized = true;
  }

  Future<bool> areNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_enabledKey) ?? false;
  }

  Future<bool> enableRandomReminders() async {
    await init();

    final granted = await requestPermissions();

    if (!granted) {
      return false;
    }

    final currentTimezone = await _configureLocalTimeZone();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, true);
    await prefs.setString(_timezoneKey, currentTimezone);


    await scheduleRandomWeeklyNotifications();

    return true;
  }

  Future<void> disableRandomReminders() async {
    await init();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, false);

    await cancelRandomReminders();
  }

  Future<void> ensureScheduledIfEnabled() async {
    await init();

    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(_enabledKey) ?? false;

    if (!enabled) return;

    final currentTimezone = await _configureLocalTimeZone();
    final prefsTimezone = prefs.getString(_timezoneKey);
    final pending = await _notifications.pendingNotificationRequests();

    final ownPendingNotifications = pending.where((notification) {
      return notification.id >= _baseNotificationId &&
          notification.id < _baseNotificationId + _maxScheduledNotifications;
    }).length;

    final timezoneChanged = prefsTimezone != currentTimezone;
    final pendingNotificationsChanged = ownPendingNotifications < 9;

    if(timezoneChanged || pendingNotificationsChanged){
      await prefs.setString(_timezoneKey, currentTimezone);
    }

    if (ownPendingNotifications < 9) {
      await scheduleRandomWeeklyNotifications();
      await scheduleRandomWeeklyNotifications();
    }
  }

  Future<bool> requestPermissions() async {
    await init();

    if (kIsWeb) return false;

    if (Platform.isAndroid) {
      final androidImplementation = _notifications
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      final granted =
      await androidImplementation?.requestNotificationsPermission();

      return granted ?? true;
    }

    if (Platform.isIOS) {
      final iosImplementation = _notifications
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();

      final granted = await iosImplementation?.requestPermissions(
        alert: true,
        badge: false,
        sound: true,
      );

      return granted ?? false;
    }

    return false;
  }

  Future<void> scheduleRandomWeeklyNotifications() async {
    await init();

    await cancelRandomReminders();

    final plans = _buildRandomPlans();

    for (final plan in plans) {
      await _notifications.zonedSchedule(
        id: plan.id,
        title: plan.title,
        body: plan.phrase,
        scheduledDate: plan.scheduledDate,
        notificationDetails: _notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: 'mindfulness_random_reminder',
      );
    }
  }

  Future<void> cancelRandomReminders() async {
    await init();

    for (int i = 0; i < _maxScheduledNotifications; i++) {
      await _notifications.cancel(id: _baseNotificationId + i);
    }
  }

  Future<String> _configureLocalTimeZone() async {
    tz.initializeTimeZones();

    try {
      final timezoneInfo = await FlutterTimezone.getLocalTimezone();
      final identifier = timezoneInfo.identifier;
      tz.setLocalLocation(tz.getLocation(identifier));
      return identifier;
    } catch (_) {
      const defaultTimezone = 'Europe/Rome';
      tz.setLocalLocation(tz.getLocation(defaultTimezone));
      return defaultTimezone;
    }
  }

  List<_MindfulnessReminderPlan> _buildRandomPlans() {
    final dates = _generateRandomDates();
    final titles = _generateRandomTitles(dates.length);
    final phrases = _generateRandomPhrases(dates.length);

    return List.generate(dates.length, (index) {
      return _MindfulnessReminderPlan(
        id: _baseNotificationId + index,
        scheduledDate: dates[index],
        title: titles[index],
        phrase: phrases[index],
      );
    });
  }

  List<tz.TZDateTime> _generateRandomDates() {
    final now = tz.TZDateTime.now(tz.local);
    final minimumDate = now.add(const Duration(minutes: 1));
    final currentWeekStart = _startOfWeek(now);

    final scheduledDates = <tz.TZDateTime>[];

    for (int week = 0; week < _weeksAhead; week++) {
      final weekStart = currentWeekStart.add(Duration(days: week * 7));

      final dayOffsets = List<int>.generate(7, (index) => index)
        ..shuffle(_random);

      int addedThisWeek = 0;

      for (final dayOffset in dayOffsets) {
        final possibleHours = <int>[12, 18]..shuffle(_random);

        tz.TZDateTime? selectedDate;

        for (final hour in possibleHours) {
          final candidate = tz.TZDateTime(
            tz.local,
            weekStart.year,
            weekStart.month,
            weekStart.day + dayOffset,
            hour,
          );

          if (candidate.isAfter(minimumDate)) {
            selectedDate = candidate;
            break;
          }
        }

        if (selectedDate == null) continue;

        scheduledDates.add(selectedDate);
        addedThisWeek++;

        if (addedThisWeek == _notificationsPerWeek) {
          break;
        }
      }
    }

    scheduledDates.sort((a, b) => a.compareTo(b));

    return scheduledDates.take(_maxScheduledNotifications).toList();
  }

  List<String> _generateRandomTitles(int count) {
    final result = <String>[];
    final pool = <String>[];

    while (result.length < count) {
      if (pool.isEmpty) {
        pool.addAll(_titles);
        pool.shuffle(_random);
      }

      result.add(pool.removeLast());
    }

    return result;
  }

  List<String> _generateRandomPhrases(int count) {
    final result = <String>[];
    final pool = <String>[];

    while (result.length < count) {
      if (pool.isEmpty) {
        pool.addAll(_phrases);
        pool.shuffle(_random);
      }

      result.add(pool.removeLast());
    }

    return result;
  }

  tz.TZDateTime _startOfWeek(tz.TZDateTime date) {
    final midnight = tz.TZDateTime(
      tz.local,
      date.year,
      date.month,
      date.day,
    );

    return midnight.subtract(
      Duration(days: date.weekday - DateTime.monday),
    );
  }

  NotificationDetails _notificationDetails() {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: true,
    );

    return const NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
  }
}

class _MindfulnessReminderPlan {
  final int id;
  final tz.TZDateTime scheduledDate;
  final String title;
  final String phrase;

  const _MindfulnessReminderPlan({
    required this.id,
    required this.scheduledDate,
    required this.title,
    required this.phrase,
  });
}