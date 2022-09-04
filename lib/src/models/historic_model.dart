import 'dart:convert';

import 'device.dart';

class HistoricModel {
  late int currentPage;
  late List<Device>? devices;
  late int lastPage;
  late int total;

  HistoricModel(
      {this.currentPage = 0,
      this.devices,
      this.lastPage = 0,
      this.total = 0});

  factory HistoricModel.fromMap(Map<String, dynamic> map) {
    return HistoricModel(
      currentPage: map['current_page'],
      devices: deviceFromMap(jsonEncode(map['devices'])),
      lastPage: map['last_page'],
      total: map['total'],
    );
  }
}
