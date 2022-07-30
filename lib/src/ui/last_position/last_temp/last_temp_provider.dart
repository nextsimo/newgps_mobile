import 'package:flutter/material.dart';

import '../../../services/newgps_service.dart';
import 'last_temp_info_model.dart';

class LastTempProvider with ChangeNotifier {
  TemBleRepportModel? model;


  LastTempProvider(){
    fetchLastTempRepport();
  }

  // fetch last temp repport
  Future<void> fetchLastTempRepport() async {
    String res = await api.post(
      url: '/tempble/show',
      body: {
        'device_id': deviceProvider.selectedDevice?.deviceId,
        'account_id': shared.getAccount()?.account.accountId,
      },
    );
    if (res.isNotEmpty) {
      model = temBleRepportModelFromJson(res);
      notifyListeners();
    }
  }
}
