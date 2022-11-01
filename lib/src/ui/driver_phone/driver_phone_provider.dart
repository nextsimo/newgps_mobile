import 'package:flutter/material.dart';
import '../../models/device.dart';
import '../../services/newgps_service.dart';
import 'drive_add_dialog.dart';
import '../../utils/functions.dart';

class DriverPhoneProvider {
  Future<void> checkPhoneDriver(
      {required BuildContext context,
      required Device? device,
      required Future<void> Function()? callNewData,
      Device? sDevice}) async {
    if (device!.phone1.isEmpty) {
      _showAddDialogPhone(
        callNewData: callNewData,
        context: context,
        sDevice: sDevice,
        device: device,
      );
      return;
    }
    showCallConducteurDialog(context, device);
  }

  Future<void> _showAddDialogPhone(
      {required BuildContext context,
      required Device device,
      required Device? sDevice,
      required Future<void> Function()? callNewData}) async {
    bool? res = await showDialog<bool>(
        context: context,
        builder: (_) {
          return DriverAddDialog(
            device: device,
          );
        });
    if (res == true) {
      await callNewData!();
      if (sDevice == null) {
        // ignore: use_build_context_synchronously
        showCallConducteurDialog(context, deviceProvider.selectedDevice);
      } else {
        Device device = deviceProvider.devices
            .firstWhere((element) => element.deviceId == sDevice.deviceId);
        // ignore: use_build_context_synchronously
        showCallConducteurDialog(context, device);
      }
    }
  }
}
