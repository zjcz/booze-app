import 'package:booze_app/about_screen.dart';
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

enum SortOption {
  nameAsc,
  nameDesc,
  createdByAsc,
  createdByDesc,
  ratingAsc,
  ratingDesc,
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  SortOption _selectedSortOption = SortOption.nameAsc; // Default sort option
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Query<Map<String, dynamic>> _buildQuery(User user) {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('beers');

    switch (_selectedSortOption) {
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

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booze App'),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.view_module),
            tooltip: 'Toggle View',
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort_by_alpha),
            tooltip: 'Sort by',
            onSelected: (SortOption result) {
              setState(() {
                _selectedSortOption = result;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOption>>[
              const PopupMenuItem<SortOption>(
                value: SortOption.nameAsc,
                child: Text('Name (A-Z)'),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.nameDesc,
                child: Text('Name (Z-A)'),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.createdByAsc,
                child: Text('Added (Oldest First)'),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.createdByDesc,
                child: Text('Added (Newest First)'),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.ratingAsc,
                child: Text('Rating (Low to High)'),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.ratingDesc,
                child: Text('Rating (High to Low)'),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _auth.signOut(),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            tooltip: 'More Options',
            itemBuilder: (BuildContext bc) {
              return const [
                PopupMenuItem(value: 'about', child: Text("About...")),
              ];
            },
            onSelected: (value) async {
              if (value == 'about') {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => AboutScreen()));
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search beers...',
                contentPadding: EdgeInsets.all(5),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _buildQuery(user!).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong.'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No beers added yet!'));
                }
                final allBeers = snapshot.data!.docs.map((doc) {
                  return Beer.fromFirestore(
                    doc.data() as Map<String, dynamic>,
                    doc.id,
                  );
                }).toList();

                final filteredBeers = (_searchQuery.isEmpty)
                    ? allBeers
                    : allBeers.where((beer) {
                        final query = _searchQuery.toLowerCase();
                        return beer.name.toLowerCase().contains(query) ||
                            beer.brewery.toLowerCase().contains(query) ||
                            beer.style.toLowerCase().contains(query);
                      }).toList();

                if (filteredBeers.isEmpty) {
                  return const Center(child: Text('No matching beers found.'));
                }
                if (_isGridView) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: filteredBeers.length,
                    itemBuilder: (context, index) {
                      final beer = filteredBeers[index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    BeerDetailScreen(beer: beer),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Center(
                                  child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(beer.imageUrl),
                                    radius: 50,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  beer.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0),
                                child: Text(
                                  '${beer.brewery}, ${beer.country}',
                                  style:
                                      Theme.of(context).textTheme.bodySmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    8.0, 4.0, 8.0, 8.0),
                                child: Text(
                                  '${beer.style} | ${beer.abv}% ABV',
                                  style:
                                      Theme.of(context).textTheme.bodySmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return ListView.builder(
                    itemCount: filteredBeers.length,
                    itemBuilder: (context, index) {
                      final beer = filteredBeers[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    BeerDetailScreen(beer: beer),
                              ),
                            );
                          },
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(beer.imageUrl),
                            radius: 30,
                          ),
                          title: Text(
                            beer.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${beer.brewery}, ${beer.country}\nStyle: ${beer.style} | ABV: ${beer.abv}%',
                          ),
                          trailing: beer.isFavorite
                              ? const Icon(Icons.star,
                                  color: Colors.amber)
                              : null,
                          isThreeLine: true,
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            // Navigate to the form with no beer object to add a new one
            MaterialPageRoute(builder: (context) => BeerFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
