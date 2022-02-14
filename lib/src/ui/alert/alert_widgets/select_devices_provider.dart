import 'package:flutter/material.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/services/newgps_service.dart';

class SelectDevicesProvider with ChangeNotifier {
  List<String> _selectedDevices = [];
  List<Device> searchDevices = deviceProvider.devices;

  List<String> get selectedDevices => _selectedDevices;

  SelectDevicesProvider(List<String> initDevices) {
    _init(initDevices);
  }

  void _init(List<String> initDevices) {
    if (initDevices.length == deviceProvider.devices.length) {
      changed(true, 'all', init: true);
    } else {
      _selectedDevices = initDevices;
    }
  }

  void search(String q) {
    if (q.isEmpty) {
      searchDevices = deviceProvider.devices;
    } else {
      searchDevices = deviceProvider.devices
          .where((e) => e.description
              .trim()
              .toLowerCase()
              .trim()
              .contains(q.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void changed(bool? val, String id, {bool init = false}) {
    if (val == null) return;
    if (val) {
      if (id == 'all') {
        return _handleAllDevices(val);
      }
      _selectedDevices.add(id);
    } else {
      if (id == 'all') {
        return _handleAllDevices(val);
      }
      _selectedDevices.remove('all');
      _selectedDevices.remove(id);
    }
    if (!init) notifyListeners();
    
  }

  void _handleAllDevices(bool val) {
    if (val) {
      _selectedDevices = List<String>.from(
          deviceProvider.devices.map((e) => e.deviceId).toList());
      _selectedDevices.add('all');
    } else {
      _selectedDevices = [];
    }
    notifyListeners();
  }
}
