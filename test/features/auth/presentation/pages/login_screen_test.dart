import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resub/features/auth/presentation/pages/login_screen.dart';

void main() {
  group('LoginScreen Widget Tests', () {
    Widget createTestWidget() {
      return const ProviderScope(child: MaterialApp(home: LoginScreen()));
    }

    testWidgets('displays login button', (WidgetTester tester) async {
      // Set larger screen size to prevent overflow
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;

      // Arrange & Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      addTearDown(() => tester.view.resetPhysicalSize());

      // Assert
      final loginButton = find.widgetWithText(ElevatedButton, 'Login');
      expect(loginButton, findsOneWidget);
    });

    testWidgets('displays link to navigate to signup screen', (
      WidgetTester tester,
    ) async {
      // Set larger screen size to prevent overflow
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;

      // Arrange & Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      addTearDown(() => tester.view.resetPhysicalSize());

      // Assert
      expect(find.text("Don't have an account?"), findsOneWidget);
      expect(find.text('Register Now'), findsOneWidget);

      final registerLink = find.text('Register Now');
      expect(registerLink, findsOneWidget);
    });

    testWidgets('displays at least one input field', (
      WidgetTester tester,
    ) async {
      // Set larger screen size to prevent overflow
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;

      // Arrange & Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      addTearDown(() => tester.view.resetPhysicalSize());

      // Assert
      final inputFields = find.byType(TextFormField);
      expect(inputFields, findsWidgets);
      expect(inputFields.evaluate().length, greaterThanOrEqualTo(1));

      // Verify email and password fields exist
      expect(find.byType(TextFormField), findsNWidgets(2));
    });
  });
}
