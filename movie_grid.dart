import 'package:flutter/material.dart';
import 'package:p25/models/movies.dart';
import 'package:p25/widget/card.dart';

class MovieGrid extends StatelessWidget {
  final List<Movie> movies;
  final void Function(Movie) onMovieTap;

  const MovieGrid({Key? key, required this.movies, required this.onMovieTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: movies.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index) {
        return MovieCard(
          key: ValueKey(movies[index].id),
          movie: movies[index],
          onTap: onMovieTap,
        );
      },
    );
  }
}
