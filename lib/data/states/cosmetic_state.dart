import 'package:flutter/material.dart';

class CosmeticState extends ChangeNotifier {
  late int pfpId = -1;

  void setPfpId(int id) {
    pfpId = id;
    notifyListeners();
  }

  int get getPfpId => pfpId;

}