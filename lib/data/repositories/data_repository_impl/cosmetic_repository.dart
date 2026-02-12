import 'package:re_discover/data/models/cosmetic_data.dart';
import 'package:re_discover/data/repositories/abstract_data_repository.dart';
import 'package:re_discover/data/repositories/static_repo_settings/paths.dart';
import 'package:re_discover/data/repositories/repository_hub.dart';
import 'package:re_discover/data/states/state_hub.dart';
import 'package:re_discover/domain/models/cosmetic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CosmeticRepository extends AbstractDataRepository<CosmeticData, Cosmetic> {
  CosmeticRepository(): super(
    path: Paths.cosmeticsPath,
    fromJson: CosmeticData.fromJson,
    toJson: (Cosmetic element) {
      CosmeticData cosmeticData = CosmeticData(id: element.id, name: element.name, img: element.img);
      return cosmeticData.toJson();
    },
    assignIds: (List data, Map<Types, AbstractDataRepository>? requiredData) {
      Map<int, Cosmetic> toSetToHolder = {};
      for (CosmeticData element in data) {
        toSetToHolder[element.id] = Cosmetic(id: element.id, name: element.name, img: element.img);
      }
      return toSetToHolder;
    });

    Future<Set<Cosmetic>> searchByIds(Set<int> ids) async {
      Set<Cosmetic> cosmetics = {};
      List<Cosmetic> list = await data;

      for (var cosmetic in list) {
        if (ids.contains(cosmetic.id)) {
          cosmetics.add(cosmetic);
        }
      }

      return cosmetics;
    }

    void setSelectedPfp(int id) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('selected_pfp_id', id);
      StateHub().cosmeticState.setPfpId(id);
    }

    void initializeSelectedPfp() async {
      print("INIZIALIZAZIONE");
      final prefs = await SharedPreferences.getInstance();
      int id = prefs.getInt('selected_pfp_id') ?? -1;
      StateHub().cosmeticState.setPfpId(id);
      print("INIZIALIZAZIONE A ID: ${id}");
    }
}