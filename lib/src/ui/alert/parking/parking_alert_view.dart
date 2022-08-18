import 'package:flutter/material.dart';
import 'package:newgps/src/services/firebase_messaging_service.dart';
import 'package:newgps/src/ui/alert/parking/components/time_slot_list_view.dart';
import 'package:newgps/src/ui/alert/parking/parking_alert_provider.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
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
    return ChangeNotifierProxyProvider<FirebaseMessagingService,
            ParkingAlertProvider>(
        create: (_) => ParkingAlertProvider(),
        lazy: false,
        update: (_, messaging, provider) {
          return ParkingAlertProvider(messaging);
        },
        builder: (context, snapshot) {
          final provider = context.read<ParkingAlertProvider>();
          return Scaffold(
            appBar: const CustomAppBar(
              actions: [CloseButton(color: Colors.black)],
            ),
            resizeToAvoidBottomInset: false,
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
                          label: 'démarrage non autorisé',
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
                  // button to save all the changes
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: MainButton(
                      onPressed: provider.saveTimeSlots,
                      label: 'Enregistrer',
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          );
        });
  }
}
