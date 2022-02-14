import 'package:flutter/material.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/ui/alert/hsitorics/notif_historic_provider.dart';
import 'package:provider/provider.dart';

class BuildSearchHistoric extends StatefulWidget {
  const BuildSearchHistoric({Key? key}) : super(key: key);

  @override
  State<BuildSearchHistoric> createState() => _BuildSearchHistoricState();
}

class _BuildSearchHistoricState extends State<BuildSearchHistoric> {
  bool _init = true;

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConsts.mainradius),
        borderSide: const BorderSide(
            color: AppConsts.mainColor, width: AppConsts.borderWidth));

    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    bool _isPortrait = orientation == Orientation.portrait;

    NotifHistoricPorvider porvider =
        Provider.of<NotifHistoricPorvider>(context, listen: false);
    return SafeArea(
      bottom: false,
      right: false,
      top: false,
      child: Container(
        width: _isPortrait ? size.width : size.width * 0.35,
        margin: const EdgeInsets.fromLTRB(10, 3, 3, 3),
        child: Autocomplete<Device>(
          fieldViewBuilder: (BuildContext context, TextEditingController _,
              FocusNode focusNode, Function onFieldSubmitted) {
            if (_init) {
              porvider.autoSearchController = _;
              porvider.handleSelectDevice();
              _init = false;
            } else {
              porvider.autoSearchController = _;
            }

            return fieldViewBuilderWidget(
                porvider, outlineInputBorder, focusNode, onFieldSubmitted);
          },
          displayStringForOption: (d) => d.description,
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return deviceProvider.devices;
            }
            return deviceProvider.devices.where(
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
              notifHistoricPorvider: porvider,
              devices: devices.toList(),
              onSelectDevice: deviceFunc,
            );
          },
        ),
      ),
    );
  }

  Widget fieldViewBuilderWidget(
      NotifHistoricPorvider notifHistoricPorvider,
      OutlineInputBorder outlineInputBorder,
      FocusNode focusNode,
      Function onFieldSubmitted) {
    return BuildTextField(
      focusNode: focusNode,
      notifHistoricPorvider: notifHistoricPorvider,
      outlineInputBorder: outlineInputBorder,
    );
  }
}

class BuildTextField extends StatefulWidget {
  final NotifHistoricPorvider notifHistoricPorvider;
  final FocusNode focusNode;
  final OutlineInputBorder outlineInputBorder;
  const BuildTextField({
    Key? key,
    required this.notifHistoricPorvider,
    required this.outlineInputBorder,
    required this.focusNode,
  }) : super(key: key);

  @override
  State<BuildTextField> createState() => _BuildTextFieldState();
}

class _BuildTextFieldState extends State<BuildTextField> {
  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return SizedBox(
      height: orientation == Orientation.portrait ? 35 : 30,
      child: TextFormField(
        autocorrect: false,
        autovalidateMode: AutovalidateMode.disabled,
        enableIMEPersonalizedLearning: false,
        enableInteractiveSelection: false,
        enableSuggestions: false,
        keyboardType: TextInputType.name,
        textAlign: TextAlign.left,
        textAlignVertical: TextAlignVertical.center,
        showCursor: true,
        textInputAction: TextInputAction.done,
        scrollPadding: EdgeInsets.zero,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        onTap: () =>
            widget.notifHistoricPorvider.autoSearchController.text = '',
        maxLines: 1,
        onFieldSubmitted: (_) =>
            widget.notifHistoricPorvider.handleSelectDevice(),
        decoration: InputDecoration(
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          filled: true,
          suffixIcon: const Icon(Icons.arrow_drop_down),
          suffixText: widget.focusNode.hasFocus
              ? ''
              : '${deviceProvider.devices.length}',
          suffixStyle: const TextStyle(
              fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey),
          border: widget.outlineInputBorder,
          focusedBorder: widget.outlineInputBorder,
          enabledBorder: widget.outlineInputBorder,
        ),
        controller: widget.notifHistoricPorvider.autoSearchController,
        focusNode: widget.focusNode,
      ),
    );
  }
}

class OptionViewBuilderWidget extends StatelessWidget {
  final List<Device> devices;
  final void Function(Device) onSelectDevice;
  final NotifHistoricPorvider notifHistoricPorvider;

  const OptionViewBuilderWidget({
    Key? key,
    required this.devices,
    required this.onSelectDevice,
    required this.notifHistoricPorvider,
  }) : super(key: key);

  Widget _buildToutsWidget(
      NotifHistoricPorvider notifHistoricPorvider, BuildContext context) {
    DeviceProvider deviceProvider =
        Provider.of<DeviceProvider>(context, listen: false);
    Orientation orientation = MediaQuery.of(context).orientation;
    return InkWell(
      onTap: () async {
        notifHistoricPorvider.deviceID = 'all';
        notifHistoricPorvider.handleSelectDevice();
        FocusScope.of(context).unfocus();
        notifHistoricPorvider.fetchDeviceFromSearchWidget();
      },
      child: Container(
        height: orientation == Orientation.portrait ? 35 : 30,
        padding: const EdgeInsets.only(left: 12),
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
    double bottom = MediaQuery.of(context).viewInsets.bottom;
    Size size = MediaQuery.of(context).size;
    bool _isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          notifHistoricPorvider.handleSelectDevice();
          FocusScope.of(context).unfocus();
        },
        child: SizedBox(
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              width: _isPortrait ? size.width : size.width * 0.35,
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
                        ? (size.height * 0.43)
                        : (bottom * 0.4),
                  ),
                  child: ListView(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    children: devices.map<Widget>((device) {
                      return OptionItem(
                        onSelectDevice: onSelectDevice,
                        notifHistoricPorvider: notifHistoricPorvider,
                        device: device,
                      );
                    }).toList()
                      ..insert(
                          0, _buildToutsWidget(notifHistoricPorvider, context)),
                  ),
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
  final Device device;
  const OptionItem({
    Key? key,
    required this.onSelectDevice,
    required this.notifHistoricPorvider,
    required this.device,
  }) : super(key: key);

  final void Function(Device p1) onSelectDevice;
  final NotifHistoricPorvider notifHistoricPorvider;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        onSelectDevice(device);
        notifHistoricPorvider.selectedDevice = device;
        notifHistoricPorvider.deviceID = device.deviceId;
        notifHistoricPorvider.fetchDeviceFromSearchWidget();
        FocusScope.of(context).unfocus();
        FocusScope.of(context).unfocus();
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
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Color.fromRGBO(device.colorR, device.colorG, device.colorB, 1),
      ),
      child: Text(
        device.statut,
        style: const TextStyle(
            fontSize: 10, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    );
  }
}
