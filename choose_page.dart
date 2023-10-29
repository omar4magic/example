import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:p25/main.dart';
import 'package:p25/models/movies.dart';
import 'package:p25/screens/recommendtion_page.dart';

class ChoosePage extends StatefulWidget {
  const ChoosePage({Key? key}) : super(key: key);

  @override
  _ChoosePageState createState() => _ChoosePageState();
}

class _ChoosePageState extends State<ChoosePage> {
  final List<Map<String, dynamic>> _genres = [
    {'id': 28, 'name': 'Action'},
    {'id': 12, 'name': 'Adventure'},
    {'id': 16, 'name': 'Animation'},
    {'id': 35, 'name': 'Comedy'},
    {'id': 80, 'name': 'Crime'},
    {'id': 18, 'name': 'Drama'},
    {'id': 10751, 'name': 'Family'},
    {'id': 14, 'name': 'Fantasy'},
    {'id': 36, 'name': 'History'},
    {'id': 27, 'name': 'Horror'},
    {'id': 10402, 'name': 'Music'},
    {'id': 9648, 'name': 'Mystery'},
    {'id': 10749, 'name': 'Romance'},
    {'id': 878, 'name': 'Science Fiction'},
    {'id': 10770, 'name': 'TV Movie'},
    {'id': 53, 'name': 'Thriller'},
    {'id': 10752, 'name': 'War'},
    {'id': 37, 'name': 'Western'},
  ];

  int _selectedGenre = 28; // Default: Action
  double _selectedRating = 7.0; // Default: 7.0
  int _selectedYear = DateTime.now().year; // Default: Current year
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

// Function to get movies by criteria (genre, rating, year)
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

  void gotoPage(List<Movie> recommendedMovies) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecommendationPage(
          title: 'Recommended Movie',
          movies: recommendedMovies,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Preferences'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<int>(
              value: _selectedGenre,
              items: _genres
                  .map(
                    (genre) => DropdownMenuItem<int>(
                      value: genre['id'],
                      child: Text(
                        genre['name'] as String,
                      ), // Genre selection dropdown
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGenre = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Minimum Rating: ${_selectedRating.toStringAsFixed(1)}'),
                Slider(
                  value: _selectedRating,
                  min: 1,
                  max: 10,
                  divisions: 9,
                  onChanged: (value) {
                    setState(() {
                      _selectedRating = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Year: $_selectedYear'), // Dropdown for selecting year
                DropdownButton<int>(
                  value: _selectedYear,
                  items: List.generate(30, (index) {
                    return DropdownMenuItem<int>(
                      value: DateTime.now().year - index,
                      child: Text((DateTime.now().year - index).toString()),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      _selectedYear = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                List<Movie> recommendedMovies = await getMoviesByCriteria(
                  _selectedGenre,
                  _selectedRating,
                  _selectedYear,
                );
                gotoPage(recommendedMovies);
                if (recommendedMovies.isNotEmpty) {
                } else {
                  // Handle no movie found for the criteria
                }
              },
              child: const Text('Get Recommendation'),
            ),
          ],
        ),
      ),
    );
  }
}
