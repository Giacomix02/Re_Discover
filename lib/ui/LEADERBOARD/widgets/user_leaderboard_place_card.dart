import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:re_discover/ui/LEADERBOARD/screen/leaderboard_screen.dart';
import '../view_model/leaderboard_view_model.dart';

class UserLeaderboardPlaceCard extends StatelessWidget
    implements PreferredSizeWidget {
  const UserLeaderboardPlaceCard({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  String formatData(String data) {
    double? value = double.tryParse(data);
    if (value == null) return data;

    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LeaderboardViewModel>(context);

    return Card(
      elevation: 3,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, child) {
            final int score = viewModel.selectedCategory == Categories.xp
                ? viewModel.user.xp.toInt()
                : viewModel.poisCount.value;
            
            return Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: FutureBuilder(
                    future: viewModel.userRank,
                    builder: (context, asyncSnapshot) {
                      if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      int rank = asyncSnapshot.data!;
                      return Text(
                        rank.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      );
                    }
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        viewModel.user.username,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'Level ${viewModel.user.level}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    formatData(score.toString()),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
