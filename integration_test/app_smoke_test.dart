import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:mi_ascolto/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Mi Ascolto - integration test', () {
    testWidgets('avvia l’app reale senza crash', (tester) async {
      app.main();

      await tester.pump();

      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 500));
      }

      expect(tester.takeException(), isNull);
      expect(find.byType(WidgetsApp), findsOneWidget);
    });
  });
}