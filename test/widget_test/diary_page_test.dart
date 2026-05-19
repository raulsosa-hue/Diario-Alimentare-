import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mi_ascolto/pages/diary_page.dart';

void main() {
  testWidgets('DiaryPage si apre correttamente', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: DiaryPage(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(DiaryPage), findsOneWidget);

    // Cambia questi testi in base a quelli reali della tua schermata
    expect(find.textContaining('Diario'), findsWidgets);
  });
}