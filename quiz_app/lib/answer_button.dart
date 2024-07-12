import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  const AnswerButton(this.answer, this.onAnswerChoosed, {super.key});
  final String answer;
  final void Function() onAnswerChoosed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onAnswerChoosed,
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
            backgroundColor: const Color.fromARGB(255, 19, 2, 22),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(40)))),
        child: Text(
          answer,
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ));
  }
}
