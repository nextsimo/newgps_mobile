import 'package:flutter/material.dart';
import 'package:newgps/src/ui/historic/date_map_picker/time_input.dart';
import 'package:newgps/src/ui/historic/historic_provider.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:provider/provider.dart';

class TimeRangeWigdet extends StatelessWidget {
  const TimeRangeWigdet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HistoricProvider provider =
        Provider.of<HistoricProvider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(8),
      width: 310,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Text('De', style: Theme.of(context).textTheme.button),
            Text('à', style: Theme.of(context).textTheme.button),
          ]),
          const SizedBox(height: 8),
          Row(
            children: [
              TimeInput(dateTime: provider.dateFrom, isDateFrom: true),
              const SizedBox(width: 6),
              TimeInput(dateTime: provider.dateTo, isDateFrom: false),
            ],
          ),
          const SizedBox(height: 2),
          MainButton(
            onPressed: () {
              provider.onTimeRangeSaveClicked();
              provider.fetchHistorics(1, true);
              Navigator.of(context).pop();
              //provider.dateTimeSavedButtonClicked = true;
              //Navigator.of(context).pop();
            },
            label: 'Enregistrer',
          ),
          const SizedBox(height: 4),
          MainButton(
            onPressed: () {
              provider.onTimeRangeRestaureClicked();
              provider.fetchHistorics(1, true);
              Navigator.of(context).pop();
/*               provider.notifyDateTime();
              provider.dateTimeSavedButtonClicked = true;
              Navigator.of(context).pop(); */
            },
            label: "Restaurer l'heure",
          ),
        ],
      ),
    );
  }
}
