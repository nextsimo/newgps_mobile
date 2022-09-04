import 'package:flutter/material.dart';
import '../../utils/styles.dart';
import 'rapport_provider.dart';
import 'repport_type_model.dart';
import 'package:provider/provider.dart';

class AutoSearchType extends StatefulWidget {
  const AutoSearchType({Key? key}) : super(key: key);

  @override
  State<AutoSearchType> createState() => _AutoSearchTypeState();
}

class _AutoSearchTypeState extends State<AutoSearchType> {
  late FocusNode _focusNode;

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConsts.mainradius),
      borderSide: const BorderSide(
        color: AppConsts.mainColor,
        width: AppConsts.borderWidth,
      ),
    );
    final RepportProvider repportProvider =
        Provider.of<RepportProvider>(context, listen: false);
    context.select<RepportProvider, RepportTypeModel>((p) => p.selectedRepport);
    return GestureDetector(
      onTap: () => repportProvider.handleRepportType(),
      child: Container(
        color: Colors.transparent,
        alignment: Alignment.topLeft,
        child: Container(
          width: 140,
          margin: const EdgeInsets.all(AppConsts.outsidePadding),
          child: Autocomplete<RepportTypeModel>(
            initialValue: const TextEditingValue(text: 'Rapport résumer'),
            fieldViewBuilder: (BuildContext context, TextEditingController _,
                FocusNode focusNode, Function onFieldSubmitted) {
                  _focusNode = focusNode;
              repportProvider.repportTextController = _;
              repportProvider.handleRepportType();
              return fieldViewBuilderWidget(repportProvider, outlineInputBorder,
                  _focusNode, onFieldSubmitted, context);
            },
            displayStringForOption: (d) => d.title,
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return repportProvider.repportsType;
              }
              return repportProvider.repportsType.where(
                (repportModel) {
                  return repportModel.title
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                },
              );
            },
            optionsViewBuilder: (BuildContext context,
                void Function(RepportTypeModel repportTypeModel) deviceFunc,
                repportsType) {
              return OptionViewBuilderWidget(
                focusNode: _focusNode,
                repports: repportsType.toList(),
                onSelectDevice: deviceFunc,
                repportProvider: repportProvider,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget fieldViewBuilderWidget(
      RepportProvider repportProvider,
      OutlineInputBorder outlineInputBorder,
      FocusNode focusNode,
      Function onFieldSubmitted,
      BuildContext context) {
    return SizedBox(
      height: 24,
      child: TextFormField(
        textAlign: TextAlign.left,
        style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w600),
        textAlignVertical: TextAlignVertical.center,
        showCursor: true,
        textInputAction: TextInputAction.done,
        scrollPadding: EdgeInsets.zero,
        maxLines: 1,
        onTap: () async {
          repportProvider.repportTextController.text = '';
          repportProvider.handleSelectDevice();
        },
        onFieldSubmitted: (_) => repportProvider.handleRepportType(),
        decoration: InputDecoration(
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.fromLTRB(10, 14, 10, 0),
          filled: true,
          suffixIcon: const Icon(Icons.arrow_drop_down, size: 15),
          suffixIconConstraints: const BoxConstraints(),
          border: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          enabledBorder: outlineInputBorder,
        ),
        controller: repportProvider.repportTextController,
        focusNode: focusNode,
      ),
    );
  }
}

class OptionViewBuilderWidget extends StatelessWidget {
  final List<RepportTypeModel> repports;
  final void Function(RepportTypeModel) onSelectDevice;
  final RepportProvider repportProvider;
  final FocusNode focusNode;

  const OptionViewBuilderWidget({
    Key? key,
    required this.repports,
    required this.onSelectDevice,
    required this.repportProvider, required this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double bottom = MediaQuery.of(context).viewInsets.bottom;
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        focusNode.unfocus();
        repportProvider.handleRepportType();
      },
      child: Material(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            width: 140,
            margin: const EdgeInsets.only(top: 8),
            constraints: BoxConstraints(
              maxHeight: _isPortrait
                  ? (size.height * 0.44)
                  : (bottom == 0.0 ? size.height * 0.5 : bottom * 0.34),
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: AppConsts.mainColor, width: AppConsts.borderWidth),
                borderRadius: BorderRadius.circular(AppConsts.mainradius)),
            child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: repports.map<Widget>((repport) {
                  return OptionItem(
                    focusNode: focusNode,
                    onSelectDevice: onSelectDevice,
                    repportProvider: repportProvider,
                    repportTypeModel: repport,
                  );
                }).toList()),
          ),
        ),
      ),
    );
  }
}

class OptionItem extends StatelessWidget {
  final RepportTypeModel repportTypeModel;
  final FocusNode focusNode;
  const OptionItem({
    Key? key,
    required this.onSelectDevice,
    required this.repportProvider,
    required this.repportTypeModel,required this.focusNode,
  }) : super(key: key);

  final void Function(RepportTypeModel p1) onSelectDevice;
  final RepportProvider repportProvider;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onSelectDevice(repportTypeModel);
        repportProvider.selectedRepport = repportTypeModel;
        focusNode.unfocus();
        if (repportTypeModel.index == 0 && !repportProvider.selectAllDevices) {
          repportProvider.selectAllDevices = true;
          repportProvider.handleSelectDevice();
        } else if (repportTypeModel.index != 0 && repportTypeModel.index != 4 &&
            repportProvider.selectAllDevices) {
          repportProvider.selectedDevice = repportProvider.devices.first;
          repportProvider.selectAllDevices = false;
          repportProvider.handleSelectDevice();
        }
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
        child: Text(
          repportTypeModel.title,
          maxLines: 1,
          style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
