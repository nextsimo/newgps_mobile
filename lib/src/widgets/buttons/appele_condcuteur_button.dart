import 'package:flutter/material.dart';
import '../../models/device.dart';
import '../../services/device_provider.dart';
import '../../ui/driver_phone/driver_phone_provider.dart';
import '../../utils/locator.dart';
import 'package:provider/provider.dart';

import 'main_button.dart';

class AppelCondicteurButton extends StatelessWidget {
  final Device? device;
  final Future<void> Function()? callNewData;
  const AppelCondicteurButton({
    super.key,
    required this.device,
    this.callNewData,
  });

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      return _AppelConducteurWidgetPortrait(device: device, callNewData: callNewData);
    }
    return _AppelConducteurWidgetLandscape(device: device, callNewData: callNewData);
  }
}

class _AppelConducteurWidgetPortrait extends StatelessWidget {
  final Future<void> Function()? callNewData;

  const _AppelConducteurWidgetPortrait({
    required this.device,
    this.callNewData,
  });

  final Device? device;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Consumer<DeviceProvider>(builder: (_, ___, ____) {
          return MainButton(
            width: 112,
            height: 35,
            onPressed: () {
              locator<DriverPhoneProvider>().checkPhoneDriver(
                  context: context, device: device, callNewData: callNewData);
            },
            icon: Icons.call,
            label: 'Conducteur',
          );
        }),
      ],
    );
  }
}

class _AppelConducteurWidgetLandscape extends StatelessWidget {
  final Future<void> Function()? callNewData;

  const _AppelConducteurWidgetLandscape({
    required this.device,
    this.callNewData,
  });

  final Device? device;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Consumer<DeviceProvider>(builder: (_, ___, ____) {
          return MainButton(
            width: 112,
            height: 27,
            onPressed: () {
              locator<DriverPhoneProvider>().checkPhoneDriver(
                  context: context, device: device, callNewData: callNewData);
            },
            label: 'Conducteur',
            icon: Icons.call,
          );
        }),
      ],
    );
  }
}
