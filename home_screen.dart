import 'package:flutter/material.dart';
import 'package:p25/screens/choose_page.dart';
import 'package:p25/screens/search_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Movie Recommendation System'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Search Movie'),
              Tab(text: 'Choose Preferences'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SearchPage(),
            ChoosePage(),
          ],
        ),
      ),
    );
  }
}
