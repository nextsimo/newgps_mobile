import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../../models/device.dart';

class MapViewAlertProvider with ChangeNotifier {
  Set<Marker> _markers = {};

  Set<Marker> get markers => _markers;

  set markers(Set<Marker> markers) {
    _markers = markers;
    notifyListeners();
  }

  MapViewAlertProvider(Device device) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchMarkers(device);
    });
  }

  void fetchMarkers(Device device) {
    markers.clear();
    markers.add(_getSimpleMarker(device));
    notifyListeners();
  }
  final uuid = const Uuid();
  Marker _getSimpleMarker(Device device) {
    LatLng position = LatLng(device.latitude, device.longitude);
    Uint8List imgRes = base64Decode(device.markerPng);
/*     Uint8List imgRes = showMatricule
        ? base64Decode(device.markerTextPng)
        : base64Decode(device.markerPng); */
    BitmapDescriptor bitmapDescriptor = BitmapDescriptor.fromBytes(imgRes);
    return Marker(
      //onTap: () => _onTapMarker(device),
      markerId:  MarkerId(uuid.v4()),
      position: position,
      icon: bitmapDescriptor,
    );
  }
}
