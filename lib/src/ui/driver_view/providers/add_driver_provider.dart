import 'package:flutter/material.dart';

class AddDriverProvider with ChangeNotifier {
  bool showAddDriver = false;

  void toggleAddDriver() {
    showAddDriver = !showAddDriver;
    notifyListeners();
  }

  // get height of the add driver view
  double get height => showAddDriver ? 243 : 0;
}
