import 'package:re_discover/data/models/position_data.dart';
import 'package:re_discover/data/repositories/abstract_data_repository.dart';
import 'package:re_discover/data/repositories/static_repo_settings/paths.dart';
import 'package:re_discover/data/repositories/repository_hub.dart';
import 'package:re_discover/domain/models/position.dart';

class PositionRepository extends AbstractDataRepository<PositionData, Position>{
  PositionRepository(): super(
    path: Paths.positionsPath,
    fromJson: PositionData.fromJson,
    toJson: (Position element) {
      PositionData positionData = PositionData(id: element.id, latitude: element.latitude, longitude: element.longitude);
      return positionData.toJson();
    },
    assignIds: (List data, Map<Types, AbstractDataRepository>? requiredData) {
      Map<int, Position> toSetToHolder = {};
      for (PositionData element in data) {
        
        toSetToHolder[element.id] = Position(id: element.id, latitude: element.latitude, longitude: element.longitude);
      }
      return toSetToHolder;
    });
}