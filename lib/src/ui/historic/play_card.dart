import 'package:flutter/material.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/ui/historic/historic_provider.dart';
import 'package:newgps/src/ui/historic/speed_status_histo.dart';
import 'package:provider/provider.dart';

class PlayCard extends StatelessWidget {
  const PlayCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HistoricProvider provider = Provider.of<HistoricProvider>(context);
    Device? device = provider.selectedPlayData;
    bool _isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    DeviceProvider deviceProvider =
        Provider.of<DeviceProvider>(context, listen: false);
    if (device == null) return const SizedBox();
    return Align(
      alignment:_isPortrait ? Alignment.bottomCenter :  Alignment.bottomLeft,
      child: SafeArea(
        child: Container(
          width: 340,
          margin: const EdgeInsets.all(AppConsts.outsidePadding),
          padding: const EdgeInsets.all(AppConsts.outsidePadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpeedStatusHisto(),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  deviceProvider.selectedDevice?.description ?? '',
                  style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ),
              const SizedBox(height: 13),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildIconLabel(
                          icon: Icons.car_repair,
                          label: device.statut,
                          title: 'Etat'),
                      const SizedBox(height: 10),
                      _buildIconLabel(
                          icon: Icons.date_range,
                          label: formatDeviceDate(device.dateTime),
                          title: 'Date'),
                    ],
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 1.5,
                      color: Colors.grey[300],
                      height: 40),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildIconLabel(
                          icon: Icons.speed,
                          label: '${device.speedKph} Km/h',
                          title: 'Vitesse'),
                      const SizedBox(height: 10),
                      _buildIconLabel(
                          icon: Icons.wysiwyg_sharp,
                          label: '${device.odometerKm.toInt()} Km/h',
                          title: 'Odometer'),
                    ],
                  ),
                ],
              ),
            ],
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 1.8,
                color: AppConsts.mainColor,
              )),
        ),
      ),
    );
  }

  Widget _buildIconLabel(
      {required String label, required IconData icon, required String title}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: AppConsts.mainColor,
          size: 15,
        ),
        const SizedBox(width: 6),
        Text(
          '$title:',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
        ),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
