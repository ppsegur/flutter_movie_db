import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_movie_db_api/models/movie.dart';


class MovieService {
  String apiUrl = '81819d9750b41c41923effa77112f27a';

  MovieService({required this.apiUrl});

  Future<List<Movie>> fetchMovies() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'] as List;
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
