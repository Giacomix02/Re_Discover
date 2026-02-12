import 'package:json_annotation/json_annotation.dart';
import 'package:re_discover/domain/models/cosmetic.dart' as domain;

part 'cosmetic_data.g.dart';

@JsonSerializable()
class CosmeticData {
  late final int id;
  late String name;
  late String img;

  CosmeticData({required this.id, required this.name, required this.img});

  factory CosmeticData.fromJson(Map<String, dynamic> json) => _$CosmeticDataFromJson(json);

  Map<String, dynamic> toJson() => _$CosmeticDataToJson(this);

  domain.Cosmetic toDomain() {
    return domain.Cosmetic(
      id: id,
      name: name,
      img: img,
    );
  }
}