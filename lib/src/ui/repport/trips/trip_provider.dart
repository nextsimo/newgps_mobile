import 'package:flutter/foundation.dart';
import 'package:newgps/src/models/account.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/ui/repport/rapport_provider.dart';
import 'package:newgps/src/ui/repport/trips/trips_model.dart';

class TripsProvider with ChangeNotifier {
  List<TripsRepportModel> trips = [];

  int selectedIndex = 0;

  bool orderByStartDate = false;
  void updateStartDateOrder(_) {
    orderByStartDate = !orderByStartDate;
    trips.sort((r1, r2) => r1.startDate.compareTo(r2.startDate));
    if (!orderByStartDate) trips = trips.reversed.toList();
    selectedIndex = 0;
    notifyListeners();
  }

  late RepportProvider repportProvider;
  TripsProvider(RepportProvider provider) {
    repportProvider = provider;
  }

  bool orderByEndDate = false;
  void updateEndDateOrder(_) {
    orderByEndDate = !orderByEndDate;
    trips.sort((r1, r2) => r1.startDate.compareTo(r2.startDate));
    if (!orderByEndDate) trips = trips.reversed.toList();
    selectedIndex = 1;
    notifyListeners();
  }

  bool orderByDrivingTime = false;
  void updateDrivingTimeOrder(_) {
    orderByDrivingTime = !orderByDrivingTime;
    trips.sort(
        (r1, r2) => r1.drivingTimeBySeconds.compareTo(r2.drivingTimeBySeconds));
    if (!orderByDrivingTime) trips = trips.reversed.toList();
    selectedIndex = 2;
    notifyListeners();
  }

  bool orderByDistance = false;
  void updateByDistance(_) {
    orderByDistance = !orderByDistance;
    trips.sort((r1, r2) => r1.distance.compareTo(r2.distance));
    if (!orderByDistance) trips = trips.reversed.toList();
    selectedIndex = 3;
    notifyListeners();
  }

  bool odrderByOdometer = true;
  void updateByOdometer(_) {
    trips.sort((r1, r2) => r1.odometer.compareTo(r2.odometer));
    if (!odrderByOdometer) trips = trips.reversed.toList();
    odrderByOdometer = !odrderByOdometer;
    selectedIndex = 4;
    notifyListeners();
  }

  bool orderByStartAdresse = true;
  void updateByStartAdresse(_) {
    trips.sort((r1, r2) => r1.startAddress.compareTo(r2.startAddress));
    if (!orderByStartAdresse) trips = trips.reversed.toList();
    orderByStartAdresse = !orderByStartAdresse;
    selectedIndex = 5;
    notifyListeners();
  }

  bool orderByEndAdresse = true;
  void updateByEndAdresse(_) {
    trips.sort((r1, r2) => r1.endAddress.compareTo(r2.endAddress));
    if (!orderByEndAdresse) trips = trips.reversed.toList();
    orderByEndAdresse = !orderByEndAdresse;
    selectedIndex = 6;
    notifyListeners();
  }

  bool orderByStopedTime = true;
  void updateByStopedTime(_) {
    trips.sort(
        (r1, r2) => r1.stopedTimeBySeconds.compareTo(r2.stopedTimeBySeconds));
    if (!orderByStopedTime) trips = trips.reversed.toList();
    orderByStopedTime = !orderByStopedTime;
    selectedIndex = 7;
    notifyListeners();
  }

  Future<void> fetchTrips(String deviceId) async {
    Account? account = shared.getAccount();
    String str = await api.post(
      url: '/repport/trips',
      body: {
        'account_id': account?.account.accountId,
        'device_id': deviceId,
        'date_from': repportProvider.dateFrom.millisecondsSinceEpoch / 1000,
        'date_to': repportProvider.dateTo.millisecondsSinceEpoch / 1000,
        'download': false
      },
    );

    if (str.isNotEmpty) {
      trips = tripsRepportModelFromJson(str);
      notifyListeners();
    }
  }
}
