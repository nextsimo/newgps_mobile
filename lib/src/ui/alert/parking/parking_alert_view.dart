import 'package:flutter/material.dart';
import 'package:newgps/src/ui/alert/parking/components/time_slot_list_view.dart';
import 'package:newgps/src/ui/alert/parking/parking_alert_provider.dart';
import 'package:provider/provider.dart';

import '../../navigation/top_app_bar.dart';
import '../widgets/build_label.dart';
import 'components/add_time_button.dart';
import 'components/days_widget.dart';
import 'components/status_widget.dart';

class ParkingAlertView extends StatelessWidget {
  const ParkingAlertView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ParkingAlertProvider>(
        create: (_) => ParkingAlertProvider(),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: const CustomAppBar(
              actions: [CloseButton(color: Colors.black)],
            ),
            body: SafeArea(
              right: false,
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Column(
                      children: const [
                        SizedBox(height: 10),
                        BuildLabel(
                          label: 'parking no autorisé',
                          icon: Icons.car_crash,
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const StatusAlertWidget(),
                  const SizedBox(height: 10),
                  const DaysWidget(),
                  const SizedBox(height: 10),
                  const AddTimeButton(),
                  const TimeSlotView(),
                ],
              ),
            ),
          );
        });
  }
}
