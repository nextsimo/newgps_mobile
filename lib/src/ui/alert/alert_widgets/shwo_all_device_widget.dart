import 'package:flutter/material.dart';

import '../../../utils/styles.dart';
import 'select_devices_view.dart';

class ShowAllDevicesWidget extends StatelessWidget {
  final Future<void> Function(List<String>) onSaveDevices;
  final List<String> selectedDevices;
  const ShowAllDevicesWidget(
      {Key? key,
      required this.onSaveDevices,
      this.selectedDevices = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (selectedDevices.isNotEmpty) {
          showDialog(
              context: context,
              builder: (_) {
                return Dialog(
                  child: SelectDeviceUi(
                    onSaveDevices: onSaveDevices,
                    initSelectedDevice: selectedDevices,
                  ),
                );
              });
        }
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppConsts.mainColor),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  [
            Text('Sélectionner les véhicules ${selectedDevices.length <= 1 ? '' : "(${selectedDevices.length-1})"}'),
           const Icon(Icons.arrow_drop_down_outlined)
          ],
        ),
      ),
    );
  }
}
