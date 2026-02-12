import 'dart:developer';

import 'package:re_discover/data/models/visit_data.dart';
import 'package:re_discover/data/repositories/static_repo_settings/paths.dart';
import 'package:re_discover/data/repositories/repository_hub.dart';
import 'package:re_discover/domain/models/city.dart';
import 'package:re_discover/domain/models/poi.dart';
import 'package:re_discover/domain/models/visit.dart';
import 'package:re_discover/data/repositories/abstract_data_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VisitRepository extends AbstractDataRepository<VisitData, Visit> {
  VisitRepository(): super(
      path: Paths.visitsPath,
      fromJson: VisitData.fromJson,
      toJson: (Visit element) {
        VisitData visitData = VisitData(id: element.id, cityID: element.city!.id, visitedPOIs: element.visitedPOIs.map((key, value) => MapEntry(key.id, value)));
        return visitData.toJson();
      },
      assignIds: (List<VisitData> data, Map<Types, AbstractDataRepository>? requiredData) {

        Map<int, Visit> toSetToHolder = {};

        if(requiredData == null) log("no required data set to VisitRepository!!");

        for (VisitData element in data) {

          City? city = requiredData?[Types.city]?.get(element.cityID);

          late Map<POI, bool> visitedPOIs = {};
          List<POI> pois = element.visitedPOIs.keys.map((e) => requiredData?[Types.poi]?.get(e)).whereType<POI>().toList();
          List<bool> visitedFlags = element.visitedPOIs.values.toList();
          if (pois.length != visitedFlags.length) {
            log("in Visit ${element.id} there's a mismatch between POIs and visited flags lengths");
          }
           else { visitedPOIs = Map<POI, bool>.fromIterables(pois, visitedFlags);
          }

          if (city == null) log("in Visit $VisitData.id $VisitData.name the city was not found in the holder");
          if (visitedPOIs.containsKey(null)) log("in Visit $VisitData.id $VisitData.name there's a POI not found in the holder: $pois");

          toSetToHolder[element.id] = Visit(id: element.id, city: city, visitedPOIs: visitedPOIs);
        }

        return toSetToHolder;
      }
  );

  // Remember: if you are visiting a city, then you don't need to store the boolean value isVisiting,
  // because the getCurrentVisit() will return null if the user is not visiting a city

  Future<void> storeCurrentVisit(Visit visit) async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getStringList("visit") != null) prefs.remove("visit");
    prefs.setStringList("visit", [visit.id.toString(), visit.city!.id.toString(), visit.visitedPOIs.keys.map((e) => e.id).toString(), visit.visitedPOIs.values.toString()]);
  }

  Future<List<String>?> getCurrentVisit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("visit");
  }

}
