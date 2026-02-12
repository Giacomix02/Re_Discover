import 'package:flutter/material.dart';

class LeaderboardHeaderSliverDelegate extends SliverPersistentHeaderDelegate{
  final PreferredSizeWidget child;
  
  LeaderboardHeaderSliverDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: child,
    );
  }

  @override
  double get maxExtent => child.preferredSize.height; //TODO find a way to reduce the child size without destroying its structure

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
  
}