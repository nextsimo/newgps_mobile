import 'package:flutter/material.dart';
import '../ui/historic/date_map_picker/time_range_widget.dart';
import '../utils/functions.dart';
import '../utils/styles.dart';
import '../ui/historic/historic_provider.dart';
import 'package:provider/provider.dart';

class DateHourWidget extends StatelessWidget {
  final double width;
  final DateTime dateFrom;
  final DateTime dateTo;
  final void Function()? ontap;
  final void Function(DateTime?)? onSelectDate;
  final bool fetchData;
  const DateHourWidget(
      {Key? key,
      this.width = 400.0,
      this.ontap,
      required this.dateFrom,
      this.fetchData = true,
      this.onSelectDate,
      required this.dateTo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    HistoricProvider historicProvider = Provider.of<HistoricProvider>(context);
    Orientation orientation = MediaQuery.of(context).orientation;
    return InkWell(
      onTap: ontap,
      child: SafeArea(
        bottom: false,
        top: false,
        right: false,
        child: Container(
          height: orientation == Orientation.portrait ? 35 : 30,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppConsts.mainColor, width: 1),
            borderRadius: BorderRadius.circular(AppConsts.mainradius),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () async {
                    var now = DateTime.now();

                    DateTime? datetime = await showDatePicker(
                      context: context,
                      initialDate: dateFrom,
                      firstDate: DateTime(now.year - 30),
                      lastDate: now,
                    );
                    onSelectDate?.call(datetime);
                    if (fetchData) {
                      // ignore: use_build_context_synchronously
                      historicProvider.updateDate(context, datetime);
                    }
                  },
                  child: Center(
                    child: Text(
                      formatDeviceDate(dateFrom, false),
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                width: 1,
                color: AppConsts.mainColor,
              ),
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () {
                    if (fetchData) {
                      historicProvider.updateTimeRange(context);
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) =>  Dialog(
                          child: TimeRangeWigdet(
                            dateFrom: dateFrom,
                            dateTo: dateTo,
                          ),
                        ),
                      );
                    }
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            formatToSimpleTime(dateFrom),
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      const Text(
                        'à',
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w500),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            formatToSimpleTime(dateTo),
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
