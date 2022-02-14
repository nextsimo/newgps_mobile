import 'package:flutter/material.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/ui/driver_phone/driver_phone_provider.dart';
import 'package:newgps/src/utils/locator.dart';
import 'package:provider/provider.dart';

import 'main_button.dart';

class AppelCondicteurButton extends StatelessWidget {
  final Device device;
  final Future<void> Function()? callNewData;
  const AppelCondicteurButton({
    Key? key,
    required this.device,
    this.callNewData,
  }) : super(key: key);

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
    Key? key,
    required this.device,
    this.callNewData,
  }) : super(key: key);

  final Device device;

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
    Key? key,
    required this.device,
    this.callNewData,
  }) : super(key: key);

  final Device device;

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
