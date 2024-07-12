import 'package:flutter/material.dart';
import 'package:quiz_app/start_screen.dart';
import 'package:quiz_app/questions_screen.dart';
import 'package:quiz_app/data/questions.dart';
import 'package:quiz_app/result_screen.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});
  @override
  State<StatefulWidget> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  List<String> answers = [];
  var activeScreen = "start_screen";

  void storeAnswer(answer) {
      answers.add(answer);
    if (answers.length == questions.length) {
      setState(() {
        activeScreen = 'results-screen';
    });
  }
  }

  @override
  void initState() {
    activeScreen = "start_screen";
    super.initState();
  }

  void changeState() {
    setState(() {
      activeScreen = "questions_screen";
    });
  }

  void restartQuiz(){
    setState(() {
      activeScreen = "start_screen";
      answers = [];
    });
  }

  Widget getScreen() {
    if (activeScreen == "start_screen") {
      return StartPage(changeState);
    } else if (activeScreen == "questions_screen") {
      return Questions(storeAnswer);
    } else {
      return ResultScreen(answers, restartQuiz);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 62, 20, 135),
            Color.fromARGB(255, 104, 8, 121),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: getScreen(),
    );
  }
}
