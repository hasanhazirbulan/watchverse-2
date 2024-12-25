import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:watch_verse/models/model.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  bool _isAddedToWatchlist = false; // Indicates if the movie is in the watchlist
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Authentication instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance
  String _currentCategory = "To Watch"; // Default category

  @override
  void initState() {
    super.initState();
    _checkIfMovieInWatchlist();
  }

  /// Check if the movie is already in the user's watchlist
  Future<void> _checkIfMovieInWatchlist() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final querySnapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('watchlist')
            .doc(_currentCategory) // Check in the current category subcollection
            .collection('movies')
            .where('id', isEqualTo: widget.movie.id)
            .get();

        setState(() {
          _isAddedToWatchlist = querySnapshot.docs.isNotEmpty;
        });
      }
    } catch (e) {
      print('Error checking watchlist: $e');
    }
  }

  /// Add or remove the movie from the selected category's watchlist
  Future<void> _toggleWatchlist() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to manage your watchlist')),
        );
        return;
      }

      final moviesCollection = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('watchlist')
          .doc(_currentCategory) // Access the current category subcollection
          .collection('movies');

      if (_isAddedToWatchlist) {
        // Remove movie from watchlist
        final querySnapshot = await moviesCollection
            .where('id', isEqualTo: widget.movie.id)
            .get();

        for (var doc in querySnapshot.docs) {
          await doc.reference.delete();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.movie.title} removed from $_currentCategory')),
        );
      } else {
        // Add movie to watchlist
        await moviesCollection.add({
          'id': widget.movie.id,
          'title': widget.movie.title,
          'posterPath': widget.movie.posterPath,
          'releaseDate': widget.movie.releaseDate,
          'voteAverage': widget.movie.voteAverage,
          'overview': widget.movie.overview,
          'addedAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.movie.title} added to $_currentCategory')),
        );
      }

      setState(() {
        _isAddedToWatchlist = !_isAddedToWatchlist;
      });
    } catch (e) {
      print('Error toggling watchlist: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  /// Show dialog to select a category for the movie
  Future<void> _showCategoryDialog() async {
    String selectedCategory = "To Watch"; // Default category

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Watchlist Category"),
          content: DropdownButtonFormField<String>(
            value: selectedCategory,
            onChanged: (value) {
              selectedCategory = value!;
            },
            items: const [
              DropdownMenuItem(value: "To Watch", child: Text("To Watch")),
              DropdownMenuItem(value: "Watched", child: Text("Watched")),
              DropdownMenuItem(value: "Favorites", child: Text("Favorites")),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                setState(() {
                  _currentCategory = selectedCategory; // Update current category
                });
                _toggleWatchlist(); // Add to selected category's watchlist
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
        actions: [
          IconButton(
            icon: Icon(
              _isAddedToWatchlist ? Icons.check : Icons.add, // Toggle between check and add
              color: _isAddedToWatchlist ? Colors.green : Colors.orange, // Change icon color
            ),
            onPressed: _isAddedToWatchlist ? _toggleWatchlist : _showCategoryDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                "https://image.tmdb.org/t/p/w500/${widget.movie.posterPath}",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 100);
                },
              ),
              const SizedBox(height: 16),
              Text(
                widget.movie.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text("Release Date: ${widget.movie.releaseDate}"),
              const SizedBox(height: 8),
              Text("Average Vote: ${widget.movie.voteAverage}"),
              const SizedBox(height: 16),
              const Text(
                "Overview:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(widget.movie.overview),
            ],
          ),
        ),
      ),
    );
  }
}
