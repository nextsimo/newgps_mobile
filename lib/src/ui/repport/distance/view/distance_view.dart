import 'package:flutter/material.dart';
import '../provider/distance_provider.dart';
import 'package:provider/provider.dart';
import '../../rapport_provider.dart';
import 'distance_repport_all_device.dart';
import 'distance_repport_one_device.dart';

class DistanceView extends StatelessWidget {
  const DistanceView({super.key});

  @override
  Widget build(BuildContext context) {
    RepportProvider provider = Provider.of<RepportProvider>(context);

    return ChangeNotifierProvider<DistanceRepportProvider>(
      create: (_) => DistanceRepportProvider(provider),
      builder: (_, __) {
        if (provider.selectAllDevices) {
          return const DistanceRepportAllDeviceView();
        }
        return const DistanceRepportOneDevice();
      },
    );
  }
}
