class AppSkin {
  late final int id;
  late String skinPath;

  AppSkin({required this.id, required this.skinPath});

  @override
    String toString() {
      
      return "id: $id, skinPath: $skinPath";
    }
}