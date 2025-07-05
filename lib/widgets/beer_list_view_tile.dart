import 'package:booze_app/data/beer.dart';
import 'package:flutter/material.dart';

class BeerListViewTile extends StatelessWidget {
  final Beer beer;
  final Function(Beer) onTap;
  const BeerListViewTile({super.key, required this.beer, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        onTap: () => onTap(beer),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(beer.imageUrl),
          radius: 30,
        ),
        title: Text(
          beer.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${beer.brewery}, ${beer.country}\nStyle: ${beer.style} | ABV: ${beer.abv}%',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, color: Colors.amber),
            Text('${beer.rating} / 5'),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
