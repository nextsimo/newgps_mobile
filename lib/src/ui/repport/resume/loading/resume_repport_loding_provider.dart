import 'package:flutter/material.dart';
import 'package:newgps/src/services/newgps_service.dart';

class ResumeReportLoadingProvider with ChangeNotifier {
  double _value = 0.0;

  double get value => _value;
  int milliseconds = 16;

  set value(double value) {
    _value = value;
    notifyListeners();
  }

  double frame = 0;

  void globalInit() {
    _init();
    _startCounteProgress();
  }

  void _init({int s = 16}) {
    try {
      frame = (1 / deviceProvider.devices.length);
    } catch (e) {}
    milliseconds = s;
  }

  void _startCounteProgress() async {
    while (frame == 0) {
      frame = (1 / deviceProvider.devices.length);
    }

    for (var d in deviceProvider.devices) {
      if (d.equipmentType == 'FMB140') {
        await Future.delayed(const Duration(milliseconds: 70));
      } else {
        await Future.delayed(const Duration(milliseconds: 70));
      }
      value = value + frame;
    }
  }

  void replay() async {
    value = 0;
    _startCounteProgress();
  }
}
