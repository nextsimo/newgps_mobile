import 'package:flutter/material.dart';

class DateTimeRangePicker extends StatefulWidget {
  final DateTimeRange initialDateRange;
  final void Function(DateTimeRange)? onConfirm;
  const DateTimeRangePicker({
    super.key,
    this.onConfirm,
    required this.initialDateRange,
  });

  @override
  State<DateTimeRangePicker> createState() => _DateTimeRangePickerState();
}

class _DateTimeRangePickerState extends State<DateTimeRangePicker> {
  late DateTimeRange _dateTimeRange;

  @override
  void initState() {
    super.initState();
    _dateTimeRange = widget.initialDateRange;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final DateTimeRange? range = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2015),
          lastDate: DateTime.now().add(const Duration(days: 1)),
          initialDateRange: _dateTimeRange,
          helpText: "Sélectionnez une plage de dates maximale de 3 jours",
          locale: const Locale("fr"),
        );
        if (range != null) {
          //  date range must be less than or equal to 3 days
          if (range.end.difference(range.start).inDays > 3) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    "La plage de dates doit être inférieure ou égale à 3 jours"),
              ),
            );
            return;
          }

          setState(() {
            _dateTimeRange = range;
          });
          widget.onConfirm?.call(_dateTimeRange);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  "${_dateTimeRange.start.day}/${_dateTimeRange.start.month}/${_dateTimeRange.start.year}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Container(
              width: 2,
              height: 20,
              decoration: const BoxDecoration(color: Colors.black),
            ),
            Expanded(
              child: Center(
                child: Text(
                  "${_dateTimeRange.end.day}/${_dateTimeRange.end.month}/${_dateTimeRange.end.year}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
