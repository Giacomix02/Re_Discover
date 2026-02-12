import 'package:flutter/material.dart';

class BadgeCard extends StatelessWidget {
  const BadgeCard({
    super.key,
    required this.iconCard,
    required this.titleCard,
    required this.infoCard,
    required this.unlocked,
  });

  final String iconCard;
  final String titleCard;
  final String infoCard;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    Widget card = Card(
      color: Colors.white,
      shape: unlocked
        ? RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: Colors.deepPurple, width: 3.0),
          )
        : RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(titleCard, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            Text(iconCard, style: TextStyle(fontSize: 40), textAlign: TextAlign.center),
            Text(infoCard, style: TextStyle(fontSize: 11, color: Colors.blueGrey), textAlign: TextAlign.center),
          ],
        ),
      ),
    );

    if (!unlocked) {
      return ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0,      0,      0,      1, 0,
        ]),
        child: card,
      );
    }

    return card;
  }

}
