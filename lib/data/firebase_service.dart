import 'dart:io';

import 'package:booze_app/data/beer.dart';
import 'package:booze_app/data/sort_option.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  FirebaseService({
    required this.auth,
    required this.firestore,
    required this.storage,
  });

  factory FirebaseService.instance() {
    return FirebaseService(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
      storage: FirebaseStorage.instance,
    );
  }

  factory FirebaseService.override(
    FirebaseAuth auth,
    FirebaseFirestore firestore,
    FirebaseStorage storage,
  ) {
    return FirebaseService(auth: auth, firestore: firestore, storage: storage);
  }

  /// Sign the current user out
  Future<void> signOut() async {
    await auth.signOut();
  }

  /// build the search query
  Query<Map<String, dynamic>> buildSearchQuery(SortOption sortOption) {
    final User user = auth.currentUser!;
    Query<Map<String, dynamic>> query = firestore
        .collection('users')
        .doc(user.uid)
        .collection('beers');

    switch (sortOption) {
      case SortOption.nameAsc:
        query = query.orderBy('nameLowercase', descending: false);
        break;
      case SortOption.nameDesc:
        query = query.orderBy('nameLowercase', descending: true);
        break;
      case SortOption.createdByAsc:
        query = query.orderBy('createdAt', descending: false);
        break;
      case SortOption.createdByDesc:
        query = query.orderBy('createdAt', descending: true);
        break;
      case SortOption.ratingAsc:
        query = query.orderBy('rating', descending: false);
        break;
      case SortOption.ratingDesc:
        query = query.orderBy('rating', descending: true);
        break;
    }
    return query;
  }

  /// Sign the user in with email and password
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw FirebaseServiceException(
        message: e.message ?? '',
        code: e.code,
        serviceType: 'auth',
      );
    }
  }

  /// Create a new user from email and password
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw FirebaseServiceException(
        message: e.message ?? '',
        code: e.code,
        serviceType: 'auth',
      );
    }
  }

  /// Write a new beer record to Firestore
  Future<void> createBeer(Beer beer) async {
    final User user = auth.currentUser!;
    final beerCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('beers');

    await beerCollection.add(beer.toFirestore());
  }

  /// Update an existing beer record to Firestore
  Future<void> updateBeer(Beer beer) async {
    final User user = auth.currentUser!;
    final beerCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('beers');

    await beerCollection.doc(beer.id).update(beer.toFirestore());
  }

  /// Method to delete a beer record from Firestore and its image from Storage
  Future<void> deleteBeer(Beer beer) async {
    try {
      // Delete the Firestore document
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('beers')
          .doc(beer.id)
          .delete();

      // Delete the image
      deleteBeerImage(beer.imageUrl);
    } catch (e) {
      throw Exception('Failed to delete beer: $e');
    }
  }

  /// Delete the image from Firebase Storage
  Future<void> deleteBeerImage(String imageUrl) async {
    if (imageUrl.isNotEmpty) {
      await FirebaseStorage.instance.refFromURL(imageUrl).delete();
    }
  }

  /// upload a new image to firestore
  Future<String> uploadImage(File image) async {
    final User user = auth.currentUser!;
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('beer_images')
        .child('${user.uid}/${DateTime.now().toIso8601String()}.jpg');

    await storageRef.putFile(image);
    return storageRef.getDownloadURL();
  }
}

class FirebaseServiceException implements Exception {
  FirebaseServiceException({
    required this.message,
    required this.code,
    required this.serviceType,
  });

  /// The long form message of the exception.
  final String message;

  /// The code to accommodate the message.
  final String code;

  /// The firebase service raising the error
  final String serviceType;
}
