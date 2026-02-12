import 'package:flutter/foundation.dart';
import 'package:re_discover/domain/models/city.dart';

class CityState extends ChangeNotifier {
  City? _selectedCity;

  City? get selectedCity => _selectedCity;

  void selectCity(City city) {
    _selectedCity = city;
    notifyListeners();
  }

  void clearSelectedCity() {
    _selectedCity = null;
    notifyListeners();
  }
}

