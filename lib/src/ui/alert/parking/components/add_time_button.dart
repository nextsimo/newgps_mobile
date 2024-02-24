import 'package:flutter/material.dart';
import '../../../../utils/styles.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/buttons/main_button.dart';
import '../parking_alert_provider.dart';

class AddTimeButton extends StatelessWidget {
  const AddTimeButton({super.key});

  @override
  Widget build(BuildContext context) {
    // read provider
    final provider = context.read<ParkingAlertProvider>();
    context.select((ParkingAlertProvider p) => p.selectedDays);
    context.select((ParkingAlertProvider p) => p.showDays);
    if (provider.showDays.isEmpty) return const SizedBox();
    bool buttonWork = provider.isAtLeastOneDaySelected();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: MainButton(
        label: "Ajouter plage d'horaire",
        backgroundColor: buttonWork ? AppConsts.mainColor : Colors.blueGrey,
        onPressed: () => provider.toggleTimeSlot(context),
      ),
    );
  }
}
