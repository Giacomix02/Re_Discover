
import 'package:re_discover/data/models/hint_data.dart';
import 'package:re_discover/data/repositories/abstract_data_repository.dart';
import 'package:re_discover/data/repositories/static_repo_settings/paths.dart';
import 'package:re_discover/data/repositories/repository_hub.dart';
import 'package:re_discover/domain/models/hint.dart';

class HintRepository extends AbstractDataRepository<HintData, Hint> {
  HintRepository(): super(
    path: Paths.hintsPath,
    fromJson: HintData.fromJson,
    toJson: (Hint element) {
      HintData hintData = HintData(id: element.id, description: element.description, images: element.images);
      return hintData.toJson();
    },
    assignIds: (List data, Map<Types, AbstractDataRepository>? requiredData) {
      Map<int, Hint> toSetToHolder = {};
      for (HintData element in data) {
        toSetToHolder[element.id] = Hint(id: element.id, description: element.description, images: element.images);
      }
      return toSetToHolder;
    });
}