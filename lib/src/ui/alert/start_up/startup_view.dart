import 'package:flutter/material.dart';
import 'package:newgps/src/services/firebase_messaging_service.dart';
import 'package:newgps/src/ui/alert/alert_widgets/shwo_all_device_widget.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/ui/login/login_as/save_account_provider.dart';
import 'package:newgps/src/ui/navigation/top_app_bar.dart';
import 'package:provider/provider.dart';
import '../widgets/build_label.dart';
import 'startup_provider.dart';

class StartupView extends StatelessWidget {
  const StartupView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<FirebaseMessagingService,
            StartupProvider>(
        create: (_) => StartupProvider(),
        lazy: false,
        update: (_, messaging, provider) {
          return StartupProvider(messaging);
        },
        builder: (context, __) {
          StartupProvider provider = Provider.of<StartupProvider>(context);
          return Scaffold(
            extendBody: false,
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
                          label: 'démarrage', icon: Icons.dangerous),
                      const SizedBox(height: 20),
                      if (provider.startupAlertSetting != null)
                        _buildStatusLabel(context, provider),
                      const SizedBox(height: 20),
                      ShowAllDevicesWidget(
                        onSaveDevices: provider.onSave,
                        selectedDevices:
                            provider.startupAlertSetting?.selectedDevices ?? [],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  _buildStatusLabel(BuildContext context, StartupProvider provider) {
    var droit = Provider.of<SavedAcountProvider>(context, listen: false)
        .userDroits
        .droits[4];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Notification statut:'),
        Switch(
            value: provider.startupAlertSetting!.isActive,
            onChanged: provider.updateState),
      ],
    );
  }
}
