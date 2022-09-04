import 'package:flutter/material.dart';
import '../parking_alert_provider.dart';
import 'package:provider/provider.dart';

class StatusAlertWidget extends StatelessWidget {
  const StatusAlertWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ParkingAlertProvider>();
    bool isActive = context
        .select<ParkingAlertProvider, bool>((provider) => provider.isActive);
    return SwitchListTile(
      value: isActive,
      onChanged: provider.setIsActive,
      title: const Text('Statut'),
    );
  }
}
