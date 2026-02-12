class Hint {
  final int id;
  late String description;
  late List<String> images;

  Hint({required this.id, required this.description, required this.images});
  @override
    String toString() {
      
      return "id: $id, description: $description, images: $images ";
    }
}