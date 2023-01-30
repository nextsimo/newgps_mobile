import 'package:flutter/material.dart';

import '../historic_provider.dart';

class ParkingProvider with ChangeNotifier {
  bool buttonClicked = false;

  void ontap(HistoricProvider historicProvider) {
    buttonClicked = !buttonClicked;
    _notifyTheHistoricProviderToUseParkingMarkers(historicProvider);
    notifyListeners();
  }

  // empty the map from all marker notify the historic provider that the map now must use parking markers
  Future<void> _notifyTheHistoricProviderToUseParkingMarkers(
      HistoricProvider historicProvider) async {
    historicProvider.handleuseParkingMarkers(buttonClicked);
    if (buttonClicked) {
      historicProvider.setParkingMarkers();
    } else {
      historicProvider.handleuseParkingMarkers(buttonClicked);
      historicProvider.notifyListeners();
    }
  }

  // unselect the parking button and clear the map from parking markers
  void unselectParkingButton(HistoricProvider historicProvider) {
    buttonClicked = false;
    historicProvider.handleuseParkingMarkers(buttonClicked);
    historicProvider.notifyListeners();
    notifyListeners();
  }
}
