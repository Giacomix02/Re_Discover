import 'package:flutter/material.dart';
import 'package:re_discover/data/states/state_hub.dart';
import 'package:re_discover/ui/HOME/screens/city_selector_screen.dart';

class HomeScreenExplorationButton extends StatelessWidget {
  const HomeScreenExplorationButton({super.key, required this.isVisiting});

  final bool isVisiting;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () {
            if (!isVisiting){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CitySelectorScreen()),
              );
            } else {
              StateHub().visitState.endVisit();
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            backgroundColor: Colors.purple,
          ),
          icon: !isVisiting ? const Icon(Icons.explore_outlined, color: Colors.white) : const Icon(Icons.cancel, color: Colors.white),
          label: Text(
            !isVisiting ? "Start Exploring" : "Stop Exploring",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
