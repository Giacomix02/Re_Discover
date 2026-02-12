import 'dart:convert';
import 'package:re_discover/data/services/data_retriever.dart';

class DataBaker<T> {
  final dataRetriever = DataRetriever();
  final T Function(Map<String, dynamic>) fromJson;
  final String path;

  DataBaker({required this.path, required this.fromJson});

  Future<List<T>> bakeDataModels() async {
    final serializedRetrievedData = await dataRetriever.retrieveData(path);
    final decodedSerializedRetrievedData = jsonDecode(serializedRetrievedData) as Map<String, dynamic>;

    List<T> data = [];

    for (var element in (decodedSerializedRetrievedData["ReDiscoverData"] as List<dynamic>)) {
      data.add(fromJson(element));
    }


    return data;
  }

}