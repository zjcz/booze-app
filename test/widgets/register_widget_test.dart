import 'package:booze_app/widgets/register_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('RegisterWidget should show widgets', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RegisterWidget(onRegister: (email, password) {}),
        ),
      ),
    );

    // Act

    // Assert
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
    expect(
        find.widgetWithText(TextFormField, 'Repeat Password'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Register'), findsOneWidget);
  });

  testWidgets('RegisterWidget should show an error message when the email is empty',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RegisterWidget(onRegister: (email, password) {}),
        ),
      ),
    );

    // Act
    await tester.tap(find.text('Register'));
    await tester.pump();

    // Assert
    expect(find.text('Please enter an email address'), findsOneWidget);
  });

  testWidgets(
      'RegisterWidget should show an error message when the password is empty',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RegisterWidget(onRegister: (email, password) {}),
        ),
      ),
    );

    // Act
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'), 'test@test.com');
    await tester.tap(find.text('Register'));
    await tester.pump();

    // Assert
    expect(find.text('Please enter a password'), findsNWidgets(2));
  });

  testWidgets(
      'RegisterWidget should show an error message when the passwords do not match',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RegisterWidget(onRegister: (email, password) {}),
        ),
      ),
    );

    // Act
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'), 'test@test.com');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), 'password');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Repeat Password'), 'wrong');
    await tester.tap(find.text('Register'));
    await tester.pump();

    // Assert
    expect(find.text('Passwords do not match'), findsNWidgets(2));
  });

  testWidgets('RegisterWidget should call onRegister when the form is valid',
      (WidgetTester tester) async {
    // Arrange
    var called = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RegisterWidget(onRegister: (email, password) => called = true),
        ),
      ),
    );

    // Act
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'), 'test@test.com');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), 'password');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Repeat Password'), 'password');
    await tester.tap(find.text('Register'));
    await tester.pump();

    // Assert
    expect(called, isTrue);
  });
}
