import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quiz_app/data/questions.dart';
import 'answer_button.dart';
import 'package:google_fonts/google_fonts.dart';

class Questions extends StatefulWidget {
  const Questions(this.onAnswerChoosed, {super.key});
  final void Function(String answer) onAnswerChoosed;
  @override
  State<StatefulWidget> createState() {
    return _QuestionState();
  }
}

class _QuestionState extends State<Questions> {
  var questionNumber = 0;
  void goNextQuestion(answer) {
    setState(() {
      questionNumber += 1;
      widget.onAnswerChoosed(answer);
    });
  }

  @override
  Widget build(BuildContext context) {
    var question = questions[questionNumber];
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              question.question,
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 235, 204, 244),
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ...question
                .shuffleAnswers()
                .map((answer) => AnswerButton(answer, () {
                      goNextQuestion(answer);
                    })),
          ],
        ));
  }
}
