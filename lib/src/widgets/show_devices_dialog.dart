import 'package:flutter/material.dart';
import '../services/newgps_service.dart';
import 'inputs/search_widget.dart';
import '../models/device.dart';
import '../utils/styles.dart';

class ShowDeviceDialogWidget extends StatelessWidget {
  final void Function(Device device) onselectedDevice;
  final String label;
  const ShowDeviceDialogWidget(
      {Key? key, required this.onselectedDevice, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (_) {
              return Dialog(
                child: _DevicesDialog(
                  onselectedDevice: onselectedDevice,
                ),
              );
            });
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        //margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppConsts.mainColor),
          borderRadius: BorderRadius.circular(AppConsts.mainradius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(label), const Icon(Icons.arrow_drop_down_outlined)],
        ),
      ),
    );
  }
}

class _DevicesDialog extends StatefulWidget {
  final void Function(Device device) onselectedDevice;

  const _DevicesDialog({Key? key, required this.onselectedDevice})
      : super(key: key);

  @override
  State<_DevicesDialog> createState() => _DevicesDialogState();
}

class _DevicesDialogState extends State<_DevicesDialog> {
  List<Device> _devices = deviceProvider.devices;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SearchWidget(
                width: double.infinity,
                onChnaged: (_) {
                  if (_.isEmpty) {
                    _devices = deviceProvider.devices;
                  } else {
                    _devices = deviceProvider.devices
                        .where((e) =>
                            e.description.toLowerCase().contains(_.toLowerCase()))
                        .toList();
                  }

                  setState(() {});
                },
                hint: 'Rechercher',
                height: 40,
              ),
            ),
            const CloseButton(),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (_, int index) {
                Device device = _devices.elementAt(index);
                return ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    widget.onselectedDevice(device);
                  },
                  title: Text(
                    device.description,
                  ),
                );
              }),
        ),
      ],
    );
  }
}
