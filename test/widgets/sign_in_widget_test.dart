import 'package:booze_app/widgets/sign_in_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SignInWidget should show widgets', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SignInWidget(onSignIn: (email, password) {}),
        ),
      ),
    );

    // Act

    // Assert
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);
  });

  testWidgets('SignInWidget should show an error message when the email is empty',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SignInWidget(onSignIn: (email, password) {}),
        ),
      ),
    );

    // Act
    await tester.tap(find.text('Sign In'));
    await tester.pump();

    // Assert
    expect(find.text('Please enter an email address'), findsOneWidget);
  });

  testWidgets(
      'SignInWidget should show an error message when the password is empty',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SignInWidget(onSignIn: (email, password) {}),
        ),
      ),
    );

    // Act
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'), 'test@test.com');
    await tester.tap(find.text('Sign In'));
    await tester.pump();

    // Assert
    expect(find.text('Please enter a password'), findsOneWidget);
  });

  testWidgets('SignInWidget should call onSignIn when the form is valid',
      (WidgetTester tester) async {
    // Arrange
    var called = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SignInWidget(onSignIn: (email, password) => called = true),
        ),
      ),
    );

    // Act
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'), 'test@test.com');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), 'password');
    await tester.tap(find.text('Sign In'));
    await tester.pump();

    // Assert
    expect(called, isTrue);
  });
}
