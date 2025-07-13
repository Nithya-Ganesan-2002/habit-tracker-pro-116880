import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitwise_frontend/main.dart';

void main() {
  testWidgets('Onboarding and navigation present', (WidgetTester tester) async {
    await tester.pumpWidget(const HabitWiseApp());

    expect(find.text('Welcome to HabitWise'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);

    // Tap Get Started and check for Home tab
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();
    expect(find.text('Today'), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });

  testWidgets('FAB is present on Home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const HabitWiseApp());

    // Proceed through onboarding
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
