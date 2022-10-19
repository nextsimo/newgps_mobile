import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../models/account.dart';
import '../../models/device.dart';
import '../../utils/functions.dart';

class TempCardProvider with ChangeNotifier {
  bool _loading = false;

  List<Device> devices = [];

  TempCardProvider() {
    devices = deviceProvider.devices;
    // sort devices by name
    devices.sort((a, b) => a.description.compareTo(b.description));
  }

  bool get loading => _loading;

  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  // refresh devices list
  Future<void> refreshDevices(BuildContext context) async {
    if (loading == true) return;
    loading = true;
    await Future.delayed(const Duration(seconds: 3));
    loading = false;
  }

  // dowload today report
  Future<void> downloadTodayReport(Device device, String exts) async {
    if (_loading == true) return;
    _loading = true;
    setDownloading(exts, true);
    await _downloadTempRepport(device, exts);
    _loading = false;
    setDownloading(exts, false);
  }

  void setDownloading(String exts, bool value) {
    if (exts == 'pdf') {
      downloadingPdf = value;
      downloadingXsl = false;
    } else {
      downloadingXsl = value;
      downloadingPdf = false;
    }
    notifyListeners();
  }

  bool downloadingPdf = false;
  bool downloadingXsl = false;
  // download temp repport
  Future<void> _downloadTempRepport(Device device, String format) async {
    Account? account = shared.getAccount();

    final now = DateTime.now();

    String res = await api.post(
      url: '/tempble/index',
      body: {
        'account_id': account?.account.accountId,
        'device_id': device.deviceId,
        'user_id': account?.account.userID,
        'date_from': DateTime(now.year, now.month, now.day, 0, 0, 0)
                .millisecondsSinceEpoch /
            1000,
        'date_to': DateTime(now.year, now.month, now.day, 23, 59, 59)
                .millisecondsSinceEpoch /
            1000,
        'order_by': 'created_at',
        'order_direction': 'asc',
        'download': true,
        'format': format
      },
    );

    await _downloadFile(
        base64Str: res.trim().toString(),
        fileName:
            "${device.description}-temp-${formatSimpleDate(now, false, '-')}",
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
      File file = File("$dir/$fileName.$extension");
      await file.create(recursive: true);
      await file.writeAsBytes(bytes);
      // set name of file

      await OpenFile.open(file.path, type: "application/$extension");
      debugPrint(file.path);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _requestStoragePermission() async {
    if (await Permission.storage.isGranted) return;
    await Permission.storage.request();
  }
}
