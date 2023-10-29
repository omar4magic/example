import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:p25/screens/home_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      done: const Text("Done"),
      next: const Text("Next"),
      onDone: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      },
      pages: [
        PageViewModel(
          body: "testsetet",
          image: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Image.network(
              "https://placehold.co/600x400",
              fit: BoxFit.cover,
            ),
          ),
          title: "Hello",
        ),
        PageViewModel(
          body: "testsetet",
          image: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Image.network(
              "https://placehold.co/600x400",
              fit: BoxFit.cover,
            ),
          ),
          title: "Hello2",
        ),
        PageViewModel(
          body: "testsetet",
          image: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Image.network(
              "https://placehold.co/600x400",
              fit: BoxFit.cover,
            ),
          ),
          title: "Hello3",
        ),
      ],
    );
  }
}
