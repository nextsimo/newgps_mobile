import 'package:flutter/material.dart';
import '../../models/device.dart';
import '../../models/user_model.dart';
import '../../services/device_provider.dart';
import '../../services/newgps_service.dart';
import '../../utils/styles.dart';
import '../../widgets/inputs/search_widget.dart';
import 'package:provider/provider.dart';

class UserDevicesUi extends StatefulWidget {
  final User user;
  final int flex;
  const UserDevicesUi({Key? key, required this.user, required this.flex})
      : super(key: key);

  @override
  State<UserDevicesUi> createState() => _UserDevicesUiState();
}

class _UserDevicesUiState extends State<UserDevicesUi> {
  final GlobalKey _key = LabeledGlobalKey("button_icon");
  OverlayEntry? _overlayEntry;
  late Size? buttonSize;
  late Offset buttonPosition;
  bool isMenuOpen = false;

  void findButton() {
    RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

  void openMenu() {
    _overlayEntryBuilder();
  }

  void closeMenu() {
    Navigator.of(context).pop();
  }

  void _overlayEntryBuilder() {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          child: _ShowListDevices(
            closeMenu: closeMenu,
            user: widget.user,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    if (isMenuOpen) closeMenu();
    _overlayEntry!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex,
      child: InkWell(
        onTap: () {
          if (isMenuOpen) {
            closeMenu();
          } else {
            openMenu();
          }
        },
        child: Container(
          key: _key,
          height: 25,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: AppConsts.mainColor, width: AppConsts.borderWidth),
            borderRadius: BorderRadius.circular(AppConsts.mainradius),
          ),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(width: 4),
                  Icon(
                    Icons.search,
                    color: Colors.grey[400],
                    size: 10,
                  ),
                  Text(
                    'Ajouter vehicule',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
              const Icon(Icons.arrow_drop_down,
                  color: Colors.grey, size: 10)
            ],
          ),
        ),
      ),
    );
  }
}

class _ShowListDevices extends StatefulWidget {
  final User user;
  final Function closeMenu;
  const _ShowListDevices(
      {Key? key, required this.closeMenu, required this.user})
      : super(key: key);

  @override
  State<_ShowListDevices> createState() => _ShowListDevicesState();
}

class _ShowListDevicesState extends State<_ShowListDevices> {
  late List<Device> devices;

  @override
  void initState() {
    super.initState();
    DeviceProvider deviceProvider = Provider.of(context, listen: false);
    devices = List<Device>.from(deviceProvider.devices);
    devices.sort((Device device1, Device device2) {
      if (widget.user.devices.contains(device1.deviceId)) {
        return -1;
      } else if (widget.user.devices.contains(device2.deviceId)) {
        return 1;
      } else {
        return 0;
      }
    });

    devices.insert(0, emptyDevice);
  }

  Device emptyDevice = Device(
      markerText: '',
      description: 'Tous les véhicules',
      deviceId: '',
      dateTime: DateTime.now(),
      latitude: 0,
      longitude: 0,
      address: '',
      distanceKm: 0,
      odometerKm: 0,
      city: '',
      heading: 0,
      speedKph: 0,
      index: 0,
      colorR: 0,
      colorG: 0,
      colorB: 0,
      statut: '',
      markerPng: '',
      phone1: '',
      phone2: '',
      deviceIcon: '',
      markerTextPng: '');
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.2,
      child: Column(
        children: [
          _searchDevices(),
          _devicesList(context),
        ],
      ),
    );
  }

  Widget _searchDevices() {
    DeviceProvider deviceProvider = Provider.of(context, listen: false);

    return Row(
      children: [
        Expanded(
          child: SearchWidget(
            autoFocus: true,
            hint: 'Rechercher',
            onChnaged: (_) {
              if (_.isEmpty) {
                devices = deviceProvider.devices;
              }
              devices = devices
                  .where((d) =>
                      d.description.toUpperCase().contains(_.toUpperCase()))
                  .toList();
              setState(() {});
            },
          ),
        ),
        const CloseButton(
          color: Colors.black,
        ),
      ],
    );
  }

  Widget _devicesList(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemBuilder: (_, int index) {
          Device device = devices.elementAt(index);
          String deviceName = device.description;
          bool selected = widget.user.devices.contains(device.deviceId);
          return CheckedMatricule(
            device: deviceName,
            ontapAllDevice: () {
              if (device.deviceId.isEmpty && !selected) {
                widget.user.devices = List<String>.from(
                    deviceProvider.devices.map((e) => e.deviceId))
                  ..add('');
                setState(() {});
              } else if (device.deviceId.isEmpty) {
                widget.user.devices.clear();
                setState(() {});
              } else {
                if (selected) {
                  widget.user.devices.remove(device.deviceId);
                  widget.user.devices.remove('');
                } else {
                  widget.user.devices.add(device.deviceId);
                }
                setState(() {});
              }
            },
            checked: selected,
            deviceID: device.deviceId,
            user: widget.user,
          );
        },
        separatorBuilder: (_, int index) => index == 0
            ? Container(
                height: 1.3,
                margin: const EdgeInsets.symmetric(vertical: 0),
                color: Colors.grey,
              )
            : const SizedBox(height: 0),
        itemCount: devices.length,
      ),
    );
  }
}

class CheckedMatricule extends StatelessWidget {
  final void Function() ontapAllDevice;
  final String device;
  final User user;
  final String deviceID;
  final bool checked;
  const CheckedMatricule(
      {Key? key,
      required this.device,
      required this.checked,
      required this.user,
      required this.deviceID,
      required this.ontapAllDevice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            value: checked,
            onChanged: (bool? check) {
              ontapAllDevice();
/*               if (check!) {
                widget.user.devices.add(widget.deviceID);
              } else if (!check) {
                widget.user.devices.remove(widget.deviceID);
              }
              _checked = check;
              setState(() {}); */
            }),
        const SizedBox(width: 10),
        Text(
          device,
          style: TextStyle(
            color: deviceID.isEmpty ? Colors.red : Colors.grey,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
