import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:re_discover/data/states/user_state.dart';
import 'package:re_discover/domain/models/cosmetic.dart';

class HomeScreenHeader extends StatelessWidget {
  const HomeScreenHeader({super.key, required this.pfpIdSelected, required this.cosmetics});

  final int pfpIdSelected;
  final List<Cosmetic> cosmetics;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        pfpIdSelected == -1 || cosmetics.isEmpty
            ? Icon(Icons.account_circle, size: 80, color: Colors.purple)
            : Text(cosmetics[pfpIdSelected].img, style: TextStyle(fontSize: 60)),
        Text(
          "Re:Discover",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),
        Consumer<UserState>(
          builder: (context, userState, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hi, ${userState.user.username}!",
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
                SizedBox(width: 5),
                Icon(Icons.waving_hand, size: 20, color: Colors.orange),
              ],
            );
          },
        ),
      ],
    );
  }
}
