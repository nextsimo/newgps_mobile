import 'package:flutter/material.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/ui/last_position/last_position_provider.dart';
import 'package:provider/provider.dart';

class AutoSearchDeviceWithAll extends StatefulWidget {
  const AutoSearchDeviceWithAll({Key? key}) : super(key: key);

  @override
  State<AutoSearchDeviceWithAll> createState() =>
      _AutoSearchDeviceWithAllState();
}

class _AutoSearchDeviceWithAllState extends State<AutoSearchDeviceWithAll> {
  bool _init = true;

  late FocusNode _focusNode;

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConsts.mainradius),
        borderSide: const BorderSide(
            color: AppConsts.mainColor, width: AppConsts.borderWidth));
    final LastPositionProvider lastPositionProvider =
        Provider.of<LastPositionProvider>(context, listen: false);

    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    bool _isPortrait = orientation == Orientation.portrait;
    return SafeArea(
      child: Container(
        width: _isPortrait ? size.width * .595 : size.width * 0.35,
        margin: const EdgeInsets.all(AppConsts.outsidePadding),
        child: Autocomplete<Device>(
          fieldViewBuilder: (BuildContext context, TextEditingController _,
              FocusNode focusNode, Function onFieldSubmitted) {
            if (_init) {
              lastPositionProvider.autoSearchController = _;
              _focusNode = focusNode;
              lastPositionProvider.handleSelectDevice(notify: false);
              _init = false;
            } else {
              lastPositionProvider.autoSearchController = _;
              _focusNode = focusNode;
            }

            return BuildTextField(
              focusNode: _focusNode,
              lastPositionProvider: lastPositionProvider,
              outlineInputBorder: outlineInputBorder,
            );
          },
          displayStringForOption: (d) => d.description,
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return lastPositionProvider.devices;
            }
            return lastPositionProvider.devices.where(
              (device) {
                return device.description
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase());
              },
            );
          },
          optionsViewBuilder: (BuildContext context,
              void Function(Device device) deviceFunc, devices) {
            return OptionViewBuilderWidget(
              focusNode: _focusNode,
              onSelectDevice: deviceFunc,
            );
          },
        ),
      ),
    );
  }
}

class BuildTextField extends StatelessWidget {
  final LastPositionProvider lastPositionProvider;
  final FocusNode focusNode;
  final OutlineInputBorder outlineInputBorder;
  const BuildTextField({
    Key? key,
    required this.lastPositionProvider,
    required this.outlineInputBorder,
    required this.focusNode,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Device> devices =
        context.select<LastPositionProvider, List<Device>>((__) => __.devices);

    Orientation orientation = MediaQuery.of(context).orientation;

    if (devices.isEmpty) {
      lastPositionProvider.autoSearchController.text =
          'Chargement des véhicules..';
    } else if (lastPositionProvider.autoSearchController.text ==
        'Chargement des véhicules..') {
      lastPositionProvider.autoSearchController.text = 'Touts les véhicules';
    }

    return IgnorePointer(
      ignoring: devices.isEmpty,
      child: SizedBox(
        height: orientation == Orientation.portrait ? 35 : 30,
        child: TextFormField(
          textAlign: TextAlign.left,
          textAlignVertical: TextAlignVertical.center,
          showCursor: true,
          textInputAction: TextInputAction.done,
          scrollPadding: EdgeInsets.zero,
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
          onTap: () => lastPositionProvider.autoSearchController.text = '',
          maxLines: 1,
          onFieldSubmitted: (_) => lastPositionProvider.handleSelectDevice(),
          decoration: InputDecoration(
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            filled: true,
            suffixIcon: const Icon(Icons.arrow_drop_down, size: 22),
            suffixText: (focusNode.hasFocus || devices.isEmpty)
                ? ''
                : '${deviceProvider.devices.length}',
            suffixStyle: const TextStyle(
                fontSize: 9, fontWeight: FontWeight.w600, color: Colors.grey),
            border: outlineInputBorder,
            focusedBorder: outlineInputBorder,
            enabledBorder: outlineInputBorder,
          ),
          controller: lastPositionProvider.autoSearchController,
          focusNode: focusNode,
        ),
      ),
    );
  }
}

class OptionViewBuilderWidget extends StatelessWidget {
  final FocusNode focusNode;
  final void Function(Device) onSelectDevice;

  const OptionViewBuilderWidget({
    Key? key,
    required this.onSelectDevice,
    required this.focusNode,
  }) : super(key: key);

  Widget _buildToutsWidget(
      LastPositionProvider lastPositionProvider, BuildContext context) {
    DeviceProvider deviceProvider =
        Provider.of<DeviceProvider>(context, listen: false);
    Orientation orientation = MediaQuery.of(context).orientation;
    return InkWell(
      onTap: () async {
        focusNode.unfocus();
        lastPositionProvider.markersProvider.fetchGroupesDevices = true;
        lastPositionProvider.setDevicesMareker(fromSelect: true);
        lastPositionProvider.handleSelectDevice();
        deviceProvider.infoModel = null;
      },
      child: Container(
        height: orientation == Orientation.portrait ? 35 : 30,
        padding: const EdgeInsets.only(left: 5),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
                color: AppConsts.mainColor, width: AppConsts.borderWidth),
          ),
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Touts les véhicules',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${deviceProvider.devices.length}",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    LastPositionProvider lastPositionProvider =
        Provider.of<LastPositionProvider>(context);
    double bottom = MediaQuery.of(context).viewInsets.bottom;
    Size size = MediaQuery.of(context).size;
    bool _isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

            List<Device> devices = deviceProvider.devices;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          focusNode.unfocus();
          lastPositionProvider.fetch(context);
          lastPositionProvider.handleSelectDevice();
        },
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            width: _isPortrait ? size.width * .595 : size.width * 0.35,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: AppConsts.mainColor, width: AppConsts.borderWidth),
                borderRadius: BorderRadius.circular(AppConsts.mainradius)),
            child: Material(
              color: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: _isPortrait
                      ? (size.height * 0.44)
                      : (bottom == 0.0 ? size.height * 0.5 : bottom * 0.37),
                ),
                child: ListView(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: devices.map<Widget>((device) {
                    return OptionItem(
                      focusNode: focusNode,
                      onSelectDevice: onSelectDevice,
                      lastPositionProvider: lastPositionProvider,
                      device: device,
                    );
                  }).toList()
                    ..insert(
                        0, _buildToutsWidget(lastPositionProvider, context)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OptionItem extends StatelessWidget {
  final FocusNode focusNode;
  final Device device;
  const OptionItem({
    Key? key,
    required this.onSelectDevice,
    required this.lastPositionProvider,
    required this.device,
    required this.focusNode,
  }) : super(key: key);

  final void Function(Device p1) onSelectDevice;
  final LastPositionProvider lastPositionProvider;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        onSelectDevice(device);
        deviceProvider.selectedDevice = device;
        focusNode.unfocus();
        lastPositionProvider.markersProvider.fetchGroupesDevices = false;
        await lastPositionProvider.fetchDevice(device.deviceId,
            isSelected: true);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4, top: 5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                device.description,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
              _BuildStatuWidget(device: device)
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildStatuWidget extends StatelessWidget {
  const _BuildStatuWidget({
    Key? key,
    required this.device,
  }) : super(key: key);

  final Device device;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Color.fromRGBO(device.colorR, device.colorG, device.colorB, 1),
      ),
      child: Text(
        device.statut,
        style: const TextStyle(
            fontSize: 8, fontWeight: FontWeight.w600, color: Colors.white),
      ),
    );
  }
}
