import 'dart:developer';

import 'package:re_discover/data/repositories/static_repo_settings/paths.dart';
import 'package:re_discover/data/repositories/repository_hub.dart';
import 'package:re_discover/data/states/state_hub.dart';
import 'package:re_discover/domain/models/cosmetic.dart';
import 'package:re_discover/domain/models/user.dart';
import 'package:re_discover/data/models/user_data.dart';
import 'package:re_discover/data/repositories/abstract_data_repository.dart';
import 'package:re_discover/domain/models/badge.dart';
import 'package:re_discover/domain/models/badge.dart' as ReDiscover;
import 'package:re_discover/gamification_engine/gamification_engine.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository extends AbstractDataRepository<UserData, User> {
  UserRepository()
    : super(
        path: Paths.usersPath,
        updateFunction: GamificationEngine().getRegisteredPlayers,
        fromJson: UserData.fromJson,
        toJson: (User element) {
          UserData userData = UserData(
            username: element.username,
            xp: element.xp,
            level: element.level,
            badgesID: element.badges.map((e) => e.id).toSet(),
            customizablesID: element.customizables.map((e) => e.id).toSet(),
            gems: element.gems,
          );
          return userData.toJson();
        },
        assignIds:
            (
              List<UserData> data,
              Map<Types, AbstractDataRepository>? requiredData,
            ) {
              Map<int, User> toSetToHolder = {};

              if (requiredData == null) {
                log("no required data set to UserRepository!!");
              }

              for (UserData element in data) {
                Set<Badge>? badges = element.badgesID
                    .map((id) => requiredData?[Types.badge]?.get(id))
                    .whereType<Badge>()
                    .toSet();

                Set<Cosmetic>? customizables = element.customizablesID
                    .map((id) => requiredData?[Types.customizable]?.get(id))
                    .whereType<Cosmetic>()
                    .toSet();

                if (badges.contains(null)) {
                  log(
                    "in User $UserData.id $UserData.name there's a badge not found in the holder: $badges",
                  );
                }
                if (customizables.contains(null)) {
                  log(
                    "in User $UserData.id $UserData.name there's a customizable not found in the holder: $customizables",
                  );
                }

                toSetToHolder[element.username.hashCode] = User(
                  username: element.username,
                  xp: element.xp,
                  level: element.level,
                  badges: badges,
                  customizables: customizables,
                  gems: element.gems,
                );
              }
              return toSetToHolder;
            },
      );

  Future<void> loginUser(String username) async {
    GamificationEngine gamificationEngine = GamificationEngine();
    bool isAvailable = await gamificationEngine.getAvailability();

    if (isAvailable) {
      await GamificationEngine().registerPlayer(username);
      UserData? data = await gamificationEngine.getPlayerState(username);
      if (data != null) {
        await storeUser(data);
        return;
      }
    }

    UserData data = UserData(
      username: username,
      xp: 0,
      level: 1,
      badgesID: {},
      customizablesID: {},
      gems: 0,
    );
    await storeUser(data);
  }

  Future<void> updateUser(String username) async {
    GamificationEngine gamificationEngine = GamificationEngine();
    bool isAvailable = await gamificationEngine.getAvailability();

    if (isAvailable) {
      UserData? data = await gamificationEngine.getPlayerState(username);
      if (data != null) {
        log(data.toString());
        await storeUser(data);
        return;
      }
    }
  }

  Future<void> storeUser(UserData data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getStringList("user") != null) {
        await prefs.remove("user");
      }

      bool save = await prefs.setStringList("user", [
        data.username.hashCode.toString(),
        data.username,
        data.xp.toString(),
        data.level.toString(),
        data.badgesID.toString(),
        data.customizablesID.toString(),
        data.gems.toString(),
      ]);

      print("Saved user $data: $save");
    } catch (e) {
      log("Error in storeUser: $e");
    }
  }

  // void updateUserXp(bool error) async {
  //   User? user = await getLoggedInUser();
  //   if(user == null) return;
  //   await GamificationEngineService().addXp(error, user.username);
  //   await updateUser(user.username);
  //   await StateHub().userState.loadUser();
  // }

  Future<void> updateUserXp(bool errorCommitted) async {
    GamificationEngine gamificationEngine = GamificationEngine();
    bool isAvailable = await gamificationEngine.getAvailability();

    if (isAvailable) {
      final username = StateHub().userState.user.username;

      await gamificationEngine.addXp(errorCommitted, username);

      await updateUser(username);

      await StateHub().userState.loadUser();
    }
  }

  Future<List<String>?> getTemporaryUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("user");
  }

  Future<User?> getLoggedInUser() async {
    var temporaryUser = await getTemporaryUser();
    var isTemporaryUserNull = temporaryUser == null;

    if (isTemporaryUserNull) return null;

    Set<ReDiscover.Badge> badges = {};
    Set<Cosmetic> cosmetics = {};

    final Set<int> badgeIds = _parseSetFromRawString(temporaryUser[4]);
    final Set<int> cosmeticIds = _parseSetFromRawString(temporaryUser[5]);

    cosmetics = await RepositoryHub().cosmeticRepository.searchByIds(
      cosmeticIds,
    );
    badges = await RepositoryHub().badgeRepository.searchByIds(badgeIds);

    return User(
      username: temporaryUser[1],
      xp: double.parse(temporaryUser[2]),
      level: int.parse(temporaryUser[3]),
      badges: badges,
      customizables: cosmetics,
      gems: int.parse(temporaryUser[6]),
    );
  }

  Set<int> _parseSetFromRawString(String raw) {
    // Rimuoviamo le parentesi graffe e spazi
    final clean = raw.replaceAll('{', '').replaceAll('}', '').trim();

    if (clean.isEmpty) return {};

    // Dividiamo per virgola, puliamo ogni elemento e convertiamo in int
    return clean
        .split(',')
        .map((e) => int.tryParse(e.trim()))
        .whereType<int>() // Rimuove eventuali null se il parsing fallisce
        .toSet();
  }

  Future<Map<User, int>> getPOIsCountAllUsers() async {
    GamificationEngine gamificationEngine = GamificationEngine();
    bool isAvailable = await gamificationEngine.getAvailability();

    if (!isAvailable) return {};
    Map<String, int> poisCountStringMap = await gamificationEngine
        .getUsersPoisCounts();

    Map<User, int> poisCountMap = {};

    List<User> users = await data;

    for (User user in users) {
      if (poisCountStringMap.containsKey(user.username)) {
        // This logic would populate a Map<User, int> based on the service results
        poisCountMap[user] = poisCountStringMap[user.username] ?? 0;
      } else {
        poisCountMap[user] =
            0; //if for some reason there isn't a user of the service call in the data holder... we do nothing about it at all!
      }
    }
    return poisCountMap;
  }
}
