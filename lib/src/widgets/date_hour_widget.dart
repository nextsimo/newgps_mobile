import 'package:flutter/material.dart';
import '../ui/historic/date_map_picker/time_range_widget.dart';
import '../utils/functions.dart';
import '../utils/styles.dart';
import '../ui/historic/historic_provider.dart';
import 'package:provider/provider.dart';

class DateHourWidget extends StatefulWidget {
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
  State<DateHourWidget> createState() => _DateHourWidgetState();
}

class _DateHourWidgetState extends State<DateHourWidget> {
  DateTime _dateFrom = DateTime.now();
  DateTime _dateTo = DateTime.now();

  @override
  void initState() {
    _dateFrom = widget.dateFrom;
    _dateTo = widget.dateTo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    HistoricProvider historicProvider =
        Provider.of<HistoricProvider>(context, listen: false);
    Orientation orientation = MediaQuery.of(context).orientation;
    return InkWell(
      onTap: widget.ontap,
      child: SafeArea(
        bottom: false,
        top: false,
        right: false,
        child: Container(
          height: orientation == Orientation.portrait ? 35 : 30,
          width: widget.width,
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
                      initialDate: _dateFrom,
                      firstDate: DateTime(now.year - 30),
                      lastDate: now,
                    );
                    widget.onSelectDate?.call(datetime);
                    if (widget.fetchData) {
                      // ignore: use_build_context_synchronously
                      historicProvider.updateDate(context, datetime);
                    }
                    if (datetime == null) {
                      return;
                    }
                    _dateFrom = DateTime(
                      datetime.year,
                      datetime.month,
                      datetime.day,
                      _dateFrom.hour,
                      _dateFrom.minute,
                      _dateFrom.second,
                    );

                    _dateTo = DateTime(
                      datetime.year,
                      datetime.month,
                      datetime.day,
                      _dateTo.hour,
                      _dateTo.minute,
                      _dateTo.second,
                    );
                    setState(() {});
                  },
                  child: Center(
                    child: Text(
                      formatDeviceDate(_dateFrom, false),
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
                  onTap: () async {
                    if (widget.fetchData) {
                      await historicProvider.updateTimeRange(context);
                    } else {
                      await showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          child: TimeRangeWigdet(
                            dateFrom: _dateFrom,
                            dateTo: _dateTo,
                          ),
                        ),
                      );
                    }
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            formatToSimpleTime(historicProvider.dateFrom),
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
                            formatToSimpleTime(historicProvider.dateTo),
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
