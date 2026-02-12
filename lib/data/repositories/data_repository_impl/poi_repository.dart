import 'dart:developer';
import 'package:re_discover/data/models/poi_data.dart';
import 'package:re_discover/data/repositories/abstract_data_repository.dart';
import 'package:re_discover/data/repositories/static_repo_settings/paths.dart';
import 'package:re_discover/data/repositories/repository_hub.dart';
import 'package:re_discover/domain/models/poi.dart';
import 'package:re_discover/domain/models/quiz.dart';
import 'package:re_discover/domain/models/position.dart';


class POIRepository extends AbstractDataRepository<POIData, POI> {
  POIRepository(): super(
    path: Paths.poisPath,
    fromJson: POIData.fromJson,
    toJson: (POI element) {
      POIData poiData = POIData(id: element.id, name: element.name, description: element.description, images: element.images, quizzesId: element.quizzes.map((element) => element.id).toList(), qrCode: element.qrCode, positionId: element.position.id);
      return poiData.toJson();
      },
    assignIds: (List<POIData> data, Map<Types, AbstractDataRepository>? requiredData) {

      Map<int, POI> toSetToHolder = {};

      if(requiredData == null) log("no required data set to POIRepository!!");

      for (POIData element in data) {

        Position? position = requiredData?[Types.position]?.get(element.positionId);
        List<Quiz> quizzes = element.quizzesId.map((id) => requiredData?[Types.quiz]?.get(id)).whereType<Quiz>().toList();
        // List<String> images = element.imagesId.map((id) => requiredData?[String]?.get(id)).whereType<String>().toList();

        if (position == null){
          log("in POI $POIData.id $POIData.name the position was not found in the holder");
          continue;
        }
        if (quizzes.contains(null)) log("in POI $POIData.id $POIData.name there's a quiz not found in the holder: $quizzes");
        // if (images.contains(null)) log("in POI $POIData.id $POIData.name there's an image not found in the holder: $images");

        toSetToHolder[element.id] = POI(id: element.id, name: element.name, description: element.description, images: element.images, quizzes: quizzes, qrCode: element.qrCode, position: position);
      }

      return toSetToHolder;
    }
  );

}
