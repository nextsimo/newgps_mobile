import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loadmore/loadmore.dart';
import 'package:provider/provider.dart';

import '../../../models/repports_details_model.dart';
import '../../../services/newgps_service.dart';
import '../../../utils/functions.dart';
import '../../../utils/styles.dart';
import '../../../widgets/empty_data.dart';
import '../clickable_text_cell.dart';
import '../custom_devider.dart';
import '../rapport_provider.dart';
import '../text_cell.dart';
import 'repport_details_provider.dart';

class RepportDetailsView extends StatelessWidget {
  const RepportDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RepportDetailsProvider>(
      create: (_) => RepportDetailsProvider(
          Provider.of<RepportProvider>(context, listen: false)),
      builder: (context, __) {
        RepportProvider provider = Provider.of<RepportProvider>(context);
        RepportDetailsProvider repportDetailsProvider =
            Provider.of<RepportDetailsProvider>(context, listen: false);
        repportDetailsProvider.fetchRepportModel(
            deviceId: deviceProvider.selectedDevice!.deviceId,
            newDateFrom: provider.dateFrom,
            newDateTo: provider.dateTo);
        return Material(
          child: SafeArea(
            right: false,
            top: false,
            bottom: false,
            child: Column(
              children: [
                const _BuildHead(),
                Expanded(
                  child: Consumer2<RepportDetailsProvider, RepportProvider>(
                      builder: (context, __, ___, ____) {
                    if (repportDetailsProvider.repportDetailsPaginateModel
                        .repportsDetailsModel.isEmpty) {
                      return SizedBox(
                        height: 180.h,
                        child: const Center(child: EmptyData()),
                      );
                    }
                    return LoadMore(
                      isFinish: repportDetailsProvider
                              .repportDetailsPaginateModel.currentPage >
                          repportDetailsProvider
                              .repportDetailsPaginateModel.lastPage,
                      textBuilder: (status) {
                        return "";
                      },
                      onLoadMore: () async {
                        await repportDetailsProvider.fetchMoreRepportModel(
                            provider,
                            deviceId: provider.selectedDevice.deviceId);

                        return true;
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 160),
                        physics: const ClampingScrollPhysics(),
                        itemCount: repportDetailsProvider
                            .repportDetailsPaginateModel
                            .repportsDetailsModel
                            .length,
                        itemBuilder: (_, int index) {
                          return _RepportRow(
                            repport: repportDetailsProvider
                                .repportDetailsPaginateModel
                                .repportsDetailsModel
                                .elementAt(index),
                          );
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BuildHead extends StatelessWidget {
  const _BuildHead();

  @override
  Widget build(BuildContext context) {
    RepportDetailsProvider repportDetailsProvider =
        Provider.of<RepportDetailsProvider>(context);
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
            flex: 2,
            index: 0,
            ontap: repportDetailsProvider.onTap,
            isSlected: 0 == repportDetailsProvider.selectedIndex,
            isUp: repportDetailsProvider.up,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Heure',
            flex: 2,
            index: 1,
            ontap: repportDetailsProvider.onTap,
            isSlected: 1 == repportDetailsProvider.selectedIndex,
            isUp: repportDetailsProvider.up,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Adresse',
            flex: 8,
            index: 2,
            ontap: repportDetailsProvider.onTap,
            isSlected: 2 == repportDetailsProvider.selectedIndex,
            isUp: repportDetailsProvider.up,
          ),
          const BuildDivider(),
          const BuildClickableTextCell(
            'LAT',
            flex: 1,
            index: 2,
          ),
          const BuildDivider(),
          const BuildClickableTextCell(
            'LONG',
            flex: 1,
            index: 2,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Statut',
            flex: 2,
            ontap: repportDetailsProvider.onTap,
            index: 3,
            isSlected: 3 == repportDetailsProvider.selectedIndex,
            isUp: repportDetailsProvider.up,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Vitesse',
            flex: 2,
            index: 4,
            ontap: repportDetailsProvider.onTap,
            isSlected: 4 == repportDetailsProvider.selectedIndex,
            isUp: repportDetailsProvider.up,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Km actuel',
            flex: 2,
            index: 5,
            ontap: repportDetailsProvider.onTap,
            isSlected: 5 == repportDetailsProvider.selectedIndex,
            isUp: repportDetailsProvider.up,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Niveau carburant (L)',
            flex: 2,
            index: 6,
            ontap: repportDetailsProvider.onTap,
            isSlected: 6 == repportDetailsProvider.selectedIndex,
            isUp: repportDetailsProvider.up,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Niveau carburant (%)',
            flex: 2,
            index: 7,
            ontap: repportDetailsProvider.onTap,
            isSlected: 7 == repportDetailsProvider.selectedIndex,
            isUp: repportDetailsProvider.up,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Total carburant (L)',
            flex: 2,
            index: 8,
            ontap: repportDetailsProvider.onTap,
            isSlected: 8 == repportDetailsProvider.selectedIndex,
            isUp: repportDetailsProvider.up,
          ),
          const BuildDivider(),
        ],
      ),
    );
  }
}

class _RepportRow extends StatelessWidget {
  const _RepportRow({
    required this.repport,
  });

  final RepportsDetailsModel repport;

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
          BuildTextCell(formatSimpleDate(repport.timestamp), flex: 2),
          const BuildDivider(),
          BuildTextCell(formatToTime(repport.timestamp), flex: 2),
          const BuildDivider(),
          BuildTextCell(repport.address, flex: 8),
          const BuildDivider(),
          BuildTextCell(repport.latitude.toString(), flex: 1),
          const BuildDivider(),
          BuildTextCell(repport.longitude.toString(), flex: 1),
          const BuildDivider(),
          BuildTextCell(repport.statut, flex: 2),
          const BuildDivider(),
          BuildTextCell('${repport.speedKph}', flex: 2),
          const BuildDivider(),
          BuildTextCell('${repport.odometerKM}', flex: 2),
          const BuildDivider(),
          BuildTextCell('${repport.fuelRemain}', flex: 2),
          const BuildDivider(),
          BuildTextCell('${repport.fuelLevel}', flex: 2),
          const BuildDivider(),
          BuildTextCell('${repport.fuelTotal}', flex: 2),
          const BuildDivider(),
        ],
      ),
    );
  }
}
