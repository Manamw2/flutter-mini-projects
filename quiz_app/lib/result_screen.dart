import 'package:flutter/material.dart';
import 'package:quiz_app/data/questions.dart';
import 'package:quiz_app/questions_result.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen(this.answers, this.restartQuiz, {super.key});
  final List<String> answers;
  final void Function() restartQuiz;

  List<Map<String, String>> getSummary() {
    final List<Map<String, String>> summary = [];
    for (int i = 0; i < answers.length; i++) {
      summary.add({
        "idx": (i + 1).toString(),
        "question": questions[i].question,
        "answer": questions[i].answers[0],
        "user_answer": answers[i],
      });
    }
    return summary;
  }

  @override
  Widget build(BuildContext context) {
    final summary = getSummary();
    final questionCount = questions.length;
    final correctAnswersCount = summary.where((data) {
      return data["answer"] == data["user_answer"];
    }).length;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "You answered $correctAnswersCount out of $questionCount questions correctly",
          style: const TextStyle(color: Colors.white, fontSize: 24),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        QuestionsResult(summary),
        const SizedBox(height: 30),
        TextButton.icon(
            onPressed: restartQuiz,
            icon: const Icon(Icons.restart_alt),
            label: const Text(
              "Restart Quiz",
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
              iconColor: Colors.white,
            ))
      ],
    );
  }
}
