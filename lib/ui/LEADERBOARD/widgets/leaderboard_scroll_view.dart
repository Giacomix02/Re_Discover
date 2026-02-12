import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:re_discover/domain/models/user.dart';
import 'package:re_discover/ui/LEADERBOARD/screen/leaderboard_screen.dart';
import 'package:re_discover/ui/LEADERBOARD/view_model/leaderboard_view_model.dart';

enum LeaderboardType { global, local, friends }

class LeaderboardScrollView extends StatelessWidget {
  const LeaderboardScrollView({super.key, required this.leaderboardType});

  final LeaderboardType leaderboardType;

  @override
  Widget build(BuildContext context) {
    final leaderboardViewModel = Provider.of<LeaderboardViewModel>(context);
    // leaderboardViewModel.sortLeaderboard();
    Future<List<User>> leaderboard = leaderboardViewModel.getLeaderboard();

    if(leaderboardType != LeaderboardType.global) return Center(child: Text("Coming soon!", style: TextStyle(fontSize: 30),));
    
    return ListenableBuilder(
      listenable: leaderboardViewModel,
      builder: (context, child) =>  FutureBuilder(
        future: leaderboard,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.hasData) {
            List<User> orderedList = asyncSnapshot.data!;
            // orderedList.sort((a, b) => b.xp.compareTo(a.xp));
      
            return RefreshIndicator(
              onRefresh: () => leaderboardViewModel.updateLeaderboard(),
              backgroundColor: Theme.of(context).primaryColor,
              color: Theme.of(context).colorScheme.onPrimary,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: ClampingScrollPhysics(),
                ),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      top: 8,
                      left: 12,
                      right: 12,
                      bottom: 80,
                    ),
                    sliver: SliverList.separated(
                      itemCount: 15,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final position = index + 1;
                        if (orderedList.length < position) return null;
                        final user = orderedList[index];
      
                        if (leaderboardViewModel.selectedCategory ==
                            Categories.xp) {
                          return LeaderboardTile(
                            position: position,
                            name: user.username, //'Explorer ${index + 1}',
                            subtitle:
                                'Level ${user.level}', //'Level ${25 - index}',
                            data: user.xp
                                .toString(), //'${(30000 - (index * 1200))}',
                            color: _getRankColor(position, context),
                          );
                        } else if (leaderboardViewModel.selectedCategory ==
                            Categories.poi) {
                          return FutureBuilder(
                            future: leaderboardViewModel.poiCountMap,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return LeaderboardTile(
                                  position: position,
                                  name: user.username,
                                  subtitle: 'Level ${user.level}',
                                  data: snapshot.data![user].toString(),
                                  color: _getRankColor(position, context),
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                if(index == 0)
                                {return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Opacity(
                                    opacity: 0.5,
                                    child: LinearProgressIndicator(minHeight: 30, borderRadius: BorderRadius.circular(10), )),
                                );
                                }
                                return Container();
                              }
                            },
                          );
                        }
                        return Text(
                          "error: ${leaderboardViewModel.selectedCategory.name} not expected",
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (asyncSnapshot.hasError) {
            return Center(child: Text('Error: ${asyncSnapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Color _getRankColor(int position, BuildContext context) {
    if (position == 1) return const Color(0xFFFFD700); // Gold
    if (position == 2) return const Color(0xFFC0C0C0); // Silver
    if (position == 3) return const Color(0xFFCD7F32); // Bronze
    return Theme.of(context).colorScheme.surfaceContainerHighest;
  }
}

class LeaderboardTile extends StatelessWidget {
  final int position;
  final String name;
  final String subtitle;
  final String data;
  final Color color;

  const LeaderboardTile({
    super.key,
    required this.position,
    required this.name,
    required this.subtitle,
    required this.data,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTopThree = position <= 3;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: isTopThree
            ? Border.all(color: color.withOpacity(0.5), width: 2)
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            _buildPositionIndicator(context),
            const SizedBox(width: 16),
            _buildUserAvatar(context),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            _buildScoreBadge(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPositionIndicator(BuildContext context) {
    return SizedBox(
      width: 30,
      child: Text(
        position.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          fontFeatures: const [FontFeature.ordinalForms()],
          color: position <= 3
              ? color.darken(0.2)
              : Theme.of(context).colorScheme.outline,
        ),
      ),
    );
  }

  Widget _buildUserAvatar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: position <= 3 ? color : Colors.transparent,
          width: 2,
        ),
      ),
      child: CircleAvatar(
        radius: 22,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Icon(
          Icons.person,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }

  Widget _buildScoreBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: position <= 3
            ? color.withOpacity(0.2)
            : Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _formatData(data),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: position <= 3
              ? color.darken(0.3)
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  String _formatData(String data) {
    double? value = double.tryParse(data);
    if (value == null) return data;

    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return data;
  }
}

extension ColorExtension on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
