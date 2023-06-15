import 'package:flutter/material.dart';
import '../../../models/account.dart';
import '../../../services/firebase_messaging_service.dart';
import '../../../services/newgps_service.dart';
import 'startup_alert_settings.dart';

class StartupProvider with ChangeNotifier {
  late FirebaseMessagingService messagingService;
  StartupAlertSetting? startupAlertSetting;

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

  Future<void> onSave(List<String> newSelectedDevices) async {
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
