import 'package:booze_app/policy_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'PolicyViewerScreen should show the terms and conditions policy when the policy type is terms and conditions',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      const MaterialApp(
        home: PolicyViewerScreen(
          policyType: PolicyType.termsAndConditions,
        ),
      ),
    );

    // Act

    // Assert
    expect(find.text('Terms & Conditions'), findsOneWidget);
  });

  testWidgets(
      'PolicyViewerScreen should show the privacy policy when the policy type is privacy policy',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      const MaterialApp(
        home: PolicyViewerScreen(
          policyType: PolicyType.privacyPolicy,
        ),
      ),
    );

    // Act

    // Assert
    expect(find.text('Privacy Policy'), findsOneWidget);
  });
}