import 'package:flutter/services.dart';

class DataRetriever {

  Future<String> retrieveData(String path) async {
    final serializedRetrievedData = await rootBundle.loadString(path);
    return serializedRetrievedData;
  }
}