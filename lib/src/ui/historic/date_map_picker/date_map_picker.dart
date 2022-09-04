import 'package:flutter/material.dart';
import '../../../utils/functions.dart';
import '../../../utils/styles.dart';
import 'time_range_widget.dart';
import '../historic_provider.dart';
import 'package:provider/provider.dart';

class DateMapPicker extends StatelessWidget {
  final void Function(Map<String, dynamic> dateTime) onSelectedDate;
  const DateMapPicker({Key? key, required this.onSelectedDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 52,
      left: 11.5,
      child: DateMapPicker2(
        onSelectedDate: onSelectedDate,
        width: 100,
      ),
    );
  }
}

class DateMapPicker2 extends StatelessWidget {
  final double width;
  const DateMapPicker2({
    Key? key,
    required this.onSelectedDate,
    required this.width,
  }) : super(key: key);

  final void Function(Map<String, dynamic> dateTime) onSelectedDate;

  @override
  Widget build(BuildContext context) {
    HistoricProvider provider = Provider.of<HistoricProvider>(context);

    TimeOfDay timeFrom = TimeOfDay(
        hour: provider.dateFrom.hour, minute: provider.dateFrom.minute);
    TimeOfDay timeTo =
        TimeOfDay(hour: provider.dateTo.hour, minute: provider.dateTo.minute);
    return InkWell(
      onTap: () async {
        DateTime now = DateTime.now();

        DateTime? dateTime = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(now.year - 50),
          lastDate: DateTime.now(),
        );

        if (dateTime != null) {
          provider.dateFrom = dateTime;
          provider.dateTo = dateTime;
          onSelectedDate({
            'date': dateTime,
          });
        }
      },
      child: Container(
        width: width,
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: AppConsts.mainColor,
              width: 1.3,
            )),
        child: Center(
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    formatDeviceDate(provider.dateFrom),
                  ),
                ),
              ),
              Container(
                width: 1.3,
                height: double.infinity,
                color: AppConsts.mainColor,
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    // provider.dateTimeSavedButtonClicked = false;
                    await showDialog(
                      context: context,
                      builder: (_) => const Dialog(
                        child: TimeRangeWigdet(),
                      ),
                    );
                  },
                  child: Center(
                    child: Text(
                      ' ${converTo2Digit(timeFrom.hour)}:${converTo2Digit(timeFrom.minute)} à ${converTo2Digit(timeTo.hour)}:${converTo2Digit(timeTo.minute)}',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String converTo2Digit(int number) {
  String res = number.toString();
  if (res.length == 1) {
    return res.padLeft(2, '0');
  }
  return res;
}
