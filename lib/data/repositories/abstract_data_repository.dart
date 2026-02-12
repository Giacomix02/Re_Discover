import 'dart:async';
import 'dart:developer';
import 'package:re_discover/data/models/listenable_data_holder.dart';
import 'package:re_discover/data/repositories/data_baker.dart';
import 'package:re_discover/data/repositories/repository_hub.dart';


/// it's ideal to not instantiate this and extending classes for resource access, but instead use RepositoryHub for that purpose
abstract class AbstractDataRepository<TData, T> {

  ListenableDataHolder<T> holder = ListenableDataHolder<T>(); // the data container

  /// The path from which to fetch data
  final String path;

  /// The function necessary for extracting data from json, defined in each [Model]Data
  late TData Function(Map<String, dynamic>) fromJson; 

  /// Necessary repositories for building objects made of objects, use the enum in RepositoryHub for the key, the corresponding repository itself as the value
  Map<Types, AbstractDataRepository>? requiredData;

  /// Optional function to use to get the list of data instead of fetching it from local json placeholder data
  late Future<List<TData>?> Function()? updateFunction; 

  /// Function to specify how to create T objects from TData objects, using the requiredData defined earlier
  /// The objects should be inserted following the pattern (object.ID, object)
  late Map<int, T> Function(List<TData>, Map<Types, AbstractDataRepository>? requiredData) assignIds;
  
  /// Function that converts T objects to TData objects, used for updating JSON files
  late Map<String, dynamic> Function(T) toJson;
  
  

  Future<void>? updateFutureLock; // lock necessary to prevent multiple simultaneous executions of the same update function



  AbstractDataRepository({required this.path, required this.fromJson, required this.assignIds, required this.toJson, this.updateFunction, this.requiredData});


  void setRequiredData(Map<Types, AbstractDataRepository> data) {
    requiredData = data;
  }

  Future<List<T>> get data async { // to be eventually expanded when update versions are introduced, comparing update versions, and if different, execute update
    if(holder.data.isEmpty) await update();
    return holder.data.values.toList();
  }

  T? get (int id) => holder.data[id];

  

  Future<List<TData>> _getData (TData Function(Map<String, dynamic>) fromJson) async {
    DataBaker<TData> dataBaker = DataBaker<TData>(path: path, fromJson: fromJson);
    return await dataBaker.bakeDataModels();
  }   

  Future<void> update() async {
    if (updateFutureLock != null) {
      return updateFutureLock;
    }

    final completer = Completer<void>();
    updateFutureLock = completer.future;
    
    try {
      List<TData>? data = [];
      if(updateFunction != null) {
        data = await updateFunction!();
        if(data == null) {
          log("no user data fetched from Gamification Engine");
          return;
        }
      } else {
        data = await _getData(fromJson);
      }

      if (requiredData != null) {
      List<Future<void>> requiredUpdatesFutures = (requiredData?.values ?? []).map((repo) => repo.update()).toList();
      if (requiredUpdatesFutures.isNotEmpty) await Future.wait(requiredUpdatesFutures);
      }
      Map<int, T> toSetToHolder = assignIds(data, requiredData);

      holder.setData(toSetToHolder);
      completer.complete();

    } catch (e, s) {
      completer.completeError(e, s);
      log(e.toString());
      log(s.toString());
      rethrow;

    } finally {
      updateFutureLock = null;
    }

  }

}