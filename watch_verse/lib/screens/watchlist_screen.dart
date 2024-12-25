import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'movie_detail_screen.dart';
import 'package:watch_verse/models/model.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({Key? key}) : super(key: key);

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  String _selectedCategory = "To Watch"; // Default category

  /// Fetch movies from the subcollection corresponding to the selected category
  Future<List<Map<String, dynamic>>> _fetchWatchlist(String category) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    // Query the subcollection for the selected category
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('watchlist')
        .doc(category) // Access the subcollection for the selected category
        .collection('movies') // Movies subcollection under the category
        .get();

    // Convert Firestore documents to a list of maps
    final movies = querySnapshot.docs.map((doc) => doc.data()).toList();

    return movies;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedCategory = value;
              });
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: "To Watch", child: Text("To Watch")),
              PopupMenuItem(value: "Watched", child: Text("Watched")),
              PopupMenuItem(value: "Favorites", child: Text("Favorites")),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchWatchlist(_selectedCategory),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final watchlist = snapshot.data ?? [];
          if (watchlist.isEmpty) {
            return const Center(child: Text('Your watchlist is empty.'));
          }

          return ListView.builder(
            itemCount: watchlist.length,
            itemBuilder: (context, index) {
              final movie = watchlist[index];
              return ListTile(
                leading: movie['posterPath'] != null
                    ? Image.network(
                  "https://image.tmdb.org/t/p/w200/${movie['posterPath']}",
                  fit: BoxFit.cover,
                )
                    : const Icon(Icons.movie),
                title: Text(movie['title'] ?? 'No title'),
                subtitle: Text('Release Date: ${movie['releaseDate']}'),
                onTap: () {
                  // Convert Firestore map data to a Movie object
                  final movieObject = Movie.fromMap(movie);

                  // Navigate to Movie Details Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailsScreen(movie: movieObject),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
