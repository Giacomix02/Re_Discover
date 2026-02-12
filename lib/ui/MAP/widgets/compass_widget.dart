import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:latlong2/latlong.dart';

class CompassWidget extends StatefulWidget {
  const CompassWidget({
    super.key,
    required this.userPosition,
    required this.poiPosition,
  });

  final LatLng userPosition;
  final LatLng poiPosition;

  @override
  State<StatefulWidget> createState() => _CompassWidget();
}

class _CompassWidget extends State<CompassWidget> {

  double bearingBetween(double lat1, double lon1, double lat2, double lon2) {
    double dLon = (lon2 - lon1) * math.pi / 180;
    lat1 = lat1 * math.pi / 180;
    lat2 = lat2 * math.pi / 180;

    double y = math.sin(dLon) * math.cos(lat2);
    double x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);
    double bearing = math.atan2(y, x);
    return (bearing * 180 / math.pi + 360) % 360; // normalize to 0–360°
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error reading heading: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        double heading = snapshot.data?.heading ?? 0;

        double angle = bearingBetween(
          widget.userPosition.latitude,
          widget.userPosition.longitude,
          widget.poiPosition.latitude,
          widget.poiPosition.longitude,
        );

        double rotation = (angle - heading + 540) % 360 - 180;

        return Material(
          shape: CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(6.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: Transform.rotate(
              angle: rotation * (math.pi / 180),
              child: Icon(Icons.navigation, size: 50, color: Colors.blue),
            ),
          ),
        );
      },
    );
  }
}
