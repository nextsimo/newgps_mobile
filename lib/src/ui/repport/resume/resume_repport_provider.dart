import 'dart:async';

import 'package:flutter/material.dart';
import 'package:newgps/src/models/account.dart';
import 'package:newgps/src/models/repport_resume_model.dart';
import 'package:newgps/src/services/newgps_service.dart';

import '../rapport_provider.dart';

class ResumeRepportProvider with ChangeNotifier {
  List<RepportResumeModel> _resumes = [];

  List<RepportResumeModel> get resumes => _resumes;

  set resumes(List<RepportResumeModel> resumes) {
    _resumes = resumes;
    notifyListeners();
  }

  late Timer _timer;

  ResumeRepportProvider(RepportProvider repportProvider) {
    fetch(repportProvider: repportProvider);
    _timer = Timer.periodic(const Duration(seconds: 12), (_) {
      fetch(repportProvider: repportProvider);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  bool orderByNumber = true;
  int selectedIndex = 0;
  void updateOrderByNumber(_) {
    resumes.sort((r1, r2) => r1.index.compareTo(r2.index));
    if (!orderByNumber) resumes = resumes.reversed.toList();
    orderByNumber = !orderByNumber;
    selectedIndex = 0;
    notifyListeners();
  }

  bool orderByMatricule = true;
  void updateOrderByMatricule(_) {
    resumes.sort((r1, r2) => r1.description.compareTo(r2.description));
    if (!orderByMatricule) resumes = resumes.reversed.toList();
    orderByMatricule = !orderByMatricule;
    selectedIndex = 1;
    notifyListeners();
  }

  bool orderByDriverName = true;
  void updateOrderByDriverName(_) {
    resumes.sort(
        (r1, r2) => r1.drivingTimeBySeconds.compareTo(r2.drivingTimeBySeconds));
    if (!orderByDriverName) resumes = resumes.reversed.toList();
    orderByDriverName = !orderByDriverName;
    selectedIndex = 2;

    notifyListeners();
  }

  bool odrderByCurrentDistance = true;
  void updateByCurrentDistance(_) {
    resumes.sort((r1, r2) => r1.lastOdometerKm.compareTo(r2.lastOdometerKm));
    if (!odrderByCurrentDistance) resumes = resumes.reversed.toList();
    odrderByCurrentDistance = !odrderByCurrentDistance;
    selectedIndex = 3;

    notifyListeners();
  }

  bool odrderByCurrentSpeed = true;
  void updateByCurrentSpeed(_) {
    resumes
        .sort((r1, r2) => r1.lastValidSpeedKph.compareTo(r2.lastValidSpeedKph));
    if (!odrderByCurrentSpeed) resumes = resumes.reversed.toList();
    odrderByCurrentSpeed = !odrderByCurrentSpeed;
    selectedIndex = 4;

    notifyListeners();
  }

  bool odrderByMaxSpeed = true;
  void updateByMaxSpeed(_) {
    resumes.sort((r1, r2) => r1.maxSpeed.compareTo(r2.maxSpeed));
    if (!odrderByMaxSpeed) resumes = resumes.reversed.toList();
    odrderByMaxSpeed = !odrderByMaxSpeed;
    selectedIndex = 5;

    notifyListeners();
  }

  bool odrderByDistance = true;
  void updateByDistance(_) {
    resumes.sort((r1, r2) => r1.distance.compareTo(r2.distance));
    if (!odrderByDistance) resumes = resumes.reversed.toList();
    odrderByDistance = !odrderByDistance;
    selectedIndex = 6;

    notifyListeners();
  }

  bool orderByCarbConsumation = true;
  void updateByCarbConsumation(_) {
    resumes.sort((r1, r2) => r1.carbConsomation.compareTo(r2.carbConsomation));
    if (!orderByCarbConsumation) resumes = resumes.reversed.toList();
    orderByCarbConsumation = !orderByCarbConsumation;
    selectedIndex = 7;

    notifyListeners();
  }

  bool orderByCurrentCarb = true;
  void updateByCurrentCarb(_) {
    resumes.sort((r1, r2) => r1.carbNiveau.compareTo(r2.carbNiveau));
    if (!orderByCurrentCarb) resumes = resumes.reversed.toList();
    orderByCurrentCarb = !orderByCurrentCarb;
    selectedIndex = 8;

    notifyListeners();
  }

  bool orderDrivingTime = true;
  void updateDrivingTime(_) {
    resumes.sort((r1, r2) => r1.drivingTime.compareTo(r2.drivingTime));
    if (!orderDrivingTime) resumes = resumes.reversed.toList();
    orderDrivingTime = !orderDrivingTime;
    selectedIndex = 9;

    notifyListeners();
  }

  bool orderByAdresse = true;
  void updateByAdresse(_) {
    resumes.sort((r1, r2) => r1.adresse.compareTo(r2.adresse));
    if (!orderByAdresse) resumes = resumes.reversed.toList();
    orderByAdresse = !orderByAdresse;
    selectedIndex = 10;

    notifyListeners();
  }

  bool orderByCity = true;
  void updateByCity(_) {
    resumes.sort((r1, r2) => r1.city.compareTo(r2.city));
    if (!orderByCity) resumes = resumes.reversed.toList();
    orderByCity = !orderByCity;
    selectedIndex = 11;

    notifyListeners();
  }

  bool orderByDateActualisation = true;
  void updateByDateActualisation(_) {
    resumes.sort((r1, r2) => r1.lastValideDate.compareTo(r2.lastValideDate));
    if (!orderByDateActualisation) resumes = resumes.reversed.toList();
    orderByDateActualisation = !orderByDateActualisation;
    selectedIndex = 12;
    notifyListeners();
  }

  bool _startFetching = false;

  bool get startFetching => _startFetching;

  set startFetching(bool startFetching) {
    _startFetching = startFetching;
    notifyListeners();
  }

  bool _loadingResumeRepport = false;

  Future<void> fetch(
      {int index = 0,
      bool download = false,
      required RepportProvider repportProvider}) async {
    if (_loadingResumeRepport) return;
    _loadingResumeRepport = true;
    Account? account = shared.getAccount();
    String res;
    res = await api.post(
      url: '/repport/resume/$index',
      body: {
        'account_id': account?.account.accountId,
        'user_id': account?.account.userID,
        'download': download,
        'date_from': (repportProvider.dateFrom.millisecondsSinceEpoch / 1000),
        'date_to': (repportProvider.dateTo.millisecondsSinceEpoch / 1000),
      },
    );
    if (download) {
      // download file

    }
    if (res.isNotEmpty) {
      _resumes = repportResumeModelFromJson(res);
      notifyListeners();
    }
    _loadingResumeRepport = false;
  }
}
