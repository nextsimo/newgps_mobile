import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/ui/repport/temperature_ble/temp_ble_repport_model.dart';

import '../../../models/account.dart';
import '../../../services/newgps_service.dart';

class TempGraphicProvider extends ChangeNotifier {
  List<TemBleRepportModel> repportsChart = [];

  TempGraphicProvider(Device device) {
    fetchTempBleRepport(device);
  }

  bool loading = true;

  Future<void> fetchTempBleRepport(Device device) async {
    loading = true;
    Account? account = shared.getAccount();
    final now = DateTime.now();
    String res = await api.post(
      url: '/tempble/index',
      body: {
        'account_id': account?.account.accountId,
        'device_id': device.deviceId,
        'user_id': account?.account.userID,
        'date_from': DateTime(now.year, now.month, now.day, 0, 0, 0)
                .millisecondsSinceEpoch /
            1000,
        'date_to': DateTime(now.year, now.month, now.day, 23, 59, 59)
                .millisecondsSinceEpoch /
            1000,
        'order_by': 'timestamp',
        'order_direction': 'desc',
      },
    );
    if (res != '[]' && res.isNotEmpty) {
      repportsChart = temBleRepportModelFromJson(res);
      _setRepportsChart();
      _setMaxMinTemp();
    }
    loading = false;
    notifyListeners();
  }

  void _setRepportsChart() {
    log("repport length: ${repportsChart.length}");
    final newRepports = List<TemBleRepportModel>.from(repportsChart);
    // add element only if the deference between the previous and the current is greater than 15 minutes
    var selectedRepport = repportsChart[0];
    for (var r in repportsChart) {
      if (selectedRepport.updatedAt.difference(r.updatedAt).inMinutes >= 60) {
        selectedRepport = r;
      } else {
        newRepports.remove(r);
      }
    }
    repportsChart = List<TemBleRepportModel>.from(newRepports);
    // sort the repports by date
    log("repport length: ${repportsChart.length}");
  }

  double maxTemp = 0;
  double minTemp = 0;
  double minHour = 0;
  double maxHour = 0;

  void _setMaxMinTemp() {
    double max = repportsChart.first.temperature1.toDouble();
    double min = repportsChart.first.temperature1.toDouble();
    for (TemBleRepportModel repport in repportsChart) {
      if (repport.temperature1 > max) {
        max = repport.temperature1.toDouble();
      }
      if (repport.temperature1 < min) {
        min = repport.temperature1.toDouble();
      }
      // set max and min hour
      if (repport.timestamp.hour > maxHour) {
        maxHour = repport.timestamp.hour.toDouble();
      }
      if (repport.timestamp.hour < minHour) {
        minHour = repport.timestamp.hour.toDouble();
      }
    }
    maxTemp = max + 2;
    minTemp = min - 2;
  }
}
