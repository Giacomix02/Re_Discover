import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:re_discover/data/repositories/repository_hub.dart';
import 'package:re_discover/data/states/state_hub.dart';
import 'package:re_discover/domain/models/city.dart';
import 'package:re_discover/domain/models/poi.dart';
import 'package:re_discover/domain/models/visit.dart';

class MapViewModel extends ChangeNotifier {

  final MapController mapController = MapController();
  LatLng currentPosition = LatLng(0, 0);
  late double currentZoom = 15.0;
  AlignOnUpdate isFollowingUser = AlignOnUpdate.always;
  bool isFollowingUserBool = true;
  bool gainedInitialPosition = false;
  bool isVisiting = false;
  POI? poiToFind;
  late Visit visit;
  late City selectedCity;
  bool _isMapReady = false;


  List<POI> poisOfSelectedCity = List<POI>.empty(growable: true);
  List<City> allCities = List<City>.empty(growable: true);
  Set<int> completedPoisIds = Set<int>(); // Track completed POIs by their ID
  bool isNewPoiUnlocked = false; // Track if a new POI was just unlocked for animation

  ValueNotifier<double> distanceNotifier = ValueNotifier<double>(
    double.infinity,
  );

  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 0,
  );

  StreamSubscription<Position>? positionStream;

  final visitState = StateHub().visitState;

  Future<void> initState() async {
    var status = await Permission.location.status;

    if (!status.isGranted) {
      status = await Permission.location.request();

      if (!status.isGranted) {
        final granted = await _waitForPermissionGrant();
        if (!granted) {
          showToast("Position permission not allowed");
          return;
        }
      }
    }
    if (status == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      showToast("Position permission denied forever, reallow from settings!");
    }

    try {
      final pos = await initialPosition();
      currentPosition = LatLng(pos.latitude, pos.longitude);
      gainedInitialPosition = true;
      notifyListeners();
      log(
        "posizione ottenuta ${currentPosition.latitude}, ${currentPosition.longitude}",
      );
    } catch (e, s) {
      log("Impossibile ottenere la posizione iniziale: $e\n$s");
      showToast("Can't get your initial position");
    }

    visitState.isVisiting.addListener(_onVisitStateChanged);
    await _onVisitStateChanged();

    // ora che il permesso è garantito, avvia lo stream e prendi la posizione iniziale
    initLocationStream();
  }

  Future<void> _onVisitStateChanged() async {
    isVisiting = visitState.isVisiting.value;

    if (visitState.isVisiting.value) {
      updateZoomLevel(15.0);
      _setFollowUserPosition(true);
      poisOfSelectedCity.clear();
      completedPoisIds.clear(); // Reset completed POIs for new visit
      selectedCity = StateHub().cityState.selectedCity!;
      List<POI> poisOfACity = RepositoryHub().cityRepository.getPOIsOfCityFromID(selectedCity.id);
      //TODO aggiungere la visita, e pensara a cosa salvare
      poisOfSelectedCity.addAll(poisOfACity);
      newPoiDecision();

        mapController.move(currentPosition, 15.0);
      
    } else {

      if (allCities.isEmpty) {
        List<City> citiesFromRepo = await RepositoryHub().cities;
        allCities.addAll(citiesFromRepo);
      }
      updateZoomLevel(5.0);
      _setFollowUserPosition(false);


        mapController.move(currentPosition, 5.0);
          }

    notifyListeners();
  }


  void setMapReady(bool ready) {
    _isMapReady = ready;
  }

  void _moveMapIfReady(double zoom) {
    if (_isMapReady) {
      try {
        mapController.move(currentPosition, zoom);
      } catch (e) {
        print("Error moving map: $e");
      }
    }
  }

  void newPoiDecision(){
    // choose a new POI to find based on the distance from the user
    // Filter out completed POIs
    List<POI> availablePOIs = poisOfSelectedCity.where((poi) => !completedPoisIds.contains(poi.id)).toList();

    if (availablePOIs.isEmpty) {
      poiToFind = null;
      distanceNotifier.value = double.infinity;
      notifyListeners();
      return;
    }
    // comparison between every distance from ListOfPOI and user Position
    // the selectet POI will be inserted in poiToFind
    POI closestPOI = availablePOIs[0];
    double closestDistance = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      closestPOI.position.latitude,
      closestPOI.position.longitude,
    );
    for (var poi in availablePOIs) {
      double distance = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        poi.position.latitude,
        poi.position.longitude,
      );
      if (distance < closestDistance) {
        closestDistance = distance;
        closestPOI = poi;
      }
    }
    poiToFind = closestPOI;
    distanceNotifier.value = closestDistance;
    notifyListeners();
  }

  void initLocationStream() => positionStream =
      Geolocator.getPositionStream(locationSettings: locationSettings).listen((
        Position? position,
      ) {
        log(
          position == null
              ? 'Unknown'
              : 'stream ${position.latitude.toString()}, ${position.longitude.toString()}',
        );
        if (position != null) {
          currentPosition = LatLng(position.latitude, position.longitude);
          if (poiToFind != null) {
            distanceNotifier.value = Geolocator.distanceBetween(
              currentPosition.latitude,
              currentPosition.longitude,
              poiToFind!.position.latitude,
              poiToFind!.position.longitude,
            );
          }
          notifyListeners();
        }
      });

  void followUserPositionToggle() {
    if (isFollowingUserBool) {
      isFollowingUser = AlignOnUpdate.never;
      isFollowingUserBool = false;
    } else {
      isFollowingUser = AlignOnUpdate.always;
      isFollowingUserBool = true;
    }
    notifyListeners();
  }

  void _setFollowUserPosition(bool follow) {
    if (follow) {
      isFollowingUser = AlignOnUpdate.always;
      isFollowingUserBool = true;
    } else {
      isFollowingUser = AlignOnUpdate.never;
      isFollowingUserBool = false;
    }
    notifyListeners();
  }

  void updateZoomLevel(double zoom) {
    currentZoom = zoom;
    notifyListeners();
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> _determinePermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('------- Location services are disabled. -------');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('------- Location permissions are denied -------');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      showToast("Position permission denied forever, reallow from settings!");

      return Future.error(
        '------- Location permissions are permanently denied, we cannot request permissions. -------',
      );
    }
  }

  Future<bool> _waitForPermissionGrant({
    Duration timeout = const Duration(seconds: 15),
  })
  async {
    final end = DateTime.now().add(timeout);

    var status = await Permission.location.status;

    while (DateTime.now().isBefore(end)) {
      if (status.isGranted) return true;
      await Future.delayed(const Duration(milliseconds: 500));
    }
    return false;
  }

  Future<Position> initialPosition() async {
    return await Geolocator.getCurrentPosition();
  }

  String getDistanceString(double distance) {
    return distance > 1000 ? "${(distance / 1000).toStringAsFixed(2)} km" : "${distance.toStringAsFixed(2)} m";
  }

  void markPoiAsCompleted(int poiId) {
    completedPoisIds.add(poiId);
    log("POI $poiId marked as completed. Total completed: ${completedPoisIds.length}");

    // Find next POI to visit
    newPoiDecision();

    // If there's a new POI, highlight it with green pulsing animation
    if (poiToFind != null) {
      isNewPoiUnlocked = true; // Activate highlight animation

      final targetPos = LatLng(poiToFind!.position.latitude, poiToFind!.position.longitude);

      // Dezoom to show context around the new POI
      mapController.move(targetPos, 13.0);

      // Disable highlight animation after 3 seconds - will smoothly transition to red with absorption effect
      Future.delayed(const Duration(seconds: 3), () {
        isNewPoiUnlocked = false;
        notifyListeners();
      });
    } else {
      showToast("All POIs completed! Great job!");
    }

    notifyListeners();
  }

  void resetCompletedPois() {
    completedPoisIds.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    visitState.isVisiting.removeListener(_onVisitStateChanged);
    positionStream?.cancel();
    super.dispose();
  }
}
