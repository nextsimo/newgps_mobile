import 'package:flutter/material.dart';
import 'package:newgps/src/models/account.dart';
import 'package:newgps/src/models/repports_details_model.dart';
import 'package:newgps/src/services/newgps_service.dart';

import '../rapport_provider.dart';

class RepportDetailsProvider with ChangeNotifier {
  RepportDetailsPaginateModel repportDetailsPaginateModel =
      RepportDetailsPaginateModel(repportsDetailsModel: []);
  late RepportProvider provider;
  Future<void> fetchRepportModel(
      {required String deviceId,
      int index = 0,
      bool up = true,
      DateTime? newDateFrom,
      DateTime? newDateTo}) async {
    if (newDateFrom != null && newDateTo != null) {
      dateFrom = newDateFrom;
      dateTo = newDateTo;
    }
    Account? account = shared.getAccount();
    String res = await api.post(url: '/repport/details?page=1', body: {
      'account_id': account?.account.accountId,
      'device_id': deviceId,
      'date_from': dateFrom.millisecondsSinceEpoch / 1000,
      'date_to': dateTo.millisecondsSinceEpoch / 1000,
      'index': index,
      'up': up,
      'download': 0
    });
    if (res.isNotEmpty) {
      repportDetailsPaginateModel = repportDetailsPaginateModelFromJson(res);
      notifyListeners();
    }
  }

  late DateTime dateFrom;
  late DateTime dateTo;
  late String selectedDeviceId;

  RepportDetailsProvider(RepportProvider repportProvider) {
    selectedDeviceId = repportProvider.selectedDevice.deviceId;
    dateTo = repportProvider.dateTo;
    dateFrom = repportProvider.dateFrom;
    provider = repportProvider;
  }

  bool _init = true;

  bool up = true;
  int selectedIndex = 0;

  Future<void> onTap(int? index) async {
    if (selectedIndex == index && !up) {
      up = true;
      await fetchRepportModel(
          deviceId: provider.selectedDevice.deviceId, index: index!, up: up);
      notifyListeners();
      return;
    }
    up = !up;
    selectedIndex = index!;
    await fetchRepportModel(deviceId: provider.selectedDevice.deviceId, index: index, up: up);
    notifyListeners();
  }

  int page = 0;
  Future<void> fetchMoreRepportModel(RepportProvider provider,
      {required String deviceId}) async {
    if (_init) {
      _init = false;
      return;
    }
    Account? account = shared.getAccount();
    String res = await api.post(url: '/repport/details?page=${++page}', body: {
      'account_id': account?.account.accountId,
      'device_id': deviceId,
      'date_from': provider.dateFrom.millisecondsSinceEpoch / 1000,
      'date_to': provider.dateTo.millisecondsSinceEpoch / 1000,
      'index': selectedIndex,
      'up': up,
      'download': 0
    });
    if (res.isNotEmpty) {
      RepportDetailsPaginateModel model =
          repportDetailsPaginateModelFromJson(res);
      repportDetailsPaginateModel.repportsDetailsModel
          .addAll(model.repportsDetailsModel);
      repportDetailsPaginateModel.currentPage = model.currentPage;
      repportDetailsPaginateModel.perPage = model.perPage;
      repportDetailsPaginateModel.total = model.total;
      notifyListeners();
    }
  }
}
