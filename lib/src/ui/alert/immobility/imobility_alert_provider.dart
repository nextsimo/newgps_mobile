import 'package:flutter/material.dart';
import 'package:newgps/src/models/account.dart';
import 'package:newgps/src/services/firebase_messaging_service.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/ui/alert/immobility/imobility_alert_settings.dart';

class ImobilityAlertViewProvider with ChangeNotifier {
  late FirebaseMessagingService messagingService;

  ImobilityAlertSettings? imobilityAlertSettings;
  final TextEditingController hoursController = TextEditingController();

  ImobilityAlertViewProvider([FirebaseMessagingService? m]) {
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
      url: '/alert/imobility/settings',
      body: {
        'notification_id': messagingService.notificationID,
        'account_id': account?.account.accountId,
        'devices': devices,
      },
    );
    if (res.isNotEmpty) {
      imobilityAlertSettings = imobilityAlertSettingsFromJson(res);
      hoursController.text = imobilityAlertSettings!.hours.toString();
      notifyListeners();
    }
  }

  Future<void> updateState(bool newState) async {
    await api.post(
      url: '/alert/imobility/update/state',
      body: {'id': imobilityAlertSettings?.id, 'is_active': newState},
    );
    await _fetchAlertSettings();
  }

  Future<void> updateMaxHour(String newValue) async {
    await api.post(
      url: '/alert/imobility/update/hour',
      body: {'id': imobilityAlertSettings?.id, 'max_hours': int.parse(newValue)},
    );
    await _fetchAlertSettings();
  }

  Future<void> onSelectedDevice(List<String> newSelectedDevices) async {
    newSelectedDevices.remove('all');
    await api.post(
      url: '/alert/imobility/update/devices',
      body: {
        'id': imobilityAlertSettings?.id,
        'devices': newSelectedDevices.join(','),
      },
    );
    await _fetchAlertSettings();
  }
}
