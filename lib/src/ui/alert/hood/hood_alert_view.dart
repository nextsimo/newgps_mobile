import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../services/firebase_messaging_service.dart';
import '../../../utils/styles.dart';
import '../../navigation/top_app_bar.dart';
import 'package:provider/provider.dart';
import '../alert_widgets/shwo_all_device_widget.dart';
import '../widgets/build_label.dart';
import 'hood_alert_view_provider.dart';

class HoodAlertView extends StatelessWidget {
  const HoodAlertView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<FirebaseMessagingService,
            HoodAlertViewProvider>(
        create: (_) => HoodAlertViewProvider(),
        lazy: false,
        update: (_, messaging, provider) {
          return HoodAlertViewProvider(messaging);
        },
        builder: (context, __) {
          HoodAlertViewProvider provider =
              Provider.of<HoodAlertViewProvider>(context);
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
                          label: 'capot', icon: FontAwesomeIcons.carBurst),
                      const SizedBox(height: 20),
                      if (provider.hoodAlertSettings != null)
                        _buildStatusLabel(context, provider),
                      const SizedBox(height: 10),
                      if (provider.hoodAlertSettings != null)
                        ShowAllDevicesWidget(
                          onSaveDevices: provider.onSelectedDevice,
                          selectedDevices:
                              provider.hoodAlertSettings?.selectedDevices ?? [],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  _buildStatusLabel(BuildContext context, HoodAlertViewProvider provider) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Notification statut:'),
        Switch(
            value: provider.hoodAlertSettings!.isActive,
            onChanged: provider.updateState),
      ],
    );
  }
}
