import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_ascolto/widgets/app_icon_mark.dart';

void main() {
  testWidgets('AppIconMark viene renderizzato senza errori', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: AppIconMark(
              size: 40,
              color: Colors.green,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(AppIconMark), findsOneWidget);
  });
}