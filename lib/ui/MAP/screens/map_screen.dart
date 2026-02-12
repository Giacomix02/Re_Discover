import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:re_discover/data/states/state_hub.dart';
import 'package:re_discover/ui/MAP/view_model/map_view_model.dart';
import 'package:re_discover/ui/MAP/widgets/compass_banner_widget.dart';
import 'package:re_discover/ui/MAP/widgets/OSM_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  /*
    return ChangeNotifierProvider(
      create: (context) => MapViewModel()..initState(),
      child: MapScreenContent(),
    );

   */
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => MapViewModel()..initState()),
          ChangeNotifierProvider.value(value: StateHub().userState)
        ],
        child: MapScreenContent(),
    );
  }
}

class MapScreenContent extends StatelessWidget {
  const MapScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final mapViewModel = context.watch<MapViewModel>();

    if (!mapViewModel.gainedInitialPosition) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text("Obtaining current position..."),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          toolbarHeight: 60,
          titleSpacing: 16,
          title: mapViewModel.isVisiting
              ? Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${mapViewModel.selectedCity.name}, Italia',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "${mapViewModel.completedPoisIds.length}/${mapViewModel.selectedCity.pois.length} visited places",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.outline,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    PopupMenuButton<int>(
                      offset: const Offset(0, 52),
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      onSelected: (value) {
                        if (value == 0) {
                          StateHub().visitState.endVisit();
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem<int>(
                          value: 0,
                          child: Row(
                            children: [
                              Icon(Icons.stop_circle_outlined, color: Colors.red, size: 20),
                              const SizedBox(width: 12),
                              Text(
                                "Stop exploring",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.more_vert_rounded,
                          size: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Available Cities',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Select a city to show details",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              if (mapViewModel.isVisiting)
                CompassBannerCustom(
                    userPosition: mapViewModel.currentPosition,
                    distanceNotifier: mapViewModel.distanceNotifier),
              OsmCustom(
                mapController: mapViewModel.mapController,
                currentPosition: mapViewModel.currentPosition,
                updateMapPosition: mapViewModel.updateZoomLevel,
                followUserPositionToggle: mapViewModel.followUserPositionToggle,
                allCities: mapViewModel.allCities,
                poisOfSelectedCity: mapViewModel.poisOfSelectedCity,
                isVisiting: mapViewModel.isVisiting,
                poiToUnlock: mapViewModel.poiToFind,
              ),
            ],
          ),
        ),
      );
    }
  }
}
