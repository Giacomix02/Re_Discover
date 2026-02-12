import 'package:json_annotation/json_annotation.dart';
import 'package:re_discover/domain/models/badge.dart' as domain;

part 'badge_data.g.dart';

@JsonSerializable()
class BadgeData {
  late final int id;
  late String name;
  late String description;
  late String img;

  BadgeData({required this.id, required this.name, required this.description, required this.img});

  factory BadgeData.fromJson(Map<String, dynamic> json) => _$BadgeDataFromJson(json);

  Map<String, dynamic> toJson() => _$BadgeDataToJson(this);

  domain.Badge toDomain() {
    return domain.Badge(
      id: id,
      name: name,
      description: description,
      img: img,
    );
  }
}