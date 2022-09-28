import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/ui/classic/classic_view_map.dart';
import 'package:newgps/src/utils/functions.dart';
import '../../models/device.dart';

class ClassicProvider with ChangeNotifier {
  bool _loading = false;

  List<Device> devices = [];

  final initialCameraPosition =
      const CameraPosition(target: LatLng(0, 0), zoom: 0);

  GoogleMapController? mapController;

  ClassicProvider() {
    devices = deviceProvider.devices;
  }

  // on map created
  Future<void> onMapCreated(
      GoogleMapController controller, Device device) async {
    mapController = controller;
    _animatedToDevice(device);
  }

  bool get loading => _loading;

  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  // refresh devices list
  Future<void> refreshDevices(BuildContext context) async {
    if (loading == true) return;
    loading = true;
    await Future.delayed(const Duration(seconds: 3));
    loading = false;
  }

  Marker _getSimpleMarker(Device device) {
    LatLng position = LatLng(device.latitude, device.longitude);
    Uint8List imgRes = base64Decode(device.markerPng);
/*     Uint8List imgRes = showMatricule
        ? base64Decode(device.markerTextPng)
        : base64Decode(device.markerPng); */
    BitmapDescriptor bitmapDescriptor = BitmapDescriptor.fromBytes(imgRes);
    return Marker(
      //onTap: () => _onTapMarker(device),
      markerId: MarkerId('${device.latitude},${device.longitude}'),
      position: position,
      icon: bitmapDescriptor,
      infoWindow: InfoWindow(
        title: device.description,
        snippet: formatDeviceDate(device.dateTime),
      ),
    );
  }

  // animated to device position
  Future<void> _animatedToDevice(Device device) async {
    try {

      await mapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(device.latitude, device.longitude), zoom: 15)));
      notifyListeners();
    } catch (_) {}
  }

  // goto the map view
  Future<void> gotoMapView(
      Device device, BuildContext providerContextasync) async {
    Set<Marker> markers = {};
    markers.add(_getSimpleMarker(device));
    Navigator.of(providerContextasync).push(
      MaterialPageRoute(
        builder: (context) => ClassicViewMap(
          device: device,
          providerContext: providerContextasync,
          markers: markers,
        ),
      ),
    );
  }

  void backToClassicView(BuildContext context) {
    mapController?.dispose();
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }
}
