import 'package:re_discover/data/repositories/data_repository_impl/app_skin_repository.dart';
import 'package:re_discover/data/repositories/data_repository_impl/badge_repository.dart';
import 'package:re_discover/data/repositories/data_repository_impl/city_repository.dart';
import 'package:re_discover/data/repositories/data_repository_impl/cosmetic_repository.dart';
import 'package:re_discover/data/repositories/data_repository_impl/hint_repository.dart';
import 'package:re_discover/data/repositories/data_repository_impl/poi_repository.dart';
import 'package:re_discover/data/repositories/data_repository_impl/position_repository.dart';
import 'package:re_discover/data/repositories/data_repository_impl/quiz_repository.dart';
import 'package:re_discover/data/repositories/data_repository_impl/user_repository.dart';
import 'package:re_discover/data/repositories/data_repository_impl/visit_repository.dart';
import 'package:re_discover/data/states/state_hub.dart';
import 'package:re_discover/domain/models/app_skin.dart';
import 'package:re_discover/domain/models/badge.dart';
import 'package:re_discover/domain/models/city.dart';
import 'package:re_discover/domain/models/cosmetic.dart';
import 'package:re_discover/domain/models/hint.dart';
import 'package:re_discover/domain/models/poi.dart';
import 'package:re_discover/domain/models/position.dart';
import 'package:re_discover/domain/models/quiz.dart';
import 'package:re_discover/domain/models/user.dart';
import 'package:re_discover/domain/models/visit.dart';
import 'package:re_discover/gamification_engine/gamification_engine.dart';


enum Types {
  city,
  poi,
  quiz,
  badge,
  customizable,
  hint,
  user,
  position,
  appSkin,
  visit
}

class RepositoryHub {
  // This class will be responsible for retrieving data from the data layer
  // and providing it to the logic layer.
  static final RepositoryHub _instance = RepositoryHub._internal();

  factory RepositoryHub() => _instance;


  final BadgeRepository badgeRepository = BadgeRepository();
  final CosmeticRepository cosmeticRepository = CosmeticRepository();
  final AppSkinRepository appSkinRepository = AppSkinRepository();

  final QuizRepository quizRepository = QuizRepository();
  final HintRepository hintRepository = HintRepository();

  final PositionRepository positionRepository = PositionRepository();

  final UserRepository userRepository = UserRepository();

  final POIRepository poiRepository = POIRepository();
  final VisitRepository visitRepository = VisitRepository();
  final CityRepository cityRepository = CityRepository();
    
  RepositoryHub._internal() { // Set required repositories here
    
    userRepository.setRequiredData({
      Types.badge: badgeRepository,
      Types.customizable: cosmeticRepository,
    });

    poiRepository.setRequiredData({Types.quiz: quizRepository, Types.position: positionRepository});
    visitRepository.setRequiredData({Types.poi: poiRepository, Types.city: cityRepository});
    cityRepository.setRequiredData({Types.poi: poiRepository, Types.position: positionRepository});
  }

  
  Future<List<Badge>> get badges => badgeRepository.data;
  Future<List<Cosmetic>> get cosmetics => cosmeticRepository.data;
  Future<List<AppSkin>> get appSkins => appSkinRepository.data;
  Future<List<Quiz>> get quizzes => quizRepository.data;
  Future<List<Hint>> get hints => hintRepository.data;
  Future<List<Position>> get positions => positionRepository.data;
  Future<List<User>> get users => userRepository.data;
  Future<List<Visit>> get visits => visitRepository.data;
  Future<List<POI>> get pois => poiRepository.data;
  Future<List<City>> get cities => cityRepository.data;

  Future addPoiVisited(String user) async{  
    await GamificationEngine().addPoiVisited(user);
    await StateHub().visitState.getPOIsCount();
  }
}


  