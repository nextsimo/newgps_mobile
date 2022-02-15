import 'package:flutter/material.dart';
import 'package:newgps/src/models/account.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/services/firebase_messaging_service.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/ui/alert/oil_change/oi_change_device_settings.dart';
import 'package:newgps/src/ui/alert/oil_change/oi_change_settings.dart';

class OilChangeAlertProvider with ChangeNotifier {
  late _AutoSearchHandler auto;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  SettingPerDevice settingPerDevice = SettingPerDevice(
    isActive: false,
    nextOilChange: 0,
    alertBefor: 0,
    deviceId: 'all',
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

  set isActive(bool isActive) {
    _isActive = isActive;
    notifyListeners();
  }

  void onChanged(bool newState) {
    isActive = newState;
  }

  OilChangeAlertSettings? settings;

  List<Device> devices = [];
  List<Device> _fixDevices = [];

  void _init() {
    _fixDevices = deviceProvider.devices;
    devices = List.from(_fixDevices);
    auto = _AutoSearchHandler(onSelected, handleSelection);
  }

  void handleSelection() {
    if (auto.deviceID == 'all') {
      auto.controller.text = 'Sélectionner une vehicule';
    } else {
      auto.controller.text = auto.selectedDevice.description;
    }
   // notifyListeners();
  }

  OilChangeAlertProvider([FirebaseMessagingService? messagingService]) {
    if (messagingService != null) {
      notificationId = messagingService.notificationID;
      _fetchGlobalSetting();
    }

    _init();
  }

  void onSelected(String deviceId) {
    if (deviceId == 'all') {
      devices = _fixDevices;
    } else {
      devices = [_fixDevices.firstWhere((e) => e.deviceId == deviceId)];
    }
    _fetchSettingPerDevice();
  }

  Future<void> save() async {
    if (formKey.currentState!.validate()) {
      settingPerDevice = SettingPerDevice(
        isActive: isActive,
        nextOilChange: double.parse(nextOilChangeController.text),
        alertBefor: double.parse(alertBeforController.text),
        deviceId: auto.selectedDevice.deviceId,
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
        'alert_befor': settingPerDevice.alertBefor,
        'device_id': settingPerDevice.deviceId,
      },
    );
    await _fetchSettingPerDevice();
  }

  Future<void> _fetchSettingPerDevice() async {
    String res = await api.post(
      url: '/alert/oilchange/device/setting',
      body: {'device_id': auto.selectedDevice.deviceId, 'setting_id' :settings!.id},
    );
    if (res.isNotEmpty) {
      settingPerDevice = settingPerDeviceFromJson(res);
      _isActive = settingPerDevice.isActive;
      nextOilChangeController.text = settingPerDevice.nextOilChange.toInt().toString();
      alertBeforController.text = settingPerDevice.alertBefor.toInt().toString();
    }
    notifyListeners();
  }
}

class _AutoSearchHandler {
  TextEditingController controller =
      TextEditingController(text: 'Sélectionner une vehicule');

  late void Function(String id) onSelect;
  late void Function() handleSelectDevice;

  _AutoSearchHandler(
      void Function(String id) myFunc, void Function() _handleSelectedDevice) {
    onSelect = myFunc;
    handleSelectDevice = _handleSelectedDevice;
  }
  String deviceID = 'all';
  late Device selectedDevice;

  void clear() {
    controller.text = '';
  }

  void initController(TextEditingController c) {
    controller = c;
  }

  void onClickAll() {
    deviceID = 'all';
    handleSelectDevice();
    onSelect('all');
  }

  void onTapDevice(Device device) {
    selectedDevice = device;
    deviceID = device.deviceId;
    onSelect(device.deviceId);
  }
}
