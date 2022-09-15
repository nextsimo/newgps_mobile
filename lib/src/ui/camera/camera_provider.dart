import 'package:flutter/material.dart';
import '../../models/device.dart';
import '../../services/newgps_service.dart';

class CameraProvider with ChangeNotifier {
  late _AutoSearchHandler auto;

  List<Device> devices = [];

  void _init() {
    devices = deviceProvider.devices;
    auto = _AutoSearchHandler(onSelected, handleSelection);
  }

  CameraProvider() {
    _init();
  }

  void handleSelection() {
    if (auto.deviceID == 'all') {
      auto.controller.text = 'Tous les véhicules';
    } else {
      auto.controller.text = auto.selectedDevice.description;
    }
    //notifyListeners();
  }

  void onSelected(String deviceId) {
    if (deviceId == 'all') {
      devices = deviceProvider.devices;
    } else {
      devices = [
        deviceProvider.devices.firstWhere((e) => e.deviceId == deviceId)
      ];
    }
    notifyListeners();
  }
}

class _AutoSearchHandler {
  TextEditingController controller =
      TextEditingController(text: 'Tous les véhicules');

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
