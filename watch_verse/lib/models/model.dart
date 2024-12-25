class Movie {
  final int id;
  final String title;
  final String overview; // Description of the movie
  final String posterPath; // Path for the poster image
  final String backDropPath; // Path for the backdrop image
  final String releaseDate; // Release date of the movie
  final double voteAverage; // Average vote score

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backDropPath,
    required this.releaseDate,
    required this.voteAverage,
  });

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      overview: map['overview'] ?? '',
      posterPath: map['poster_path'] ?? map['posterPath'] ?? '', // Handle both naming conventions
      backDropPath: map['backdrop_path'] ?? map['backDropPath'] ?? '', // Handle both naming conventions
      releaseDate: map['release_date'] ?? map['releaseDate'] ?? '', // Handle both naming conventions
      voteAverage: map['vote_average']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath, // Ensure consistent naming when saving to Firestore
      'backdrop_path': backDropPath,
      'release_date': releaseDate,
      'vote_average': voteAverage,
    };
  }
}
