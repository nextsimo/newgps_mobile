import 'package:flutter/material.dart';

class GestionProvider with ChangeNotifier {
  int _selectedIndex = -1;

  
  int get selectedIndex => _selectedIndex;

  set selectedIndex(int selectedIndex) {
    _selectedIndex = selectedIndex;
    notifyListeners();
  }
}
