import 'package:flutter/material.dart';
import 'package:newgps/src/services/firebase_messaging_service.dart';
import 'package:newgps/src/ui/alert/alert_widgets/shwo_all_device_widget.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/ui/navigation/top_app_bar.dart';
import 'package:provider/provider.dart';
import '../widgets/build_label.dart';
import 'towing_provider.dart';

class TowingView extends StatelessWidget {
  const TowingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<FirebaseMessagingService,
            TowingProvider>(
        create: (_) => TowingProvider(),
        lazy: false,
        update: (_, messaging, provider) {
          return TowingProvider(messaging);
        },
        builder: (context, __) {
          TowingProvider provider = Provider.of<TowingProvider>(context);
          return Scaffold(
            appBar: const CustomAppBar(
              actions: [CloseButton(color: Colors.black)],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Padding(
                  padding: const EdgeInsets.all(AppConsts.outsidePadding),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const BuildLabel(
                          label: 'Dépannage', icon: Icons.car_repair_sharp),
                      const SizedBox(height: 20),
                      if (provider.towingAlertSetting != null)
                        _buildStatusLabel(context, provider),
                      const SizedBox(height: 20),
                      if (provider.towingAlertSetting != null)
                        ShowAllDevicesWidget(
                          onSaveDevices: provider.onSelectedDevice,
                          selectedDevices:
                              provider.towingAlertSetting!.selectedDevices,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  _buildStatusLabel(BuildContext context, TowingProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Notification statut:'),
        Switch(
            value: provider.towingAlertSetting!.isActive,
            onChanged: provider.updateState),
      ],
    );
  }
}
