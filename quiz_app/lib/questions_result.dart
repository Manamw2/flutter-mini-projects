import 'package:flutter/material.dart';

class QuestionsResult extends StatelessWidget {
  const QuestionsResult(this.summary, {super.key});
  final List<Map<String, String>> summary;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ...summary.map((item) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: item["answer"] == item["user_answer"]? Colors.blueAccent: Colors.pink),
                    child: Text(item["idx"] as String),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item["question"] as String,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(item["user_answer"] as String, style: const TextStyle(
                          color: Color.fromARGB(255, 213, 240, 240),
                          fontSize: 12,
                          ),
                          ),
                        Text(item["answer"] as String, style: const TextStyle(
                          color: Color.fromARGB(255, 50, 200, 246),
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                          ),),
                      ],
                    ),
                  )
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}
