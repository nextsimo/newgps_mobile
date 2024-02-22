import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animarker/core/ripple_marker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newgps/src/ui/repport/trips/trips_model.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:uuid/uuid.dart';
import '../../models/account.dart';
import '../../models/device.dart';
import '../../models/historic_model.dart';
import '../../models/info_model.dart';
import '../../services/newgps_service.dart';
import '../../utils/device_size.dart';
import '../../widgets/floatin_window.dart';
import 'date_map_picker/time_range_widget.dart';

class HistoricProvider with ChangeNotifier {
  final Map<String, Marker> markers = {};

  bool notifyMap = false;

  Device? lastDevice;

  final CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

  late DateTime dateFrom;
  late DateTime dateTo;
  GoogleMapController? googleMapController;

  DateTime selectedDateFrom = DateTime.now();
  DateTime selectedDateTo = DateTime.now();

  final Map<String, Marker> _parkingMarkers = {};

  bool useParkingMarker = false;

  void handleuseParkingMarkers(bool v) {
    useParkingMarker = v;
  }

  List<TripsRepportModel> trips = [];

  // get ripple color from device
  Color getRippleColor() {
    if (deviceProvider.selectedDevice != null) {
      final Device device = deviceProvider.selectedDevice as Device;
      return Color.fromRGBO(device.colorR, device.colorG, device.colorB, 1);
    }
    return Colors.blue;
  }

  Future<void> _fetchParkingMarkers() async {
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

  void setParkingMarkers(bool notify) {
    _parkingMarkers.clear();
    for (var trip in trips) {
      final parkingMarker = _buildParkingMarker(trip);
      _parkingMarkers[parkingMarker.markerId.value] = parkingMarker;
    }
    if (notify) {
      notifyMap = !notifyMap;
      notifyListeners();
    }
  }

  Marker _buildParkingMarker(TripsRepportModel trip) {
    return Marker(
      markerId: MarkerId(uuid.v4()),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
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
                Expanded(
                  child: Row(
                    children: [
                      const Text("Address"),
                      const Text(
                        ": ",
                      ),
                      Expanded(
                        child: AutoSizeText(
                          trip.startAddress.split(",")[0].split(",")[0],
                          minFontSize: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          LatLng(trip.latitude, trip.longitude),
        );
      },
    );
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

  bool loading = false;

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
    if (useParkingMarker) return _parkingMarkers.values.toSet();
    if (historicIsPlayed) return const {};
    return markers.values.toSet();
  }

  bool play = true;

  void playPause() {
    play = !play;
    notifyMap = !notifyMap;
    notifyListeners();
    if (play) {
      continueHistoric();
    }
  }

  void fresh() {
    markers.clear();
    autoSearchController.dispose();
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

  //Set<Marker> playedMarkers = {};

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
    //playedMarkers.clear();\
    line.clear();
    histoLine.clear();
    markers.clear();
    historicIsPlayed = !historicIsPlayed;
    notifyMap = !notifyMap;
    animateMarker.clear();
    if (!historicIsPlayed) {
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 500));
      setHistoricMarkers();
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

      //Marker marker = getSimpleMarker(device);
      MarkerId markerId = const MarkerId('played_marker');
      BitmapDescriptor bitmapDescriptor =
          _getBitmapDescriptor(device.markerPng);
      var marker = RippleMarker(
        markerId: markerId,
        position: LatLng(device.latitude, device.longitude),
        ripple: false,
        visible: true,
        consumeTapEvents: false,
        icon: bitmapDescriptor,
      );

      animateMarker[markerId] = marker;
      if (init) {
        init = false;
      }
      if (index > 1) {
        line.add(Polyline(
          color: Colors.blue,
          width: 3,
          polylineId: PolylineId(uuid.v5(uuid.v4(), uuid.v4())),
          points: [
            marker.position,
            getSimpleMarker(historicModel.devices![index - 1]).position
          ],
        ));
      }
      googleMapController
          ?.animateCamera(CameraUpdate.newLatLng(marker.position));
      notifyMap = !notifyMap;
      notifyListeners();
      await Future.delayed(speedDuration);
    }

    // notify each time add marker
  }

  void continueHistoric() async {
    if (!historicIsPlayed) {
      //playedMarkers.clear();
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
      MarkerId markerId = const MarkerId('played_marker');
      BitmapDescriptor bitmapDescriptor =
          _getBitmapDescriptor(device.markerPng);

      animateMarker[markerId] = RippleMarker(
        markerId: markerId,
        position: LatLng(device.latitude, device.longitude),
        ripple: false,
        visible: true,
        consumeTapEvents: false,
        icon: bitmapDescriptor,
      );
      if (init) {
        googleMapController
            ?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: animateMarker[markerId]!.position,
          bearing: device.heading.toDouble(),
        )));
/*         await mapController?.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: marker.position,
                bearing: device.heading.toDouble(),
                zoom: 14.5))); */
        init = false;
      }
      if (index > 1) {
        line.add(Polyline(
          color: Colors.blue,
          polylineId: PolylineId(uuid.v5(uuid.v4(), uuid.v4())),
          points: [
            getSimpleMarker(historicModel.devices![index - 1]).position,
            animateMarker[markerId]!.position
          ],
        ));
      }
      googleMapController?.animateCamera(
          CameraUpdate.newLatLng(animateMarker[markerId]!.position));
      notifyListeners();
      notifyMap = !notifyMap;
      await Future.delayed(speedDuration);
    }

    // notify each time add marker
  }

  void moveCamera(LatLng pos, {double zoom = 6}) {
    googleMapController
        ?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: pos,
      zoom: zoom,
    )));
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
    fetchHistorics(context, null, 1, true);
  }

  void normaleView() {
    googleMapController
        ?.animateCamera(CameraUpdate.newCameraPosition(const CameraPosition(
      target: LatLng(33.589886, -7.603869),
      zoom: 6.5,
    )));
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
      deviceProvider.notifyListeners();
    }
  }

  void clear() {
    //playedMarkers.clear();
    line.clear();
    historicIsPlayed = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      notifyListeners();
    });
  }

  Future<void> updateDate(BuildContext context, DateTime? datetime) async {
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
    fetchHistorics(context, null, 1, true);
  }

  Future<void> updateTimeRange(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => Dialog(
        child: TimeRangeWigdet(
          dateFrom: dateFrom,
          dateTo: dateTo,
        ),
      ),
    );
  }

  // get tow points from list of points to fit the map  to the screen

  // zo

  // zoom to list of points
  Future<void> _zoomToPoints(List<LatLng> points) async {
    if (points.isNotEmpty) {
      final bounds = boundsFromLatLngList(points);
      googleMapController
          ?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
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

  // show all markers on the map
  void showAllMarkers() {
    loading = true;
    notifyListeners();
    markers.clear();
    historicModel.devices?.forEach((device) {
      final marker = getSimpleMarker(device);
      markers[marker.markerId.value] = marker;
    });
    loading = false;
    notifyMap = !notifyMap;
    notifyListeners();
  }

  Future<void> fetchHistorics(BuildContext context, Device? device,
      [int page = 1, bool init = false]) async {
    histoLine = {};
    histoLine.clear();
    //playedMarkers = {};
    Device? selectedDevice = device ?? deviceProvider.selectedDevice;
    log('==========> ${selectedDevice?.description}');
    if (init) {
      loading = true;
      markers.clear();
      circles = {};
      _parkingMarkers.clear();
      _fetchParkingMarkers().then((value) {
        setParkingMarkers(false);
      });
      //playedMarkers = {};
      historicModel.devices?.clear();
      Future.microtask(() {
        notifyMap = !notifyMap;
        notifyListeners();
      });
    }
    Account? account = shared.getAccount();
    String res = await api.postGzipCode(
      url: '/historic2',
      body: {
        'accountId': account?.account.accountId,
        'deviceId': selectedDevice?.deviceId,
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
      if (historicModel.currentPage < historicModel.lastPage) {
        // ignore: use_build_context_synchronously
        fetchHistorics(context, selectedDevice, ++page);
        return;
      }

      //_zoomToPoints(markers.map((e) => e.position).toList());
      await fetchInfoData();
      setHistoricMarkers();
    }
  }

  // set historic markers on the map
  Future<void> setHistoricMarkers() async {
    await _voidSetStartAndMarker();
    await _setHistoricLine();

    loading = false;

    await _zoomToPoints(List<LatLng>.from(
        historicModel.devices!.map((e) => LatLng(e.latitude, e.longitude))));
    notifyMap = !notifyMap;
    notifyListeners();
  }

  final uuid = const Uuid();

  Future<void> _voidSetStartAndMarker() async {
    if (historicModel.devices?.isNotEmpty == true) {
      final lastDevice = historicModel.devices?.last;
      if (lastDevice == null) {
        return;
      }
      const markerId = MarkerId("played_marker");

      var marker = RippleMarker(
        markerId: markerId,
        position: LatLng(lastDevice.latitude, lastDevice.longitude),
        ripple: true,
        visible: false,
        consumeTapEvents: false,
      );

      animateMarker[markerId] = marker;

      final simpleMarker = getSimpleMarker(lastDevice);
      markers[simpleMarker.markerId.value] = simpleMarker;

      if (historicModel.devices!.length > 5) {
        final firstDevice = historicModel.devices!.first;
        final firstMarker = Marker(
          markerId: const MarkerId("first_marker"),
          position: LatLng(firstDevice.latitude, firstDevice.longitude),
          infoWindow: const InfoWindow(title: 'Départ'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        markers[firstMarker.markerId.value] = firstMarker;
      }
    }
  }

  final animateMarker = <MarkerId, Marker>{};

  final String isDriving = "En Route";
  final String isParking = "Parking";
  final String isSlow = "Ralenti";

  // get color depending on the status
  Color _getColor(String status) {
    if (status == isDriving) {
      return Colors.green;
    } else if (status == isParking) {
      return Colors.red;
    } else if (status == isSlow) {
      return Colors.orange;
    } else {
      return Colors.black;
    }
  }

  // set line of the historic
  Future<void> _setHistoricLine() async {
    if (historicModel.devices == null || historicModel.devices!.isEmpty) return;
    List<HistoLineInfo> histoLineInfo = [];
    String? status = "Unknown";
    int index = -1;
    lastDevice = historicModel.devices?.last;
    for (Device device in historicModel.devices!) {
      index++;

      if (device.statut == isParking) {
        final m = getSimpleMarker(device);
        markers[m.markerId.value] = m;
      } else if (device.statut == isSlow) {
        final m = getSimpleMarker(device);
        markers[m.markerId.value] = m;
      }

      if (device.statut == status) {
        histoLineInfo.last.points.add(
          LatLng(
            device.latitude,
            device.longitude,
          ),
        );
      } else {
        if (index != 0) {
          histoLineInfo.add(
            HistoLineInfo(
              color: histoLineInfo.last.color,
              status: histoLineInfo.last.status,
              points: [
                LatLng(
                  histoLineInfo.last.points.last.latitude,
                  histoLineInfo.last.points.last.longitude,
                ),
                LatLng(
                  device.latitude,
                  device.longitude,
                )
              ],
            ),
          );
        }
        // add new line
        histoLineInfo.add(HistoLineInfo(
          status: device.statut,
          color: _getColor(device.statut),
          points: [LatLng(device.latitude, device.longitude)],
        ));
      }
      status = device.statut;
    }

    for (HistoLineInfo info in histoLineInfo) {
      final polylineId = PolylineId(uuid.v5(uuid.v4(), uuid.v4()));
      histoLine.add(
        Polyline(
          onTap: () => _onTapLine(polylineId, info),
          polylineId: polylineId,
          color: info.color,
          points: info.points,
          width: 4,
          endCap: Cap.roundCap,
          startCap: Cap.roundCap,
          visible: info.status != isParking,
          geodesic: true,
          consumeTapEvents: info.status != isParking,
        ),
      );
    }
    _zoomToPoints(histoLineInfo.map((e) => e.points.first).toList());
  }

  // on tap line hide all markers and show only the selected one
  Future<void> _onTapLine(PolylineId polylineId, HistoLineInfo info) async {
    markers.clear();
    List<LatLng> points = histoLine.firstWhere((element) {
      return element.polylineId == polylineId;
    }).points;
    historicModel.devices?.forEach((d) {
      if (d.statut == isParking) {
        final m = getSimpleMarker(d);
        markers[m.markerId.value] = m;
      } else if (d.statut == isSlow) {
        final m = getSimpleMarker(d);
        markers[m.markerId.value] = m;
      } else if (d.statut == info.status &&
          points.contains(LatLng(d.latitude, d.longitude))) {
        final m = getSimpleMarker(d);
        markers[m.markerId.value] = m;
      }
    });
    notifyMap = !notifyMap;
    notifyListeners();
  }

  void onTapEnter(BuildContext context, String val) {
    deviceProvider.selectedDevice = deviceProvider.devices.firstWhere(
      (device) {
        return device.description.toLowerCase().contains(val.toLowerCase());
      },
    );
    deviceProvider.handleSelectDevice();
    notifyListeners();
    fetchHistorics(context, deviceProvider.selectedDevice);
    // show snackbar
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
          fuelLevel:  device.fuelLevel,
          fuelTotalCounted: device.fuelTotalCounted,
        );
      },
    );
  }

  // get bitmap discriptor from base64
  BitmapDescriptor _getBitmapDescriptor(String base64) {
    late BitmapDescriptor bitmapDescriptor;
    try {
      Uint8List imgRes = base64Decode(base64);
      bitmapDescriptor = BitmapDescriptor.fromBytes(imgRes);
      return bitmapDescriptor;
    } catch (e) {
      bitmapDescriptor = BitmapDescriptor.defaultMarker;
    }
    return bitmapDescriptor;
  }

  MarkerId _getMarkerId(Device device) {
    return MarkerId(
        '${device.latitude},${device.longitude},${device.dateTime.millisecondsSinceEpoch}');
  }

  Marker getSimpleMarker(Device device) {
    LatLng position = LatLng(device.latitude, device.longitude);
    BitmapDescriptor bitmapDescriptor = _getBitmapDescriptor(device.markerPng);
    Device myDevice = device.copyWith(
      description: deviceProvider.selectedDevice?.description ?? '',
    );
    return Marker(
      onTap: () => _onTapMarker(myDevice),
      markerId: _getMarkerId(device),
      position: position,
      icon: bitmapDescriptor,
    );

/*     return Marker(
      onTap: () => _onTapMarker(myDevice),
      markerId: MarkerId('${device.latitude},${device.longitude}'),
      position: position,
      icon: bitmapDescriptor,
    ); */
  }
}

class HistoLineInfo {
  final Color color;
  final List<LatLng> points;
  final String status;

  HistoLineInfo(
      {required this.color, required this.points, required this.status});
}
