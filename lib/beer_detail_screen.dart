import 'package:booze_app/data/firebase_service.dart';
import 'package:flutter/material.dart';
import 'data/beer.dart';
import 'beer_form_screen.dart';

class BeerDetailScreen extends StatefulWidget {
  final Beer beer;
  final FirebaseService firebaseService;

  const BeerDetailScreen({
    super.key,
    required this.beer,
    required this.firebaseService,
  });

  @override
  State<BeerDetailScreen> createState() => _BeerDetailScreenState();
}

class _BeerDetailScreenState extends State<BeerDetailScreen> {
  Future<void> _deleteBeer(BuildContext context) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to permanently delete this beer record?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        widget.firebaseService.deleteBeer(widget.beer);

        // Pop back to the home screen
        if (!mounted) return;
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to delete beer: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.beer.name),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async => await _deleteBeer(context),
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BeerFormScreen(
                    beer: widget.beer,
                    firebaseService: widget.firebaseService,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.beer.imageUrl.isNotEmpty)
              Center(
                child: Image.network(
                  widget.beer.imageUrl,
                  height: 250,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, progress) {
                    return progress == null
                        ? child
                        : Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Icon(Icons.sports_bar_outlined),
                      title: Text(
                        widget.beer.style,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text('Style'),
                    ),
                    ListTile(
                      leading: Icon(Icons.business_outlined),
                      title: Text(
                        '${widget.beer.brewery}, ${widget.beer.country}',
                      ),
                      subtitle: Text('Brewery & Country'),
                    ),
                    ListTile(
                      leading: Icon(Icons.percent_outlined),
                      title: Text('${widget.beer.abv}% ABV'),
                      subtitle: Text('Alcohol by Volume'),
                    ),
                    ListTile(
                      leading: Icon(Icons.star_outline),
                      title: Text('${widget.beer.rating} / 5'),
                      subtitle: Text('Your Rating'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            if (widget.beer.flavour.isNotEmpty) ...[
              Text(
                'Flavour Profile',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 8),
              Text(widget.beer.flavour),
              SizedBox(height: 16),
            ],
            if (widget.beer.notes.isNotEmpty) ...[
              Text('Your Notes', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 8),
              Text(widget.beer.notes),
            ],
          ],
        ),
      ),
    );
  }
}
