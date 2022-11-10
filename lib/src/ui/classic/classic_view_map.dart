import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/widgets/custom_info_windows.dart';
import 'package:provider/provider.dart';
import 'classic_provider.dart';

class ClassicViewMap extends StatefulWidget {
  const ClassicViewMap({
    Key? key,
  }) : super(key: key);

  @override
  State<ClassicViewMap> createState() => _ClassicViewMapState();
}

class _ClassicViewMapState extends State<ClassicViewMap>
    with AutomaticKeepAliveClientMixin<ClassicViewMap> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final provider = context.read<ClassicProvider>();
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Consumer<ClassicProvider>(builder: (context, provider, __) {
              return GoogleMap(
                markers: provider.markers,
                initialCameraPosition: provider.initialCameraPosition,
                onMapCreated: (controller) =>
                    provider.onMapCreated(controller, provider.device),
                mapType: deviceProvider.mapType,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                onCameraMove: provider.onCameraMove,
                onTap: provider.onTapMap,
              );
            }),
            MyCustomInfoWindows(controller: provider.customInfoWindowController),
            InkWell(
              onTap: () => provider.backToClassicView(context),
              child: Container(
                width: 48,
                height: 48,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppConsts.mainColor, width: 2.0),
                  borderRadius: BorderRadius.circular(AppConsts.mainradius),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
