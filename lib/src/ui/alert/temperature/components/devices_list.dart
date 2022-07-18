import 'package:flutter/material.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/ui/alert/temperature/logic/temperature_provider.dart';
import 'package:provider/provider.dart';

class MyDevicesList extends StatelessWidget {
  const MyDevicesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // read provider
    final TemperatureBleProvider provider =
        context.read<TemperatureBleProvider>();
    context
        .select<TemperatureBleProvider, List<String>>((_) => _.selectedDevice);
    return SizedBox(
      width: 200,
      height: 100,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.4,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        shrinkWrap: true,
        itemCount: deviceProvider.devices.length,
        itemBuilder: (BuildContext context, int index) {
          final Device device = deviceProvider.devices[index];
          return _BuildChip(
            deviceId: device.deviceId,
            description: device.description,
            isSelected: provider.isDeviceIdInList(device.deviceId),
          );
        },
        //childAspectRatio: 1.5,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

class _BuildChip extends StatelessWidget {
  final String description;
  final bool isSelected;
  final String deviceId;
  const _BuildChip(
      {Key? key,
      required this.description,
      required this.isSelected,
      required this.deviceId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TemperatureBleProvider provider =
        context.read<TemperatureBleProvider>();

    return GestureDetector(
      onTap: () => provider.addOrRemoveDevice(deviceId),
      child: Chip(
        backgroundColor: isSelected ? Colors.blue : Colors.white,
        label: Text(
          description,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
        elevation: 5,
      ),
    );
  }
}
