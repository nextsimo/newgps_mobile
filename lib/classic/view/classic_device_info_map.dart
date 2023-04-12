import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:newgps/src/ui/navigation/top_app_bar.dart';

import '../../models/device_info_model.dart';

class ClassicDeviceInfoMap extends StatelessWidget {
  final DeviceInfoModel deviceInfo;
  final Color stateColor;
  const ClassicDeviceInfoMap(
      {super.key, required this.deviceInfo, required this.stateColor});

  static Route route(DeviceInfoModel deviceInfo, Color stateColor) {
    return MaterialPageRoute<void>(
      builder: (_) =>
          ClassicDeviceInfoMap(deviceInfo: deviceInfo, stateColor: stateColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: LatLng(deviceInfo.latitude, deviceInfo.longitude),
              interactiveFlags:
                  InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              zoom: 11,
              maxZoom: 18,
              minZoom: 5,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://maps.googleapis.com/maps/vt?pb=!1m4!1m3!1i{z}!2i{x}!3i{y}!2m3!1e0!2sar-MO!3i420120488!3m7!2sMaroc!2sfr!3sMA!1e68!1sfr!23i4111425!1d6949765.30025005!2d-11.64635036166239!3d31.731186528518357',
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  if (deviceInfo.points.isEmpty)
                    _buildMarker(
                      LatLng(deviceInfo.latitude, deviceInfo.longitude),
                      stateColor,
                      deviceInfo.heading,
                    ),
                  if (deviceInfo.points.isNotEmpty) ...[
                    _buildMarker(
                      deviceInfo.points.last,
                      stateColor,
                      deviceInfo.heading,
                    ),
                    _buildMarker(
                      deviceInfo.points.first,
                      Colors.blue,
                      deviceInfo.heading,
                    ),
                    if(deviceInfo.maxSpeed >0)
                    Marker(
                      width: 60.0,
                      height: 60.0,
                      rotate: true,
                      anchorPos: AnchorPos.align(AnchorAlign.center),
                      point: deviceInfo.points.last,
                      builder: (ctx) => Column(
                        children: [
                                                    Text(
                            '${deviceInfo.maxSpeed} km/h',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const Icon(
                            FontAwesomeIcons.solidFlag,
                            color: Colors.red,
                            size: 20,
                          ),

                        ],
                      ),
                    ),
                  ]
                ],
              ),

              PolylineLayer(
                polylines: [
                  Polyline(
                    points: deviceInfo.points,
                    strokeWidth: 4.0,
                    color: stateColor,
                  ),
                ],
              ),

              //CurrentLocationLayer(), // <-- add layer here
            ],
          ),
          const Positioned(
            top: 100,
            left: 10,
            child: BackButton(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Marker _buildMarker(LatLng pos, Color color, double heading) {
    return Marker(
      width: 30.0,
      height: 30.0,
      rotate: true,
      anchorPos: AnchorPos.align(AnchorAlign.center),
      point: pos,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.4),
          shape: BoxShape.circle,
          border: Border.fromBorderSide(
            BorderSide(
              color: color,
              width: 1.0,
            ),
          ),
        ),
        child: Transform.rotate(
          angle: heading,
          child: Icon(
            FontAwesomeIcons.locationArrow,
            color: color,
            size: 15.0,
          ),
        ),
      ),
    );
  }
}
