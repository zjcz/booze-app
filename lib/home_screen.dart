import 'package:booze_app/data/beer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'beer_form_screen.dart'; 
import 'beer_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Booze App'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _auth.signOut(),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('beers')
            .orderBy('name', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong.'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No beers added yet!'));
          }
          final beerDocs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: beerDocs.length,
            itemBuilder: (context, index) {
              final beer = Beer.fromFirestore(
                beerDocs[index].data() as Map<String, dynamic>,
                beerDocs[index].id,
              );

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BeerDetailScreen(beer: beer),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(beer.imageUrl),
                    radius: 30,
                  ),
                  title: Text(
                    beer.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${beer.brewery}, ${beer.country}\nStyle: ${beer.style} | ABV: ${beer.abv}%',
                  ),
                  trailing: beer.isFavorite
                      ? Icon(Icons.star, color: Colors.amber)
                      : null,
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            // Navigate to the form with no beer object to add a new one
            MaterialPageRoute(builder: (context) => BeerFormScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
