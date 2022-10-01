import 'dart:async';
import 'package:flutter/material.dart';
import 'package:newgps/src/services/newgps_service.dart';
import '../../models/device.dart';

class TempCardProvider with ChangeNotifier {
  bool _loading = false;

  List<Device> devices = [];

  TempCardProvider() {
    devices = deviceProvider.devices;
    // sort devices by name
    devices.sort((a, b) => a.description.compareTo(b.description));
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


}
