import 'package:flutter/material.dart';

class PreferredSizeTabbarCard extends StatelessWidget
    implements PreferredSizeWidget {
  final TabController tabController;

  const PreferredSizeTabbarCard({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      // dividerColor: Theme.of(context).scaffoldBackgroundColor,
      // dividerHeight: 0,
      controller: tabController,
      splashBorderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
      labelColor: Theme.of(context).primaryColor,
      unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
      indicatorColor: Theme.of(context).primaryColor,
      tabs: const [
        Tab(text: 'Global'),
        Tab(text: 'Local'),
        Tab(text: 'Friends'),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight);
}
