import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../services/device_provider.dart';
import '../../services/geozone_service.dart';
import 'last_position_provider.dart';
import '../../utils/locator.dart';
import 'package:provider/provider.dart';

class LastpositionMap extends StatefulWidget {
  const LastpositionMap({Key? key}) : super(key: key);

  @override
  State<LastpositionMap> createState() => _LastpositionMapState();
}

class _LastpositionMapState extends State<LastpositionMap>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (!mounted) return;
    if (state == AppLifecycleState.resumed) {
      LastPositionProvider lastPositionProvider =
          Provider.of<LastPositionProvider>(context, listen: false);
      lastPositionProvider.mapController?.setMapStyle("[]");
    }
  }

  @override
  Widget build(BuildContext context) {
    DeviceProvider deviceProvider =
        Provider.of<DeviceProvider>(context, listen: false);
    context.select<DeviceProvider, MapType>((value) => value.mapType);

    LastPositionProvider p =
        Provider.of<LastPositionProvider>(context, listen: false);
    return StreamBuilder(
        stream: Stream.periodic(const Duration(seconds: 11), (_) async {
          return p.fetch(context);
        }),
        builder: (context, snapshot) {
          LastPositionProvider provider =
              Provider.of<LastPositionProvider>(context);
          return GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            circles: locator<GeozoneService>().circles,
            polygons: locator<GeozoneService>().polygons,
            trafficEnabled: provider.traficClicked,
            mapType: deviceProvider.mapType,
            zoomControlsEnabled: false,
            markers: provider.markersProvider.getMarkers()
              ..addAll(p.getGeozoneShapes()),
            polylines: provider.polylines,
            mapToolbarEnabled: false,
            onMapCreated: (controller) async {
              provider.mapController = controller;
              // zoom camera 
              provider.handleZoomCamera();
              provider.markersProvider.simpleMarkerManager
                  .setMapId(controller.mapId);
              provider.markersProvider.textMarkerManager
                  .setMapId(controller.mapId);
            },
            onCameraMove: (pos) {
              provider.markersProvider.currentZoom = pos.zoom;
              provider.markersProvider.simpleMarkerManager.onCameraMove(pos);
              provider.markersProvider.textMarkerManager.onCameraMove(pos);
            },
            onCameraIdle: () {
              provider.markersProvider.simpleMarkerManager.updateMap();
              provider.markersProvider.textMarkerManager.updateMap();
            },
            initialCameraPosition: const CameraPosition(
                target: LatLng(31.7917, -7.0926), zoom: 6.5),
          );
        });
  }
}
