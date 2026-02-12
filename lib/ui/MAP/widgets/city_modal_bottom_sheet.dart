import 'package:flutter/material.dart';
import 'package:re_discover/data/states/state_hub.dart';
import 'package:re_discover/domain/models/city.dart';

class CityModalBottomSheet extends StatelessWidget {
  const CityModalBottomSheet({super.key, required this.city});

  final City city;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  city.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  city.description,
                  style: TextStyle(fontSize: 16),
                  softWrap: true,
                ),
                SizedBox(height: 10),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image(image: AssetImage(city.image)),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Descrizione immagine o didascalia.',
                  style: TextStyle(fontSize: 13),
                  softWrap: true,
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                      Expanded(
                        child: FloatingActionButton(
                          heroTag: null,
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            "Begin to Explore!",
                          ),
                          onPressed: () {
                            StateHub().cityState.selectCity(city);

                            StateHub().visitState.startVisit();

                            StateHub().navigationState.setSelectedIndex(1);

                            Navigator.pop(context);
                          },
                        ),
                      )
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
