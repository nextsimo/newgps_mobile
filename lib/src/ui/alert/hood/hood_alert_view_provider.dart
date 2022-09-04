import 'package:flutter/material.dart';
import '../../../models/account.dart';
import '../../../services/firebase_messaging_service.dart';
import '../../../services/newgps_service.dart';
import 'hood_alert_settings.dart';

class HoodAlertViewProvider with ChangeNotifier {
  late FirebaseMessagingService messagingService;

  HoodAlertSettings? hoodAlertSettings;

  HoodAlertViewProvider([FirebaseMessagingService? m]) {
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
      url: '/alert/hood/settings',
      body: {
        'notification_id': messagingService.notificationID,
        'account_id': account?.account.accountId,
        'devices_id': devices,
      },
    );
    if (res.isNotEmpty) {
      hoodAlertSettings = hoodAlertSettingsFromJson(res);
      notifyListeners();
    }
  }

  Future<void> updateState(bool newState) async {
    await api.post(
      url: '/alert/hood/update/state',
      body: {'id': hoodAlertSettings?.id, 'is_active': newState},
    );
    await _fetchAlertSettings();
  }

  Future<void> onSelectedDevice(List<String> newSelectedDevices) async {
    newSelectedDevices.remove('all');
    await api.post(
      url: '/alert/hood/update/devices',
      body: {
        'id': hoodAlertSettings?.id,
        'devices_id': newSelectedDevices.join(','),
      },
    );
    await _fetchAlertSettings();
  }
}
