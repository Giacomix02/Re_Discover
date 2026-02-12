class Position {
  late final int id;
  late final double latitude;
  late final double longitude;

  Position({required this.id, required this.latitude, required this.longitude});

  @override
    String toString() {
      
      return "id: $id, latitude: $latitude, longitude: $longitude";
    }
}