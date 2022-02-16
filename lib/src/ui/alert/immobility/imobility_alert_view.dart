import 'package:flutter/material.dart';
import 'package:newgps/src/services/firebase_messaging_service.dart';
import 'package:newgps/src/ui/alert/alert_widgets/shwo_all_device_widget.dart';
import 'package:newgps/src/ui/alert/immobility/imobility_alert_provider.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/ui/login/login_as/save_account_provider.dart';
import 'package:newgps/src/ui/navigation/top_app_bar.dart';
import 'package:provider/provider.dart';
import '../alert_widgets/select_devices_view.dart';
import '../widgets/build_label.dart';

class ImobilityAlertView extends StatelessWidget {
  const ImobilityAlertView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<FirebaseMessagingService,
            ImobilityAlertViewProvider>(
        create: (_) => ImobilityAlertViewProvider(),
        lazy: false,
        update: (_, messaging, provider) {
          return ImobilityAlertViewProvider(messaging);
        },
        builder: (context, __) {
          ImobilityAlertViewProvider provider =
              Provider.of<ImobilityAlertViewProvider>(context);
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
                          label: 'imobilisation',
                          icon: Icons.verified_user_rounded),
                      const SizedBox(height: 20),
                      if (provider.imobilityAlertSettings != null)
                        _buildStatusLabel(context, provider),
                      const SizedBox(height: 10),
                      const _BuilTextFieldHour(),
                      const SizedBox(height: 10),
                      if (provider.imobilityAlertSettings != null)
                        ShowAllDevicesWidget(
                          onSaveDevices: provider.onSelectedDevice,
                          selectedDevices:
                              provider.imobilityAlertSettings!.selectedDevices,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  _buildStatusLabel(BuildContext context, ImobilityAlertViewProvider provider) {
    var droit = Provider.of<SavedAcountProvider>(context, listen: false)
        .userDroits
        .droits[4];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Notification statut:'),
        Switch(
            value: provider.imobilityAlertSettings!.isActive,
            onChanged: provider.updateState),
      ],
    );
  }
}

class _BuilTextFieldHour extends StatelessWidget {
  const _BuilTextFieldHour({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ImobilityAlertViewProvider provider =
        Provider.of<ImobilityAlertViewProvider>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Temps arrêté'),
        Padding(
          padding: const EdgeInsets.only(right: 6),
          child: SizedBox(
            width: 100,
            height: 40,
            child: TextField(
              controller: provider.hoursController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.send,
              textAlignVertical: TextAlignVertical.top,
              onSubmitted: provider.updateMaxHour,
              decoration: const InputDecoration(
                labelText: 'Heures',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.6,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
