import 'package:flutter/material.dart';
import 'package:newgps/src/models/account.dart';
import 'package:newgps/src/services/firebase_messaging_service.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/ui/alert/start_up/startup_alert_settings.dart';

import '../../../models/device.dart';

class StartupProvider with ChangeNotifier {
  late FirebaseMessagingService messagingService;
  StartupAlertSetting? startupAlertSetting;
  List<Device> selectedDevices = [];
  
  StartupProvider([FirebaseMessagingService? m]) {
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
      url: '/alert/startup/settings',
      body: {
        'notification_id': messagingService.notificationID,
        'account_id': account?.account.accountId,
        'devices': devices,
      },
    );
    if (res.isNotEmpty) {
      startupAlertSetting = startupAlertSettingFromJson(res);
      selectedDevices = deviceProvider.devices.where((e) => startupAlertSetting!.selectedDevices.contains(e.deviceId)).toList();
      notifyListeners();
    }
  }

  Future<void> updateState(bool newState) async {
    await api.post(
      url: '/alert/startup/update/state',
      body: {'id': startupAlertSetting?.id, 'is_active': newState},
    );
    await _fetchAlertSettings();
  }

  Future<void> onSelectedDevice(List<String> newSelectedDevices) async {
    newSelectedDevices.remove('all');
    await api.post(
      url: '/alert/startup/update/devices',
      body: {
        'id': startupAlertSetting?.id,
        'devices': newSelectedDevices.join(','),
      },
    );
    await _fetchAlertSettings();
  }
}
