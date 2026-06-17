import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mi_ascolto/pages/splash_screen.dart';
import 'package:mi_ascolto/services/mindfulness_notification_service.dart';

import 'data/database_helper.dart';
import 'pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  await MindfulnessNotificationService.instance.init();
  await MindfulnessNotificationService.instance.ensureScheduledIfEnabled();
  runApp(const DiarioApp());
}

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: const Color(0xFFE9EFF2),
  colorScheme: ColorScheme.light(
    primary: const Color(0xFF4F8F86),
    surface: const Color(0xFFF6F7F8),
  ),
  cardTheme: CardThemeData(
    color: const Color(0xFFF6F7F8),
    elevation: 4,
    shadowColor: Colors.black26,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      color: Color(0xFF3A3A3A),
      fontWeight: FontWeight.w600,
    ),
    bodyMedium: TextStyle(
      color: Color(0xFF4A4A4A),
    ),
    bodySmall: TextStyle(
      color: Color(0xFF8F9396),
    ),
  ),
);

class DiarioApp extends StatelessWidget {
  const DiarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi Ascolto',
      theme: appTheme,
      supportedLocales: const [
        Locale('it', 'IT'),
        Locale('en', 'US'),
        Locale('de', 'DE'),
        Locale('es', 'ES'),
        Locale('fr', 'FR'),
        Locale('pt', 'PT'),
        Locale('ru', 'RU'),
        Locale('zh', 'CN'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashScreen(
        nextPage: HomePage(),
      ),
    );
  }
}
