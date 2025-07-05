import 'package:booze_app/beer_form_screen.dart';
import 'package:booze_app/data/beer.dart';
import 'package:booze_app/data/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'beer_form_screen_test.mocks.dart';

@GenerateMocks([FirebaseService])
void main() {
  late MockFirebaseService mockFirebaseService;

  final beer = Beer(
    id: '1',
    name: 'Test Beer',
    brewery: 'Test Brewery',
    country: 'Test Country',
    style: 'Test Style',
    abv: 5.0,
    rating: 4,
    notes: 'Test Notes',
    flavour: 'Test Flavour',
    imageUrl: 'https://test.com/image.png',
    createdAt: DateTime.now(),
  );

  setUp(() {
    mockFirebaseService = MockFirebaseService();
  });

  testWidgets('BeerFormScreen should show widgets for adding a new beer', (
    WidgetTester tester,
  ) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(home: BeerFormScreen(firebaseService: mockFirebaseService)),
    );

    // Act

    // Assert
    expect(find.text('Add a New Beer'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Beer Name'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Brewery'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Country'), findsOneWidget);
    expect(
      find.widgetWithText(TextFormField, 'Style (e.g., IPA, Stout)'),
      findsOneWidget,
    );
    expect(find.widgetWithText(TextFormField, 'ABV (%)'), findsOneWidget);
    expect(
      find.widgetWithText(TextFormField, 'Flavour Profile'),
      findsOneWidget,
    );
    expect(find.widgetWithText(TextFormField, 'Notes'), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);
    expect(find.text('Select Image'), findsOneWidget);
    expect(find.text('Save Beer'), findsOneWidget);
  });

  testWidgets(
    'BeerFormScreen should show widgets for editing an existing beer',
    (WidgetTester tester) async {
      // Arrange
      await mockNetworkImagesFor(
        () => tester.pumpWidget(
          MaterialApp(
            home: BeerFormScreen(
              beer: beer,
              firebaseService: mockFirebaseService,
            ),
          ),
        ),
      );

      // Act

      // Assert
      expect(find.text('Edit Beer'), findsOneWidget);
      expect(find.text('Test Beer'), findsOneWidget);
      expect(find.text('Test Brewery'), findsOneWidget);
      expect(find.text('Test Country'), findsOneWidget);
      expect(find.text('Test Style'), findsOneWidget);
      expect(find.text('5.0'), findsOneWidget);
      expect(find.text('Test Flavour'), findsOneWidget);
      expect(find.text('Test Notes'), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(find.text('Select Image'), findsOneWidget);
      expect(find.text('Save Beer'), findsOneWidget);
    },
  );

  testWidgets(
    'BeerFormScreen should show an error message when the name is empty',
    (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(home: BeerFormScreen(firebaseService: mockFirebaseService)),
      );

      // Act
      final buttonFinder = find.text('Save Beer');
      final scrollableFinder = find.byType(Scrollable).last;
      await tester.scrollUntilVisible(
        buttonFinder,
        10,
        scrollable: scrollableFinder,
      );
      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Please enter a name'), findsOneWidget);
    },
  );

  testWidgets(
    'BeerFormScreen should show an error message when the brewery is empty',
    (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(home: BeerFormScreen(firebaseService: mockFirebaseService)),
      );

      // Act
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Beer Name'),
        'Test Beer',
      );

      final buttonFinder = find.text('Save Beer');
      final scrollableFinder = find.byType(Scrollable).last;
      await tester.scrollUntilVisible(
        buttonFinder,
        10,
        scrollable: scrollableFinder,
      );
      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Please enter a brewery'), findsOneWidget);
    },
  );

  testWidgets(
    'BeerFormScreen should update the rating when the slider is changed',
    (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(home: BeerFormScreen(firebaseService: mockFirebaseService)),
      );

      // Act
      await tester.drag(find.byType(Slider), const Offset(1000, 0));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Rating: 5 / 5'), findsOneWidget);
    },
  );
}
