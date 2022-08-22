import 'package:flutter/material.dart';

import '../../../models/account.dart';
import '../../../services/newgps_service.dart';
import '../rapport_provider.dart';
import 'temp_ble_repport_model.dart';

class TemperatureRepportProvider with ChangeNotifier {
  late RepportProvider provider;

  List<TemBleRepportModel> _repports = [];
  List<TemBleRepportModel> repportsChart = [];
  List<int> showIndexed = [];

  List<TemBleRepportModel> get repports => _repports;

  set repports(List<TemBleRepportModel> repports) {
    _repports = repports;
    _repports.removeLast();
    setRepportsChart();
    notifyListeners();
  }

  _listenToProvider() {
    fetchTempBleRepport();
  }

  void setRepportsChart() {

    for (var i = 0; i < _repports.length; i++) {

      // time between two repports is 30 minutes
      if (i == 0) {
        continue;
      } else if (_repports[i].updatedAt.difference(_repports[i - 1].updatedAt).inMinutes == 15) {
        repportsChart.add(_repports[i]);
        showIndexed.add(i);
      }
    }
    // remove last element if is not empty
    if (repportsChart.isNotEmpty) {
      repportsChart.removeLast();
    }
  }

  double maxTemp = 0;
  double minTemp = 0;
  double minHour = 0;
  double maxHour = 0;

  void _setMaxMinTemp() {
    double max = _repports.first.temperature1.toDouble();
    double min = _repports.first.temperature1.toDouble();
    for (TemBleRepportModel repport in _repports) {
      if (repport.temperature1 > max) {
        max = repport.temperature1.toDouble();
      }
      if (repport.temperature1 < min) {
        min = repport.temperature1.toDouble();
      }
      // set max and min hour
      if (repport.timestamp.hour > maxHour) {
        maxHour = repport.timestamp.hour.toDouble();
      }
      if (repport.timestamp.hour < minHour) {
        minHour = repport.timestamp.hour.toDouble();
      }
    }
    maxTemp = max + 2;
    minTemp = min - 2;
  }

  bool loading = false;
  int selectedIndex = 1;
  bool up = false;

  String orderBy = 'timestamp';

  Future<void> orderByClick(int? index) async {
    selectedIndex = index ?? 2;
    if (loading) return;
    loading = true;
    up = !up;
    switch (index) {
      case 1:
      case 2:
        orderBy = 'timestamp';
        break;
      case 3:
        orderBy = 'temperature1';
        break;
      case 4:
        orderBy = 'temperature2';
        break;
      case 5:
        orderBy = 'temperature3';
        break;
      case 6:
        orderBy = 'temperature4';
        break;
      default:
        orderBy = 'timestamp';
        break;
    }
    await fetchTempBleRepport();
    loading = false;
  }

  Future<void> fetchTempBleRepport() async {
    Account? account = shared.getAccount();
    debugPrint(provider.dateFrom.toString());
    debugPrint(provider.dateTo.toString());
    String res = await api.post(
      url: '/tempble/index',
      body: {
        'account_id': account?.account.accountId,
        'device_id': provider.selectedDevice.deviceId,
        'user_id': account?.account.userID,
        'date_from': (provider.dateFrom.millisecondsSinceEpoch / 1000),
        'date_to': (provider.dateTo.millisecondsSinceEpoch / 1000),
        'order_by': orderBy,
        'order_direction': up ? 'asc' : 'desc',
      },
    );
    if (res != '[]') {
      repports = temBleRepportModelFromJson(res);
      _setMaxMinTemp();
    }
  }

  void init(RepportProvider p) async {
    provider = p;
    provider.addListener(_listenToProvider);

    //await _fetchTempBleRepport();
  }

  // check temperature ble if is valid or not if equal to 3000 return non défini else return temperature value
  String checkTemperature(num temperature) {
    if (temperature == 3000) {
      return 'Non défini';
    } else {
      return temperature.toString();
    }
  }
}
