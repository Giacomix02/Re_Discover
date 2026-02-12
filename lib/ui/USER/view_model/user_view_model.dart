import 'package:flutter/foundation.dart';
import 'package:re_discover/data/repositories/repository_hub.dart';
import 'package:re_discover/data/states/state_hub.dart';
import 'package:re_discover/domain/models/badge.dart';
import 'package:re_discover/domain/models/cosmetic.dart';

class UserViewModel extends ChangeNotifier {
  List<Badge> badges = [];
  List<Cosmetic> cosmetics = [];

  int selectedPfp = -1;
  bool isLoading = true;

  List<int> unlockedBadges = [];
  List<int> unlockedCosmetics = [];

  Future<void> initState() async {
    StateHub().userState.addListener(_onUserStateChanged);
    StateHub().cosmeticState.addListener(_onCosmeticStateChanged);
    await _updateBadgesCosmetics();
    _updateSelectedPfp();
    isLoading = false;
    notifyListeners();
  }

  void _onUserStateChanged() {
    _updateBadgesCosmetics();
    notifyListeners();
  }

  void _onCosmeticStateChanged() {
    _updateSelectedPfp();
  }

  void _updateSelectedPfp() {
    selectedPfp = StateHub().cosmeticState.pfpId;
    notifyListeners();
  }

  Future<void> _updateBadgesCosmetics() async {
    badges = await RepositoryHub().badges;
    cosmetics = await RepositoryHub().cosmetics;

    unlockedBadges.clear();
    unlockedCosmetics.clear();

    for (var badge in StateHub().userState.user.badges) {
      unlockedBadges.add(badge.id);
    }

    for (var cosmetic in StateHub().userState.user.customizables) {
      unlockedCosmetics.add(cosmetic.id);
    }

    notifyListeners();
  }
}

