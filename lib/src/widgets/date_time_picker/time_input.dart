import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/styles.dart';
import 'date_map_picker.dart';


class TimeInput extends StatelessWidget {
  final DateTime dateTime;
  final bool isDateFrom;
  final dynamic provider;

  const TimeInput(
      {super.key,
      required this.dateTime,
      required this.isDateFrom,
      required this.provider});

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
              provider: provider,
              isHour: true,
              controller: TextEditingController(
                text: converTo2Digit(dateTime.hour),
              ),
            ),
            const Text(':'),
            _BuildInput(
              maxNumber: 59,
              isDateFrom: isDateFrom,
              provider: provider,
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
  final dynamic provider;

  const _BuildInput(
      {required this.controller,
      required this.isDateFrom,
      required this.isHour,
      this.maxNumber = 59,
      required this.provider});

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
    return Expanded(
      child: TextField(
        maxLines: 1,
        focusNode: _focusNode,
        controller: widget.controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineMedium,
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
              widget.provider.selectedTimeFrom = DateTime(
                widget.provider.selectedTimeFrom.year,
                widget.provider.selectedTimeFrom.month,
                widget.provider.selectedTimeFrom.day,
                int.parse(val),
                widget.provider.selectedTimeFrom.minute,
                widget.provider.selectedTimeFrom.second,
              );
            } else {
              widget.provider.selectedTimeFrom = DateTime(
                widget.provider.selectedTimeFrom.year,
                widget.provider.selectedTimeFrom.month,
                widget.provider.selectedTimeFrom.day,
                widget.provider.selectedTimeFrom.hour,
                int.parse(val),
                widget.provider.selectedTimeFrom.second,
              );
            }
          } else {
            if (widget.isHour) {
              widget.provider.selectedTimeTo = DateTime(
                widget.provider.selectedTimeTo.year,
                widget.provider.selectedTimeTo.month,
                widget.provider.selectedTimeTo.day,
                int.parse(val),
                widget.provider.selectedTimeTo.minute,
                widget.provider.selectedTimeTo.second,
              );
            } else {
              widget.provider.selectedTimeTo = DateTime(
                widget.provider.selectedTimeTo.year,
                widget.provider.selectedTimeTo.month,
                widget.provider.selectedTimeTo.day,
                widget.provider.selectedTimeTo.hour,
                int.parse(val),
                widget.provider.selectedTimeTo.second,
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
