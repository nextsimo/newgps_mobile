import 'package:flutter/material.dart';
import 'select_devices_provider.dart';
import '../../../utils/styles.dart';
import '../../../widgets/buttons/main_button.dart';
import '../../../widgets/inputs/search_widget.dart';
import 'package:provider/provider.dart';
import '../../../models/device.dart';

class SelectDeviceUi extends StatelessWidget {
  final Future<void> Function(List<String> ids) onSaveDevices;
  final List<String> initSelectedDevice;
  const SelectDeviceUi(
      {Key? key,
      required this.onSaveDevices,
      required this.initSelectedDevice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SelectDevicesProvider>(
        create: (__) => SelectDevicesProvider(initSelectedDevice),
        builder: (context, __) {
          final SelectDevicesProvider provider =
              Provider.of<SelectDevicesProvider>(context);
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SearchWidget(
                      width: double.infinity,
                      onChnaged: provider.search,
                      hint: 'Rechercher',
                      height: 40,
                    ),
                  ),
                  const CloseButton(),
                ],
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
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: provider.searchDevices.length,
                            itemBuilder: (_, int index) {
                              Device device =
                                  provider.searchDevices.elementAt(index);
                              return _BuildCheckBoxText(
                                label: device.description,
                                id: device.deviceId,
                              );
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MainButton(
                          label: 'Enregistrer',
                          onPressed: () async {
                            await onSaveDevices(List.from(provider.selectedDevices));
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}

class _BuildCheckBoxText extends StatelessWidget {

  final String label;
  final String id;
  const _BuildCheckBoxText(
      {Key? key,
      required this.label,
      required this.id})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final SelectDevicesProvider selectDevicesProvider =
        Provider.of<SelectDevicesProvider>(context, listen: false);
    return CheckboxListTile(
      onChanged: (bool? val) {
        selectDevicesProvider.changed(val, id);
      },
      value: selectDevicesProvider.selectedDevices.contains(id),
      title: Text(
        label,
        //style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}
