import 'package:flutter/material.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:provider/provider.dart';

import 'temp_device_temp.dart';

class ClassicDeviceTemp extends StatelessWidget {
  final Device device;
  const ClassicDeviceTemp({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TempCardDeviceTempProvider>(
        create: (context) => TempCardDeviceTempProvider(device),
        builder: (context, __) {
          return FutureBuilder(
            future: context
                .read<TempCardDeviceTempProvider>()
                .fetchLastTempRepport(device.deviceId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return _BuildStreamerWigdet(device: device);
              } else {
                return const SizedBox();
              }
            },
          );
        });
  }
}

class _BuildStreamerWigdet extends StatelessWidget {
  const _BuildStreamerWigdet({
    required this.device,
  });

  final Device device;

  // format temperature to 2 decimal and add sign + or -
  String _formatTemperature(double? temperature) {
    if (temperature == null) {
      return '--';
    }
    if (temperature == 0) {
      return '0';
    }
    String sign = temperature < 0 ? '' : '+';
    return '$sign${temperature.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(
        const Duration(seconds: 10),
        (_) async {
          await context
              .read<TempCardDeviceTempProvider>()
              .fetchLastTempRepport(device.deviceId);
        },
      ),
      builder: (context, snapshot) {
        final tempertaure =
            context.read<TempCardDeviceTempProvider>().temperature;
        return Row(
          children: [
            Text(
              _formatTemperature(tempertaure ?? 0),
              style: TextStyle(
                color: _buildStatutColor(tempertaure ?? 0),
                fontSize: 33,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 5),
            const Text(
              '°C',
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }

  // get color depend on the temperature
  Color _buildStatutColor(double temp) {
    if (temp <= 0) {
      return AppConsts.mainColor;
    } else {
      return Colors.red;
    }
  }
}
