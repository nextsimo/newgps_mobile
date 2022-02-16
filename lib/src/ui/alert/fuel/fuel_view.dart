import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../../services/firebase_messaging_service.dart';
import '../../../utils/styles.dart';
import '../../login/login_as/save_account_provider.dart';
import '../../navigation/top_app_bar.dart';
import '../widgets/build_label.dart';
import 'fuel_provider.dart';

class FuelAlertView extends StatelessWidget {
  const FuelAlertView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<FirebaseMessagingService, FuelProvider>(
        create: (_) => FuelProvider(),
        lazy: false,
        update: (_, messaging, provider) {
          return FuelProvider(m: messaging);
        },
        builder: (context, __) {
          FuelProvider provider = Provider.of<FuelProvider>(context);
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
                          label: 'carburant', icon: Icons.ev_station_rounded),
                      const SizedBox(height: 20),
                      _buildStatusLabel(provider, context),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }


  _buildStatusLabel(FuelProvider provider, BuildContext context) {
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