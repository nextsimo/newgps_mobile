import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../services/firebase_messaging_service.dart';
import '../alert_widgets/shwo_all_device_widget.dart';
import 'imobility_alert_provider.dart';
import '../../../utils/styles.dart';
import '../../navigation/top_app_bar.dart';
import '../../../widgets/buttons/main_button.dart';
import 'package:provider/provider.dart';
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
                        icon: FontAwesomeIcons.carSide,
                      ),
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
          child: Row(
            children: [
              SizedBox(
                width: 100,
                height: 40,
                child: TextField(
                  controller: provider.hoursController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  textAlignVertical: TextAlignVertical.top,
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
              const SizedBox(width: 10),
              MainButton(
                onPressed: () => provider.updateMaxHour(),
                label: 'Enregitrer',
                width: 90,
                height: 40,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
