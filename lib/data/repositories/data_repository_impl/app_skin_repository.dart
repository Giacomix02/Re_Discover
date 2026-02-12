import 'package:re_discover/data/models/app_skin_data.dart';
import 'package:re_discover/data/repositories/abstract_data_repository.dart';
import 'package:re_discover/data/repositories/static_repo_settings/paths.dart';
import 'package:re_discover/data/repositories/repository_hub.dart';
import 'package:re_discover/domain/models/app_skin.dart';
class AppSkinRepository extends AbstractDataRepository<AppSkinData, AppSkin> {
  AppSkinRepository(): super(
    path: Paths.appSkinPath,
    fromJson: AppSkinData.fromJson,
    toJson: (AppSkin element) {
      AppSkinData appSkinData = AppSkinData(id: element.id, skinPath: element.skinPath);
      return appSkinData.toJson();
    },
    assignIds: (List data, Map<Types, AbstractDataRepository>? requiredData) {
      Map<int, AppSkin> toSetToHolder = {};
      for (AppSkinData element in data) {
        toSetToHolder[element.id] = AppSkin(id: element.id, skinPath: element.skinPath);
      }
      return toSetToHolder;
    });
}
