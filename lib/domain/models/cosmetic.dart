class Cosmetic {
  late final int id;
  late String name;
  late String img;

  Cosmetic({required this.id,required this.name,required this.img});
  @override
    String toString() {
      
      return "id: $id, name: $name, imgPath: $img";
    }
}