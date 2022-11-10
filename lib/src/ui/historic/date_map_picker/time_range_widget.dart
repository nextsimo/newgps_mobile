import 'package:flutter/material.dart';
import '../../../utils/styles.dart';
import 'time_input.dart';
import '../historic_provider.dart';
import '../../../widgets/buttons/main_button.dart';
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
        borderRadius: BorderRadius.circular(AppConsts.mainradius),
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
              provider.fetchHistorics(context,1, true);
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
              provider.fetchHistorics(context, 1, true);
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
