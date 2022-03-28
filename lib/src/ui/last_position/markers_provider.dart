import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/models/user_droits.dart';
import 'package:newgps/src/utils/device_size.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/ui/last_position/last_position_provider.dart';
import 'package:newgps/src/ui/login/login_as/save_account_provider.dart';
import 'package:newgps/src/widgets/floatin_window.dart';
import 'package:provider/provider.dart';

class Place with ClusterItem {
  final bool isText;
  final LatLng latLng;
  final Device device;

  Place({required this.latLng, this.isText = false, required this.device});

  @override
  String toString() {
    return 'Place ${device.description} (isText : $isText)';
  }

  @override
  LatLng get location => latLng;
}

class MarkersProvider {
  late ClusterManager simpleMarkerManager;
  late ClusterManager textMarkerManager;
  late Set<Marker> simpleMarkers = {};
  late Set<Marker> onMarker = {};
  late Set<Marker> textMakers = {};
  late List<Device> devices = [];
  late Set<Marker> clusterMarkers = {};
  bool showMatricule = false;
  bool showCluster = false;
  List<Place> clusterItems = [];
  List<Place> clusterItemsText = [];
  double currentZoom = 12;

  Future<void> onClickGroupment(bool state, List<Device> ds) async {
    showCluster = state;
    await setMarkers(ds);
  }

  Future<void> onClickMatricule(bool state, List<Device> ds) async {
    showMatricule = state;
    await setMarkers(ds);
  }

  void initCluster(LastPositionProvider lastPositionProvider) {
    textMarkerManager = ClusterManager<Place>(
        clusterItemsText, lastPositionProvider.updateSimpleMarkersText,
        stopClusteringZoom: 12,
        levels: const [1, 4, 5, 7, 9.5, 10, 11],
        markerBuilder: lastPositionProvider.markerBuilder(true));
    simpleMarkerManager = ClusterManager<Place>(
      clusterItems,
      lastPositionProvider.updateSimpleClusterMarkers,
      stopClusteringZoom: 12,
      levels: const [1, 4, 5, 7, 9.5, 10, 11],
      markerBuilder: lastPositionProvider.markerBuilder(false),
    );
  }

  MarkersProvider(List<Device> initDevices, BuildContext context) {
    devices = initDevices;
    SavedAcountProvider pro =
        Provider.of<SavedAcountProvider>(context, listen: false);
    droit = pro.userDroits.droits.elementAt(1);
  }

  bool fetchGroupesDevices = true;

  Set<Marker> getMarkers() {
    if (fetchGroupesDevices) {
      if (showCluster && showMatricule) {
        return clusterMarkers..addAll(textMakers);
      } else if (showCluster) {
        return clusterMarkers;
      } else {
        if (showMatricule) return simpleMarkers..addAll(textMakers);
        return simpleMarkers;
      }
    }
    return onMarker;
  }

  Future<void> setMarkers(List<Device> ds) async {
    devices = ds;
    simpleMarkers = {};
    clusterMarkers = {};
    textMakers = {};
    if (fetchGroupesDevices) {
      if (showCluster) {
        // fetch with cluster
        if (showMatricule) {
          // clustring with matricule
          _setWithClusterAndMatricule();
        } else {
          // clutsring only without matricule
          _setWithClusterOnly();
        }
      } else {
        if (showMatricule) {
          _setMarkersWithMatricule();
        } else {
          _setMarkersOnly();
        }
      }
    } else {
      if (showMatricule) {
        // normal marker with matricule
        _setMarkersWithMatricule();
      } else {
        // normal marker without matricule
        _setMarkersOnly();
      }
    }
  }

  void _setMarkersOnly() {
    simpleMarkers = Set<Marker>.from(devices.map((d) {
      return getSimpleMarker(d);
    }).toSet());
  }

  void _setMarkersWithMatricule() async {
    for (Device device in devices) {
      simpleMarkers.add(getSimpleMarker(device));
      textMakers.add(getTextMarker(device));
    }
  }

  void _setWithClusterOnly() {
    clusterItems = [];
    clusterItemsText = [];
    clusterItems = List<Place>.from(devices.map((d) {
      LatLng position = LatLng(d.latitude, d.longitude);
      return Place(
        latLng: position,
        device: d,
      );
    }).toList());
    simpleMarkerManager.setItems(clusterItems);
    textMarkerManager.setItems(clusterItemsText);
    simpleMarkerManager.updateMap();
  }

  void _setWithClusterAndMatricule() {
    clusterItems = [];
    clusterItemsText = [];

    for (Device device in devices) {
      LatLng position = LatLng(device.latitude, device.longitude);
      clusterItems.add(
        Place(
          device: device,
          latLng: position,
        ),
      );
      clusterItemsText.add(
        Place(
          device: device,
          latLng: position,
        ),
      );
    }
    simpleMarkerManager.setItems(clusterItemsText);
    textMarkerManager.setItems(clusterItems);
    simpleMarkerManager.updateMap();
    textMarkerManager.updateMap();
  }

  Future<Marker> getClusterMarker(Cluster<Place> cluster) async {
    Color color = cluster.isMultiple
        ? AppConsts.blue
        : Color.fromRGBO(
            cluster.items.first.device.colorR,
            cluster.items.first.device.colorG,
            cluster.items.first.device.colorB,
            1);

    debugPrint("->${cluster.location.latitude}->${cluster.location.longitude}");
    if (currentZoom > 11 && !cluster.isMultiple) {
      return getSimpleMarker(cluster.items.first.device);
    }

    return Marker(
      position: cluster.location,
      markerId: MarkerId(
          '${cluster.location.latitude},${cluster.location.longitude}'),
      icon: await _getClusterBitmap(
        '${cluster.count}',
        myColor: color,
      ),
    );
  }

  Marker getTextMarker(Device device) {
    LatLng position = LatLng(device.latitude, device.longitude);
    Uint8List imgRes = base64Decode(device.markerText);
    BitmapDescriptor bitmapDescriptor = BitmapDescriptor.fromBytes(imgRes);
    return Marker(
      zIndex: 1,
      onTap: () => _onTapMarker(device),
      position: position,
      anchor: const Offset(0.5, 0.1),
      markerId: MarkerId('${device.latitude},${device.longitude}___text'),
      icon: bitmapDescriptor,
    );
  }

  bool showWindows = false;

  late Droit droit;

  Future<void> _onTapMarker(Device device) async {
    await showModalBottomSheet(
      isDismissible: true,
      context: DeviceSize.c,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isScrollControlled: false,
      builder: (context) {
        return FloatingGroupWindowInfo(
          showCallDriver: fetchGroupesDevices,
          device: device,
          showOnOffDevice: droit.write,
        );
      },
    );
  }

  Marker getSimpleMarker(Device device) {
    LatLng position = LatLng(device.latitude, device.longitude);
    Uint8List imgRes = base64Decode(device.markerPng);
/*     Uint8List imgRes = showMatricule
        ? base64Decode(device.markerTextPng)
        : base64Decode(device.markerPng); */
    BitmapDescriptor bitmapDescriptor = BitmapDescriptor.fromBytes(imgRes);
    return Marker(
      onTap: () => _onTapMarker(device),
      markerId: MarkerId('${device.latitude},${device.longitude}'),
      position: position,
      icon: bitmapDescriptor,
    );
  }

  Future<BitmapDescriptor> _getClusterBitmap(String text,
      {double size = 110, Color myColor = AppConsts.blue}) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = myColor;
    final Paint paint2 = Paint()..color = Colors.white;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);

    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: text,
      style: TextStyle(
          fontSize: size / 3,
          color: Colors.white,
          fontWeight: FontWeight.normal),
    );
    painter.layout();
    painter.paint(canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2));

    final img = await pictureRecorder
        .endRecording()
        .toImage(size.toInt(), size.toInt());
    final data = await img.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }
}
