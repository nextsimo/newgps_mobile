import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newgps/src/utils/utils.dart';
import '../../../../models/device.dart';
import '../../../../services/device_provider.dart';
import 'map_view_alert_provider.dart';
import '../../../../widgets/map_type_widget.dart';
import 'package:provider/provider.dart';

class MapViewALert extends StatelessWidget {
  final Device device;
  const MapViewALert({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);
    return ChangeNotifierProvider<MapViewAlertProvider>(
        create: (_) => MapViewAlertProvider(device),
        builder: (context, __) {
          MapViewAlertProvider provider =
              Provider.of<MapViewAlertProvider>(context);
          return Stack(
            children: [
              GoogleMap(
                cloudMapId: Utils.mapId,
                mapType: deviceProvider.mapType,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                markers: provider.markers,
                initialCameraPosition: const CameraPosition(
                    target: LatLng(33.589886, -7.603869), zoom: 6),
                onMapCreated: (GoogleMapController controller) {
                  provider.googleMapController = controller;
                  provider.googleMapController
                      ?.setMapStyle(Utils.googleMapStyle);
                },
              ),
              const Align(
                alignment: Alignment.topRight,
                child: CloseButton(
                  color: Colors.black,
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: MapTypeWidget(
                  onChange: (MapType _) {
                    deviceProvider.mapType = _;
                  },
                  mapController: provider.googleMapController,
                ),
              ),
            ],
          );
        });
  }
}
