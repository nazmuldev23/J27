import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j27/app/app.dart';

void main() {
  testWidgets('J27 e-commerce app splash screen and main render test', (WidgetTester tester) async {
    await tester.pumpWidget(const J27());

    // Verify Welcome text on SplashScreen
    expect(find.text('Welcome to J27'), findsOneWidget);
    expect(find.text('Your Favorite E-Commerce Store'), findsOneWidget);

    // Advance time for splash screen timer transition
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify Main Navigation / Home Screen rendered
    expect(find.text('J27 E-Commerce'), findsOneWidget);
    expect(find.text('Wireless Headphones'), findsOneWidget);
    expect(find.text('Smart Watch Series 7'), findsOneWidget);

    // Verify bottom navigation items
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
  });
}
