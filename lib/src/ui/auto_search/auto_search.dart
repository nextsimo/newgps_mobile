import 'package:flutter/material.dart';
import '../../models/device.dart';
import '../../services/device_provider.dart';
import '../../utils/styles.dart';
import '../historic/historic_provider.dart';
import '../last_position/last_position_provider.dart';
import 'package:provider/provider.dart';

class AutoSearchDevice extends StatefulWidget {
  final Future<void> Function(Device device)? onSelectDeviceFromOtherView;
  const AutoSearchDevice({Key? key, this.onSelectDeviceFromOtherView})
      : super(key: key);
  @override
  State<AutoSearchDevice> createState() => _AutoSearchDeviceState();
}

class _AutoSearchDeviceState extends State<AutoSearchDevice> {
  bool _init = true;
  late FocusNode _focusNode;
  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConsts.mainradius),
        borderSide: const BorderSide(
            color: AppConsts.mainColor, width: AppConsts.borderWidth));
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);
    final HistoricProvider historicProvider =
        Provider.of<HistoricProvider>(context, listen: false);

    Size size = MediaQuery.of(context).size;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return SafeArea(
      child: Container(
        width: isPortrait ? size.width * .6 : size.width * 0.35,
        margin: const EdgeInsets.all(AppConsts.outsidePadding),
        child: Autocomplete<Device>(
          fieldViewBuilder: (BuildContext context, TextEditingController _,
              FocusNode focusNode, Function onFieldSubmitted) {
            if (_init) {
              deviceProvider.autoSearchController = _;
              deviceProvider.handleSelectDevice();
              _focusNode = focusNode;
              _init = false;
            } else {
              deviceProvider.autoSearchController = _;
            }
            if (deviceProvider.devices.isEmpty) {
              deviceProvider.autoSearchController.text =
                  'Chargement des véhicules..';
            } else if (deviceProvider.autoSearchController.text ==
                'Chargement des véhicules..') {
              deviceProvider.autoSearchController.text =
                  deviceProvider.devices.first.description;
                  historicProvider.fetchHistorics(context);
            }
            return fieldViewBuilderWidget(deviceProvider, outlineInputBorder,
                _focusNode, onFieldSubmitted, historicProvider);
          },
          displayStringForOption: (d) => d.description,
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) return deviceProvider.devices;
            return deviceProvider.devices.where(
              (device) {
                return device.description
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase());
              },
            );
          },
          onSelected: widget.onSelectDeviceFromOtherView,
          optionsViewBuilder: (BuildContext context,
              void Function(Device device) deviceFunc, devices) {
            return OptionViewBuilderWidget(
              focusNode: _focusNode,
              onSelectDevice: deviceFunc,
              devices: devices.toList(),
            );
          },
        ),
      ),
    );
  }

  Widget fieldViewBuilderWidget(
      DeviceProvider deviceProvider,
      OutlineInputBorder outlineInputBorder,
      FocusNode focusNode,
      Function onFieldSubmitted,
      HistoricProvider historicProvider) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return SizedBox(
      height: orientation == Orientation.portrait ? 35 : 30,
      child: TextFormField(
        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
        textAlign: TextAlign.left,
        textAlignVertical: TextAlignVertical.center,
        showCursor: true,
        textInputAction: TextInputAction.done,
        scrollPadding: EdgeInsets.zero,
        maxLines: 1,
        onFieldSubmitted: (_) => deviceProvider.handleSelectDevice(),
        onTap: () => deviceProvider.autoSearchController.text = '',
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          fillColor: Colors.white,
          filled: true,
          suffixIcon: const Icon(Icons.arrow_drop_down),
          border: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          enabledBorder: outlineInputBorder,
        ),
        controller: deviceProvider.autoSearchController,
        focusNode: focusNode,
      ),
    );
  }
}

class OptionViewBuilderWidget extends StatelessWidget {
  final FocusNode focusNode;
  final List<Device> devices;
  final void Function(Device) onSelectDevice;

  const OptionViewBuilderWidget({
    Key? key,
    required this.onSelectDevice,
    required this.focusNode,required this.devices,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeviceProvider deviceProvider =
        Provider.of<DeviceProvider>(context);
    Size size = MediaQuery.of(context).size;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    double bottom = MediaQuery.of(context).viewInsets.bottom;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          deviceProvider.handleSelectDevice();
          focusNode.unfocus();
        },
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            width: isPortrait ? size.width * .6 : size.width * 0.35,
            margin: const EdgeInsets.only(top: 3),
            constraints: BoxConstraints(
              maxHeight: isPortrait
                  ? (size.height * 0.44)
                  : (bottom == 0.0 ? size.height * 0.5 : bottom * 0.5),
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: AppConsts.mainColor, width: AppConsts.borderWidth),
                borderRadius: BorderRadius.circular(AppConsts.mainradius)),
            child: Material(
              color: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: size.height * 0.75,
                ),
                child: ListView(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    children: devices.map<Widget>((device) {
                      return OptionItem(
                        focusNode: focusNode,
                        onSelectDevice: onSelectDevice,
                        deviceProvider: deviceProvider,
                        device: device,
                      );
                    }).toList()),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OptionItem extends StatelessWidget {
  final Device device;
  final FocusNode focusNode;
  const OptionItem({
    Key? key,
    required this.onSelectDevice,
    required this.deviceProvider,
    required this.device,
    required this.focusNode,
  }) : super(key: key);

  final void Function(Device p1) onSelectDevice;
  final DeviceProvider deviceProvider;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        LastPositionProvider lastPositionProvider =
            Provider.of<LastPositionProvider>(context, listen: false);
        lastPositionProvider.markersProvider.fetchGroupesDevices = false;
        onSelectDevice(device);
        deviceProvider.selectedDevice = device;
        focusNode.unfocus();
        onSelectDevice(device);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4, top: 5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                device.description,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
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
