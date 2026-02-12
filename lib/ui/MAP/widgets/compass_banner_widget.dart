import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:re_discover/domain/models/poi.dart';
import 'package:re_discover/ui/MAP/view_model/map_view_model.dart';
import 'package:re_discover/ui/MAP/widgets/compass_widget.dart';
import 'package:latlong2/latlong.dart';

class CompassBannerCustom extends StatelessWidget {
  const CompassBannerCustom({super.key, required this.distanceNotifier, required this.userPosition});

  final ValueNotifier<double> distanceNotifier;
  final LatLng userPosition;




  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MapViewModel>(context);

    POI? poiToFind = viewModel.poiToFind;

    if (poiToFind == null) {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Center(
          child: Text(
            "No destination selected",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return ValueListenableBuilder(
      valueListenable: distanceNotifier,
      builder: (context, distance, child) {
        return Container(
          color: Colors.white,
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: CompassWidget(
                  userPosition: userPosition,
                  poiPosition: LatLng(poiToFind.position.latitude, poiToFind.position.longitude),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        poiToFind.name,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text("${viewModel.getDistanceString(distance)} to destination"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
