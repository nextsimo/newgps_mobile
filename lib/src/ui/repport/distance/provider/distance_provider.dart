import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:newgps/src/ui/repport/rapport_provider.dart';

import '../../../../models/account.dart';
import '../../../../services/newgps_service.dart';
import '../models/repport_distance_model.dart';

class DistanceRepportProvider with ChangeNotifier {
  RepportDistanceModel repport = RepportDistanceModel(
    distanceSum: 0,
    repports: [],
  );

  List<Repport> repportsPerDevice = [];

  String orderBy = 'description';

  bool up = true;

  bool loading = false;

  void _init() {
    repport = RepportDistanceModel(
      distanceSum: 0,
      repports: [],
    );
    orderBy = 'description';
    up = true;
    loading = false;
    repportsPerDevice = [];
    totalDistance = 0;
  }

  late RepportProvider provider;

  DistanceRepportProvider(RepportProvider p) {
    provider = p;
  }

  bool isSelected(int index) {
    return index == selectedIndex;
  }

  int totalDistance = 0;

  int selectedIndex = 0;
  Future<void> orderByClick(int? index) async {
    selectedIndex = index ?? 0;
    if (loading) return;
    loading = true;
    up = !up;
    switch (index) {
      case 0:
        orderBy = 'description';
        break;
      case 1:
        orderBy = 'start_km';
        break;
      case 2:
        orderBy = 'end_km';
        break;
      case 3:
        orderBy = 'distance';
        break;
      default:
        orderBy = 'description';
    }
    await fetchForAllDevices();
    loading = false;
  }

  Future<void> fetchForAllDevices() async {
    //_init();
    Account? account = shared.getAccount();
    String res = await api.post(
      url: '/repport/distance/all',
      body: {
        'account_id': account?.account.accountId,
        'user_id': account?.account.userID,
        'order_by': orderBy,
        'or': up ? 'asc' : 'desc',
        'date_from': provider.dateFrom.millisecondsSinceEpoch / 1000,
        'date_to': provider.dateTo.millisecondsSinceEpoch / 1000,
      },
    );

    if (res.isNotEmpty) {
      repport = repportDistanceModelFromJson(res);
      notifyListeners();
    }
  }

  Future<void> fetchOnDevice() async {
    _init();

    for (DateTime i = provider.dateFrom;
        i.isBefore(provider.dateTo);
        i = i.add(const Duration(days: 1))) {
      Account? account = shared.getAccount();
      debugPrint("------> " + i.toString());
      String res = await api.post(
        url: '/repport/distance/device',
        body: {
          'account_id': account?.account.accountId,
          'user_id': account?.account.userID,
          'order_by': orderBy,
          'or': up ? 'asc' : 'desc',
          'date_from':
              (DateTime(i.year, i.month, i.day, 00, 01).millisecondsSinceEpoch /
                  1000),
          'date_to':
              (DateTime(i.year, i.month, i.day, 23, 59).millisecondsSinceEpoch /
                  1000),
          'device_id': provider.selectedDevice.deviceId,
        },
      );

      if (res.isNotEmpty) {
        var repport = Repport.fromJson(json.decode(res));
        totalDistance += repport.distance;
        repportsPerDevice.add(repport);
        notifyListeners();
      }
    }
  }
}
