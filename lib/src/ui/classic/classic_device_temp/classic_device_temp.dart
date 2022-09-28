import 'package:flutter/material.dart';
import 'package:newgps/src/models/device.dart';

import '../../../services/newgps_service.dart';
import '../../last_position/last_temp/last_temp_info_model.dart';

class ClassicDeviceTempProvider with ChangeNotifier {
  double? temperature;

  ClassicDeviceTempProvider(Device device) {
    fetchLastTempRepport(device.deviceId);
  }

  Future<void> fetchLastTempRepport(String deviceId) async {
    String res = await api.post(
      url: '/tempble/show',
      body: {
        'device_id': deviceId,
        'account_id': shared.getAccount()?.account.accountId,
      },
    );
    if (res.isNotEmpty) {
      temperature = temBleRepportModelFromJson(res).temperature1.toDouble();
    }
  }
}
