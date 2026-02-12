class Badge {
  late final int id;
  late String name;
  late String description;
  late String img;

  Badge({required this.id, required this.name, required this.description, required this.img});

  @override
    String toString() {
      
      return "id: $id, name: $name, imgPath: $img";
    }
}