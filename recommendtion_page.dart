import 'package:flutter/material.dart';
import 'package:p25/models/movies.dart';
import 'package:p25/widget/movie_grid.dart';

class RecommendationPage extends StatelessWidget {
  final String title;
  final List<Movie> movies;

  const RecommendationPage({
    Key? key,
    required this.title,
    required this.movies,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: movies.isEmpty
          ? const Center(
              child: Text('No movies found for the given criteria.'),
            )
          : MovieGrid(
              movies: movies,
              onMovieTap: (movie) {
                // Handle tap on recommended movie if needed
              },
            ),
    );
  }
}
