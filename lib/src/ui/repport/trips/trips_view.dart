import 'package:flutter/material.dart';
import '../../../utils/functions.dart';
import '../../../utils/styles.dart';
import '../rapport_provider.dart';
import 'trips_model.dart';
import 'package:provider/provider.dart';

import '../clickable_text_cell.dart';
import '../custom_devider.dart';
import '../text_cell.dart';
import 'trip_provider.dart';

class TripsView extends StatelessWidget {
  const TripsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TripsProvider>(
      create: (_) =>
          TripsProvider(Provider.of<RepportProvider>(context, listen: false)),
      builder: (context, __) {
        RepportProvider provider = Provider.of<RepportProvider>(context);
        TripsProvider tripsProvider =
            Provider.of<TripsProvider>(context, listen: false);
        tripsProvider.fetchTrips(provider.selectedDevice.deviceId);
        return Material(
          child: SafeArea(
            right: false,
            bottom: false,
            top: false,
            child: Column(
              children: [
                const _BuildHead(),
                Consumer<TripsProvider>(builder: (context, __, ___) {
                  return Expanded(
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      itemCount: tripsProvider.trips.length,
                      itemBuilder: (_, int index) {
                        return _RepportRow(
                            trip: tripsProvider.trips.elementAt(index));
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
    TripsProvider provider = Provider.of<TripsProvider>(context);

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
            'Date de début',
            isSlected: 0 == provider.selectedIndex,
            isUp: provider.orderByStartDate,
            ontap: provider.updateStartDateOrder,
            flex: 2,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Adresse de début',
            flex: 3,
            isSlected: 5 == provider.selectedIndex,
            isUp: provider.orderByStartAdresse,
            ontap: provider.updateByStartAdresse,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Temps conduite',
            isSlected: 2 == provider.selectedIndex,
            isUp: provider.orderByDrivingTime,
            ontap: provider.updateDrivingTimeOrder,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Date du fin',
            isSlected: 1 == provider.selectedIndex,
            isUp: provider.orderByEndDate,
            ontap: provider.updateEndDateOrder,
            flex: 2,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Adresse du fin',
            flex: 3,
            isSlected: 6 == provider.selectedIndex,
            isUp: provider.orderByEndAdresse,
            ontap: provider.updateByEndAdresse,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            "Temps d'arrêt",
            isSlected: 7 == provider.selectedIndex,
            isUp: provider.orderByStopedTime,
            ontap: provider.updateByStopedTime,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'D. parcorue(Km)',
            isSlected: 3 == provider.selectedIndex,
            isUp: provider.orderByDistance,
            ontap: provider.updateByDistance,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Kilométrage',
            isSlected: 4 == provider.selectedIndex,
            isUp: provider.odrderByOdometer,
            ontap: provider.updateByOdometer,
          ),
          const BuildDivider(),
          const _BuildHeadCard(
            label: 'Localiser',
          ),
          const BuildDivider(),
        ],
      ),
    );
  }
}

class _BuildHeadCard extends StatelessWidget {
  final String label;
  const _BuildHeadCard({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 7,
            ),
          ),
          const Icon(
            Icons.map,
            color: AppConsts.mainColor,
            size: 15,
          ),
        ],
      ),
    );
  }
}

class _RepportRow extends StatelessWidget {
  const _RepportRow({
    Key? key,
    required this.trip,
  }) : super(key: key);

  final TripsRepportModel trip;

  @override
  Widget build(BuildContext context) {
    // read provdider
    TripsProvider provider = context.read<TripsProvider>();
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
          BuildTextCell(
            formatDeviceDate(trip.startDate),
            flex: 2,
          ),
          const BuildDivider(),
          BuildTextCell(trip.startAddress, flex: 3),
          const BuildDivider(),
          BuildTextCell(trip.drivingTime),
          const BuildDivider(),
          BuildTextCell(formatDeviceDate(trip.endDate), flex: 2),
          const BuildDivider(),
          BuildTextCell(trip.endAddress, flex: 3),
          const BuildDivider(),
          BuildTextCell(trip.stopedTime),
          const BuildDivider(),
          BuildTextCell('${trip.distance}'),
          const BuildDivider(),
          BuildTextCell('${trip.odometer}'),
          const BuildDivider(),
          Expanded(
            child: InkWell(
              onTap: () => provider.navigateToRepportMap(context, trip),
              child: const CircleAvatar(
                backgroundColor: AppConsts.blue,
                radius: 9,
                child: Icon(
                  Icons.location_pin,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
          ),
          const BuildDivider(),
        ],
      ),
    );
  }
}
