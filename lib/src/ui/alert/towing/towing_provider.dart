import 'package:flutter/material.dart';

import '../../../models/account.dart';
import '../../../services/firebase_messaging_service.dart';
import '../../../services/newgps_service.dart';
import 'towing_alert_settings.dart';

class TowingProvider with ChangeNotifier {
  late FirebaseMessagingService messagingService;
  TowingAlertSetting? towingAlertSetting;

  
  TowingProvider([FirebaseMessagingService? m]) {
    if (m != null) {
      messagingService = m;
      _fetchAlertSettings();
    }
  }

  Future<void> _fetchAlertSettings() async {
    Account? account = shared.getAccount();
    String devices = List<String>.from(
            deviceProvider.devices.map((e) => e.deviceId).toList())
        .join(',');
    String res = await api.post(
      url: '/alert/towing/settings',
      body: {
        'notification_id': messagingService.notificationID,
        'account_id': account?.account.accountId,
        'devices': devices,
      },
    );
    if (res.isNotEmpty) {
      towingAlertSetting = towingAlertSettingFromJson(res);
      notifyListeners();
    }
  }

  Future<void> updateState(bool newState) async {
    await api.post(
      url: '/alert/towing/update/state',
      body: {'id': towingAlertSetting?.id, 'is_active': newState},
    );
    await  _fetchAlertSettings();
  }

  Future<void> onSelectedDevice(List<String> newSelectedDevices) async {
    newSelectedDevices.remove('all');
    await api.post(
      url: '/alert/towing/update/devices',
      body: {
        'id': towingAlertSetting?.id,
        'devices': newSelectedDevices.join(','),
      },
    );
    await _fetchAlertSettings();
  }
}
