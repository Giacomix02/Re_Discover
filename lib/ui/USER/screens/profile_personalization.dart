import 'package:flutter/material.dart';
import 'package:re_discover/domain/models/cosmetic.dart';
import 'package:re_discover/ui/USER/widgets/profile_picture_card.dart';

import '../../../data/states/state_hub.dart';

class ProfilePersonalization extends StatelessWidget {
  const ProfilePersonalization({super.key, required this.cosmetics, required this.unlockedCosmetics, required this.selectedPfp});

  final List<Cosmetic> cosmetics;
  final List<int> unlockedCosmetics;
  final int selectedPfp;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              scrolledUnderElevation: 0,
              pinned: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: const Text(
                'Cosmetics',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverGrid.count(
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                childAspectRatio: 0.95,
                children: <Widget>[
                  ...cosmetics.map((cosmetic) => ListenableBuilder(
                    listenable: StateHub().cosmeticState,
                    builder: (context, child) {
                      return ProfilePictureCard(
                        id: cosmetic.id,
                        iconProfile: cosmetic.img,
                        titleProfile: cosmetic.name,
                        unlocked: unlockedCosmetics.contains(cosmetic.id),
                        equipped: cosmetic.id == StateHub().cosmeticState.pfpId,
                      );
                    },
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}