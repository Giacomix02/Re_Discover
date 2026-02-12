import 'package:flutter/foundation.dart';
import 'package:re_discover/data/repositories/repository_hub.dart';
import 'package:re_discover/data/states/state_hub.dart';

class MainViewModel extends ChangeNotifier {
  final _userRepository = RepositoryHub().userRepository;
  final _userState = StateHub().userState;


  MainViewModel();

  Future<bool> shouldOobeBeRunned() async {

    var user = await _userRepository.getLoggedInUser();

    if (user == null) return true;

    await _userState.loadUser();
    return false;
  }


}
