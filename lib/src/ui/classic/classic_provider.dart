import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/ui/classic/classic_info_windows.dart';
import '../../models/device.dart';

class ClassicProvider with ChangeNotifier {
  bool _loading = false;
  final CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

  List<Device> devices = [];

  late Device device;

  final PageController pageController = PageController();

  final initialCameraPosition =
      const CameraPosition(target: LatLng(0, 0), zoom: 0);

  GoogleMapController? mapController;

  ClassicProvider() {
    devices = deviceProvider.devices;
  }

  Set<Marker> markers = {};

  // on tap map
  void onTapMap(LatLng latLng) {
    customInfoWindowController.hideInfoWindow!();
  }

  // on camera move
  void onCameraMove(CameraPosition cameraPosition) {
    customInfoWindowController.onCameraMove!();
  }

  // on map created
  Future<void> onMapCreated(
      GoogleMapController controller, Device device) async {
    mapController = controller;
    customInfoWindowController.googleMapController = controller;
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
    BitmapDescriptor bitmapDescriptor = BitmapDescriptor.fromBytes(imgRes);
    return Marker(
      markerId: const MarkerId('oneMarker'),
      position: position,
      icon: bitmapDescriptor,
      onTap: () => customInfoWindowController.addInfoWindow!(
        ClassicInfoWindows(
          device: device
        ),
        position,
      ),
    );
  }

  // animated to device position
  Future<void> _animatedToDevice(Device device) async {
    try {
      await mapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(device.latitude, device.longitude), zoom: 15)));
    } catch (_) {}
  }

  // goto the map view
  Future<void> gotoMapView(Device d, BuildContext providerContextasync) async {
    device = d;
    List<Marker> newMarkers = [];
    newMarkers.add(_getSimpleMarker(device));
    markers = newMarkers.toSet();
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    pageController.jumpToPage(1);
    await _animatedToDevice(device);
  }

  void backToClassicView(BuildContext context) {
    pageController.jumpToPage(0);
    markers = {};
    notifyListeners();
    customInfoWindowController.hideInfoWindow!();
  }

  @override
  void dispose() {
    mapController?.dispose();
    customInfoWindowController.dispose();
    super.dispose();
  }
}
