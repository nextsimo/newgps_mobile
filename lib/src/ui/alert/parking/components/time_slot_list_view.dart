import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../parking_alert_provider.dart';

class TimeSlotView extends StatelessWidget {
  const TimeSlotView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // read provider
    final provider = context.read<ParkingAlertProvider>();
    context.select((ParkingAlertProvider p) => p.timeSlots);
    return Expanded(
      child: ListView.separated(
        separatorBuilder: (_, __) => const Divider(),
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 130),
        itemCount: provider.timeSlots.length,
        itemBuilder: (context, index) {
          final model = provider.timeSlots[index];
          return ListTile(
            title: Wrap(
              spacing: 1,
              runSpacing: 1,
              children: getTimeSlotsWidget(provider, model.timeSlots),
            ),
            leading: SizedBox(
              width: 70,
              child: Text(provider.getDayName(model.day)),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.add_circle_rounded),
                  onPressed: () => provider.showAddTimeRangeDialogToAddTimeSlot(
                      context, model),
                  color: Colors.green,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () =>
                      provider.showDeleteConfirmationDialog(model.day, index),
                  color: Colors.red,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> getTimeSlotsWidget(
      ParkingAlertProvider provider, List<DateTimeRange> timeSlots) {
    return timeSlots.map<Widget>((e) {
      return Chip(
        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.zero,
        label: Text(
          '${provider.getHourMinute(e.start)} - ${provider.getHourMinute(e.end)}',
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      );
    }).toList();
  }
}
