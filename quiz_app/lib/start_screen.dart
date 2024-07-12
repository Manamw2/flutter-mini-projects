import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StartPage extends StatelessWidget {
  const StartPage(this.toQuestionsPage, {super.key});

  final void Function() toQuestionsPage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/quiz-logo.png",
          width: 300,
          color: const Color.fromRGBO(255, 255, 255, 0.588),
        ),
        const SizedBox(
          height: 80,
        ),
        Text(
          "Learn Flutter The Fun Way!",
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 235, 204, 244),
            fontSize: 24,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        OutlinedButton.icon(
          onPressed: toQuestionsPage,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          ),
          icon: const Icon(Icons.arrow_right_alt),
          label: const Text(
            "Start Quiz",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ],
    );
  }
}
