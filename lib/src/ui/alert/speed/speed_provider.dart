import 'package:flutter/material.dart';
import '../../../models/account.dart';
import '../../../models/speed_alert_model.dart';
import '../../../services/firebase_messaging_service.dart';
import '../../../services/newgps_service.dart';

class SpeedAlertProvider with ChangeNotifier {    
  SpeedAlertSettings? model;
  bool _loading = false;
  bool _active = false;

  bool get active => _active;

  set active(bool active) {
    _active = active;
    notifyListeners();
  }

  bool get loading => _loading;

  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  FirebaseMessagingService? messagingService;

  final TextEditingController controller = TextEditingController();

  SpeedAlertProvider(FirebaseMessagingService? firebaseMessagingService) {
    messagingService = firebaseMessagingService;
    if (firebaseMessagingService != null) fetchSpeedParam();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onTap() {
    _selectText();
  }

  Future<void> onTapSwitch(bool val) async {
    await api.post(
      url: '/speednotif/update/status',
      body: {
        'notification_id': messagingService?.notificationID,
        'is_active': val,
      },
    );
    active = val;
  }

  Future<void> onTapSaved() async {
    _setTextController(controller.text);
    await _updateMaxSpeed(double.parse(controller.text.split(' ').first));
  }

  Future<void> _updateMaxSpeed(double speedLimit) async {
    await api.post(
      url: '/speednotif/update/maxspeed',
      body: {
        'notification_id': messagingService?.notificationID,
        'max_speed': speedLimit,
      },
    );
  }

  void _setTextController(String text) {
    String newText = text.split(' ').first;
    controller.text = '$newText Km/h';
    _selectText();
  }

  void _selectText() {
    controller.selection =
        TextSelection(baseOffset: 0, extentOffset: controller.text.length);
  }

  Future<void> fetchSpeedParam() async {
    _loading = false;
    Account? account = shared.getAccount();

    String res = await api.post(url: '/speednotif/settings', body: {
      'account_id': account?.account.accountId,
      'notification_id': messagingService?.notificationID,
    });
    model = speedAlertSettingsFromJson(res);
    _setTextController(model!.maxSpeed.toString());
    active = model!.isActive;
    loading = true;
  }
}
