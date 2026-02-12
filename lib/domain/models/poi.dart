import 'package:re_discover/domain/models/position.dart';
import 'package:re_discover/domain/models/quiz.dart';

class POI{
  late final int id;
  late String name;
  late String description;
  late List<String> images; // ID -> String sorry mano I had to make this change, we'll think about this later
  late List<Quiz> quizzes;
  late String qrCode;
  late Position position;

  POI({required this.id, required this.name, required this.description, required this.images, required this.quizzes, required this.qrCode, required this.position});

  @override
    String toString() {
      
      return "id: $id, name: $name, description: $description, qrCode: $qrCode, position: $position, quizzes: $quizzes, images: $images";
    }
}
