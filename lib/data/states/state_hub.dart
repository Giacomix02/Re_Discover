import 'package:re_discover/data/repositories/repository_hub.dart';
import 'package:re_discover/data/states/city_state.dart';
import 'package:re_discover/data/states/cosmetic_state.dart';
import 'package:re_discover/data/states/navigator_state.dart';
import 'package:re_discover/data/states/user_state.dart';
import 'package:re_discover/data/states/visit_state.dart';

class StateHub {
  static final StateHub _instance = StateHub._internal();

  factory StateHub() => _instance;

  StateHub._internal();


  final _userRepository = RepositoryHub().userRepository;

  late final _userState = UserState(_userRepository);

  late final _visitState = VisitState();

  late final _cityState = CityState();

  late final _navigationState = NavigationState();

  late final _cosmeticState = CosmeticState();


  UserState get userState => _userState;
  VisitState get visitState => _visitState;
  CityState get cityState => _cityState;
  NavigationState get navigationState => _navigationState;
  CosmeticState get cosmeticState => _cosmeticState;

}
