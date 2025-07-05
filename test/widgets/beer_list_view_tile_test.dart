import 'package:booze_app/data/beer.dart';
import 'package:booze_app/widgets/beer_list_view_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  final beer = Beer(
    id: '1',
    name: 'Test Beer',
    brewery: 'Test Brewery',
    country: 'Test Country',
    style: 'IPA',
    abv: 6.5,
    rating: 4,
    imageUrl: 'https://images.punkapi.com/v2/keg.png',
    notes: 'A delicious test beer.',
    flavour: 'Hoppy',
    createdAt: DateTime.now(),
  );

  group('BeerListViewTile', () {
    testWidgets('should display all beer information correctly',
        (WidgetTester tester) async {
      // Arrange
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BeerListViewTile(
                beer: beer,
                onTap: (_) {},
              ),
            ),
          ),
        );
      });

      // Act & Assert
      expect(find.text(beer.name), findsOneWidget);
      expect(
          find.text(
              '${beer.brewery}, ${beer.country}\nStyle: ${beer.style} | ABV: ${beer.abv}%'),
          findsOneWidget);
      expect(find.text('${beer.rating} / 5'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('should call onTap when the tile is tapped',
        (WidgetTester tester) async {
      // Arrange
      var tapped = false;
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BeerListViewTile(
                beer: beer,
                onTap: (_) {
                  tapped = true;
                },
              ),
            ),
          ),
        );
      });

      // Act
      await tester.tap(find.byType(ListTile));
      await tester.pump();

      // Assert
      expect(tapped, isTrue);
    });
  });
}