import 'package:json_annotation/json_annotation.dart';

part 'user_data.g.dart';

@JsonSerializable()
class UserData {
  // late final int id;
  late String username;
  late double xp;
  late int level;
  late int gems;
  late Set<int> badgesID;
  late Set<int> customizablesID;

  UserData({required this.username, required this.xp, required this.level, required this.badgesID, required this.customizablesID, required this.gems});

  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);

}