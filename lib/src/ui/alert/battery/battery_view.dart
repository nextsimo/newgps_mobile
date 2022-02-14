import 'package:flutter/material.dart';
import 'package:newgps/src/models/batter_alert_historic.dart';
import 'package:newgps/src/services/firebase_messaging_service.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/ui/login/login_as/save_account_provider.dart';
import 'package:newgps/src/ui/navigation/top_app_bar.dart';
import 'package:provider/provider.dart';
import '../widgets/build_label.dart';
import 'battery_provider.dart';

class BatteryAlertView extends StatelessWidget {
  const BatteryAlertView({Key? key}) : super(key: key);

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
                          label: 'batterie',
                          icon: Icons.battery_charging_full_outlined),
                      const SizedBox(height: 20),
                      _buildStatusLabel(provider, context),
                      const SizedBox(height: 20),
                      _buildHistoric(provider.historics),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget _buildHistoric(List<BatteryNotifcationHistoric> historics) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Historiques:'),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(AppConsts.outsidePadding),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                childAspectRatio: 2.8,
                crossAxisSpacing: AppConsts.outsidePadding,
                maxCrossAxisExtent: 400,
                mainAxisSpacing: AppConsts.outsidePadding,
              ),
              itemCount: historics.length,
              itemBuilder: (_, int index) {
                BatteryNotifcationHistoric historic = historics[index];
                return BatteryHistoricCard(historic: historic);
              },
            ),
          ),
        ],
      ),
    );
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

class BatteryHistoricCard extends StatelessWidget {
  const BatteryHistoricCard({
    Key? key,
    required this.historic,
  }) : super(key: key);

  final BatteryNotifcationHistoric historic;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 330,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 8),
                blurRadius: 12,
              ),
            ]),
        child: Row(
          children: [
            Icon(
              Icons.power_settings_new_sharp,
              size: 99,
              color: historic.isBatteryDown ? Colors.red : Colors.green,
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(historic.description),
                const SizedBox(height: 4),
                Text("De: ${historic.deviceName}"),
                const SizedBox(height: 4),
                Text("à: ${historic.date}"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
