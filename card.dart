import 'package:flutter/material.dart';
import 'package:p25/main.dart';
import 'package:p25/models/movies.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final void Function(Movie) onTap;

  const MovieCard({Key? key, required this.movie, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => onTap(movie),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.network(
                '$imageBaseUrl${movie.posterPath}', // Display movie poster
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                movie.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for displaying a grid of movies
