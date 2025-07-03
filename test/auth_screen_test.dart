import 'package:booze_app/auth_screen.dart';
import 'package:booze_app/data/firebase_service.dart';
import 'package:booze_app/widgets/register_widget.dart';
import 'package:booze_app/widgets/sign_in_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'auth_screen_test.mocks.dart';

@GenerateMocks([FirebaseService])
void main() {
  late MockFirebaseService mockFirebaseService;

  setUp(() {
    mockFirebaseService = MockFirebaseService();
  });

  testWidgets('AuthScreen should show sign-in widget by default', (
    WidgetTester tester,
  ) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(home: AuthScreen(firebaseService: mockFirebaseService)),
    );

    // Act

    // Assert
    expect(find.byType(SignInWidget), findsOneWidget);
    expect(find.byType(RegisterWidget), findsNothing);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('AuthScreen should switch to register mode', (
    WidgetTester tester,
  ) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(home: AuthScreen(firebaseService: mockFirebaseService)),
    );

    // Act
    final richText = find.byKey(const Key('switchModeText')).first;
    fireOnTap(richText, 'Register now');
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(RegisterWidget), findsOneWidget);
    expect(find.byType(SignInWidget), findsNothing);
    expect(find.widgetWithText(AppBar, 'Register'), findsOneWidget);
  });

  testWidgets('AuthScreen should switch back to sign-in mode', (
    WidgetTester tester,
  ) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(home: AuthScreen(firebaseService: mockFirebaseService)),
    );

    // Go to register mode first
    final richText = find.byKey(const Key('switchModeText')).first;
    fireOnTap(richText, 'Register now');
    await tester.pumpAndSettle();

    // Act
    fireOnTap(richText, 'Click to sign in');
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(SignInWidget), findsOneWidget);
    expect(find.byType(RegisterWidget), findsNothing);
    expect(find.widgetWithText(AppBar, 'Login'), findsOneWidget);
  });
}

void fireOnTap(Finder finder, String text) {
  final Element element = finder.evaluate().single;
  final RenderParagraph paragraph = element.renderObject as RenderParagraph;
  // The children are the individual TextSpans which have GestureRecognizers
  paragraph.text.visitChildren((dynamic span) {
    if (span.text != text) return true; // continue iterating.

    (span.recognizer as TapGestureRecognizer).onTap!();
    return false; // stop iterating, we found the one.
  });
}
