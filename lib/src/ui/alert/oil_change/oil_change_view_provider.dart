import 'package:flutter/material.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/services/newgps_service.dart';

class OilChangeAlertProvider with ChangeNotifier {
  late _AutoSearchHandler auto;

  List<Device> devices = [];
  List<Device> _fixDevices = [];

  void _init() {
    _fixDevices = deviceProvider.devices;
    devices = List.from(_fixDevices);
    auto = _AutoSearchHandler(onSelected, handleSelection);
  }

  void handleSelection() {
    if (auto.deviceID == 'all') {
      auto.controller.text = 'Touts les véhicules';
    } else {
      auto.controller.text = auto.selectedDevice.description;
    }
    notifyListeners();
  }

  OilChangeAlertProvider() {
    _init();
  }

  void onSelected(String deviceId) {
    if (deviceId == 'all') {
      devices = _fixDevices;
    } else {
      devices = [_fixDevices.firstWhere((e) => e.deviceId == deviceId)];
    }
    notifyListeners();
  }
}

class _AutoSearchHandler {
  TextEditingController controller =
      TextEditingController(text: 'Touts les véhicules');

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
