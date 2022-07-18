import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/ui/historic/historic_provider.dart';
import 'package:provider/provider.dart';

class HistoricMapView extends StatefulWidget {
  const HistoricMapView({Key? key}) : super(key: key);

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
    if (state == AppLifecycleState.resumed) {
      historicProvider.mapController?.setMapStyle("[]");
    }
  }

  @override
  void dispose() {
    super.dispose();
    historicProvider.clear();
  }

  @override
  Widget build(BuildContext context) {
    context.select<DeviceProvider, MapType>((value) => value.mapType);
    return Center(
      child: Consumer<HistoricProvider>(
          builder: (_, HistoricProvider provider, __) {
        final DeviceProvider deviceProvider =
            Provider.of<DeviceProvider>(context, listen: false);
        return GoogleMap(
          polylines: provider.getLines(),
          zoomControlsEnabled: false,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          markers: provider.getMarker(),
          mapType: deviceProvider.mapType,
          onMapCreated: (controller) async {
            provider.mapController = controller;
            controller
                .moveCamera(CameraUpdate.newCameraPosition(const CameraPosition(
              bearing: 0,
              target: LatLng(33.589886, -7.603869),
              zoom: 6.5,
            )));
          },
          initialCameraPosition:
              const CameraPosition(target: LatLng(31.7917, -7.0926), zoom: 6),
        );
      }),
    );
  }
}
