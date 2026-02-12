import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:re_discover/data/repositories/repository_hub.dart';
import 'package:re_discover/domain/models/city.dart';

class CitySelectorViewModel extends ChangeNotifier {
  List<City> _allCities = [];
  String _searchQuery = '';

  CitySelectorViewModel() {
    _loadCities();
  }


  UnmodifiableListView<City> get citiesToDisplay {
    if (_searchQuery.isEmpty) {
      return UnmodifiableListView(_allCities);
    } else {
      return UnmodifiableListView(_allCities
          .where((city) =>
              city.name.toLowerCase().startsWith(_searchQuery.toLowerCase()))
          .toList());
    }
  }

  Future<void> _loadCities() async {
    _allCities = await RepositoryHub().cities;
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query.trim();
    notifyListeners();
  }

}
