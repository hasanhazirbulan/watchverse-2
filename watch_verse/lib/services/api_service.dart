import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:watch_verse/models/model.dart';

const apiKey = "0b168b40d626ffdbd23540f26ceb63b0";

class APIservices {
  final nowShowingApi =
      "https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey";
  final upComingApi =
      "https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey";
  final popularApi =
      "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey";
  final searchApi =
      "https://api.themoviedb.org/3/search/movie?api_key=$apiKey";
  // for nowShowing moveis
  Future<List<Movie>> getNowShowing() async {
    Uri url = Uri.parse(nowShowingApi);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception("Failed to load data");
    }
  }

  // for up coming moveis
  Future<List<Movie>> getUpComing() async {
    Uri url = Uri.parse(upComingApi);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception("Failed to load data");
    }
  }
  Future<List<Movie>> searchMovies(String query) async {
    final searchApi =
        "https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$query";
    Uri url = Uri.parse(searchApi);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception("Failed to search movies");
    }
  }
  Future<List<String>> getMovieSuggestions(String query) async {
    if (query.isEmpty) {
      return [];
    }

    final Uri url = Uri.parse('$searchApi&query=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      List<String> suggestions = data
          .map((movie) => movie['title'] as String)
          .take(10) // Maksimum 10 öneri
          .toList();
      return suggestions;
    } else {
      throw Exception("Failed to fetch suggestions");
    }
  }

  // for popular moves
  Future<List<Movie>> getPopular() async {
    Uri url = Uri.parse(popularApi);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception("Failed to load data");
    }
  }
}
