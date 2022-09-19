import 'package:flutter/material.dart';

import '../../../services/newgps_service.dart';
import '../models/my_driver_model.dart';

class DriverViewProvider with ChangeNotifier {
  DriverViewProvider() {
    _init();
  }

  void _init() {
    _fetchAll();
  }

  List<MyDriverModel> _myDrivers = [];

  List<MyDriverModel> get myDrivers => _myDrivers;

  // fetch all my drivers
  Future<void> _fetchAll() async {
    String? accountId = shared.getAccount()?.account.accountId;
    String res = await api.get(url: '/driver/index/$accountId');
    _myDrivers = myDriverModelFromJson(res);
    notifyListeners();
  }

  // refresh my drivers
  Future<void> refresh() async {
    _myDrivers = [];
    await _fetchAll();
  }

  // delete my driver
  Future<void> deleteDriver(int id) async {
    String res = await api.get(url: '/driver/delete/$id');
    if (res.isNotEmpty) {
      _myDrivers.removeWhere((element) => element.id == id);
      notifyListeners();
    }
  }
}
