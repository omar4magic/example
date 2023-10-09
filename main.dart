import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Recommendation System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Movie Recommendation System'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // The API key for the movie database
  final String apiKey = 'afdcd475833e8e0d4d610c1bbaa5bfbd';

  // The controller for the search text field
  final TextEditingController _controller = TextEditingController();

  // list of movies to display
  final List<Movie> _movies = [];

  // The flag to indicate if the app is loading data
  bool _loading = false;

  // method to fetch movies from the API based on the query
  Future<void> _fetchMovies(String query) async {
    // Set the loading flag to true and clear the previous movies
    setState(() {
      _loading = true;
      _movies.clear();
    });

    // Construct the URL for the API request
    final String url =
        'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$query';

    // Send a GET request to the URL and wait for the response
    final response = await http.get(Uri.parse(url));

    // If the response status code is 200 (OK)
    if (response.statusCode == 200) {
      // Parse the response body as a JSON object
      final data = jsonDecode(response.body);

      // Get the results array from the data object
      final results = data['results'] as List<dynamic>;

      // For each result in the results array
      for (final result in results) {
        // Create a new Movie object from the result and add it to the movies list
        final movie = Movie.fromJson(result);
        _movies.add(movie);
      }

      // Set the loading flag to false
      setState(() {
        _loading = false;
      });
    } else {
      // If the response status code is not 200, throw an exception
      throw Exception('Failed to load movies');
    }
  }

  // The method to fetch similar movies from the API based on the movie id
  Future<void> _fetchSimilarMovies(int id) async {
    // Set the loading flag to true and clear the previous movies
    setState(() {
      _loading = true;
      _movies.clear();
    });

    // Construct the URL for the API request
    final String url =
        'https://api.themoviedb.org/3/movie/$id/similar?api_key=$apiKey';

    // Send a GET request to the URL and wait for the response
    final response = await http.get(Uri.parse(url));

    // If the response status code is 200 (OK)
    if (response.statusCode == 200) {
      // Parse the response body as a JSON object
      final data = jsonDecode(response.body);

      // Get the results array from the data object
      final results = data['results'] as List<dynamic>;

      // For each result in the results array
      for (final result in results) {
        // Create a new Movie object from the result and add it to the movies list
        final movie = Movie.fromJson(result);
        _movies.add(movie);
      }

      // Set the loading flag to false
      setState(() {
        _loading = false;
      });
    } else {
      // If the response status code is not 200, throw an exception
      throw Exception('Failed to load similar movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              // Show a dialog with a text field to enter the search query
              final query = await showDialog<String>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Search for a movie'),
                  content: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter the movie title',
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        // Clear the text field and pop the dialog
                        _controller.clear();
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: const Text('Search'),
                      onPressed: () {
                        // Pop the dialog with the text field value
                        Navigator.pop(context, _controller.text);
                      },
                    ),
                  ],
                ),
              );

              // If the query is not null or empty, fetch the movies
              if (query != null && query.isNotEmpty) {
                _fetchMovies(query);
              }
            },
          ),
        ],
      ),
      body: _loading
          // If the app is loading, show a circular progress indicator
          ? const Center(
              child: CircularProgressIndicator(),
            )
          // If the app is not loading, show a grid view of movies
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.7,
              ),
              itemCount: _movies.length,
              itemBuilder: (context, index) {
                // Get the movie at the index
                final movie = _movies[index];

                // Return a card widget with the movie poster and title
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      // When the card is tapped, fetch the similar movies
                      _fetchSimilarMovies(movie.id);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            movie.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// A class to represent a movie
class Movie {
  final int id;
  final String title;
  final String posterPath;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'No Title', // Provide a default title
      posterPath:
          json['poster_path'] as String? ?? '', // Provide a default poster path
    );
  }
}
