import 'package:flutter/material.dart';

class HomeScreenAnswersAccuracyCards extends StatelessWidget {
  const HomeScreenAnswersAccuracyCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Icon(Icons.check_circle_outline, size: 40, color: Colors.green),
                  Text("Correct Answers", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("11"),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Icon(Icons.gps_fixed, size: 40, color: Colors.blue),
                  Text("Accuracy", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("43%"),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
