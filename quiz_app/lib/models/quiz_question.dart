
class QuizQuestion{
  const QuizQuestion(this.question, this.answers);
  final String question;
  final List<String> answers;
  List<String> shuffleAnswers(){
    var x = List.of(answers);
    x.shuffle();
    return x;
  }
}