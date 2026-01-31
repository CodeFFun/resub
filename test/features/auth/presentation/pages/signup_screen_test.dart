import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resub/features/auth/presentation/pages/signup_screen.dart';

void main() {
  group('SignupScreen Widget Tests', () {
    Widget createTestWidget() {
      return const ProviderScope(child: MaterialApp(home: SignupScreen()));
    }

    testWidgets('displays register button', (WidgetTester tester) async {
      // Set larger screen size to prevent overflow
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;

      // Arrange & Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      addTearDown(() => tester.view.resetPhysicalSize());

      // Assert
      final registerButton = find.widgetWithText(ElevatedButton, 'Register');
      expect(registerButton, findsOneWidget);
    });

    testWidgets('displays link to navigate to login screen', (
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
      expect(find.text('Already have an account?'), findsOneWidget);
      expect(find.text('Login Now'), findsOneWidget);

      final loginLink = find.text('Login Now');
      expect(loginLink, findsOneWidget);
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

      // Verify username, email and password fields exist
      expect(find.byType(TextFormField), findsNWidgets(3));
    });
  });
}
