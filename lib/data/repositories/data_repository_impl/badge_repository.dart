import 'package:re_discover/data/models/badge_data.dart';
import 'package:re_discover/data/repositories/abstract_data_repository.dart';
import 'package:re_discover/data/repositories/static_repo_settings/paths.dart';
import 'package:re_discover/data/repositories/repository_hub.dart';
import 'package:re_discover/domain/models/badge.dart';

import '../../../domain/models/badge.dart' as ReDiscover;

class BadgeRepository extends AbstractDataRepository<BadgeData, Badge> {
  BadgeRepository(): super(
    path: Paths.badgesPath,
    fromJson: BadgeData.fromJson,
    toJson: (Badge element) {
      BadgeData badgeData = BadgeData(id: element.id, name: element.name, description: element.description, img: element.img);
      return badgeData.toJson();
    },
    assignIds: (List data, Map<Types, AbstractDataRepository>? requiredData) {
      Map<int, Badge> toSetToHolder = {};
      for (BadgeData element in data) {
        toSetToHolder[element.id] = Badge(id: element.id, name: element.name, description: element.description, img: element.img);
      }
      return toSetToHolder;
    });

    Future<Set<Badge>> searchByIds(Set<int> ids) async {
      Set<ReDiscover.Badge> badges = {};
      List<ReDiscover.Badge> list = await data;

      for (var badge in list) {
        if (ids.contains(badge.id)) {
          badges.add(badge);
        }
      }

      return badges;
    }

}