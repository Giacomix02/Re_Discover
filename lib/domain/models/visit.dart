import 'package:re_discover/domain/models/poi.dart';
import 'city.dart';


class Visit {
  late final int id;
  late City? city;
  late Map<POI, bool> visitedPOIs;

  Visit({required this.id, required this.city, required this.visitedPOIs});

  @override
    String toString() {
      return "id: $id, city: $city, visitedPOIs: $visitedPOIs";
    }
}