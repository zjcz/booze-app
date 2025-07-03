import 'package:booze_app/data/firebase_service.dart';
import 'package:booze_app/home_screen.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_screen_test.mocks.dart';

late MockFirebaseService mockFirebaseService;

@GenerateMocks([FirebaseService])
void main() {
  setUp(() async {
    mockFirebaseService = MockFirebaseService();
    when(
      mockFirebaseService.buildSearchQuery(any),
    ).thenReturn(FakeFirebaseFirestore().collection('empty_collection'));
  });

  testWidgets('HomeScreen should show widgets', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(home: HomeScreen(firebaseService: mockFirebaseService)),
    );

    // Act

    // Assert
    expect(find.text('Booze App'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('HomeScreen should toggle between list and grid view', (
    WidgetTester tester,
  ) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(home: HomeScreen(firebaseService: mockFirebaseService)),
    );

    // Act
    await tester.tap(find.byIcon(Icons.view_module));
    await tester.pump();

    // Assert
    expect(find.byIcon(Icons.view_list), findsOneWidget);

    // Act
    await tester.tap(find.byIcon(Icons.view_list));
    await tester.pump();

    // Assert
    expect(find.byIcon(Icons.view_module), findsOneWidget);
  });

  testWidgets('HomeScreen should show sort options', (
    WidgetTester tester,
  ) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(home: HomeScreen(firebaseService: mockFirebaseService)),
    );

    // Act
    await tester.tap(find.byIcon(Icons.sort_by_alpha));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Name (A-Z)'), findsOneWidget);
    expect(find.text('Name (Z-A)'), findsOneWidget);
    expect(find.text('Added (Oldest First)'), findsOneWidget);
    expect(find.text('Added (Newest First)'), findsOneWidget);
    expect(find.text('Rating (Low to High)'), findsOneWidget);
    expect(find.text('Rating (High to Low)'), findsOneWidget);
  });

  testWidgets('HomeScreen should show more options', (
    WidgetTester tester,
  ) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(home: HomeScreen(firebaseService: mockFirebaseService)),
    );

    // Act
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('About...'), findsOneWidget);
  });

  testWidgets('HomeScreen should logout when clicking logout icon', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(mockFirebaseService.signOut());
    await tester.pumpWidget(
      MaterialApp(home: HomeScreen(firebaseService: mockFirebaseService)),
    );

    // Act
    await tester.tap(find.byIcon(Icons.logout));
    await tester.pumpAndSettle();

    // Assert
    verify(mockFirebaseService.signOut()).called(1);
  });
}
