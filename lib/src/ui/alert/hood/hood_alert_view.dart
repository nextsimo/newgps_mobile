import 'package:flutter/material.dart';
import 'package:newgps/src/services/firebase_messaging_service.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/ui/login/login_as/save_account_provider.dart';
import 'package:newgps/src/ui/navigation/top_app_bar.dart';
import 'package:provider/provider.dart';
import '../alert_widgets/select_devices_view.dart';
import '../widgets/build_label.dart';
import 'hood_alert_view_provider.dart';

class HoodAlertView extends StatelessWidget {
  const HoodAlertView({Key? key}) : super(key: key);

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
                          label: 'capot',
                          icon: Icons.verified_user_rounded),
                      const SizedBox(height: 20),
                      if (provider.hoodAlertSettings != null)
                        _buildStatusLabel(context, provider),
                      const SizedBox(height: 10),
                      if (provider.hoodAlertSettings != null)
                        SelectDeviceUi(
                          onSelectDevice: provider.onSelectedDevice,
                          initSelectedDevice:
                              provider.hoodAlertSettings!.selectedDevices,
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
    var droit = Provider.of<SavedAcountProvider>(context, listen: false)
        .userDroits
        .droits[4];
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