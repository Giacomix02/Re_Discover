import 'dart:developer';

import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:re_discover/data/models/user_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

class GamificationEngineService {
  static final GamificationEngineService _instance =
      GamificationEngineService._internal();

  factory GamificationEngineService() => _instance;

  GamificationEngineService._internal();

  

}
