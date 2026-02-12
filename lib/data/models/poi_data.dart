import 'package:json_annotation/json_annotation.dart';

part 'poi_data.g.dart';

@JsonSerializable()
class POIData {
  late final int id;
  late String name;
  late String description;
  late List<String> images;
  late List<int> quizzesId;
  late String qrCode;
  late int positionId;

  POIData({required this.id, required this.name, required this.description, required this.images, required this.quizzesId, required this.qrCode, required this.positionId});

  factory POIData.fromJson(Map<String, dynamic> json) => _$POIDataFromJson(json);

  Map<String, dynamic> toJson() => _$POIDataToJson(this);

}
