import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../parking_alert_provider.dart';

class DaysWidget extends StatelessWidget {
  const DaysWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // read provider
    final provider = context.read<ParkingAlertProvider>();
    List<int> showDays = context.select<ParkingAlertProvider, List<int>>(
        (ParkingAlertProvider provider) => provider.showDays);
    if (showDays.isEmpty) return const SizedBox();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // label
          Text(
            'Selectionner les jours',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 10),
          Selector<ParkingAlertProvider, List<int>>(
            builder: (context, selectedDays, _) {
              return Wrap(
                spacing: 5,
                runSpacing: 0,
                children: provider.showDays.map<Widget>((index) {
                  bool isSelected = provider.isDaySelected(index);
                  return GestureDetector(
                    onTap: () => provider.toggleDay(index),
                    child: Chip(
                      elevation: isSelected ? 0 : 5,
                      backgroundColor: isSelected ? Colors.green : Colors.white,
                      label: SizedBox(
                        width: 60,
                        child: Text(
                          provider.getDayName(index),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
            selector: (p0, p1) => p1.selectedDays,
          ),
        ],
      ),
    );
  }
}
