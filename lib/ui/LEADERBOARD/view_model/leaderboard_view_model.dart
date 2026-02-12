import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:re_discover/data/repositories/data_repository_impl/user_repository.dart';
import 'package:re_discover/data/repositories/repository_hub.dart';
import 'package:re_discover/data/states/state_hub.dart';
import 'package:re_discover/domain/models/user.dart';
import 'package:re_discover/ui/LEADERBOARD/screen/leaderboard_screen.dart';

class LeaderboardViewModel extends ChangeNotifier {

  User user = StateHub().userState.user;

  ValueNotifier<int> get poisCount => StateHub().visitState.poisCount;

  Future<Map<User, int>> poiCountMap = Future(() => {});

  UserRepository userRepository = RepositoryHub().userRepository;

  Future<List<User>> orderedList = Future(() => []);

  Future<int> userRank = Future(() => 0,);
  
  
  Categories selectedCategory = Categories.xp;
  // Categories? orderedByCategory;


  LeaderboardViewModel() {
    selectedCategory = Categories.xp;
  
    // Ascolta i cambiamenti di UserState
    StateHub().userState.addListener(_onUserStateChanged);
    init();
  }


  Future<void> init() async {
    updateLeaderboard();
  }

  void _onUserStateChanged() {
    refreshUser();
  }

  void refreshUser() {
    user = StateHub().userState.user;
    notifyListeners();
  }

  

  Future<void> updateLeaderboard() async {
    await userRepository.update();
    if (selectedCategory == Categories.poi)
      {
        poiCountMap = userRepository.getPOIsCountAllUsers();
      }
    
    orderedList = userRepository.data;
    await sortLeaderboard();
    
    notifyListeners();
  }

  Future<List<User>> getLeaderboard() async {

      
      List<User> list = await orderedList; 

      // if(selectedCategory == orderedByCategory) { // if user changes score, we can't check for it
      //   return orderedList;
      // }

      if (list.isEmpty) {
        list = await userRepository.data;
      }
      // await orderList(list);

    return orderedList;
  }

  // Future<Map<User, int>> getPoiCountMap() async {
  //   Map<User,int> map = await poiCountMap;
  //   if (map.isEmpty)
  //     {
  //       poiCountMap = userRepository.getPOIsCountAllUsers();
  //       return map;
  //     }
  //   else {
  //     return map;
  //   }
  // }

  Future<void> sortLeaderboard() async {
    List<User> toSort = await orderedList;
    orderedList = Completer<List<User>>().future;

    switch (selectedCategory) {
        case Categories.xp:
          toSort.sort((a, b) => b.xp.compareTo(a.xp));
          break;
        case Categories.poi:

          Map pois = await poiCountMap;

          toSort.sort((a, b) => pois[b].compareTo(pois[a]));
          break;
    }
    userRank = Future.value(toSort.indexWhere((userInSort) => userInSort.username == user.username,) + 1);
    log("userRank: $userRank");
    orderedList = Future.value(toSort);
  }

  void changeCategory(Categories newCategory) {
    selectedCategory = newCategory;
    if (selectedCategory == Categories.poi)
      {
        poiCountMap = userRepository.getPOIsCountAllUsers();
      }
    
    // sortLeaderboard();
    notifyListeners();
  }
  @override
  void dispose() {
    StateHub().userState.removeListener(_onUserStateChanged);
    super.dispose();
  }
  
  
}
