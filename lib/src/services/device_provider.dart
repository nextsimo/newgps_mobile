import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/account.dart';
import '../models/device.dart';
import '../models/info_model.dart';
import 'newgps_service.dart';
import '../ui/login/login_as/save_account_provider.dart';
import '../utils/device_size.dart';
import '../widgets/buttons/main_button.dart';
import 'package:provider/provider.dart';

import '../models/device_icon_model.dart';

class DeviceProvider with ChangeNotifier {
  List<Device> _devices = [];

  List<Device> get devices => _devices;

  set devices(List<Device> devices) {
    _devices = devices;
    notifyListeners();
  }

  bool _loading = true;

  bool get loading => _loading;

  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  InfoModel? _infoModel;

  InfoModel? get infoModel => _infoModel;

  set infoModel(InfoModel? infoModel) {
    _infoModel = infoModel;
    notifyListeners();
  }

  late MapType _mapType = MapType.normal;

  MapType get mapType => _mapType;

  set mapType(MapType mapType) {
    _mapType = mapType;
    notifyListeners();
  }

  // is selected icon
  bool isSelectedIcon(DeviceIconModel icon) {
    return selectedDevice?.deviceIcon == icon.name;
  }

  // fetch list of icons from server
  Future<void> _fetchDevicesIconsList() async {
    String res = await api.get(
      url: '/devices/icons',
    );

    if (res.isEmpty) return;

    icons = deviceIconFromJson(res);
  }

  Device? selectedDevice;

  int selectedTabIndex = 0;

  List<DeviceIconModel> icons = [];

  // change icon for device
  Future<void> changeIcon({required String name, required String deviceId}) async {
    final accoutId = shared.getAccount()?.account.accountId;
    await api.get(
        url: '/device/change/$deviceId/$accoutId/$name');
    // show toast message in french
    Fluttertoast.showToast(
      msg:
          'Icone changé avec succès! votre changement sera visible dans quelques secondes',
      toastLength: Toast.LENGTH_LONG,
    );

    Navigator.of(DeviceSize.c).pop();
    Navigator.of(DeviceSize.c).pop();
    // show loading
  }

  Future<void> startStopDevice(
      String command, BuildContext context, Device device) async {
    Account? account = shared.getAccount();
    SavedAcountProvider savedAcountProvider =
        Provider.of<SavedAcountProvider>(context, listen: false);

    SavedAccount? savedAccount =
        savedAcountProvider.getAccount(account!.account.accountId);
    String res = await api.post(
      url: '/startstop/device',
      body: {
        'command': command,
        'account_id': account.account.accountId,
        'password': savedAccount!.key,
        'device_id': device.deviceId
      },
    );

    if (res.isNotEmpty) {
      Navigator.of(context).pop();
      bool isStart = command == 'IgnitionEnable';
      String message = isStart ? 'Le démarrage' : "L'arrêt";

      if (json.decode(res).containsKey('Success')) {
        showDialog(
            context: context,
            builder: (_) {
              return Dialog(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    const Icon(Icons.check_circle_outline,
                        color: Colors.green, size: 45),
                    const SizedBox(height: 10),
                    const Text('Terminé',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    Text('$message du véhicule a réussi'),
                    const SizedBox(height: 10),
                    MainButton(
                      width: 170,
                      onPressed: () => Navigator.of(context).pop(),
                      label: 'Fermer',
                      backgroundColor: Colors.green,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              );
            });
      } else {
        showDialog(
            context: context,
            builder: (_) {
              return Dialog(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    const Icon(Icons.warning, color: Colors.red, size: 45),
                    const SizedBox(height: 10),
                    const Text('Terminé',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    Text('$message du véhicule a échouer'),
                    const SizedBox(height: 10),
                    MainButton(
                      width: 170,
                      onPressed: () => Navigator.of(context).pop(),
                      label: 'Fermer',
                      backgroundColor: Colors.red,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              );
            });
      }
    }
  }

  late TextEditingController autoSearchController;

  void handleSelectDevice() {
    autoSearchController.text = selectedDevice?.description ?? '';
  }

  Future<void> init(BuildContext context, {bool init = false}) async {
    _loading = true;
    _fetchDevicesIconsList();
    await fetchDevices(init: init);
    selectedDevice = devices.first;
    autoSearchController =
        TextEditingController(text: selectedDevice!.description);
    loading = false;
  }

  Future<void> fetchDevice() async {
    Account? account = shared.getAccount();
    String res = await api.post(
      url: '/device',
      body: {
        'accountId': account?.account.accountId,
        'deviceId': selectedDevice!.deviceId,
        'is_web': false
      },
    );

    if (res.isNotEmpty) {
      log(res);
      Device device = Device.fromMap(json.decode(res));
      deviceProvider.selectedDevice = device;
    }
  }

  Future<void> fetchDevices({bool init = false}) async {
    debugPrint('start /api/devices called from device provider -----> $init');
    Account? account = shared.getAccount();
    Map<String, dynamic> body = {
      'accountId': account?.account.accountId,
      'user_id': account?.account.userID,
      'is_web': false,
      'icon': 'BinTruck',
    };

    if (init) {
      body.addAll({'init': true});
    }

    String res = await api.post(
      url: '/devices',
      body: body,
    );
    if (res.isNotEmpty) {
      devices = deviceFromMap(res);
      debugPrint('end /api/devices called from device provider');
    }
  }

  SortedColumn sortedColumn = SortedColumn();

  void sortDevices(int index) {
    if (index != sortedColumn.index) {
      sortedColumn.isAsc = true;
    }
    devices.sort((Device d1, Device d2) {
      if (sortedColumn.isAsc) {
        switch (index) {
          case 0:
            return d1.description.compareTo(d2.description);
          case 1:
            return d2.odometerKm.compareTo(d1.odometerKm);
          case 2:
            return d2.speedKph.compareTo(d1.speedKph);
          case 3:
            //return d2.'maxSpeed'!.compareTo(d1.maxSpeed ?? 0);
            return 1;
          case 4:
            return d2.distanceKm.compareTo(d1.distanceKm);
          case 10:
            return d2.dateTime.compareTo(d1.dateTime);
          default:
            return 0;
        }
      } else {
        switch (index) {
          case 0:
            return d2.description.compareTo(d1.description);
          case 1:
            return d1.odometerKm.compareTo(d2.odometerKm);
          case 2:
            return d1.speedKph.compareTo(d2.speedKph);
          case 3:
            //return d1.maxSpeed!.compareTo(d2.maxSpeed ?? 0);
            return 1;
          case 4:
            return d1.distanceKm.compareTo(d2.distanceKm);
          case 10:
            return d1.dateTime.compareTo(d2.dateTime);
          default:
            return 0;
        }
      }
    });
    sortedColumn.isAsc = !sortedColumn.isAsc;
    sortedColumn.index = index;
    notifyListeners();
  }
}

class SortedColumn {
  int index = 2;
  bool isAsc = false;

  SortedColumn({this.index = 2, this.isAsc = false});
}
