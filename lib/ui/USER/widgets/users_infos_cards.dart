import 'package:flutter/material.dart';

class UsersInfosCards extends StatelessWidget {
  const UsersInfosCards({super.key, required this.iconCard1, required this.iconCard2, required this.titleCard1, required this.titleCard2, required this.infoCard1, required this.infoCard2, required this.cardColor1, required this.cardColor2});

  final IconData iconCard1;
  final IconData iconCard2;

  final String titleCard1;
  final String titleCard2;

  final String infoCard1;
  final String infoCard2;

  final Color cardColor1;
  final Color cardColor2;



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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(iconCard1, size: 40, color: cardColor1),
                  const SizedBox(height: 8),
                  Text(
                    infoCard1,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    titleCard1,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(iconCard2, size: 40, color: cardColor2),
                  const SizedBox(height: 8),
                  Text(
                    infoCard2,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    titleCard2,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
