import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:re_discover/domain/models/poi.dart';
import 'package:re_discover/ui/MAP/screens/quiz_screen.dart';
import 'package:re_discover/ui/MAP/view_model/map_view_model.dart';

class PoiModalBottomSheet extends StatelessWidget {
  const PoiModalBottomSheet({super.key, required this.distanceNotifier, required this.poi});

  final ValueNotifier<double> distanceNotifier;
  final POI poi;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MapViewModel>(context);

    return ValueListenableBuilder(
      valueListenable: distanceNotifier,
      builder: (context, distance, child) {
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
                      poi.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      poi.description,
                      style: TextStyle(fontSize: 16),
                      softWrap: true,
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image(image: AssetImage(poi.images[0])),
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.near_me_outlined),
                        SizedBox(width: 5),
                        Text(
                          '${viewModel.getDistanceString(distance)} from you',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (distance < 60)
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
                                "Answer the quiz",
                              ),
                              onPressed: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                        builder: (context) => QuizScreen(
                                          poi: poi,
                                          mapViewModel: viewModel,
                                        )
                                    )
                                )
                              },
                            ),
                          )
                        else
                          Expanded(
                            child: Card(
                              color: Colors.deepPurple[50],
                              elevation: 1,
                              shadowColor: Colors.black,
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.inversePrimary,
                                  width: 3,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.near_me_outlined,
                                      size: 40,
                                      color: Colors.deepPurple[300],
                                    ),
                                    Text(
                                      "Approach the location to unlock the quiz",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
