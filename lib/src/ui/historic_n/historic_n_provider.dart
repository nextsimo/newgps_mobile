import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:newgps/src/ui/historic_n/my_marker_builder.dart';
import '../../models/account.dart';
import '../../models/device.dart';
import '../../models/historic_model.dart';
import '../../services/newgps_service.dart';

class HistoricProviderN with ChangeNotifier {
  HistoricModel historicModel = HistoricModel(
    devices: [],
  );

  List<Marker> markers = [];

  HistoricProviderN() {
    _fetchHistoric();
  }

  // fetch historic
  Future<void> _fetchHistoric() async {
    Account? account = shared.getAccount();
    String res = '';
    int page = 0;
    DateTime now = DateTime.now();
    debugPrint("HistoricProviderN: ===> Fetch start");
    do {
      debugPrint("HistoricProviderN: While");
      page++;
      res = await api.postGzipCode(
        url: '/historic2',
        body: {
          'accountId': account?.account.accountId,
          'deviceId': deviceProvider.selectedDevice?.deviceId,
          'from':
              DateTime(now.year, now.month, now.day).millisecondsSinceEpoch ~/
                  1000,
          'to': now.millisecondsSinceEpoch ~/ 1000,
          'page': page,
          'is_mobile': true
        },
      );

      HistoricModel newHistoricModel = HistoricModel.fromMap(jsonDecode(res));
      historicModel.currentPage = newHistoricModel.currentPage;
      historicModel.lastPage = newHistoricModel.lastPage;
      historicModel.total = newHistoricModel.total;
      historicModel.devices?.addAll(newHistoricModel.devices!);
      debugPrint("HistoricProviderN: While end page ==> $page");
    } while (historicModel.currentPage < historicModel.lastPage);

    if (historicModel.devices != null) {
      final devices = historicModel.devices!;
      if (devices.isEmpty) return;
      markers.clear();
      List<Marker> newMarkers = [];
      var index = -1;
      final firstDevice = devices.first;
      newMarkers.add(Marker(
        point: LatLng(firstDevice.latitude, firstDevice.longitude),
        builder: (_) => MyMarkerBuilder(device: firstDevice),
        width: 30,
        height: 30,
      ));

      final itemsLastIndex = (devices.length - 1);
      for (var device in devices) {
        index++;
        if (index == 0) continue;

        final previousDevice = devices.elementAt(index - 1);
        if (index == itemsLastIndex) {
          newMarkers.add(_markerBuilder(device: device, wave: true));
          continue;
        }
        bool isStatusDiffrent = device.statut != previousDevice.statut;
        if (isStatusDiffrent) {
          newMarkers.add(_markerBuilder(device: device));
          continue;
        }
        final d = Geolocator.distanceBetween(device.latitude, device.longitude,
            previousDevice.latitude, previousDevice.longitude);
        if (d > 300) {
          newMarkers.add(
            _markerBuilder(device: device),
          );
          continue;
        }
      }
      markers = newMarkers;
    }

    notifyListeners();
  }

  Marker _markerBuilder({required Device device, bool wave = false}) => Marker(
      point: LatLng(device.latitude, device.longitude),
      builder: (_) => MyMarkerBuilder(
            device: device,
            wave: wave,
          ));
}
