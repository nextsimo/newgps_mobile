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
    int notifiId = messagingService!.notificationID;
    await api.post(
      url: '/batterynotif/update',
      body: {
        'notification_id': notifiId,
        'is_active': val,
      },
    );

    active = val;
    notifyListeners();
  }

  void fetchAlert() async {
    Account? account = shared.getAccount();
    String res = await api.post(
      url: '/batterynotif/settings',
      body: {
        'account_id': account?.account.accountId,
        'notification_id': messagingService!.notificationID,
      },
    );

    if (res.isNotEmpty) {
      batteryNotifcationSetting = batteryNotifcationSettingFromJson(res);
      active = batteryNotifcationSetting!.isActive;
      //await fetchHistoric();
      notifyListeners();
    }
  }

  Future<void> fetchHistoric() async {
    String res = await api.post(
      url: '/batterynotif/historics',
      body: {'notification_id': messagingService?.notificationID},
    );
    historics = batteryNotifcationHistoricFromJson(res);
  }
}
