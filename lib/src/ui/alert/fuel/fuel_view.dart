import 'package:flutter/material.dart';
import 'package:newgps/src/models/fuel_notif_historic.dart';
import 'package:newgps/src/services/firebase_messaging_service.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/ui/login/login_as/save_account_provider.dart';
import 'package:newgps/src/ui/navigation/top_app_bar.dart';
import 'package:provider/provider.dart';
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
                      const SizedBox(height: 20),
                      _buildHistoric(context, provider.historics),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget _buildHistoric(
      BuildContext context, List<FuelNotifHistoric> historics) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Historiques:'),
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
                FuelNotifHistoric historic = historics[index];
                return BuildHistoricCard(historic: historic);
              },
            ),
          ),
        ],
      ),
    );
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

class BuildHistoricCard extends StatelessWidget {
  const BuildHistoricCard({
    Key? key,
    required this.historic,
  }) : super(key: key);

  final FuelNotifHistoric historic;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      borderOnForeground: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${historic.fuelValue1 - historic.fuelValue2}L Perdu',
                  ),
                  const SizedBox(height: 9),
                  Text('Par ${historic.deviceName}')
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 1,
              color: Colors.grey[300],
              height: 60,
            ),
            Expanded(
              child: Text(
                "Dans le ${historic.date} à ${historic.address}",
                style: Theme.of(context).textTheme.caption,
              ),
            )
          ],
        ),
      ),
    );
  }
}
