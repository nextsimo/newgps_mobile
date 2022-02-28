import 'package:flutter/material.dart';
import 'package:newgps/src/services/newgps_service.dart';

class ResumeReportLoadingProvider with ChangeNotifier {
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
    frame = (1 / deviceProvider.devices.length);
  }

  void _startCounteProgress() async {
    for (var d in deviceProvider.devices) {
      if (d.equipmentType == 'FMB140') {
        await Future.delayed(const Duration(milliseconds: 126));
      } else {
        await Future.delayed(const Duration(milliseconds: 16));
      }
      value = value + frame;
    }
  }

  void replay() async {
    value = 0;
    _startCounteProgress();
  }
}
