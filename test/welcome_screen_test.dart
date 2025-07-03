import 'package:booze_app/policy_viewer_screen.dart';
import 'package:booze_app/welcome_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('WelcomeScreen should show widgets', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(home: WelcomeScreen(onWelcomeScreenDismissed: () {})),
    );

    // Act

    // Assert
    expect(find.text('Welcome to Booze App!'), findsOneWidget);
    expect(
      find.text('Discover, Track, and Rate Your Favorite Beers!'),
      findsOneWidget,
    );
    expect(find.text('Let\'s Get Started'), findsOneWidget);
  });

  testWidgets(
    'onWelcomeScreenDismissed should be called when the button is pressed',
    (WidgetTester tester) async {
      // Arrange
      var dismissed = false;
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(
        MaterialApp(
          home: WelcomeScreen(onWelcomeScreenDismissed: () => dismissed = true),
        ),
      );

      // Act
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Assert
      expect(dismissed, isTrue);
    },
  );

  testWidgets(
    'PolicyViewerScreen should be shown when the terms and conditions are tapped',
    (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(home: WelcomeScreen(onWelcomeScreenDismissed: () {})),
      );

      // Act
      final richText = find.byKey(const Key('viewTermsAndPrivacyBox')).first;
      fireOnTap(richText, 'Terms & Conditions');
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(PolicyViewerScreen), findsOneWidget);
      expect(find.text('Terms & Conditions'), findsOneWidget);
    },
  );

  testWidgets(
    'PolicyViewerScreen should be shown when the privacy policy is tapped',
    (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(home: WelcomeScreen(onWelcomeScreenDismissed: () {})),
      );

      // Act
      final richText = find.byKey(const Key('viewTermsAndPrivacyBox')).first;
      fireOnTap(richText, 'Privacy Policy');
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(PolicyViewerScreen), findsOneWidget);
      expect(find.widgetWithText(AppBar, 'Privacy Policy'), findsOneWidget);
    },
  );
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
