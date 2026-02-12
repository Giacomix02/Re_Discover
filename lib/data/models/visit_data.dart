import 'package:json_annotation/json_annotation.dart';

part 'visit_data.g.dart';

@JsonSerializable()
class VisitData {
  late final int id;
  late int cityID;
  late Map<int, bool> visitedPOIs;

  VisitData({required this.id, required this.cityID, required this.visitedPOIs});

  factory VisitData.fromJson(Map<String, dynamic> json) => _$VisitDataFromJson(json);

  Map<String, dynamic> toJson() => _$VisitDataToJson(this);
}