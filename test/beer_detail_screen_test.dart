import 'package:booze_app/beer_detail_screen.dart';
import 'package:booze_app/beer_form_screen.dart';
import 'package:booze_app/data/beer.dart';
import 'package:booze_app/data/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'beer_detail_screen_test.mocks.dart';

@GenerateMocks([FirebaseService])
void main() {
  late MockFirebaseService mockFirebaseService;

  setUp(() {
    mockFirebaseService = MockFirebaseService();
  });

  final beer = Beer(
    id: '1',
    name: 'Test Beer',
    brewery: 'Test Brewery',
    country: 'Test Country',
    style: 'Test Style',
    abv: 5.0,
    rating: 4,
    notes: 'Test Notes',
    flavor: 'Test Flavor',
    imageUrl: 'https://test.com/image.png',
    createdAt: DateTime.now(),
  );

  testWidgets('BeerDetailScreen should show widgets', (
    WidgetTester tester,
  ) async {
    // Arrange
    await mockNetworkImagesFor(
      () => tester.pumpWidget(
        MaterialApp(
          home: BeerDetailScreen(
            beer: beer,
            firebaseService: mockFirebaseService,
          ),
        ),
      ),
    );

    // Act

    // Assert
    expect(find.text('Test Beer'), findsOneWidget);
    expect(find.text('Test Style'), findsOneWidget);
    expect(find.text('Test Brewery, Test Country'), findsOneWidget);
    expect(find.text('5.0% ABV'), findsOneWidget);
    expect(find.text('4 / 5'), findsOneWidget);
    expect(find.text('Flavor Profile'), findsOneWidget);
    expect(find.text('Test Flavor'), findsOneWidget);
    expect(find.text('Your Notes'), findsOneWidget);
    expect(find.text('Test Notes'), findsOneWidget);
  });

  testWidgets(
    'BeerDetailScreen should show an image when the URL is not empty',
    (WidgetTester tester) async {
      // Arrange
      await mockNetworkImagesFor(
        () => tester.pumpWidget(
          MaterialApp(
            home: BeerDetailScreen(
              beer: beer,
              firebaseService: mockFirebaseService,
            ),
          ),
        ),
      );

      // Act

      // Assert
      expect(find.byType(Image), findsOneWidget);
    },
  );

  testWidgets(
    'BeerDetailScreen should not show an image when the URL is empty',
    (WidgetTester tester) async {
      // Arrange
      final beerWithNoImage = Beer(
        id: '1',
        name: 'Test Beer',
        brewery: 'Test Brewery',
        country: 'Test Country',
        style: 'Test Style',
        abv: 5.0,
        rating: 4,
        notes: 'Test Notes',
        flavor: 'Test Flavor',
        imageUrl: '',
        createdAt: DateTime.now(),
      );

      await mockNetworkImagesFor(
        () => tester.pumpWidget(
          MaterialApp(
            home: BeerDetailScreen(
              beer: beerWithNoImage,
              firebaseService: mockFirebaseService,
            ),
          ),
        ),
      );

      // Act

      // Assert
      expect(find.byType(Image), findsNothing);
    },
  );

  testWidgets(
    'BeerDetailScreen should show BeerFormScreen when edit button is pressed',
    (WidgetTester tester) async {
      // Arrange
      await mockNetworkImagesFor(
        () => tester.pumpWidget(
          MaterialApp(
            home: BeerDetailScreen(
              beer: beer,
              firebaseService: mockFirebaseService,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(BeerFormScreen), findsOneWidget);
    },
  );

  testWidgets(
    'BeerDetailScreen should show AlertDialog when delete button is pressed',
    (tester) async {
      // Arrange
      await mockNetworkImagesFor(
        () => tester.pumpWidget(
          MaterialApp(
            home: BeerDetailScreen(
              beer: beer,
              firebaseService: mockFirebaseService,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      // Assert
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Are you sure?'), findsOneWidget);
      expect(
        find.text('Do you want to permanently delete this beer record?'),
        findsOneWidget,
      );
      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
    },
  );

  testWidgets(
    'BeerDetailScreen should dismiss delete AlertDialog when no button is pressed',
    (tester) async {
      // Arrange
      when(mockFirebaseService.deleteBeer(beer)).thenAnswer((_) async {
        return;
      });

      await mockNetworkImagesFor(
        () => tester.pumpWidget(
          MaterialApp(
            home: BeerDetailScreen(
              beer: beer,
              firebaseService: mockFirebaseService,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();
      await tester.tap(find.text('No'));
      await tester.pump();

      // Assert
      expect(find.byType(AlertDialog), findsNothing);
      verifyNever(mockFirebaseService.deleteBeer(beer));
    },
  );

  testWidgets(
    'BeerDetailScreen should delete record when yes button is pressed on delete AlertDialog',
    (tester) async {
      // Arrange
      when(mockFirebaseService.deleteBeer(beer)).thenAnswer((_) async {
        return;
      });

      await mockNetworkImagesFor(
        () => tester.pumpWidget(
          MaterialApp(
            home: BeerDetailScreen(
              beer: beer,
              firebaseService: mockFirebaseService,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();
      await tester.tap(find.text('Yes'));
      await tester.pump();

      // Assert
      expect(find.byType(AlertDialog), findsNothing);
      verify(mockFirebaseService.deleteBeer(beer)).called(1);
    },
  );
}
