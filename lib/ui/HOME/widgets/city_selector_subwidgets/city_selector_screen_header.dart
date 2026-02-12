import 'package:flutter/material.dart';

class CitySelectorScreenHeader extends StatelessWidget {
  const CitySelectorScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.map, size: 60, color: Colors.purple),
        Text(
          "Re:Discover",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Select the city to explore!",
              style: TextStyle(fontSize: 15, color: Colors.blueGrey),
            ),
          ],
        ),
      ],
    );
  }
}
