import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:vendor_management_system/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Vendor Management System Integration Tests', () {
    testWidgets('Initial screen displays correctly', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify that the initial screen loads
      expect(find.text('Vendors'), findsOneWidget);
    });

    testWidgets('Search functionality works', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Find the search field
      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      // Enter search text
      await tester.enterText(searchField, 'Test');
      await tester.pumpAndSettle();

      // Wait for search results
      await tester.pump(const Duration(milliseconds: 300)); // Account for debounce
    });

    testWidgets('Scroll list works', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Initial position
      final initialPosition = tester.getCenter(find.byType(ListView));

      // Scroll down
      await tester.fling(find.byType(ListView), const Offset(0, -500), 10000);
      await tester.pumpAndSettle();

      // Verify we've scrolled
      final finalPosition = tester.getCenter(find.byType(ListView));
      expect(initialPosition.dy, greaterThan(finalPosition.dy));
    });
  });
}
