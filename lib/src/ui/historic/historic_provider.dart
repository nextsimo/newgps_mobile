import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:label_marker/label_marker.dart';
import 'package:newgps/src/ui/repport/trips/trips_model.dart';
import 'package:newgps/src/utils/functions.dart';
import '../../models/account.dart';
import '../../models/device.dart';
import '../../models/historic_model.dart';
import '../../models/info_model.dart';
import '../../services/newgps_service.dart';
import '../../utils/device_size.dart';
import '../../widgets/floatin_window.dart';
import 'date_map_picker/time_range_widget.dart';

class HistoricProvider with ChangeNotifier {
  late Set<Marker> markers = {};

  final CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

  late DateTime dateFrom;
  late DateTime dateTo;

  GoogleMapController? mapController;

  late DateTime selectedDateFrom;
  late DateTime selectedDateTo;

  final Set<Marker> _parkingMarkers = {};

  bool useParkingMarker = false;

  void handleuseParkingMarkers(bool v) {
    useParkingMarker = v;
  }

  List<TripsRepportModel> trips = [];

  Future<void> fetchParkingMarkers() async {
    Account? account = shared.getAccount();
    debugPrint({
      'account_id': account?.account.accountId,
      'device_id': deviceProvider.selectedDevice?.deviceId,
      'date_from': dateFrom.millisecondsSinceEpoch / 1000,
      'date_to': dateTo.millisecondsSinceEpoch / 1000,
      'download': false
    }.toString());
    String str = await api.post(
      url: '/repport/trips/speed',
      body: {
        'account_id': account?.account.accountId,
        'device_id': deviceProvider.selectedDevice?.deviceId,
        'date_from': dateFrom.millisecondsSinceEpoch / 1000,
        'date_to': dateTo.millisecondsSinceEpoch / 1000,
        'download': false
      },
    );

    if (str.isNotEmpty) {
      trips = tripsRepportModelFromJson(str);
    }
  }

  void setParkingMarkers() {
    _parkingMarkers.clear();
    for (var trip in trips) {
      _parkingMarkers.add(
        Marker(
          markerId: MarkerId("${trip.latitude}${trip.longitude}"),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          position: LatLng(trip.latitude, trip.longitude),
          onTap: () {
            customInfoWindowController.addInfoWindow!(
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRowInfo('Début', formatDeviceDate(trip.startDate)),
                    const SizedBox(height: 10),
                    _buildRowInfo('Fin', formatDeviceDate(trip.endDate)),
                    const SizedBox(height: 10),
                    _buildRowInfo("Durée", trip.stopedTime),
                    const SizedBox(height: 10),
                    _buildRowInfo("Adresse", trip.endAddress),
                  ],
                ),
              ),
              LatLng(trip.latitude, trip.longitude),
            );
          },
        ),
      );
    }
    notifyListeners();
  }

  Row _buildRowInfo(String label, String content) {
    return Row(
      children: [
        Text(label),
        const Text(
          ":",
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // show bottom sheet

  TextEditingController autoSearchController = TextEditingController();

  Device? selectedPlayData;

  bool _loading = false;

  bool get loading => _loading;

  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  clearMarker() {
    markers.clear();

    notifyListeners();
  }

  HistoricModel historicModel = HistoricModel(
    devices: [],
  );

  void notify() {
    notifyListeners();
  }

  Set<Marker> getMarker() {
    if (useParkingMarker) return _parkingMarkers;
    if (historicIsPlayed) return playedMarkers;
    return markers;
  }

  bool play = true;

  void playPause() {
    play = !play;
    notifyListeners();
    if (play) {
      continueHistoric();
    }
  }

  void fresh() {
    markers = {};
    autoSearchController.dispose();
    mapController = null;
    notifyListeners();
  }

  // on camera move
  void onCameraMove(CameraPosition cameraPosition) {
    customInfoWindowController.onCameraMove!();
  }

  // ontap map
  void onTapMap(LatLng latLng) {
    customInfoWindowController.hideInfoWindow!();
  }

  Set<Marker> playedMarkers = {};

  Set<Polyline> line = {};
  Set<Polyline> histoLine = {};

  bool historicIsPlayed = false;
  int stopedIndex = 0;
  int selectedIndex = 0;

  Set<Polyline> getLines() {
    if (line.isEmpty) {
      return histoLine;
    }
    return line;
  }

  void ontapSpeed(int index) {
    selectedIndex = index;
    switch (index) {
      case 0:
        speedDuration = const Duration(milliseconds: 1300);
        break;
      case 1:
        speedDuration = const Duration(milliseconds: 800);
        break;
      case 2:
        speedDuration = const Duration(milliseconds: 500);
        break;
      case 3:
        speedDuration = const Duration(milliseconds: 160);
        break;
      default:
    }
    notifyListeners();
  }

  Duration speedDuration = const Duration(milliseconds: 1300);
  void playHistoric() async {
    playedMarkers.clear();
    line.clear();
    historicIsPlayed = !historicIsPlayed;
    if (!historicIsPlayed) {
      notifyListeners();
      return;
    }

    // clear all markers
    int index = -1;
    line.clear();
    bool init = true;
    for (Device device in historicModel.devices!) {
      if (!play) {
        stopedIndex = historicModel.devices!.indexOf(device);
        break;
      }
      selectedPlayData = device;
      if (!historicIsPlayed) break;
      index++;

      Marker marker = markers.elementAt(index);
      playedMarkers.add(marker);
      if (init) {
        await mapController?.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: marker.position,
                bearing: device.heading.toDouble(),
                zoom: 14.5)));
        init = false;
      }
      if (playedMarkers.length > 1) {
        line.add(Polyline(
          color: Colors.blue,
          polylineId: PolylineId(marker.position.toString()),
          points: [markers.elementAt(index - 1).position, marker.position],
        ));
      }
      await mapController
          ?.animateCamera(CameraUpdate.newLatLng(marker.position));
      notifyListeners();
      await Future.delayed(speedDuration);
    }

    // notify each time add marker
  }

  void continueHistoric() async {
    if (!historicIsPlayed) {
      playedMarkers.clear();
      line.clear();
      notifyListeners();
      return;
    }

    // clear all markers
    int index = stopedIndex;
    bool init = true;
    for (Device device in historicModel.devices!
        .getRange(stopedIndex, historicModel.devices!.length)) {
      if (!play) {
        stopedIndex = historicModel.devices!.indexOf(device);
        break;
      }
      selectedPlayData = device;
      if (!historicIsPlayed) break;
      index++;
      Marker marker = markers.elementAt(index);
      playedMarkers.add(marker);
      if (init) {
        await mapController?.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: marker.position,
                bearing: device.heading.toDouble(),
                zoom: 14.5)));
        init = false;
      }
      if (playedMarkers.length > 1) {
        line.add(Polyline(
          color: Colors.blue,
          polylineId: PolylineId(marker.position.toString()),
          points: [markers.elementAt(index - 1).position, marker.position],
        ));
      }
      await mapController
          ?.animateCamera(CameraUpdate.newLatLng(marker.position));
      notifyListeners();
      await Future.delayed(speedDuration);
    }

    // notify each time add marker
  }

  void moveCamera(LatLng pos, {double zoom = 6}) {
    mapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: pos, zoom: zoom),
    ));
  }

  void initTimeRange() {
    selectedDateFrom = dateFrom;
    selectedDateTo = dateTo;
  }

  void onTimeRangeSaveClicked() {
    dateFrom = DateTime(
      dateFrom.year,
      dateFrom.month,
      dateFrom.day,
      selectedDateFrom.hour,
      selectedDateFrom.minute,
      selectedDateFrom.second,
    );

    dateTo = DateTime(
      dateTo.year,
      dateTo.month,
      dateTo.day,
      selectedDateTo.hour,
      selectedDateTo.minute,
      selectedDateTo.second,
    );
    notifyListeners();
  }

  void onTimeRangeRestaureClicked() {
    _initDate();
    notifyListeners();
  }

  HistoricProvider() {
    _initDate();
  }

  void init(BuildContext context) {
    fetchHistorics(context, 1, true);
  }

  void normaleView() {
    mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        const CameraPosition(
          bearing: 0,
          target: LatLng(33.589886, -7.603869),
          zoom: 6.5,
        ),
      ),
    );
  }

  void _initDate() {
    var now = DateTime.now();
    dateFrom = DateTime(now.year, now.month, now.day, 00, 00, 01);
    dateTo = DateTime(now.year, now.month, now.day, 23, 59, 59);
  }

  void handleSelectDevice() {
    autoSearchController.text =
        deviceProvider.selectedDevice?.description ?? '';
  }

  Future<void> fetchInfoData() async {
    Account? account = shared.getAccount();

    String res = await api.post(
      url: '/info',
      body: {
        'account_id': account?.account.accountId,
        'device_id': deviceProvider.selectedDevice?.deviceId,
        'date_from': dateFrom.millisecondsSinceEpoch ~/ 1000,
        'date_to': dateTo.millisecondsSinceEpoch ~/ 1000,
      },
    );

    if (res.isNotEmpty) {
      deviceProvider.infoModel = infoModelFromJson(res);
    }
  }

  void clear() {
    playedMarkers.clear();
    line.clear();
    historicIsPlayed = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      notifyListeners();
    });
  }

  Future<void> updateDate(BuildContext context) async {
    var now = DateTime.now();
    DateTime? datetime = await showDatePicker(
      context: context,
      initialDate: dateFrom,
      firstDate: DateTime(now.year - 30),
      lastDate: now,
    );

    if (datetime == null) return;

    dateFrom = DateTime(
      datetime.year,
      datetime.month,
      datetime.day,
      dateFrom.hour,
      dateFrom.minute,
      dateFrom.second,
    );

    dateTo = DateTime(
      datetime.year,
      datetime.month,
      datetime.day,
      dateTo.hour,
      dateTo.minute,
      dateTo.second,
    );

    // ignore: use_build_context_synchronously
    fetchHistorics(context, 1, true);
  }

  void updateTimeRange(BuildContext context) async {
    showDialog(
      context: context,
      builder: (_) => const Dialog(
        child: TimeRangeWigdet(),
      ),
    );
  }

  // get tow points from list of points to fit the map  to the screen

  // zo

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

  Set<Circle> circles = {};

  // set start and end markers
  Future<void> _setStartEndMarkers() async {
    if (markers.length > 1) {
      circles.add(
        Circle(
          circleId: const CircleId('Fin'),
          center: LatLng(
            markers.last.position.latitude,
            markers.last.position.longitude,
          ),
          radius: 20,
          fillColor: const Color.fromARGB(66, 244, 67, 54),
          strokeColor: Colors.red,
          strokeWidth: 2,
        ),
      );
    }
  }

  Future<void> fetchHistorics(BuildContext context,
      [int page = 1, bool init = false]) async {
    if (useParkingMarker) {
      loading = true;
      _parkingMarkers.clear();
      notifyListeners();
      await fetchParkingMarkers();
      loading = false;
      setParkingMarkers();
      return;
    }

    histoLine = {};
    histoLine.clear();
    playedMarkers = {};
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loading = true;
    });
    if (init) {
      _loading = true;
      markers = {};
      circles = {};

      playedMarkers = {};
      historicModel.devices?.clear();
    }
    Account? account = shared.getAccount();

    String res = await api.postGzipCode(
      url: '/historic2',
      body: {
        'accountId': account?.account.accountId,
        'deviceId': deviceProvider.selectedDevice?.deviceId,
        'from': dateFrom.millisecondsSinceEpoch / 1000,
        'to': dateTo.millisecondsSinceEpoch / 1000,
        'page': page,
        'is_mobile': true
      },
    );
    if (res.isNotEmpty) {
      HistoricModel newHistoricModel = HistoricModel.fromMap(jsonDecode(res));
      historicModel.currentPage = newHistoricModel.currentPage;
      historicModel.lastPage = newHistoricModel.lastPage;
      historicModel.total = newHistoricModel.total;
      historicModel.devices?.addAll(newHistoricModel.devices!);
      for (Device device in newHistoricModel.devices!) {
        // check if the first index
        if (historicModel.devices?.indexOf(device) == 0) {
          circles.add(
            Circle(
              circleId: const CircleId('Départ'),
              center: LatLng(device.latitude, device.longitude),
              radius: 20,
              fillColor: const Color.fromARGB(86, 76, 175, 79),
              strokeColor: Colors.green,
              strokeWidth: 2,
            ),
          );
          markers.add(
            Marker(
              markerId: const MarkerId('Départ'),
              zIndex: 2,
              position: LatLng(device.latitude, device.longitude),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen),
              infoWindow: const InfoWindow(title: 'Départ'),
              onTap: () {
                // zoom to point
                mapController!.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(device.latitude, device.longitude),
                    18,
                  ),
                );
              },
            ),
          );
        }
        markers.add(getSimpleMarker(device));
      }
      if (historicModel.currentPage < historicModel.lastPage) {
        // ignore: use_build_context_synchronously
        fetchHistorics(context, ++page);
        return;
      }
      _zoomToPoints(markers.map((e) => e.position).toList());
      await fetchInfoData();
    }

    int index = -1;
    histoLine.clear();
    for (var m in markers) {
      index++;
      if (index == markers.length - 2) break;
      histoLine.addAll(Set<Polyline>.from({
        Polyline(
          width: 3,
          color: Colors.red.withOpacity(0.4),
          polylineId: PolylineId(m.position.toString()),
          points: [
            m.position,
            markers.elementAt(index + 1).position,
          ],
        )
      }));
    }
    await _setStartEndMarkers();

    loading = false;
  }

  void onTapEnter(BuildContext context, String val) {
    deviceProvider.selectedDevice = deviceProvider.devices.firstWhere(
      (device) {
        return device.description.toLowerCase().contains(val.toLowerCase());
      },
    );
    deviceProvider.handleSelectDevice();
    notifyListeners();
    fetchHistorics(context);
  }

  Future<void> _onTapMarker(Device device) async {
    await showModalBottomSheet(
      isDismissible: true,
      context: DeviceSize.c,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isScrollControlled: false,
      builder: (context) {
        return FloatingGroupWindowInfo(
          showCallDriver: false,
          device: device,
          showOnOffDevice: false,
        );
      },
    );
  }

  Marker getSimpleMarker(Device device) {
    LatLng position = LatLng(device.latitude, device.longitude);
    BitmapDescriptor bitmapDescriptor;
    try {
      log('${device.dateTime}');
      if (device.markerPng.isEmpty) {
        log("message");
        bitmapDescriptor = BitmapDescriptor.defaultMarker;
      } else {
        Uint8List imgRes = base64Decode(device.markerPng);
        bitmapDescriptor = BitmapDescriptor.fromBytes(imgRes);
      }
    } catch (e) {
      log(device.markerPng);
      log(e.toString());
      bitmapDescriptor = BitmapDescriptor.defaultMarker;
    }
    Device myDevice = device.copyWith(
      description: deviceProvider.selectedDevice?.description ?? '',
    );
    return Marker(
      onTap: () => _onTapMarker(myDevice),
      markerId: MarkerId('${device.latitude},${device.longitude}'),
      position: position,
      icon: bitmapDescriptor,
    );
  }
}
