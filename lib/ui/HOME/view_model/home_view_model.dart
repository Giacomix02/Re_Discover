import 'package:flutter/foundation.dart';
import 'package:re_discover/data/states/state_hub.dart';
import 'package:re_discover/domain/models/cosmetic.dart';

import '../../../data/repositories/repository_hub.dart';


class HomeViewModel extends ChangeNotifier {
  bool isVisiting = false;
  final visitState = StateHub().visitState;

  List<Cosmetic> cosmetics = [];
  int selectedPfp = -1;


  void initState() async {
    cosmetics = await RepositoryHub().cosmetics;
    visitState.isVisiting.addListener(_onVisitStateChanged);
    StateHub().cosmeticState.addListener(_onCosmeticStateChanged);
    _updateSelectedPfp();
    await _onVisitStateChanged();
  }

  Future<void> _onVisitStateChanged() async {
    isVisiting = visitState.isVisiting.value;
    notifyListeners();
  }

  void _onCosmeticStateChanged() {
    _updateSelectedPfp();
  }

  void _updateSelectedPfp() {
    selectedPfp = StateHub().cosmeticState.pfpId;
    notifyListeners();
  }


}
