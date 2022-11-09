import 'package:flutter/material.dart';
import '../../../models/account.dart';
import '../../../models/device.dart';
import '../../../services/firebase_messaging_service.dart';
import '../../../services/newgps_service.dart';
import 'oi_change_device_settings.dart';
import 'oi_change_settings.dart';

class OilChangeAlertProvider with ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Device selectedDevice = deviceProvider.devices.first;

  SettingPerDevice settingPerDevice = SettingPerDevice(
    isActive: false,
    nextOilChange: 0,
    alertBefor: 0,
    deviceId: 'all',
    lastOilChange: 0,
  );

  late int notificationId;

  bool _isActive = false;

  bool get isActive => _isActive;

  bool _globalIsActive = false;

  bool get globalIsActive => _globalIsActive;

  set globalIsActive(bool globalIsActive) {
    _globalIsActive = globalIsActive;
    notifyListeners();
  }

  final TextEditingController nextOilChangeController = TextEditingController();
  final TextEditingController alertBeforController = TextEditingController();
  final TextEditingController lastOilChangeController = TextEditingController();

  set isActive(bool isActive) {
    _isActive = isActive;
    notifyListeners();
  }

  void onChanged(bool newState) {
    isActive = newState;
  }

  OilChangeAlertSettings? settings;

  OilChangeAlertProvider([FirebaseMessagingService? messagingService]) {
    if (messagingService != null) {
      notificationId = messagingService.notificationID;
      _init();
    }
  }

  Future<void> _init() async {
    await _fetchGlobalSetting();
    _fetchSettingPerDevice();
  }

  void onSelectedDevice(Device device) {
    selectedDevice = device;
    _fetchSettingPerDevice();
  }

  Future<void> save() async {
    if (formKey.currentState!.validate()) {
      settingPerDevice = SettingPerDevice(
        lastOilChange: double.parse(lastOilChangeController.text),
        isActive: isActive,
        nextOilChange: double.parse(nextOilChangeController.text),
        alertBefor: double.parse(alertBeforController.text),
        deviceId: selectedDevice.deviceId,
      );
      await _saveSettingPerDevice();
    }
  }

  Future<void> updateGlobaleState(bool newState) async {
    await api.post(
      url: '/alert/oilchange/setting/update/state',
      body: {'id': settings!.id, 'is_active': newState},
    );
    await _fetchGlobalSetting();
  }

  Future<void> _fetchGlobalSetting() async {
    Account? account = shared.getAccount();
    String res = await api.post(
      url: '/alert/oilchange/setting',
      body: {
        'notification_id': notificationId,
        'account_id': account?.account.accountId,
        'user_id': account?.account.userID,
      },
    );

    if (res.isNotEmpty) {
      settings = oilChangeAlertSettingsFromJson(res);
      _globalIsActive = settings!.isActive;
      notifyListeners();
    }
  }

  Future<void> _saveSettingPerDevice() async {
    await api.post(
      url: '/alert/oilchange/device/setting/save',
      body: {
        'setting_id': settings!.id,
        'is_active': settingPerDevice.isActive,
        'next_oil_change': settingPerDevice.nextOilChange,
        'last_oil_change': settingPerDevice.lastOilChange,
        'alert_befor': settingPerDevice.alertBefor,
        'device_id': settingPerDevice.deviceId
      },
    );
    await _fetchSettingPerDevice();
  }

  Future<void> _fetchSettingPerDevice() async {
    Account? account = shared.getAccount();
    String res = await api.post(
      url: '/alert/oilchange/device/setting',
      body: {
        'device_id': selectedDevice.deviceId,
        'setting_id': settings!.id,
        'account_id': account?.account.accountId,
      },
    );
    if (res.isNotEmpty) {
      settingPerDevice = settingPerDeviceFromJson(res);
      _isActive = settingPerDevice.isActive;
      nextOilChangeController.text =
          settingPerDevice.nextOilChange.toInt().toString();
      alertBeforController.text =
          settingPerDevice.alertBefor.toInt().toString();

      lastOilChangeController.text =
          settingPerDevice.lastOilChange.toInt().toString();
    }
    notifyListeners();
  }
}
