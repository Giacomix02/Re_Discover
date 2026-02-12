import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:re_discover/data/repositories/data_repository_impl/user_repository.dart';
import 'package:re_discover/domain/models/user.dart';

class UserState extends ChangeNotifier {
  final UserRepository _userRepository;

  late User _user;
  User get user => _user;

  UserState(this._userRepository);

  Future<bool> loadUser() async {
    User? user = (await _userRepository.getLoggedInUser());
    if (user == null) {
      return false;
    }
    log(user.toString());
    _user = user;

    notifyListeners();
    return true;
  }
}
