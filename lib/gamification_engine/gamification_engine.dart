import 'dart:developer';

import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:re_discover/data/models/user_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:re_discover/data/states/state_hub.dart';

const String baseURL = "https://gamification-api.polyglot-edu.com/gamification";

const String modelURL = "$baseURL/model/game/$gameID"; // not to be used

const String gameID = "697d01992657a80217381c9e";

const String playerManagingURL = "$baseURL/data/game/$gameID/player";

const String playerStatusURL = "$baseURL/gengine/state/$gameID";

const String actionExecutionURL = "$baseURL/gengine/execute";

const String badgesURL = "$modelURL/badges";

const String rulesURL = "$modelURL/rules";

final Map<String, String> httpHeaders = {
  'Authorization': ?dotenv.env['API_GAMIFICATION_ENGINE'],
  'Content-Type': 'application/json; charset=UTF-8',
};

class GamificationEngine {
  static final GamificationEngine _instance =
      GamificationEngine._internal();

  factory GamificationEngine() => _instance;

  GamificationEngine._internal();


  final int _pollingInterval = 2;

  Stream<bool>? _periodicAvailability;

  Stream <bool> getAvailabilityPeriodically() {
    _periodicAvailability ??= _getAvailabilityPeriodically().asBroadcastStream();
    return _periodicAvailability!;
  }


  Stream<bool> _getAvailabilityPeriodically() async* {
    yield await getAvailability();
    yield* Stream.periodic(Duration(seconds: _pollingInterval), (_) {
      return GamificationEngine().getAvailability();
    }).asyncMap((event) async => await event);
  }
  
  Future<bool> getAvailability() async {
    try {
       final response = await http.get(
      Uri.parse(modelURL),
      headers: httpHeaders,
    );
    if (response.statusCode == 200) {
      return true;
    }
    log("Engine unavailable, ${response.body}");
    
    } catch (e) {
      if (e is http.ClientException) {
        return false;
      }
    }
    
    return false;
   
    
  }

  Future<void> registerPlayer(String user) async {
    final Map<String, dynamic> json = {
      "id": user,
      "playerId": user,
      "gameId": gameID,
      "state": {},
      "levels": [],
      "inventory": {},
      "customData": {},
    };

    final response = await http.post(
      Uri.parse("$playerManagingURL/$user"),
      headers: httpHeaders,
      body: jsonEncode(json),
    );

    if (response.statusCode != 200) {
      log("Error registering player: ${response.statusCode}");
    }
  }

  Future addPoiVisited(String user) async {
    final Map<String, dynamic> json = {
      "gameId": gameID,
      "actionId": "poi_visited",
      "playerId": user,
    };

    final response = await http.post(
      Uri.parse(actionExecutionURL),
      headers: httpHeaders,
      body: jsonEncode(json),
    );

    if (response.statusCode != 200) {
      log("Error registering player: ${response.statusCode}");
    }
  }

  Future<UserData?> getPlayerState(String user) async {
    final response = await http.get(
      Uri.parse("$playerManagingURL/$user"),
      headers: httpHeaders,
    );

    if (response.statusCode != 200) {
      log("Error getting player state: ${response.statusCode}");
      return null;
    }

    return fromPlayerJson(jsonDecode(response.body));
  }

  Future<void> addXp(bool errors, String userId) async {
    String callParameters = errors ? "earn_xp_quiz_errors" : "earn_xp_quiz";

    final Map<String, dynamic> json = {
      "gameId": gameID,
      "actionId": callParameters,
      "playerId": userId,
    };
    final response = await http.post(
      Uri.parse(actionExecutionURL),
      headers: httpHeaders,
      body: jsonEncode(json),
    );
    if (response.statusCode != 200) {
      log("Error adding XP: ${response.statusCode}");
    }
  }

  void deletePlayer(String user) async {
    final response = await http.delete(
      Uri.parse("$playerManagingURL/$user"),
      headers: httpHeaders,
    );
    if (response.statusCode != 200) {
      log("Error deleting player: ${response.statusCode}");
    }
  }


  Future<int> getUserPOICount(String userId) async {
    final response = await http.get(
      Uri.parse("$playerManagingURL/$userId/state"),
      headers: httpHeaders,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      log(json.toString());
      // 1. Estraiamo la lista PointConcept in modo sicuro
      final List? pointList = json['state']?['PointConcept'];
      final poiEntry = pointList?.firstWhere(
        (element) => element['id'] == 'poi',
        orElse: () => null,
      );

      // 3. Estraiamo lo score. Se xpEntry è null (perché state era {}) mettiamo 0.0 // didn't even rename xp to poi oh well
      double userPoisCount = (poiEntry?['score'] ?? 0.0).toDouble();

      return userPoisCount.toInt();
    } else {
      log("Error getting user POI count: ${response.statusCode}");
      return 0;
    }
  }

  Future<Map<String, int>> getUsersPoisCounts({int size = 100}) async {
    final response = await http.get(
      Uri.parse("$playerStatusURL?size=$size"),
      headers: httpHeaders,
    );
    // log(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> jsonList = json["content"];
      Map<String, int> poisCountMap = {};

  
      for (Map<String, dynamic> json in jsonList) {
        final List? pointList = json['state']?['PointConcept'];
        final poiEntry = pointList?.firstWhere(
        (element) => element['id'] == 'poi',
        orElse: () => null,
      );
        // we didn't want PoisCount in the User class so I had to make this monstruosity... god help us all

        poisCountMap[json['playerId']] = (poiEntry?['score'] ?? 0.0).toInt();
      } 

      return poisCountMap;
    } else {
      log("Error getting registered players: ${response.statusCode}");
      return {};
    }
  }

  Future<List<UserData>?> getRegisteredPlayers({int size = 100}) async {
    bool isAvailable = await getAvailability();
    if (!isAvailable) return null;
    final response = await http.get(
      Uri.parse("$playerStatusURL?size=$size"),
      headers: httpHeaders,
    );
    // log(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> jsonList = json["content"];

      return jsonList.cast<Map<String, dynamic>>().map(fromPlayerJson).toList();
    } else {
      log("Error getting registered players: ${response.statusCode}");
      return null;
    }
  }


  // void _executeAction(
  //   String user,
  //   ActionId actionId, {
  //   Map<String, dynamic> params = const {},
  // }) async {
  //   final Map<String, dynamic> json = {
  //     "gameId": gameID,
  //     "actionId": actionId.id,
  //     "playerId": user,
  //     "data": params,
  //   };

  //   final response = await http.post(
  //     Uri.parse(actionExecutionURL),
  //     headers: httpHeaders,
  //     body: jsonEncode(json),
  //   );
  //   if (response.statusCode != 200) {
  //     log("Error executing action $actionId: ${response.statusCode}");
  //   }
  // }
}

// enum ActionId {
//   earnXp("earn_xp");

//   final String id;

//   const ActionId(this.id);
// }

UserData fromPlayerJson(Map<String, dynamic> json) {
  // 1. Estraiamo la lista PointConcept in modo sicuro
  // Se 'state' o 'PointConcept' mancano, pointList sarà null
  final List? pointList = json['state']?['PointConcept'];

  // Cerchiamo l'elemento che ha id == "xp" invece di usare l'indice [2]
  // Questo lo rende immune a cambi di ordine nel JSON
  final xpEntry = pointList?.firstWhere(
    (element) => element['id'] == 'xp',
    orElse: () => null,
  );
  double userXP = (xpEntry?['score'] ?? 0.0).toDouble();

  // estraggo le gems
  final gemsEntry = pointList?.firstWhere(
        (element) => element['id'] == 'gems',
    orElse: () => null,
  );
  int userGems = (gemsEntry?['score'] ?? 0).toInt();


  // Livello: gestiamo il caso in cui 'levels' sia vuoto o nullo
  int userLevel = 1;
  if (json['levels'] != null && (json['levels'] as List).isNotEmpty) {
    userLevel = parserInt(json['levels'][0]['levelValue'].toString(), 1);
  }

  // Estraggo badges e customizables
  final List? badgesAndCosmetics = json['state']?['BadgeCollectionConcept'];

  // Estraggo i badges e faccio un for per estrarre gli int
  final badges = badgesAndCosmetics?.firstWhere(
        (element) => element['id'] == 'badges',
    orElse: () => null,
  );
  List badgesListString = (badges?['badgeEarned'] ?? []);
  Set<int> badgesSetID = {};
  for (var string in badgesListString) {
    badgesSetID.add(parserInt(string, 0));
  }


  // Estraggo i customizables e faccio un for per estrarre gli int
  final cosmetics = badgesAndCosmetics?.firstWhere(
        (element) => element['id'] == 'cosmetics',
    orElse: () => null,
  );
  List cosmeticsListString = (cosmetics?['badgeEarned'] ?? []);
  Set<int> cosmeticsSetID = {};
  for (var string in cosmeticsListString) {
    cosmeticsSetID.add(parserInt(string, 0));
  }



  return UserData(
    username: json['playerId'] ?? 'Unknown',
    xp: userXP,
    level: userLevel,
    badgesID: badgesSetID,
    customizablesID: cosmeticsSetID,
    gems: userGems,
  );
}

int parserInt(String value, int defaultValue) {
  return int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? defaultValue;
}