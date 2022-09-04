import 'package:flutter/material.dart';
import '../buttons/main_button.dart';
import 'time_input.dart';

class TimeRangeWigdet extends StatelessWidget {
  final dynamic provider;
  final void Function()? onSave;
  final void Function()? onRestaure;
  final bool Function()? onSaveAndClose;
  final bool restaure;

  const TimeRangeWigdet(
      {Key? key,
      required this.provider,
       this.onSave,
      this.onRestaure,
      this.restaure = true,
      this.onSaveAndClose})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Text('De', style: Theme.of(context).textTheme.button),
              Text('à', style: Theme.of(context).textTheme.button),
            ]),
            const SizedBox(height: 15),
            Row(
              children: [
                TimeInput(
                  dateTime: provider.selectedTimeFrom,
                  isDateFrom: true,
                  provider: provider,
                ),
                const SizedBox(width: 16),
                TimeInput(
                  dateTime: provider.selectedTimeTo,
                  isDateFrom: false,
                  provider: provider,
                ),
              ],
            ),
            const SizedBox(height: 4),
            MainButton(
              height: 40,
              onPressed: () {
                if (onSave != null) {
                  onSave!();
                } 
                if (onSaveAndClose != null) {
                  bool res = onSaveAndClose!();
                  if (res) Navigator.pop(context);
                }
              },
              label: 'Enregistrer',
            ),
            const SizedBox(height: 2),
            if (restaure)
              MainButton(
                height: 40,
                onPressed: onRestaure!,
                label: "Restaurer l'heure",
              ),
          ],
        ),
      ),
    );
  }
}
