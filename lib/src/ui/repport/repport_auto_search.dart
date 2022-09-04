import 'package:flutter/material.dart';
import '../../models/device.dart';
import '../../utils/styles.dart';
import 'rapport_provider.dart';
import 'package:provider/provider.dart';

class AutoSearchField extends StatefulWidget {
  const AutoSearchField({Key? key}) : super(key: key);

  @override
  State<AutoSearchField> createState() => _AutoSearchFieldState();
}

class _AutoSearchFieldState extends State<AutoSearchField> {
  late FocusNode _focusNode;

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConsts.mainradius),
        borderSide: const BorderSide(
            color: AppConsts.mainColor, width: AppConsts.borderWidth));
    final RepportProvider repportProvider =
        Provider.of<RepportProvider>(context, listen: false);
    if (repportProvider.devices.isEmpty) return const SizedBox();
    return GestureDetector(
      onTap: () => repportProvider.handleSelectDevice(),
      child: Container(
        color: Colors.transparent,
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: 180,
          child: Autocomplete<Device>(
            initialValue: const TextEditingValue(text: 'Toutes les vehicules'),
            fieldViewBuilder: (BuildContext context, TextEditingController _,
                FocusNode focusNode, Function onFieldSubmitted) {
              repportProvider.autoSearchTextController = _;
              _focusNode = focusNode;
              return _BuildTextField(
                  repportProvider: repportProvider,
                  outlineInputBorder: outlineInputBorder,
                  focus: _focusNode);
            },
            displayStringForOption: (d) => d.description,
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return repportProvider.devices;
              }
              return repportProvider.devices.where(
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
                devices: devices.toList(),
                onSelectRepportResumeModel: deviceFunc,
                repportProvider: repportProvider,
                focusNode: _focusNode,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _BuildTextField extends StatefulWidget {
  const _BuildTextField({
    Key? key,
    required this.repportProvider,
    required this.outlineInputBorder,
    required this.focus,
  }) : super(key: key);

  final RepportProvider repportProvider;
  final OutlineInputBorder outlineInputBorder;
  final FocusNode focus;

  @override
  State<_BuildTextField> createState() => _BuildTextFieldState();
}

class _BuildTextFieldState extends State<_BuildTextField> {
  @override
  void initState() {
    super.initState();

    widget.focus.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    widget.focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: TextFormField(
        textAlign: TextAlign.left,
        textAlignVertical: TextAlignVertical.center,
        textInputAction: TextInputAction.done,
        scrollPadding: EdgeInsets.zero,
        maxLines: 1,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w500,
        ),
        onTap: () async {
          widget.repportProvider.autoSearchTextController.text = '';
          widget.repportProvider.handleRepportType();
          //repportProvider.handleSelectDevice(only: true);
        },
        onFieldSubmitted: (_) => widget.repportProvider.handleSelectDevice(),
        decoration: InputDecoration(
          fillColor: Colors.white,
          suffixStyle: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w500,
          ),
          suffixText: widget.focus.hasFocus
              ? ''
              : '${widget.repportProvider.devices.length}',
          contentPadding: const EdgeInsets.fromLTRB(10, 14, 10, 0),
          filled: true,
          suffixIcon: const Icon(Icons.arrow_drop_down, size: 15),
          suffixIconConstraints: const BoxConstraints(),
          border: widget.outlineInputBorder,
          focusedBorder: widget.outlineInputBorder,
          enabledBorder: widget.outlineInputBorder,
        ),
        controller: widget.repportProvider.autoSearchTextController,
        focusNode: widget.focus,
      ),
    );
  }
}

class OptionViewBuilderWidget extends StatelessWidget {
  final List<Device> devices;
  final RepportProvider repportProvider;
  final FocusNode focusNode;
  final void Function(Device) onSelectRepportResumeModel;

  const OptionViewBuilderWidget({
    Key? key,
    required this.devices,
    required this.onSelectRepportResumeModel,
    required this.repportProvider,
    required this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    bool _isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double bottom = MediaQuery.of(context).viewInsets.bottom;
    return GestureDetector(
      onTap: () {
        focusNode.unfocus();
        repportProvider.handleSelectDevice();
      },
      child: Material(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            width: 180,
            constraints: BoxConstraints(
              maxHeight: _isPortrait
                  ? (size.height * 0.44)
                  : (bottom == 0.0 ? size.height * 0.5 : bottom * 0.34),
            ),
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: AppConsts.mainColor, width: AppConsts.borderWidth),
                borderRadius: BorderRadius.circular(AppConsts.mainradius)),
            child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: devices.map<Widget>((device) {
                  return OptionItem(
                    focusNode: focusNode,
                    onSelectRepportResumeModel: onSelectRepportResumeModel,
                    repportProvider: repportProvider,
                    device: device,
                  );
                }).toList()
                  ..insert(0, _buildToutsWidget(repportProvider, context))),
          ),
        ),
      ),
    );
  }

  Widget _buildToutsWidget(RepportProvider provider, BuildContext context) {
    return InkWell(
      onTap: () async {
        focusNode.unfocus();
        provider.autoSearchTextController.text = 'Touts les véhicules';
        repportProvider.selectAllDevices = true;

        if (provider.selectedRepport.index != 0 &&
            provider.selectedRepport.index != 4) {
          provider.selectedRepport = provider.repportsType.first;
        }
      },
      child: Container(
        height: 30,
        padding:
            const EdgeInsets.symmetric(horizontal: AppConsts.outsidePadding),
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
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${repportProvider.devices.length}',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
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
    required this.onSelectRepportResumeModel,
    required this.repportProvider,
    required this.device,
    required this.focusNode,
  }) : super(key: key);

  final void Function(Device p1) onSelectRepportResumeModel;
  final RepportProvider repportProvider;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        onSelectRepportResumeModel(device);
        repportProvider.selectedDevice = device;
        repportProvider.selectAllDevices = false;
        if (repportProvider.selectedRepport.index ==
            repportProvider.repportsType.first.index) {
          repportProvider.selectedRepport =
              repportProvider.repportsType.elementAt(1);
        }

        focusNode.unfocus();
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: Text(
          device.description,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
