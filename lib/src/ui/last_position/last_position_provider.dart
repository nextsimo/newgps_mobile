import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../models/account.dart';
import '../../models/device.dart';
import '../../models/info_model.dart';
import '../../services/newgps_service.dart';
import 'markers_provider.dart';

import '../../services/geozone_service.dart';
import '../../utils/locator.dart';

class LastPositionProvider with ChangeNotifier {
  late List<Device> _devices = [];
  late Set<Polyline> polylines = {};
  late DateTime lastDateFetchDevices = DateTime.now();
  late bool notifyMap = false;
  bool _showGeozone = false;

  bool get showGeozone => _showGeozone;

  set showGeozone(bool showGeozone) {
    _showGeozone = showGeozone;
    notifyListeners();
  }

  bool _init = false;

  late MarkersProvider markersProvider;

  GoogleMapController? mapController;

  bool _matriculeClicked = false;
  bool _regrouperClicked = false;

  bool get regrouperClicked => _regrouperClicked;

  set regrouperClicked(bool regrouperClicked) {
    _regrouperClicked = regrouperClicked;
    notifyListeners();
  }

  // handle zoome camera
  Future<void> handleZoomCamera() async {
    if (mapController != null) {
      // check if group of deveices is selected
      if (markersProvider.fetchGroupesDevices) {
        _zoomToPoints(List<LatLng>.from(markersProvider.devices
            .map((e) => LatLng(e.latitude, e.longitude))));
      } else {
        if (deviceProvider.selectedDevice == null) return;
        Device device = deviceProvider.selectedDevice!;
        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(device.latitude, device.longitude),
              zoom: 15,
            ),
          ),
        );
      }
    }
  }

  // zoom to list of points
  Future<void> _zoomToPoints(List<LatLng> points) async {
    if (points.isNotEmpty) {
      final bounds = boundsFromLatLngList(points);

      // zoom and center to bounds
      await mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 100),
      );
    }
  }

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
        northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }

  Future<void> fetch(BuildContext context) async {
    debugPrint("----------------> ${markersProvider.fetchGroupesDevices}");
    if (markersProvider.fetchGroupesDevices) {
      await fetchDevices(context);
    } else {
      await fetchDevice(deviceProvider.selectedDevice!.deviceId);
    }
  }

  // get geozone shapes
  Set<Marker> getGeozoneShapes() {
    if (!showGeozone) return {};
    return locator<GeozoneService>().geozoneMarkers;
  }

  bool get matriculeClicked => _matriculeClicked;

  set matriculeClicked(bool matriculeClicked) {
    _matriculeClicked = matriculeClicked;
    notifyListeners();
  }

  bool _traficClicked = false;

  bool get traficClicked => _traficClicked;

  void ontraficClicked(bool newState) {
    _traficClicked = newState;
    notifyListeners();
  }

  Future<void> fetchInfoData(String deviceID) async {
    Account? account = shared.getAccount();

    String res = await api.post(
      url: '/info',
      body: {
        'account_id': account?.account.accountId,
        'device_id': deviceID,
        'driving_time': true,
      },
    );

    if (res.isNotEmpty) {
      deviceProvider.infoModel = infoModelFromJson(res);
    }
  }

  void normaleView() {
    _zoomToPoints(List<LatLng>.from(
        markersProvider.devices.map((e) => LatLng(e.latitude, e.longitude))));
    return;
  }

  void notifyTheMap() {
    notifyMap = !notifyMap;
    notifyListeners();
  }

  Future<void> onClickRegoupement(bool state) async {
    regrouperClicked = state;
    log("$state");
    await markersProvider.onClickGroupment(state, devices);
    notifyListeners();
  }

  Future<void> onClickMatricule(bool state) async {
    matriculeClicked = state;
    log("$state");
    await markersProvider.onClickMatricule(state, devices);
    notifyListeners();
  }

  List<Device> get devices => _devices;

  TextEditingController autoSearchController =
      TextEditingController(text: 'init');
  void fresh() {
    _devices = [];
    polylines = {};
    markersProvider.fetchGroupesDevices = true;
    lastDateFetchDevices = DateTime.now();
    notifyMap = false;
    mapController = null;
    markersProvider.clusterItems = [];
    markersProvider.clusterItemsText = [];
    markersProvider.clusterMarkers = {};
    markersProvider.onMarker = {};
    markersProvider.showMatricule = false;
    markersProvider.showCluster = false;
    markersProvider.devices = [];
    markersProvider.textMakers = {};
    notifyListeners();
  }

  Future<void> init(BuildContext context) async {
    markersProvider = MarkersProvider(devices, context);
    _initCluster();
    await deviceProvider.init(context, init: true);
    await setDevicesMareker();
    await markersProvider.setMarkers(devices);
    notifyListeners();
  }

  Future<void> moveCamera(LatLng pos,
      {double zoom = 6, double tilt = 0.0, double bearing = 0}) async {
    await mapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: pos, zoom: zoom, tilt: tilt, bearing: bearing),
    ));
  }

  Future<void> fetchInitDevice(BuildContext context,
      {bool init = false}) async {
    if (_init) {
      if (markersProvider.fetchGroupesDevices) {
        await fetchDevices(context);
      } else {
        await fetchDevice(deviceProvider.selectedDevice!.deviceId);
      }
    }
    _init = true;
  }

  set devices(List<Device> devices) {
    _devices = devices;
    notifyListeners();
  }

  void handleSelectDevice({bool notify = true}) {
    if (markersProvider.fetchGroupesDevices) {
      autoSearchController.text = 'Tous les véhicules';
    } else {
      autoSearchController.text = deviceProvider.selectedDevice!.description;
    }
  }

  void updateSimpleClusterMarkers(Set<Marker> ms) {
    markersProvider.clusterMarkers = ms;
    notifyListeners();
  }

  void updateSimpleMarkersText(Set<Marker> ms) {
    markersProvider.textMakers = ms;
    notifyListeners();
  }

  final uuid = const Uuid();
  Future<Marker> Function(Cluster<Place>) markerBuilder(bool isText) =>
      (cluster) async {
        if (!isText) {
          return markersProvider.getClusterMarker(cluster);
        }
        if (isText && !cluster.isMultiple) {
          return markersProvider.getTextMarker(cluster.items.first.device);
        }
        return Marker(markerId: MarkerId(uuid.v4()), visible: false);
      };

  void _initCluster() {
    markersProvider.initCluster(this);
  }

  late bool loadingRoute = false;
  bool navigationStarted = false;

  void _setMapFitToTour(Set<Polyline> p) {
    double minLat = p.first.points.first.latitude;
    double minLong = p.first.points.first.longitude;
    double maxLat = p.first.points.first.latitude;
    double maxLong = p.first.points.first.longitude;
    for (var poly in p) {
      for (var point in poly.points) {
        if (point.latitude < minLat) minLat = point.latitude;
        if (point.latitude > maxLat) maxLat = point.latitude;
        if (point.longitude < minLong) minLong = point.longitude;
        if (point.longitude > maxLong) maxLong = point.longitude;
      }
    }

    mapController?.moveCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(minLat, minLong),
            northeast: LatLng(maxLat, maxLong)),
        90));
  }

  Future<void> buildRoutes() async {
    if (polylines.isNotEmpty && navigationStarted) {
      navigationStarted = false;
      polylines.clear();
      notifyTheMap();
      moveCamera(
          LatLng(deviceProvider.selectedDevice!.latitude,
              deviceProvider.selectedDevice!.longitude),
          zoom: 14);
      return;
    } else if (polylines.isNotEmpty && !navigationStarted) {
      navigationStarted = true;

      Position position =
          await GeolocatorPlatform.instance.getCurrentPosition();
      double b = GeolocatorPlatform.instance.bearingBetween(
        polylines.first.points.first.latitude,
        polylines.first.points.first.longitude,
        polylines.first.points[9].latitude,
        polylines.first.points[9].longitude,
      );

      moveCamera(
          LatLng(
            position.latitude,
            position.longitude,
          ),
          zoom: 14,
          tilt: 90,
          bearing: b);

      return;
    }

    await GeolocatorPlatform.instance.requestPermission();
    loadingRoute = true;
    notifyTheMap();
    List<LatLng> points = await _getRouteCoordinates();
    polylines.clear();
    polylines.add(
      Polyline(
        polylineId: const PolylineId('PolylineId'),
        width: 7,
        visible: true,
        endCap: Cap.roundCap,
        startCap: Cap.roundCap,
        points: points,
        color: Colors.blue[600]!,
        jointType: JointType.round,
      ),
    );
    loadingRoute = false;
    _setMapFitToTour(polylines);
    notifyTheMap();
  }

  Future<List<LatLng>> _getRouteCoordinates() async {
    Position myLocation = await Geolocator.getCurrentPosition();
    var res = await api.post(url: '/route', body: {
      "origin": "${myLocation.latitude},${myLocation.longitude}",
      "destination":
          "${deviceProvider.selectedDevice!.latitude},${deviceProvider.selectedDevice!.longitude}"
    });

    if (res.isEmpty) return [];
    var points = List<LatLng>.from(
        json.decode(res).map((e) => LatLng(e[0], e[1])).toList());
    return points;
  }

  bool _loadingDevice = false;

  Future<void> setDeviceOffline(String id) async {
    Device? device = deviceProvider.devices.firstWhere((d) => d.deviceId == id);
    deviceProvider.selectedDevice = device;
    markersProvider.onMarker.clear();
    markersProvider.simpleMarkers.clear();

    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 250));
    notifyListeners();
    markersProvider.onMarker.add(markersProvider.getSimpleMarker(device));
    moveCamera(
        LatLng(deviceProvider.selectedDevice!.latitude,
            deviceProvider.selectedDevice!.longitude),
        zoom: 14);
    notifyListeners();
  }

  Future<void> fetchDevice(String deviceId, {bool isSelected = false}) async {
    if (_loadingDevice) return;
    _loadingDevice = true;

    if (isSelected) {
      setDeviceOffline(deviceId);
    }

    Account? account = shared.getAccount();
    await Future.delayed(const Duration(milliseconds: 250));

    markersProvider.simpleMarkers = {};
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 250));
    notifyListeners();

    String res = await api.post(
      url: '/device',
      body: {
        'accountId': account?.account.accountId,
        'deviceId': deviceId,
        'is_web': false,
        'icon': 'BinTruck',
      },
    );

    if (res.isNotEmpty) {
      log(res);
      Device device = Device.fromMap(json.decode(res));
      deviceProvider.selectedDevice = device;
      await fetchInfoData(deviceId);
      markersProvider.onMarker.clear();
      markersProvider.onMarker.add(markersProvider.getSimpleMarker(device));
      notifyListeners();
    }
    await Future.delayed(const Duration(milliseconds: 300));
    if (isSelected) {
      if (polylines.isNotEmpty) {
        await buildRoutes();
      }
      moveCamera(
          LatLng(deviceProvider.selectedDevice!.latitude,
              deviceProvider.selectedDevice!.longitude),
          zoom: 14);
    }
    _loadingDevice = false;
  }

  Future<void> setDevicesMareker({bool fromSelect = false}) async {
    if (fromSelect) {
      normaleView();
    }
    polylines = {};
    navigationStarted = false;
    _devices = deviceProvider.devices;
    if (_devices.length == 1) deviceProvider.selectedDevice = _devices.first;
    markersProvider.simpleMarkers.clear();
    markersProvider.textMakers.clear();
    for (Device device in _devices) {
      Marker marker = markersProvider.getSimpleMarker(device);
      Marker textmarker = markersProvider.getTextMarker(device);
      markersProvider.simpleMarkers.add(marker);
      markersProvider.textMakers.add(textmarker);
    }
    _loading = false;
    debugPrint('end /api/devices called from last position');
    notifyListeners();
  }

  bool _loading = false;
  Future<void> fetchDevices(BuildContext context, {bool init = false}) async {
    lastDateFetchDevices = DateTime.now();
    if (_loading) return;
    debugPrint("-----------------------> ${lastDateFetchDevices.second}");
    debugPrint('start /api/devices called from last position');
    _loading = true;
    await deviceProvider.fetchDevices(init: init);
    await setDevicesMareker();
  }
}
