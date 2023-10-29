import 'package:flutter/material.dart';
import 'package:p25/screens/intro_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const IntroScreen(),
    );
  }
}

// Constants for API and base URLs

const String apiKey = 'afdcd475833e8e0d4d610c1bbaa5bfbd';
const String baseUrl = 'https://api.themoviedb.org/3';
const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
