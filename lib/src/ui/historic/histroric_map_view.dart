import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animarker/widgets/animarker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../services/device_provider.dart';
import '../../widgets/custom_info_windows.dart';
import 'historic_provider.dart';
import 'package:provider/provider.dart';

class HistoricMapView extends StatefulWidget {
  const HistoricMapView({super.key});

  @override
  State<HistoricMapView> createState() => _HistoricMapViewState();
}

class _HistoricMapViewState extends State<HistoricMapView>
    with WidgetsBindingObserver {
  late HistoricProvider historicProvider;
  @override
  void initState() {
    super.initState();
    historicProvider = Provider.of(context, listen: false);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (!mounted) return;
/*     if (state == AppLifecycleState.resumed) {
      historicProvider.googleMapController?.setMapStyle(Utils.googleMapStyle);
    } */
  }

  @override
  void dispose() {
    super.dispose();
    historicProvider.clear();
  }

  @override
  Widget build(BuildContext context) {
    context.select<DeviceProvider, MapType>((value) => value.mapType);
    final provider = context.read<HistoricProvider>();
    return Center(
      child: Selector<HistoricProvider, bool>(
          selector: (_, p) => p.notifyMap,
          builder: (_, ___, __) {
            final DeviceProvider deviceProvider =
                Provider.of<DeviceProvider>(context, listen: false);
            log("Build historic map");
            return Stack(
              children: [
                Animarker(
                  isActiveTrip: true,
                  useRotation: false,
                  rippleRadius: 0.2,
                  duration: Duration(
                      milliseconds:
                          historicProvider.speedDuration.inMilliseconds ~/ 10),
                  rippleDuration: const Duration(milliseconds: 500),
                  shouldAnimateCamera: false,
                  rippleColor: historicProvider.getRippleColor(),
                  mapId: Future<int>.value(
                      provider.googleMapController?.mapId ?? 0),
                  markers: provider.animateMarker.values.toSet(),
                  child: GoogleMap(
                    //cloudMapId: Utils.mapId,
                    markers: provider.getMarker(),
                    polylines: provider.getLines(),
                    zoomControlsEnabled: false,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    circles: provider.circles,
                    mapType: deviceProvider.mapType,
                    onCameraMove: (pos) {
                      provider.onCameraMove(pos);
                    },
                    onTap: provider.onTapMap,
                    onMapCreated: (controller) async {
                      provider.googleMapController = controller;
                      provider.customInfoWindowController.googleMapController =
                          controller;
                    },
                    initialCameraPosition: const CameraPosition(
                        target: LatLng(31.7917, -7.0926), zoom: 6),
                  ),
                ),
                MyCustomInfoWindows(
                  controller: provider.customInfoWindowController,
                ),
              ],
            );
          }),
    );
  }
}
