import 'package:flutter/material.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/utils/styles.dart';

typedef HandleSelectDevice = void Function();
typedef OnClickAll = void Function();
typedef InitController = void Function(TextEditingController c);
typedef ClearTextController = void Function();
typedef OnSelectDevice = void Function(Device device);

class AutoSearchWithAllWidget extends StatefulWidget {
  final InitController initController;
  final HandleSelectDevice handleSelectDevice;
  final OnClickAll onClickAll;
  final ClearTextController clearTextController;
  final OnSelectDevice onSelectDevice;
  final TextEditingController controller;
  final double? width;
  final bool withoutAll;
  const AutoSearchWithAllWidget(
      {Key? key,
      required this.initController,
      required this.handleSelectDevice,
      required this.onClickAll,
      required this.clearTextController,
      required this.controller,
      required this.onSelectDevice,
      this.width, this.withoutAll =false})
      : super(key: key);

  @override
  State<AutoSearchWithAllWidget> createState() =>
      _AutoSearchWithAllWidgetState();
}

class _AutoSearchWithAllWidgetState extends State<AutoSearchWithAllWidget> {
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
    return SafeArea(
      bottom: false,
      right: false,
      top: false,
      child: Container(
        width: _isPortrait
            ? (widget.width ?? (size.width * .595))
            : size.width * 0.35,
        margin: const EdgeInsets.all(AppConsts.outsidePadding),
        child: Autocomplete<Device>(
          fieldViewBuilder: (BuildContext context, TextEditingController _,
              FocusNode focusNode, Function onFieldSubmitted) {
            if (_init) {
              widget.initController(_);
              widget.handleSelectDevice();
              _init = false;
            } else {
              widget.initController(_);
            }
            return BuildTextField(
              rebuild: () {
                widget.clearTextController();
                setState(() {});
              },
              controller: widget.controller,
              clearTextController: widget.clearTextController,
              handleSelectDevice: widget.handleSelectDevice,
              focusNode: focusNode,
              outlineInputBorder: outlineInputBorder,
            );
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
              withoutAll: widget.withoutAll,
              onSelectDevice2: widget.onSelectDevice,
              handleSelectDevice: widget.handleSelectDevice,
              onClickAll: widget.onClickAll,
              devices: devices.toList(),
              onSelectDevice: deviceFunc,
              width: widget.width,
            );
          },
        ),
      ),
    );
  }
}

class BuildTextField extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final HandleSelectDevice handleSelectDevice;
  final ClearTextController clearTextController;
  final OutlineInputBorder outlineInputBorder;
  final void Function() rebuild;
  const BuildTextField({
    Key? key,
    required this.outlineInputBorder,
    required this.focusNode,
    required this.clearTextController,
    required this.handleSelectDevice,
    required this.controller,
    required this.rebuild,
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
        textAlign: TextAlign.left,
        textAlignVertical: TextAlignVertical.center,
        showCursor: true,
        textInputAction: TextInputAction.done,
        scrollPadding: EdgeInsets.zero,
        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
        onTap: () async {
          widget.clearTextController();
          widget.controller.clear();
/*           await Future.delayed(const Duration(milliseconds: 250));
          widget.rebuild(); */
        },
        maxLines: 1,
        onFieldSubmitted: (_) => widget.handleSelectDevice(),
        autofocus: false,
        decoration: InputDecoration(
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          filled: true,
          suffixIcon: const Icon(Icons.arrow_drop_down),
          suffixText: widget.focusNode.hasFocus
              ? ''
              : '${deviceProvider.devices.length}',
          suffixStyle: const TextStyle(
              fontSize: 9, fontWeight: FontWeight.w600, color: Colors.grey),
          border: widget.outlineInputBorder,
          focusedBorder: widget.outlineInputBorder,
          enabledBorder: widget.outlineInputBorder,
        ),
        controller: widget.controller,
        focusNode: widget.focusNode,
      ),
    );
  }
}

class OptionViewBuilderWidget extends StatelessWidget {
  final double? width;
  final OnClickAll onClickAll;
  final OnSelectDevice onSelectDevice2;
  final bool withoutAll;

  final List<Device> devices;
  final void Function(Device) onSelectDevice;
  final HandleSelectDevice handleSelectDevice;

  const OptionViewBuilderWidget({
    Key? key,
    required this.devices,
    required this.onSelectDevice,
    required this.onClickAll,
    required this.handleSelectDevice,
    required this.onSelectDevice2,
    this.width,
    this.withoutAll = false,
  }) : super(key: key);

  Widget _buildToutsWidget(BuildContext context) {
    if (withoutAll) {
      return const SizedBox();
    }
    Orientation orientation = MediaQuery.of(context).orientation;

    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        onClickAll();
        FocusScope.of(context).unfocus();
      },
      child: Container(
        height: orientation == Orientation.portrait ? 35 : 30,
        padding: const EdgeInsets.only(left: 6),
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
             Text(
              withoutAll?  'Sélectionner une vehicule' :'Touts les véhicules' ,
              style: const  TextStyle(
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
          handleSelectDevice();
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: Colors.transparent,
          width: size.width,
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(right: width != null ? 9 : 20),
              width: _isPortrait
                  ? (width ?? (size.width * .595))
                  : size.width * 0.35,
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
                        onSelectDevice2: onSelectDevice2,
                        onSelectDevice: onSelectDevice,
                        device: device,
                      );
                    }).toList()
                      ..insert(0, _buildToutsWidget(context)),
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
  final OnSelectDevice onSelectDevice2;
  const OptionItem({
    Key? key,
    required this.onSelectDevice,
    required this.device,
    required this.onSelectDevice2,
  }) : super(key: key);

  final void Function(Device p1) onSelectDevice;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        onSelectDevice(device);
        onSelectDevice2(device);
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4, top: 5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
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
