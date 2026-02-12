import 'package:json_annotation/json_annotation.dart';

part 'city_data.g.dart';

@JsonSerializable()
class CityData{
  late final int id;
  late String name;
  late String image;
  late int positionID;
  late String description;
  late Set<int> poisID;

  CityData({required this.id, required this.name, required this.image, required this.description, required this.positionID, required this.poisID});

  factory CityData.fromJson(Map<String, dynamic> json) => _$CityDataFromJson(json);

  Map<String, dynamic> toJson() => _$CityDataToJson(this);
}