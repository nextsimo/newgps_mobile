import 'package:flutter/material.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/models/fuel_repport_model.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/ui/repport/fuel/fuel_repport_provider.dart';
import 'package:newgps/src/ui/repport/rapport_provider.dart';
import 'package:provider/provider.dart';

import '../clickable_text_cell.dart';
import '../custom_devider.dart';
import '../text_cell.dart';

class FuelRepportView extends StatelessWidget {
  const FuelRepportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FuelRepportProvider>(
      create: (_) => FuelRepportProvider(),
      builder: (context, __) {
        RepportProvider provider =
            Provider.of<RepportProvider>(context);
        FuelRepportProvider fuelRepportProvider =
            Provider.of<FuelRepportProvider>(context, listen: false);
        fuelRepportProvider.fetchRepportsByDate(
            provider.selectedDevice.deviceId, provider);
        context.select<RepportProvider, Device>((p) => p.selectedDevice);
        return Material(
          child: SafeArea(
            right: false,
            bottom: false,
            top: false,
            child: Column(
              children: [
                const _BuildHead(),
                Consumer<FuelRepportProvider>(builder: (context, __, ___) {
                  return Expanded(
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      itemCount: fuelRepportProvider.repports.length,
                      itemBuilder: (_, int index) {
                        return _RepportRow(
                            repport:
                                fuelRepportProvider.repports.elementAt(index));
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BuildHead extends StatelessWidget {
  const _BuildHead({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FuelRepportProvider fuelRepportProvider =
        Provider.of<FuelRepportProvider>(context);
    var borderSide = const BorderSide(
        color: AppConsts.mainColor, width: AppConsts.borderWidth);
    return Container(
      decoration: BoxDecoration(
        color: AppConsts.mainColor.withOpacity(0.2),
        border: Border(bottom: borderSide, top: borderSide),
      ),
      child: Row(
        children: [
          const BuildDivider(),
          BuildClickableTextCell(
            'Date',
            ontap: fuelRepportProvider.updateDateOrder,
            isSlected: 0 == fuelRepportProvider.selectedIndex,
            isUp: fuelRepportProvider.orderByDate,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Cons. Carburant(L)',
            ontap: fuelRepportProvider.updateFuelConsome,
            isSlected: 1 == fuelRepportProvider.selectedIndex,
            isUp: fuelRepportProvider.orderByFuelConsom,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Cons. Carburant(L/100KM)',
            ontap: fuelRepportProvider.updateFuelConsome100,
            isSlected: 2 == fuelRepportProvider.selectedIndex,
            isUp: fuelRepportProvider.orderByFuelConsome100,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Distance parcorue(Km)',
            ontap: fuelRepportProvider.updateByDistance,
            isSlected: 3 == fuelRepportProvider.selectedIndex,
            isUp: fuelRepportProvider.orderByDistance,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Km actuel',
            ontap: fuelRepportProvider.updateByDistance,
            isSlected: 4 == fuelRepportProvider.selectedIndex,
            isUp: fuelRepportProvider.orderByDistance,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Temps conduite',
            ontap: fuelRepportProvider.updateByDrivingTime,
            isSlected: 5 == fuelRepportProvider.selectedIndex,
            isUp: fuelRepportProvider.oderByDrivingTime,
          ),
          const BuildDivider(),
        ],
      ),
    );
  }
}

class _RepportRow extends StatelessWidget {
  const _RepportRow({
    Key? key,
    required this.repport,
  }) : super(key: key);

  final FuelRepportData repport;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppConsts.mainColor,
            width: AppConsts.borderWidth,
          ),
        ),
      ),
      child: Row(
        children: [
          const BuildDivider(),
          BuildTextCell(formatSimpleDate(repport.date)),
          const BuildDivider(),
          BuildTextCell('${repport.carbConsomation}'),
          const BuildDivider(),
          BuildTextCell('${repport.carbConsomation100}'),
          const BuildDivider(),
          BuildTextCell('${repport.distance}'),
          const BuildDivider(),
          BuildTextCell('${repport.odometerKM}'),
          const BuildDivider(),
          BuildTextCell(repport.drivingTime),
          const BuildDivider(),
        ],
      ),
    );
  }
}
