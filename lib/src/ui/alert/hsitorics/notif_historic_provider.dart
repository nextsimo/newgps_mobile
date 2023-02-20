import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import '../../../models/account.dart';
import '../../../models/device.dart';
import '../../../models/notif_hsitoric_model.dart';
import '../../../services/device_provider.dart';
import '../../../services/newgps_service.dart';
import '../../driver_phone/driver_phone_provider.dart';
import '../../../utils/functions.dart';
import 'map_view/map_view_alert.dart';
import 'notif_historic_details.dart';
import '../../login/login_as/save_account_provider.dart';
import '../../../utils/locator.dart';
import 'package:provider/provider.dart';

class NotifHistoricPorvider with ChangeNotifier {
  List<NotifHistoric> _histos = [];

  List<NotifHistoric> get histos => _histos;

  List<String> selectedDevices = [];

  String deviceID = 'all';

  late Device selectedDevice;

  final ScrollController scrollController = ScrollController();

  void _init() {
    scrollController.addListener(_scrollListner);
  }

  void _scrollListner() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent) {
      if (!_stopPagination) _fetchDetailsHisto(deviceId: deviceID, type: _type);
    }
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.removeListener(_scrollListner);
    scrollController.dispose();
  }

  set histos(List<NotifHistoric> histos) {
    _histos = histos;
    notifyListeners();
  }

  late String _type;

  NotifHistoricPorvider({String type = ''}) {
    _type = type;
    if (type.isEmpty) {
      fetchHisto();
    } else {
      _fetchDetailsHisto(type: type);
      _init();
    }
  }

  void call(BuildContext context, String deviceID) {
    DeviceProvider deviceProvider =
        Provider.of<DeviceProvider>(context, listen: false);
    Device device = deviceProvider.devices
        .firstWhere((element) => element.deviceId == deviceID);
    locator<DriverPhoneProvider>().checkPhoneDriver(
        context: context,
        device: device,
        sDevice: device,
        callNewData: () async {
          await deviceProvider.fetchDevices();
        });
  }

  void _locatedAlert({required BuildContext context, required Device device}) {
    showDialog(
        context: context,
        builder: (_) => Dialog(
                child: MapViewALert(
              device: device,
            )));
  }

  Future<void> findAlertPosition(
      {required BuildContext context,
      required int timestamp,
      required String deviceId}) async {
    Account? account = shared.getAccount();
    String res = await api.post(url: '/alert/position', body: {
      'account_id': account?.account.accountId,
      'device_id': deviceId,
      'timestamp': timestamp
    });

    if (res.isNotEmpty) {
      Device device = Device.fromMap(json.decode(res));
      // ignore: use_build_context_synchronously
      _locatedAlert(context: context, device: device);
    }
  }

  TextEditingController autoSearchController =
      TextEditingController(text: 'Tous les véhicules');

  void handleSelectDevice() {
    if (deviceID == 'all') {
      autoSearchController.text = 'Tous les véhicules';
    } else {
      autoSearchController.text = selectedDevice.description;
    }
  }

  void fetchDeviceFromSearchWidget() {
    _page = 1;
    _loadingDeatailsHisto = false;
    _stopPagination = false;
    histos = [];
    if (deviceID == 'all') {
      _fetchDetailsHisto(type: _type);
    } else {
      _fetchDetailsHisto(type: _type, deviceId: deviceID);
    }
  }

  void initDevices(BuildContext context) {
    DeviceProvider deviceProvider = Provider.of(context, listen: false);
    selectedDevices = List<String>.from(
        deviceProvider.devices.map((e) => e.deviceId).toList());
  }

  void notif() {
    notifyListeners();
  }

  IconData getIcon(String type) {
    switch (type) {
      case 'fuel':
        return Icons.ev_station_rounded;
      case 'battery':
        return Icons.battery_charging_full;
      case 'geozone':
        return const IconData(0xe802, fontFamily: 'geozone');
      case 'speed':
        return Icons.speed;
      case 'startup':
        return Icons.dangerous;
      case 'imobility':
        return Icons.verified_user_rounded;
      case 'hood':
        return Icons.radar;
      case 'oil_change':
        return Icons.ev_station_rounded;
      case 'towing':
        return Icons.stacked_line_chart_sharp;
      default:
        return Icons.car_repair_sharp;
    }
  }

  String getLabel(String type) {
    switch (type) {
      case 'fuel':
        return 'carburant';
      case 'battery':
        return 'batterie';
      case 'speed':
        return 'vitesse';
      case 'geozone':
        return 'geozone';
      case 'startup':
        return 'demarage';
      case 'imobility':
        return 'Imobilisation';
      case 'hood':
        return 'Capot';
      case 'oil_change':
        return 'Vidange';
      case 'towing':
        return 'Dépannage';
      default:
        return '';
    }
  }

  void navigateToDetaisl(BuildContext context, {required NotifHistoric model}) {
    _saveLastReadToLocal(model.type);
    SavedAcountProvider acountProvider =
        Provider.of<SavedAcountProvider>(context, listen: false);

    acountProvider.checkNotifcation();

    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => NotifHistorisDetails(type: model.type)));
  }

  bool _loadingDeatailsHisto = false;
  int _page = 1;
  bool _stopPagination = false;
  Future<void> _fetchDetailsHisto({
    String type = '',
    String deviceId = 'all',
  }) async {
    if (_loadingDeatailsHisto) return;
    _loadingDeatailsHisto = true;
    Account? account = shared.getAccount();
    String res = await api.post(
      url: '/notification/historics/details2',
      body: {
        'type': type,
        'device_id': deviceId,
        'account_id': account?.account.accountId,
        'page': _page,
        'notification_id': NewgpsService.messaging.notificationID,
      },
    );
    _page++;
    if (res.isNotEmpty) {
      List<NotifHistoric> newHisto = notifHistoricFromJson(res);
      if (newHisto.isEmpty) {
        _stopPagination = true;
      }
      histos.addAll(newHisto);
      notifyListeners();
    }
    _loadingDeatailsHisto = false;
  }

  Future<void> _saveLastReadToLocal(String type) async {
    Account? account = shared.getAccount();
    await api.post(
      url: '/alert/historic/read/save',
      body: {
        'type': type,
        'device_token': await _getDeviceToken(),
        'account_id': account?.account.accountId,
      },
    );
  }

  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  Future<String?> _getDeviceToken() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
      return "android_${androidInfo.model}_${androidInfo.serialNumber}";
    } else {
      IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
      return "ios_${iosInfo.model}_${iosInfo.identifierForVendor}";
    }
  }

  bool loading = false;

  Future<void> fetchHisto() async {
    loading = true;
    String res = await api.post(
      url: '/notification/historics2',
      body: await getBody()
        ..addAll({
          'notification_id': NewgpsService.messaging.notificationID,
        }),
    );
    if (res.isNotEmpty) {
      histos = notifHistoricFromJson(res);
    }
    loading = false;
    notifyListeners();
  }
}
