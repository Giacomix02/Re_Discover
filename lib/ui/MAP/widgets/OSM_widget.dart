import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:re_discover/domain/models/city.dart';
import 'package:re_discover/domain/models/poi.dart';
import 'package:re_discover/ui/MAP/view_model/map_view_model.dart';
import 'package:re_discover/ui/MAP/widgets/level_widget.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:re_discover/ui/core/utils.dart';

class OsmCustom extends StatefulWidget {
  const OsmCustom({
    super.key,
    required this.mapController,
    required this.currentPosition,
    required this.updateMapPosition,
    required this.followUserPositionToggle,
    required this.allCities,
    required this.poisOfSelectedCity,
    required this.isVisiting,
    required this.poiToUnlock,
  });

  final MapController mapController;
  final LatLng currentPosition;
  final Function(double zoom) updateMapPosition;
  final VoidCallback followUserPositionToggle;
  final List<City> allCities;
  final List<POI> poisOfSelectedCity;
  final bool isVisiting;
  final POI? poiToUnlock;

  @override
  State<OsmCustom> createState() => _OsmCustomState();
}

class _OsmCustomState extends State<OsmCustom> {
  @override
  Widget build(BuildContext context) {

    List<Marker> cityMarkers(List<City> cities) {
      return cities.map((city) {
        final lat = city.position.latitude;
        final lng = city.position.longitude;

        return Marker(
          point: LatLng(lat, lng),
          width: 40,
          height: 40,
          rotate: true,
          child: GestureDetector(
            onTap: () => onShowModalCity(context: context, city: city),
            child: Transform.translate(
              offset: const Offset(0, -10),
              child: const Icon(Icons.location_city_rounded, color: Colors.black, size: 20),
            ),
          ),
        );
      }).toList();
    }


    return Expanded(
      child: FlutterMap(
        mapController: widget.mapController,
        options: MapOptions(
          initialCenter: widget.currentPosition,
          initialZoom: context.watch<MapViewModel>().currentZoom,
          onMapReady: () {
            // Imposta il flag quando la mappa è pronta
            context.read<MapViewModel>().setMapReady(true);
          },
          onPositionChanged: (position, hasGesture) {
            widget.updateMapPosition(position.zoom);
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'it.univaq.egs.re_discover',
          ),
          Consumer<MapViewModel>(
            builder: (context, mapViewModel, child) => CurrentLocationLayer(
              alignPositionOnUpdate: mapViewModel.isFollowingUser,
              alignDirectionOnUpdate: AlignOnUpdate.never,
              style: LocationMarkerStyle(
                marker: const DefaultLocationMarker(
                  child: Icon(Icons.my_location, color: Colors.blue, size: 3),
                ),
                markerSize: const Size(20, 20),
                markerDirection: MarkerDirection.heading,
              ),
            ),
          ),
          Consumer<MapViewModel>(
            builder: (context, viewModel, child) {
              List<Marker> markers = widget.isVisiting && widget.poiToUnlock != null
                  ? [
                      Marker(
                        point: LatLng(widget.poiToUnlock!.position.latitude, widget.poiToUnlock!.position.longitude),
                        width: 100,
                        height: 100,
                        rotate: true,
                        child: GestureDetector(
                          onTap: () => onShowModalMap(
                            context: context,
                            distanceNotifier: viewModel.distanceNotifier,
                            poi: widget.poiToUnlock!,
                            mapViewModel: viewModel,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Effetto glow pulsante per POI appena sbloccato con riassorbimento finale
                              if (viewModel.isNewPoiUnlocked)
                                _PulsingGlowEffect(),
                              // Marker con transizione smooth del colore
                              Transform.translate(
                                offset: const Offset(0, -20),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 600),
                                  child: Icon(
                                    Icons.room,
                                    key: ValueKey<bool>(viewModel.isNewPoiUnlocked),
                                    color: viewModel.isNewPoiUnlocked ? Colors.green : Colors.red,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]
                  : widget.isVisiting ? [] : cityMarkers(widget.allCities);

              return MarkerLayer(markers: markers);
            },
          ),
          // builder: (context, viewModel, child) => MarkerLayer(
          //   markers: mapMarkers,
          // markers: [
          //   Marker(
          //     point: widget.poiPosition,
          //     width: 60,
          //     height: 60,
          //     rotate: true,
          //     child: GestureDetector(
          //       onTap: () => onShowModalMap(
          //         context: context,
          //         distanceNotifier: viewModel.distanceNotifier,
          //       ),
          //       child: Transform.translate(
          //         offset: const Offset(0, -20),
          //         child: const Icon(Icons.room, color: Colors.red, size: 40),
          //       ),
          //     ),
          //   ),
          // ],
          //   ),
          // ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: const EdgeInsets.only(right: 20, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Consumer<MapViewModel>(
                    // Consumer in order to rebuild only this part if zoom and current position change
                    builder: (context, mapViewModel, child) =>
                        FloatingActionButton(
                          heroTag: null,
                          onPressed: () => widget.mapController.move(
                            mapViewModel.currentPosition,
                            mapViewModel.currentZoom,
                          ),
                          child: const Icon(Icons.my_location),
                        ),
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    heroTag: null,
                    onPressed: widget.followUserPositionToggle,
                    child: Consumer<MapViewModel>(
                      builder: (context, mapViewModel, child) {
                        if (mapViewModel.isFollowingUserBool) {
                          return const Icon(Icons.near_me);
                        } else {
                          return const Icon(Icons.near_me_disabled);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (widget.isVisiting)
            Align(alignment: Alignment.topCenter, child: LevelWidget()),
        ],
      ),
    );
  }
}

/// Widget che gestisce l'effetto di pulsazione verde con riassorbimento finale nel POI
class _PulsingGlowEffect extends StatefulWidget {
  @override
  State<_PulsingGlowEffect> createState() => _PulsingGlowEffectState();
}

class _PulsingGlowEffectState extends State<_PulsingGlowEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isAbsorbing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Dopo 2 secondi, inizia il riassorbimento
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() {
          _isAbsorbing = true;
        });
        _controller.stop();
        _controller.duration = const Duration(milliseconds: 600);
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final scale = _isAbsorbing ? _controller.value * 1.5 : _animation.value;
        final opacity = _isAbsorbing ? _controller.value * 0.5 : 0.3 / scale;

        return Transform.scale(
          scale: scale,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.withValues(alpha: opacity),
            ),
          ),
        );
      },
    );
  }
}

