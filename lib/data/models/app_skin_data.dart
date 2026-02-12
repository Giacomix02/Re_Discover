import 'package:json_annotation/json_annotation.dart';
import 'package:re_discover/domain/models/app_skin.dart' as domain;

part 'app_skin_data.g.dart';

@JsonSerializable()
class AppSkinData {
  late final int id;
  late String skinPath;

  AppSkinData({required this.id, required this.skinPath});

  factory AppSkinData.fromJson(Map<String, dynamic> json) => _$AppSkinDataFromJson(json);

  Map<String, dynamic> toJson() => _$AppSkinDataToJson(this);

  domain.AppSkin toDomain() {
    return domain.AppSkin(
      id: id,
      skinPath: skinPath,
    );
  }
}