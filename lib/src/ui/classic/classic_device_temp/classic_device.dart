import 'package:flutter/material.dart';
import 'package:newgps/src/models/device.dart';
import 'package:provider/provider.dart';

import '../../../utils/styles.dart';
import 'classic_device_temp.dart';

class ClassicDeviceTemp extends StatelessWidget {
  final Device device;
  const ClassicDeviceTemp({Key? key, required this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ClassicDeviceTempProvider>(
        create: (context) => ClassicDeviceTempProvider(device),
        builder: (context, __) {
          return FutureBuilder(
            future: context
                .read<ClassicDeviceTempProvider>()
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
    Key? key,
    required this.device,
  }) : super(key: key);

  final Device device;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(
        const Duration(seconds: 10),
        (_) async {
          await context
              .read<ClassicDeviceTempProvider>()
              .fetchLastTempRepport(device.deviceId);
        },
      ),
      builder: (context, snapshot) {
        final tempertaure =
            context.read<ClassicDeviceTempProvider>().temperature;
        return Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: _buildStatutColor(tempertaure ?? 0),
              width: 1.8,
            ),
            borderRadius: BorderRadius.circular(AppConsts.mainradius),
          ),
          child: Row(
            children: [
              Icon(
                Icons.thermostat,
                color: _buildStatutColor(tempertaure ?? 0),
              ),
              const SizedBox(width: 5),
              Text(
                '${tempertaure ?? '--'}  °C',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // get color depend on the temperature
  Color _buildStatutColor(double temp) {
    if (temp <= 0) {
      return Colors.blue;
    } else {
      return Colors.red;
    }
  }
}
