import 'package:flutter/material.dart';
import 'package:re_discover/data/repositories/repository_hub.dart';

class ProfilePictureCard extends StatelessWidget {
  const ProfilePictureCard({
    super.key,
    required this.id,
    required this.iconProfile,
    required this.titleProfile,
    required this.unlocked,
    required this.equipped,
  });

  final String iconProfile;
  final String titleProfile;
  final bool unlocked;
  final bool equipped;
  final int id;

  ElevatedButton buildEquipButton(){
    Color buttonColor;
    if (!unlocked) {
      buttonColor = Colors.grey;
    } else if (equipped) {
      // Colore a tema per "Unequip" (Deep Purple)
      buttonColor = Colors.deepPurple.shade600;
    } else {
      buttonColor = Colors.green;
    }
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: unlocked ? () {
        if(!equipped){
          // Equip profile picture
          RepositoryHub().cosmeticRepository.setSelectedPfp(id);
        } else {
          // Unequip profile picture
          RepositoryHub().cosmeticRepository.setSelectedPfp(-1);
        }
      } : null,
      child: Text(
        unlocked ? (equipped ? "Unequip" : "Equip") : "Locked",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    Widget card = Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(titleProfile, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            Text(iconProfile, style: TextStyle(fontSize: 40), textAlign: TextAlign.center),
            Flex(
              direction: Axis.horizontal,
              children: [Expanded(child: buildEquipButton())],
            )
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
