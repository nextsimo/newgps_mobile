import 'package:flutter/material.dart';
import 'package:newgps/src/services/newgps_service.dart';

class ResumeReportLoadingProvider with ChangeNotifier {
  final int milleSecondsPerDevice = 128;
  int numberOfDevices = deviceProvider.devices.length;

  double _value = 0.0;

  double get value => _value;

  set value(double value) {
    _value = value;
    notifyListeners();
  }

  late double frame;

  ResumeReportLoadingProvider() {
    _init();
    _startCounteProgress();
  }

  void _init() {
    frame = (1 / numberOfDevices);
  }

  void _startCounteProgress() async {
    while (numberOfDevices > 0) {
      await Future.delayed(Duration(milliseconds: milleSecondsPerDevice));
      value = value + frame;
      numberOfDevices--;
    }
  }

  void replay() async {
    numberOfDevices = deviceProvider.devices.length;
    value = 0;
    _startCounteProgress();
  }
}
