import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/firebase_messaging_service.dart';
import '../../../navigation/top_app_bar.dart';
import '../../widgets/build_label.dart';
import '../logic/temperature_provider.dart';
import 'base_form_list_view.dart';

class TemperatureBleView extends StatelessWidget {
  const TemperatureBleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<FirebaseMessagingService,
            TemperatureBleProvider>(
        create: (context) => TemperatureBleProvider(),
        update: (context, firebaseMessagingService, __) {
          return TemperatureBleProvider(firebaseMessagingService);
        },
        builder: (context, snapshot) {
          return const Scaffold(
            resizeToAvoidBottomInset: false,
/*             extendBodyBehindAppBar: true,
            extendBody: true, */
            appBar: CustomAppBar(
              actions: [CloseButton(color: Colors.black)],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  BuildLabel(
                    icon: Icons.thermostat,
                    label: 'température',
                  ),
                  SizedBox(height: 10),
                  _BuildState(),
                  SizedBox(height: 10),
                  BaseFormListView(),
                ],
              ),
            ),
          );
        });
  }
}

// components

class _BuildState extends StatelessWidget {
  const _BuildState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TemperatureBleProvider provider = context.read<TemperatureBleProvider>();

    return Selector<TemperatureBleProvider, bool>(
        selector: (context, temperatureBleProvider) =>
            temperatureBleProvider.globaleNotificationEnabled,
        builder: (context, globaleNotificationEnabled, _) {
          return SwitchListTile(
            title: const Text('Notification statut:'),
            value: globaleNotificationEnabled,
            onChanged: provider.updateGlobaleNotificationEnabled,
          );
        });
  }
}
