import 'package:flutter/material.dart';
import 'package:newgps/src/ui/alert/alert_widgets/select_devices_provider.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/widgets/inputs/search_widget.dart';
import 'package:provider/provider.dart';
import '../../../models/device.dart';

class SelectDeviceUi extends StatelessWidget {
  final void Function(List<String> ids) onSelectDevice;
  final List<String> initSelectedDevice;
  const SelectDeviceUi(
      {Key? key,
      required this.onSelectDevice,
      required this.initSelectedDevice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SelectDevicesProvider>(
        create: (__) => SelectDevicesProvider(initSelectedDevice),
        builder: (context, __) {
          final SelectDevicesProvider provider =
              Provider.of<SelectDevicesProvider>(context);
          return Expanded(
            child: Column(
              children: [
                SearchWidget(
                  width: double.infinity,
                  onChnaged: provider.search,
                  hint: 'Rechercher',
                  height: 40,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: AppConsts.mainColor),
                        borderRadius: BorderRadius.circular(6)),
                    child: Column(
                      children: [
                        // ignore: prefer_const_constructors
                        _BuildCheckBoxText(
                          label: 'Toutes les vehicules',
                          id: 'all',
                          onSelectDevice: onSelectDevice,
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: provider.searchDevices.length,
                              itemBuilder: (_, int index) {
                                Device device =
                                    provider.searchDevices.elementAt(index);
                                return _BuildCheckBoxText(
                                  onSelectDevice: onSelectDevice,
                                  label: device.description,
                                  id: device.deviceId,
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class _BuildCheckBoxText extends StatelessWidget {
  final void Function(List<String> ids) onSelectDevice;

  final String label;
  final String id;
  const _BuildCheckBoxText(
      {Key? key,
      required this.label,
      required this.id,
      required this.onSelectDevice})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final SelectDevicesProvider selectDevicesProvider =
        Provider.of<SelectDevicesProvider>(context, listen: false);
    return CheckboxListTile(
      onChanged: (bool? val) {
        selectDevicesProvider.changed(val, id);
        onSelectDevice(List.from(selectDevicesProvider.selectedDevices));
      },
      value: selectDevicesProvider.selectedDevices.contains(id),
      title: Text(
        label,
        //style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}
