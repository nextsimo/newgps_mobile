import 'package:flutter/material.dart';
import 'package:newgps/src/models/account.dart';
import 'package:newgps/src/models/batter_alert_historic.dart';
import 'package:newgps/src/models/battery_alert_model.dart';
import 'package:newgps/src/services/firebase_messaging_service.dart';
import 'package:newgps/src/services/newgps_service.dart';

class BatteryProvider with ChangeNotifier {
  FirebaseMessagingService? messagingService;
  BatteryNotifcationSetting? batteryNotifcationSetting;
  bool active = false;

  List<BatteryNotifcationHistoric> historics = [];

  BatteryProvider({FirebaseMessagingService? m}) {
    messagingService = m;
    if (m != null) {
      fetchAlert();
    }
  }

  Future<void> onSwitchTaped(bool val) async {
    await api.post(
      url: '/batterynotif/update',
      body: {
        'id': batteryNotifcationSetting?.id,
        'is_active': val,
      },
    );

    active = val;
    notifyListeners();
  }

  Future<void> onSave(List<String> newSelectedDevices) async {
    newSelectedDevices.remove('all');
    await api.post(
      url: '/alert/battery/update/devices',
      body: {
        'id': batteryNotifcationSetting?.id,
        'devices': newSelectedDevices.join(','),
      },
    );
    await fetchAlert();
  }

  Future<void> fetchAlert() async {
    Account? account = shared.getAccount();
    String devices = List<String>.from(
            deviceProvider.devices.map((e) => e.deviceId).toList())
        .join(',');
    String res = await api.post(
      url: '/batterynotif/settings',
      body: {
        'account_id': account?.account.accountId,
        'notification_id': messagingService!.notificationID,
        'devices': devices,
        'user_id' :account?.account.userID
      },
    );

    if (res.isNotEmpty) {
      batteryNotifcationSetting = batteryNotifcationSettingFromJson(res);
      active = batteryNotifcationSetting!.isActive;
      notifyListeners();
    }
  }

  Future<void> fetchHistoric() async {
    String res = await api.post(
      url: '/batterynotif/historics',
      body: {
        'notification_id': messagingService?.notificationID,
      },
    );
    historics = batteryNotifcationHistoricFromJson(res);
  }
}
