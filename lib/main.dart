import 'package:flutter/material.dart';

import 'data/database_helper.dart';
import 'pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper.instance.database;
  runApp(const DiarioApp());
}

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: const Color(0xFFE9EFF2),
  colorScheme: ColorScheme.light(
    primary: const Color(0xFF4F8F86),
    background: const Color(0xFFE9EFF2),
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
      title: 'Diario Alimentare',
      theme: appTheme,
      home: HomePage(),
    );
  }
}
