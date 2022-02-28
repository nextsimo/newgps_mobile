import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
//import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:newgps/src/models/account.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/models/repport_resume_model.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/ui/repport/repport_type_model.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

class RepportProvider with ChangeNotifier {
  late List<Device> devices;
  final List<RepportTypeModel> repportsType = const [
    RepportTypeModel(
      index: 0,
      title: 'Rapport résumer',
    ),
    RepportTypeModel(
      index: 1,
      title: 'Rapport détaillés',
    ),
    RepportTypeModel(
      index: 2,
      title: 'Consomation du carburant',
    ),
    RepportTypeModel(
      index: 3,
      title: 'Rapport arrêt / redémarrage',
    ),
    RepportTypeModel(
      index: 4,
      title: 'Rapport distance',
    ),
    RepportTypeModel(
      index: 5,
      title: 'Rapport connexion',
    ),
  ];

  Future<void> downloadDocument(BuildContext context) async {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Container(
          width: 200,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConsts.mainradius),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MainButton(
                onPressed: downloadXcl,
                label: 'XSL',
              ),
              const SizedBox(height: 10),
              MainButton(
                onPressed: downloadPdf,
                label: 'PDF',
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _isFetching = false;
  }

  void ontapEnterRepportDevice(String val) {
    deviceProvider.selectedDevice = devices.firstWhere((device) {
      return device.description.toLowerCase().contains(val.toLowerCase());
    });
    selectedDevice = deviceProvider.selectedDevice!;
    selectAllDevices = false;
    if (selectedRepport.index == repportsType.first.index) {
      selectedRepport = repportsType.elementAt(1);
    }
    handleSelectDevice();
  }

  bool _isFetching = false;

  bool get isFetching => _isFetching;

  set isFetching(bool isFetching) {
    _isFetching = isFetching;
    notifyListeners();
  }

  void ontapEnterRepportType(String val) {
    selectedRepport = repportsType.firstWhere((r) {
      return r.title.toLowerCase().contains(val.toLowerCase());
    });

    if (selectedRepport.index == 0 && !selectAllDevices) {
      selectAllDevices = true;
      handleSelectDevice();
    } else if (selectedRepport.index != 0 && selectAllDevices) {
      selectedDevice = devices.first;
      selectAllDevices = false;
      handleSelectDevice();
    }
  }

  Future<void> downloadXcl() async {
    switch (selectedRepport.index) {
      case 0:
        await downloadResumeRepport();
        break;
      case 1:
        await downlaodDetails('xlsx');
        break;
      case 2:
        await downloadFuelRepport('xlsx');
        break;
      case 3:
        await downlaodTrips('xlsx');
        break;
      default:
    }
  }

  Future<void> downloadPdf() async {
    switch (selectedRepport.index) {
      case 0:
        await downloadResumeRepport(format: 'pdf');
        break;
      case 1:
        await downlaodDetails('pdf');
        break;
      case 2:
        await downloadFuelRepport('pdf');
        break;
      case 3:
        await downlaodTrips('pdf');
        break;
      default:
    }
  }

  DateTime _selectedDateMonth = DateTime.now();

  DateTime get selectedDateMonth => _selectedDateMonth;

  set selectedDateMonth(DateTime selectedDateMonth) {
    _selectedDateMonth = selectedDateMonth;
    notifyListeners();
  }

  Future<void> downlaodDetails(String format) async {
    Account? account = shared.getAccount();
    String res = await api.post(url: '/repport/details', body: {
      'account_id': account?.account.accountId,
      'device_id': selectedDevice.deviceId,
      'date_from': dateFrom.millisecondsSinceEpoch / 1000,
      'date_to': dateTo.millisecondsSinceEpoch / 1000,
      'index': 0,
      'up': false,
      'download': 1,
      'format': format,
    });

    await _downloadFile(
        base64Str: res,
        fileName: "rapport_detailler_${formatSimpleDate(dateFrom)}.$format",
        extension: format);
  }

  Future<void> downlaodTrips(String format) async {
    Account? account = shared.getAccount();
    String res = await api.post(
      url: '/repport/trips',
      body: {
        'account_id': account?.account.accountId,
        'device_id': selectedDevice.deviceId,
        'date_from': dateFrom.millisecondsSinceEpoch / 1000,
        'date_to': dateTo.millisecondsSinceEpoch / 1000,
        'download': true,
        'format': format
      },
    );

    await _downloadFile(
        base64Str: res.trim().toString(),
        fileName: "voyage_rapport_${formatSimpleDate(dateFrom)}.$format",
        extension: format);
  }

  Future<void> downloadFuelRepport(String format) async {
    Account? account = shared.getAccount();
    String res = await api.post(
      url: '/repport/resume/fuelbydate',
      body: {
        'account_id': account?.account.accountId,
        'device_id': selectedDevice.deviceId,
        'year': 0,
        'month': 0,
        'day': 0,
        'date_from': dateFrom.millisecondsSinceEpoch / 1000,
        'date_to': dateTo.millisecondsSinceEpoch / 1000,
        'hour_from': dateFrom.hour,
        'minute_from': dateFrom.minute,
        'hour_to': dateTo.hour,
        'minute_to': dateTo.minute,
        'download': true,
        'format': format
      },
    );
    await _downloadFile(
        base64Str: res,
        fileName: "carburant_rapport_${formatSimpleDate(dateFrom)}.$format",
        extension: format);
  }

  Future<void> downloadResumeRepport({String format = 'xlsx'}) async {
    Account? account = shared.getAccount();
    String res = await api.post(
      url: '/repport/resume/0',
      body: {
        'account_id': account?.account.accountId,
        'user_id': account?.account.userID,
        'date_from': dateFrom.millisecondsSinceEpoch / 1000,
        'date_to': dateTo.millisecondsSinceEpoch / 1000,
        'download': true,
        'format': format
      },
    );

    await _downloadFile(
        base64Str: res,
        fileName: "rapport_resumer_${formatSimpleDate(dateFrom)}",
        extension: format);
  }

  Future<void> _downloadFile(
      {required String base64Str,
      required String fileName,
      required String extension}) async {
    try {
      await _requestStoragePermission();
      Uint8List bytes = base64.decode(base64Str);
      String? dir = (await getApplicationSupportDirectory()).path;
      File file = File("$dir/" + fileName + '.$extension');
      await file.create(recursive: true);
      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);
      debugPrint(file.path);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _requestStoragePermission() async {
    if (await Permission.storage.isGranted) return;
    await Permission.storage.request();
  }

  late RepportTypeModel _selectedRepport;

  RepportTypeModel get selectedRepport => _selectedRepport;

  set selectedRepport(RepportTypeModel selectedRepport) {
    _selectedRepport = selectedRepport;
    notifyListeners();
  }

  late DateTime dateFrom;
  late DateTime dateTo = DateTime.now();

  void _initDate() {
    dateFrom = DateTime(dateTo.year, dateTo.month, dateTo.day, 0, 0, 0, 1);
    dateTo = DateTime(dateTo.year, dateTo.month, dateTo.day, 23, 59, 0, 0);
    selectedTimeFrom = dateFrom;
    selectedTimeTo = dateTo;
  }

  late Device _selectedDevice;

  Device get selectedDevice => _selectedDevice;

  set selectedDevice(Device selectedDevice) {
    deviceProvider.selectedDevice = selectedDevice;
    _selectedDevice = selectedDevice;
    notifyListeners();
  }

  bool _selectAllDevices = true;

  bool get selectAllDevices => _selectAllDevices;

  set selectAllDevices(bool selectAllDevices) {
    _selectAllDevices = selectAllDevices;
    notifyListeners();
  }

  RepportProvider(List<Device> ds) {
    devices = ds;
    _initDate();
    selectedRepport = repportsType.first;
  }

  late TextEditingController repportTextController;
  late TextEditingController autoSearchTextController;

  void handleRepportType() {
    repportTextController.text = selectedRepport.title;
/*     if (selectAllDevices) {
      fetchRepports(deviceID: 'all', index: 0);
    } */
  }

  void handleSelectDevice() {
    if (selectAllDevices) {
      autoSearchTextController.text = 'Touts les véhicules';
    } else {
      autoSearchTextController.text = selectedDevice.description;
    }
    notifyListeners();
  }

  bool _notifyDate = false;

  bool get notifyDate => _notifyDate;

  set notifyDate(bool notifyDate) {
    _notifyDate = !notifyDate;
    notifyListeners();
  }

  late DateTime selectedTimeFrom;
  late DateTime selectedTimeTo;

  Future<void> updateDateFrom(context) async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: dateFrom,
      firstDate: DateTime(200),
      lastDate: dateTo,
    );
    if (newDate != null) {
      dateFrom = DateTime(
        newDate.year,
        newDate.month,
        newDate.day,
        dateFrom.hour,
        dateFrom.minute,
        dateFrom.second,
      );
      notifyDate = _notifyDate;
      hanleFetchRepports();
    }
  }

  Future<void> updateDateTo(context) async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: dateTo,
      firstDate: dateFrom,
      lastDate: DateTime.now(),
    );
    if (newDate != null) {
      dateTo = DateTime(
        newDate.year,
        newDate.month,
        newDate.day,
        dateTo.hour,
        dateTo.minute,
        dateTo.second,
      );
      notifyDate = _notifyDate;
      hanleFetchRepports();
    }
  }

  void hanleFetchRepports() {
    if (selectedRepport.index == 0) {
      //fetchRepports(deviceID: selectedDevice.deviceId);
    } else {
      notifyListeners();
    }
  }

  void restaureTime(BuildContext context) {
    DateTime now = DateTime.now();
    dateFrom = DateTime(
      dateFrom.year,
      dateFrom.month,
      dateFrom.day,
      0,
      0,
      1,
    );
    dateTo = DateTime(
      dateTo.year,
      dateTo.month,
      dateTo.day,
      now.hour,
      now.minute,
      now.second,
    );
    notifyDate = _notifyDate;
    hanleFetchRepports();
    Navigator.of(context).pop();
  }

  void updateTime(BuildContext context) {
    dateFrom = DateTime(
      dateFrom.year,
      dateFrom.month,
      dateFrom.day,
      selectedTimeFrom.hour,
      selectedTimeFrom.minute,
      selectedTimeFrom.second,
    );
    dateTo = DateTime(
      dateTo.year,
      dateTo.month,
      dateTo.day,
      selectedTimeTo.hour,
      selectedTimeTo.minute,
      selectedTimeTo.second,
    );
    notifyDate = _notifyDate;
    Navigator.of(context).pop();
    hanleFetchRepports();
  }

  Future<void> onSave(RepportResumeModel repportResumeModel) async {
    Account? account = shared.getAccount();

    debugPrint(jsonEncode(repportResumeModel.toJson()));
    await api.post(
      url: '/repport/resume/update',
      body: {
        'account_id': account?.account.accountId,
        'data': json.encode(repportResumeModel.toJson())
      },
    );
  }
}
