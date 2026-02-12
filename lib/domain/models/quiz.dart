class Quiz {
  late final int id;
  late String description;
  late List<Question> questions;
  late int maxTry;

  Quiz._withMaxTry(this.id, this.description, this.questions, this.maxTry);
  Quiz._withoutMaxTry(this.id, this.description, this.questions) : maxTry=questions.length;

  factory Quiz({required int id, required String description, required List<Question> questions, int? maxTry}) {
    if(maxTry != null) {
      return Quiz._withMaxTry(id, description, questions, maxTry);
    }else{
      return Quiz._withoutMaxTry(id, description, questions);
    }
  }
  @override
    String toString() {
      
      return "id: $id, description: $description, questions: $questions, maxTry: $maxTry";
    }
}

class Question {
  late String questionText;
  late List<String> answers;
  late int correctOptionIndex;

  Question({required this.questionText, required this.answers, required this.correctOptionIndex});
  @override
    String toString() {
      
      return "questionText: $questionText, answers: $answers, correctOptionIndex: $correctOptionIndex";
    }
}
