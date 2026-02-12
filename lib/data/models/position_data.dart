import 'package:json_annotation/json_annotation.dart';

part 'position_data.g.dart';

@JsonSerializable()
class PositionData {
  late final int id ;
  late final double latitude;
  late final double longitude;

  PositionData({required this.id, required this.latitude, required this.longitude});

  factory PositionData.fromJson(Map<String, dynamic> json) => _$PositionDataFromJson(json);

  Map<String, dynamic> toJson() => _$PositionDataToJson(this);
}