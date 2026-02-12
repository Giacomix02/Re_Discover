import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:re_discover/data/states/state_hub.dart';
import 'package:re_discover/data/states/user_state.dart';
import 'package:re_discover/ui/USER/screens/badges_screen.dart';
import 'package:re_discover/ui/USER/screens/profile_personalization.dart';
import 'package:re_discover/ui/USER/view_model/user_view_model.dart';
import 'package:re_discover/ui/USER/widgets/users_infos_cards.dart';
import 'package:re_discover/ui/core/widgets/level_card.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel()..initState()),
        ChangeNotifierProvider.value(value: StateHub().userState)
      ],
      child: const UserScreenContent(),
    );
  }
}

class UserScreenContent extends StatelessWidget {
  const UserScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final userViewModel = context.watch<UserViewModel>();
    final userState = context.watch<UserState>();

    if (userViewModel.isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.deepPurple.shade600,
                    Colors.deepPurple.shade800,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 16,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.purple.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: userViewModel.selectedPfp == -1 || userViewModel.cosmetics.isEmpty
                                    ? Icon(Icons.account_circle, size: 100, color: Colors.purple.shade300)
                                    : Text(
                                        userViewModel.cosmetics[userViewModel.selectedPfp].img,
                                        style: const TextStyle(fontSize: 60),
                                      ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ProfilePersonalization(
                                        cosmetics: userViewModel.cosmetics,
                                        unlockedCosmetics: userViewModel.unlockedCosmetics,
                                        selectedPfp: userViewModel.selectedPfp,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.deepPurple.shade600, width: 3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.edit_rounded,
                                    size: 20,
                                    color: Colors.deepPurple.shade600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Text(
                        userState.user.username,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Level Badge
                            Row(
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  color: Colors.amber.shade300,
                                  size: 24,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Level ${userState.user.level}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),

                            // Divisore
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              width: 1,
                              height: 24,
                              color: Colors.white.withValues(alpha: 0.4),
                            ),

                            // Gems
                            Row(
                              children: [
                                Icon(
                                  Icons.diamond,
                                  color: Colors.pink.shade300,
                                  size: 22,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${userState.user.gems}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 📋 Quick Actions Section
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Menu Buttons in una riga
                  Row(
                    children: [
                      // Menu Button Badges
                      Expanded(
                        child: _buildMenuButton(
                          context: context,
                          icon: Icons.workspace_premium,
                          label: 'Badges',
                          gradientColors: [
                            Colors.deepPurple.shade400,
                            Colors.purple.shade600,
                          ],
                          shadowColor: Colors.purple.withValues(alpha: 0.4),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListenableBuilder(
                                  listenable: userViewModel,
                                  builder: (context, child) => BadgesScreen(
                                    badges: userViewModel.badges,
                                    unlockedBadges: userViewModel.unlockedBadges,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Menu Button Cosmetics
                      Expanded(
                        child: _buildMenuButton(
                          context: context,
                          icon: Icons.palette,
                          label: 'Cosmetics',
                          gradientColors: [
                            Colors.pink.shade400,
                            Colors.deepOrange.shade500,
                          ],
                          shadowColor: Colors.pink.withValues(alpha: 0.4),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProfilePersonalization(
                                  cosmetics: userViewModel.cosmetics,
                                  unlockedCosmetics: userViewModel.unlockedCosmetics,
                                  selectedPfp: userViewModel.selectedPfp,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Progress',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const LevelCard(),
                ],
              ),
            ),
          ),

          // 📊 Statistics Section
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Statistics',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quiz Statistics
                  const UsersInfosCards(
                    iconCard1: Icons.check,
                    iconCard2: Icons.trending_up_outlined,
                    titleCard1: 'Correct Answers',
                    titleCard2: 'Accuracy',
                    infoCard1: '60',
                    infoCard2: '90%',
                    cardColor1: Colors.green,
                    cardColor2: Colors.blue,
                  ),
                  const SizedBox(height: 12),

                  // Places & Badges Statistics
                  ValueListenableBuilder<int>(
                    valueListenable: StateHub().visitState.poisCount,
                    builder: (context, count, child) {
                      return UsersInfosCards(
                        iconCard1: Icons.place_outlined,
                        iconCard2: Icons.workspace_premium,
                        titleCard1: 'Visited Places',
                        titleCard2: 'Unlocked Badges',
                        infoCard1: count.toString(),
                        infoCard2: '${userViewModel.unlockedBadges.length}',
                        cardColor1: Colors.purple,
                        cardColor2: Colors.orange,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget helper per i menu buttons
  Widget _buildMenuButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required List<Color> gradientColors,
    required Color shadowColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Icona in cerchio semi-trasparente
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

}