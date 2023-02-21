import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../utils/styles.dart';
import '../historic_provider.dart';
import 'package:provider/provider.dart';

import 'date_map_picker.dart';

class TimeInput extends StatelessWidget {
  final DateTime dateTime;
  final bool isDateFrom;

  const TimeInput({Key? key, required this.dateTime, required this.isDateFrom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConsts.mainradius),
            border: Border.all(color: AppConsts.mainColor, width: 1.6)),
        child: Row(
          children: [
            _BuildInput(
              maxNumber: 23,
              isDateFrom: isDateFrom,
              isHour: true,
              controller: TextEditingController(
                text: converTo2Digit(dateTime.hour),
              ),
            ),
            const Text(':'),
            _BuildInput(
              maxNumber: 59,
              isDateFrom: isDateFrom,
              isHour: false,
              controller: TextEditingController(
                text: converTo2Digit(dateTime.minute),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BuildInput extends StatefulWidget {
  final TextEditingController controller;
  final bool isDateFrom;
  final bool isHour;
  final int maxNumber;

  const _BuildInput(
      {Key? key,
      required this.controller,
      required this.isDateFrom,
      required this.isHour,
      this.maxNumber = 59})
      : super(key: key);

  @override
  State<_BuildInput> createState() => _BuildInputState();
}

class _BuildInputState extends State<_BuildInput> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        widget.controller.selection = TextSelection(
            baseOffset: 0, extentOffset: widget.controller.text.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    HistoricProvider provider =
        Provider.of<HistoricProvider>(context, listen: false);
    return Expanded(
      child: TextField(
        maxLines: 1,
        focusNode: _focusNode,
        controller: widget.controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineSmall,
        inputFormatters: [LengthLimitingTextInputFormatter(2)],
        autofocus: true,
        decoration: _buidDecoration(),
        onChanged: (String val) {
          if (val.length > 1) {
            _focusNode.nextFocus();
          }
          if (int.parse(val) > widget.maxNumber) {
            widget.controller.text = widget.maxNumber.toString();
          }

          if (widget.isDateFrom) {
            if (widget.isHour) {
              provider.selectedDateFrom = DateTime(
                provider.selectedDateFrom.year,
                provider.selectedDateFrom.month,
                provider.selectedDateFrom.day,
                int.parse(val),
                provider.selectedDateFrom.minute,
                provider.selectedDateFrom.second,
              );
            } else {
              provider.selectedDateFrom = DateTime(
                provider.selectedDateFrom.year,
                provider.selectedDateFrom.month,
                provider.selectedDateFrom.day,
                provider.selectedDateFrom.hour,
                int.parse(val),
                provider.selectedDateFrom.second,
              );
            }
          } else {
            if (widget.isHour) {
              provider.selectedDateTo = DateTime(
                provider.selectedDateTo.year,
                provider.selectedDateTo.month,
                provider.selectedDateTo.day,
                int.parse(val),
                provider.selectedDateTo.minute,
                provider.selectedDateTo.second,
              );
            } else {
              provider.selectedDateTo = DateTime(
                provider.selectedDateTo.year,
                provider.selectedDateTo.month,
                provider.selectedDateTo.day,
                provider.selectedDateTo.hour,
                int.parse(val),
                provider.selectedDateTo.second,
              );
            }
          }
        },
      ),
    );
  }

  InputDecoration _buidDecoration() {
    return const InputDecoration(
      contentPadding: EdgeInsets.zero,
      border: InputBorder.none,
    );
  }
}
