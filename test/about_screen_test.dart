import 'package:booze_app/about_screen.dart';
import 'package:booze_app/policy_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  // Set mock initial values for PackageInfo
  PackageInfo.setMockInitialValues(
    appName: 'booze_app',
    packageName: 'com.example.booze_app',
    version: '1.0.0',
    buildNumber: '1',
    buildSignature: '',
  );

  testWidgets('AboutScreen should show widgets', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(const MaterialApp(home: AboutScreen()));
    await tester.pumpAndSettle(); // Wait for package info to load

    // Act

    // Assert
    expect(find.text('About'), findsOneWidget);
    expect(find.text('Booze App'), findsOneWidget);
    expect(find.text('Version: 1.0.0, build: 1'), findsOneWidget);
    expect(
      find.widgetWithText(ElevatedButton, 'Visit Website'),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(ElevatedButton, 'Terms and Conditions'),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(ElevatedButton, 'Privacy Policy'),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(ElevatedButton, '3rd Party Licenses'),
      findsOneWidget,
    );
  });

  testWidgets(
    'PolicyViewerScreen should be shown when the terms and conditions are tapped',
    (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(home: AboutScreen()));
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('Terms and Conditions'));
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
      await tester.pumpWidget(const MaterialApp(home: AboutScreen()));
      await tester.pumpAndSettle();

      // Act
      final buttonFinder = find.text('Privacy Policy');
      final scrollableFinder = find.byType(Scrollable).last;
      await tester.scrollUntilVisible(
        buttonFinder,
        10,
        scrollable: scrollableFinder,
      );
      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(PolicyViewerScreen), findsOneWidget);
      expect(find.widgetWithText(AppBar, 'Privacy Policy'), findsOneWidget);
    },
  );

  // Note: Testing for 'Visit Website' and '3rd Party Licenses' is not included
  // as they launch external URLs or system dialogs, which are better suited for
  // integration tests.
}
