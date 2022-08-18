import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newgps/src/ui/repport_map/repport_map_provider.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:provider/provider.dart';

class RepportMapView extends StatelessWidget {
  final Set<Marker> markers;
  final DateTime stopDate;
  final String stopeTime;
  final String deviceDescription;
  const RepportMapView(
      {Key? key,
      required this.markers,
      required this.stopDate,
      required this.stopeTime,
      required this.deviceDescription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RepportMapProvider>(
        create: (context) => RepportMapProvider(markers),
        builder: (context, __) {
          // read provider
          final provider = context.read<RepportMapProvider>();
          return Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                /// Google Map
                Center(
                  child: Container(
                    height: 600,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                                target: LatLng(
                              markers.first.position.latitude,
                              markers.first.position.longitude,
                            )),
                            markers: provider.markers,
                            onMapCreated: provider.onMapCreated,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    formatDeviceDate(stopDate),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 17,
                                    child: VerticalDivider(
                                      thickness: 1.2,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    stopeTime,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.car_crash_rounded,
                                    color: Colors.red,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    deviceDescription,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // close button
                Positioned(
                  top: 10,
                  right: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      color: Colors.black,
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
