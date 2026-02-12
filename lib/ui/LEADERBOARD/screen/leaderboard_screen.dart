import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:re_discover/ui/LEADERBOARD/view_model/leaderboard_view_model.dart';

import 'package:re_discover/ui/LEADERBOARD/widgets/leaderboard_scroll_view.dart';
import 'package:re_discover/ui/LEADERBOARD/widgets/preferred_size_tabbar_card.dart';
import 'package:re_discover/ui/LEADERBOARD/widgets/user_leaderboard_place_card.dart';

enum Categories {
  xp("Explorer XP", Icons.stars_rounded),
  poi("Visited POI", Icons.location_on_sharp);

  const Categories(this.name, this.icon);

  final String name;
  final IconData icon;
}

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with TickerProviderStateMixin {
  late final LeaderboardViewModel leaderboardViewModel;
  late final TabController _tabController;
  late final PreferredSizeWidget tabBar;

  @override
  void initState() {
    super.initState();
    leaderboardViewModel = LeaderboardViewModel();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    tabBar = PreferredSizeTabbarCard(tabController: _tabController);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return ChangeNotifierProvider(
      create: (_) => leaderboardViewModel,
      child: SafeArea(
        child: Scaffold(
          body: NestedScrollView(
            physics: const BouncingScrollPhysics(),
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                scrolledUnderElevation: 0,
                pinned: true,
                floating: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                collapsedHeight: tabBar.preferredSize.height + 30,
                expandedHeight: 140,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 16.0 + tabBar.preferredSize.height,
                  ),
                  title: Text(
                    'Leaderboard',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  stretchModes: const [
                    StretchMode.blurBackground,
                    StretchMode.fadeTitle,
                  ],
                ),
                bottom: tabBar,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: Row(
                    children: [
                      Text(
                        "Filter by:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.outline,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: _buildCategorySelector()),
                    ],
                  ),
                ),
              ),
              PinnedHeaderSliver(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: UserLeaderboardPlaceCard(
                  ),
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              physics: const BouncingScrollPhysics(),
              children: LeaderboardType.values.map((type) {
                return LeaderboardScrollView(leaderboardType: type);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Consumer<LeaderboardViewModel>(
      builder: (context, viewModel, child) => ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return PopupMenuButton<Categories>(
                initialValue: viewModel.selectedCategory,
                tooltip: "Select Category",
                onSelected: viewModel.changeCategory,
                // Increased offset to 56 to add a small gap between the button and the menu
                offset: const Offset(0, 56),
                elevation: 4,
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  maxWidth: constraints.maxWidth,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                itemBuilder: (BuildContext context) {
                  return Categories.values.map((Categories category) {
                    return PopupMenuItem<Categories>(
                      value: category,
                      child: Row(
                        children: [
                          Icon(
                            category.icon,
                            size: 20,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            category.name,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    );
                  }).toList();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            viewModel.selectedCategory.icon,
                            size: 20,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            viewModel.selectedCategory.name,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      ),
    );
  }
}
