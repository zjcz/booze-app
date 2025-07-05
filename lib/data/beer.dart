import 'package:cloud_firestore/cloud_firestore.dart';

class Beer {
  final String id;
  final String name;
  final String brewery;
  final String country;
  final String style;
  final double abv;
  final String flavour;
  final String notes;
  final String imageUrl;
  final int rating;
  final DateTime createdAt;

  Beer({
    required this.id,
    required this.name,
    required this.brewery,
    required this.country,
    required this.style,
    required this.abv,
    required this.flavour,
    required this.notes,
    required this.imageUrl,
    required this.rating,
    required this.createdAt,
  });

  // A factory constructor to create a Beer from a Firestore document
  factory Beer.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Beer(
      id: documentId,
      name: data['name'] ?? '',
      brewery: data['brewery'] ?? '',
      country: data['country'] ?? '',
      style: data['style'] ?? '',
      abv: (data['abv'] ?? 0.0).toDouble(),
      flavour: data['flavour'] ?? '',
      notes: data['notes'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      rating: (data['rating'] ?? 0).toInt(),
      // Firestore stores Timestamps, so we convert it to a DateTime object
      createdAt: (data['createdAt'] as Timestamp? ?? Timestamp.now()).toDate(),
    );
  }

  // A method to convert a Beer object to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'nameLowercase': name.toLowerCase(),
      'brewery': brewery,
      'country': country,
      'style': style,
      'abv': abv,
      'flavour': flavour,
      'notes': notes,
      'imageUrl': imageUrl,
      'rating': rating,
      'createdAt': Timestamp.fromDate(
        createdAt,
      ), // Convert DateTime to Timestamp
    };
  }
}
