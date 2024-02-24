import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../services/firebase_messaging_service.dart';
import '../../../utils/styles.dart';
import '../../login/login_as/save_account_provider.dart';
import '../../navigation/top_app_bar.dart';
import '../alert_widgets/shwo_all_device_widget.dart';
import '../widgets/build_label.dart';
import 'battery_provider.dart';

class BatteryAlertView extends StatelessWidget {
  const BatteryAlertView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<FirebaseMessagingService,
            BatteryProvider>(
        create: (_) => BatteryProvider(),
        lazy: false,
        update: (_, messaging, provider) {
          return BatteryProvider(m: messaging);
        },
        builder: (context, __) {
          BatteryProvider provider = Provider.of<BatteryProvider>(context);
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
                        label: 'Alimentation boitier',
                        icon: FontAwesomeIcons.plug,
                      ),
                      const SizedBox(height: 20),
                      _buildStatusLabel(provider, context),
                      const SizedBox(height: 20),
                      ShowAllDevicesWidget(
                        onSaveDevices: provider.onSave,
                        selectedDevices:
                            provider.batteryNotifcationSetting?.selectedDevices ?? [],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  _buildStatusLabel(BatteryProvider provider, BuildContext context) {
    var droit = Provider.of<SavedAcountProvider>(context, listen: false)
        .userDroits
        .droits[4];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Notification statut:'),
        Switch(
            value: provider.active,
            onChanged: droit.write ? provider.onSwitchTaped : null),
      ],
    );
  }
}
