import 'package:watch_verse/screens/movie_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:watch_verse/models/model.dart';
import 'package:watch_verse/services/api_service.dart';
import 'package:watch_verse/main.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final APIservices _apiServices = APIservices();
  List<Movie> _searchResults = [];
  List<String> _suggestions = []; // Max 4 unique suggestions
  bool _isLoading = false;
  String _currentQuery = '';

  /// Fetch movie suggestions and results based on user input
  Future<void> _fetchSuggestionsAndResults(String query) async {
    setState(() {
      _isLoading = true;
      _currentQuery = query;
    });

    try {
      // Fetch suggestions
      final suggestions = await _apiServices.getMovieSuggestions(query);

      // Fetch search results
      final results = await _apiServices.searchMovies(query);

      setState(() {
        _suggestions = suggestions.toSet().take(4).toList(); // Limit to max 4 unique suggestions
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkMode, // Global dark mode state
      builder: (context, isDark, _) {
        return Scaffold(
          backgroundColor: isDark ? Colors.black : Colors.white,
          appBar: AppBar(
            backgroundColor: isDark ? Colors.black : Colors.white,
            iconTheme: IconThemeData(
              color: isDark ? Colors.white : Colors.black, // Adjust icon color
            ),
            title: Text(
              "Search Movies",
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: "Search for movies...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.search, color: isDark ? Colors.white : Colors.black),
                    filled: true,
                    fillColor: isDark ? Colors.grey[900] : Colors.grey[200],
                    hintStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                  ),
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  onChanged: (query) {
                    if (query.trim().isNotEmpty) {
                      // Fetch suggestions and results if query is not empty
                      _fetchSuggestionsAndResults(query);
                    } else {
                      // Clear suggestions and results when query is empty
                      setState(() {
                        _suggestions = [];
                        _searchResults = [];
                      });
                    }
                  },
                ),
                const SizedBox(height: 8),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (_currentQuery.trim().isNotEmpty) // Show results only when a query exists
                  Expanded(
                    child: ListView(
                      children: [
                        // Suggestion List
                        if (_suggestions.isNotEmpty)
                          ..._suggestions.map((suggestion) {
                            return ListTile(
                              title: Text(
                                suggestion,
                                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                              ),
                              onTap: () {
                                // Perform search when suggestion is tapped
                                _fetchSuggestionsAndResults(suggestion);
                              },
                            );
                          }).toList(),
                        // Search Results
                        ..._searchResults.map((movie) {
                          return ListTile(
                            leading: movie.posterPath.isNotEmpty
                                ? Image.network(
                              "https://image.tmdb.org/t/p/w200/${movie.posterPath}",
                              fit: BoxFit.cover,
                            )
                                : const Icon(Icons.movie),
                            title: Text(
                              movie.title,
                              style: TextStyle(color: isDark ? Colors.white : Colors.black),
                            ),
                            subtitle: Text(
                              "Release Date: ${movie.releaseDate}",
                              style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                            ),
                            onTap: () {
                              // Navigate to movie details
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetailsScreen(movie: movie),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

