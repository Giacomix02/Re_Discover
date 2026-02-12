import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:re_discover/data/states/user_state.dart';

class LevelCard extends StatelessWidget {
  const LevelCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          spacing: 10,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "Level",
                      style: TextStyle(fontSize: 13, color: Colors.black),
                    ),
                    Consumer<UserState>(
                      builder: (context, userState, child) {
                        return Text(
                          "${userState.user.level}",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Icon(Icons.track_changes, size: 50, color: Colors.orange),
              ],
            ),
            Consumer<UserState>(
              builder: (BuildContext context, UserState value, Widget? child) {
                return Column(
                  children: [
                    LinearProgressIndicator(
                      value: (value.user.xp % 125) / 125,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(10),
                      backgroundColor: Colors.grey[300],
                      color: Colors.orange,
                    ),
                    SizedBox(height: 10),
                    Text("${value.user.xp.toStringAsFixed(0)} / ${125 * value.user.level} XP"),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
