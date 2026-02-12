import 'package:json_annotation/json_annotation.dart';
import 'package:re_discover/domain/models/quiz.dart' as domain;

part 'quiz_data.g.dart';

@JsonSerializable(explicitToJson: true)
class QuizData {
  late final int id;
  late String description;
  late List<QuestionData> questions;
  late int maxTry;

  QuizData._withMaxTry(this.id, this.description, this.questions, this.maxTry);
  QuizData._withoutMaxTry(this.id, this.description, this.questions) : maxTry = questions.length;

  factory QuizData({required int id, required String description, required List<QuestionData> questions, int? maxTry})
  {
    if(maxTry != null) {
      return QuizData._withMaxTry(id, description, questions, maxTry);
    } else {
      return QuizData._withoutMaxTry(id, description, questions);
    }
  }

  factory QuizData.fromJson(Map<String, dynamic> json) => _$QuizDataFromJson(json);

  Map<String, dynamic> toJson() => _$QuizDataToJson(this);

  domain.Quiz toDomain() {
    return domain.Quiz(
      id: id,
      description: description,
      questions: questions.map((questions) => domain.Question(
        questionText: questions.questionText,
        answers: questions.answers,
        correctOptionIndex: questions.correctOptionIndex,
      )).toList(),
      maxTry: maxTry,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class QuestionData {
  late String questionText;
  late List<String> answers;
  late int correctOptionIndex;

  QuestionData({required this.questionText, required this.answers, required this.correctOptionIndex});

  factory QuestionData.fromJson(Map<String, dynamic> json) => _$QuestionDataFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionDataToJson(this);
}
