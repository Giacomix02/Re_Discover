import 'package:flutter/material.dart';

class ListenableDataHolder <T> extends ChangeNotifier {
  // This class will be responsible for holding data and notifying listeners when it changes.
  Map<int, T> _data = {}; // Map of ID to object, intended use is inputting an object ID to get the desired object

  Map<int, T> get data => _data;
  List<T> get values => _data.values.toList();

  void setData(Map<int, T> newData) {
    _data = newData;
    notifyListeners();
  }

  bool isEmpty() => _data.isEmpty;

  T? get(int id) => _data[id];

  
}