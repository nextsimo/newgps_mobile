import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:provider/provider.dart';

import '../navigation/top_app_bar.dart';
import 'classic_provider.dart';

class ClassicViewMap extends StatelessWidget {
  final BuildContext providerContext;
  final Set<Marker> markers;
  final Device device;
  const ClassicViewMap(
      {Key? key, required this.device, required this.providerContext, required this.markers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = providerContext.watch<ClassicProvider>();
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              markers: markers,
              initialCameraPosition: provider.initialCameraPosition,
              onMapCreated: (controller) =>
                  provider.onMapCreated(controller, device),
              mapType: deviceProvider.mapType,
              myLocationButtonEnabled: true,
            ),
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppConsts.mainColor, width: 2.0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: BackButton(
                color: Colors.black,
                onPressed: () => provider.backToClassicView(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
