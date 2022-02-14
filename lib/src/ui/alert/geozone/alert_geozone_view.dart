import 'package:flutter/material.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/ui/alert/widgets/build_label.dart';
import 'package:newgps/src/ui/navigation/top_app_bar.dart';

class AlertGeozoneView extends StatelessWidget {
  const AlertGeozoneView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        actions: [CloseButton(color: Colors.black)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConsts.outsidePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const BuildLabel(
                label: 'Geozone', icon: Icons.battery_charging_full_outlined),
            const SizedBox(height: 20),
            _buildStatusLabel(),
            const SizedBox(height: 20),
            const Text('Selectioné une geozone:'),
            const SizedBox(height: 15),
            SizedBox(
              height: 200,
              child: ListView.separated(
                itemCount: 19,
                shrinkWrap: true,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, int index) {
                  return Container(
                    width: 230,
                    color: Colors.red,
                    child: Center(child: Text('$index')),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text('Historique:'),
            const SizedBox(height: 15),
            Expanded(
              child: GridView.builder(
                itemCount: 20,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  mainAxisExtent: 200,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (_, int index) {
                  return const HistoALertGeozoneCard();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusLabel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Notification statut:'),
        Switch(value: true, onChanged: (_) {}),
      ],
    );
  }
}

class HistoALertGeozoneCard extends StatelessWidget {
  const HistoALertGeozoneCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConsts.mainradius),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0, 15),
              blurRadius: 12),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text('Véhicule:'),
              SizedBox(width: 10),
              Text('Omaar FMB1212',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 14),
          RichText(
              text: const TextSpan(
                  style: TextStyle(color: Colors.black),
                  text: 'Est sortie de geozone ',
                  children: [
                TextSpan(
                  text: 'Bueno car',
                  style: TextStyle(
                    color: AppConsts.mainColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ])),
          const SizedBox(height: 14),
          Row(
            children: const [
              Text('Date:'),
              SizedBox(width: 10),
              Text('22/10/2022 10:10:10',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Adresse:'),
              SizedBox(width: 10),
              Expanded(
                child: Text('Casablanca Bourgoune Mosque hassane 2',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
