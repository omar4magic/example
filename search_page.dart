import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:p25/main.dart';
import 'package:p25/models/movies.dart';
import 'package:p25/screens/recommendtion_page.dart';
import 'package:p25/widget/movie_grid.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<Movie> _movies = [];
  bool _loading = false;
  String _errorMessage = '';
  Future<List<Movie>> getSimilarMovies(int movieId) async {
    String url = '$baseUrl/movie/$movieId/similar?api_key=$apiKey';

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var results = data['results'] as List;

      return results.map((result) => Movie.fromJson(result)).toList();
    } else {
      throw Exception('Failed to get similar movies');
    }
  }

  Future<void> _search(String query) async {
    setState(() {
      _loading = true;
      _movies = [];
      _errorMessage = '';
    });

    String url = '$baseUrl/search/movie?api_key=$apiKey&query=$query';

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var results = data['results'] as List;

        setState(() {
          _loading = false;
          _movies = results.map((result) => Movie.fromJson(result)).toList();
        });
      } else {
        throw Exception('Failed to search movies');
      }
    } catch (e) {
      print('Exception occurred: $e');
      setState(() {
        _loading = false;
        _errorMessage = 'Failed to search for movies. Please try again.';
      });
    }
  }

  Future<List<Movie>> getMoviesByCriteria(
    int genreId,
    double rating,
    int year,
  ) async {
    // API call to get movies based on criteria
    String url =
        '$baseUrl/discover/movie?api_key=$apiKey&with_genres=$genreId&vote_average.gte=$rating&primary_release_year=$year';

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var results = data['results'] as List;

      return results.map((result) => Movie.fromJson(result)).toList();
    } else {
      throw Exception('Failed to get movies by criteria');
    }
  }

  void gotoAnotherPage(List<Movie> similarMovies, Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecommendationPage(
          title: 'Movies similar to ${movie.title}',
          movies: similarMovies,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search and choose a movie'), // Search page title
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter a movie name',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _search(_controller.text), // Search button
                ),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                    ? Center(child: Text(_errorMessage))
                    : MovieGrid(
                        movies: _movies,
                        onMovieTap: (movie) async {
                          var similarMovies = await getSimilarMovies(movie.id);
                          gotoAnotherPage(similarMovies, movie);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
