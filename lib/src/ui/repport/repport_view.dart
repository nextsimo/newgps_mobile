import 'dart:io';

import 'package:flutter/material.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/ui/driver_phone/driver_phone_provider.dart';
import 'package:newgps/src/utils/locator.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/ui/historic/historic_provider.dart';
import 'package:newgps/src/ui/last_position/last_position_provider.dart';
import 'package:newgps/src/ui/navigation/top_app_bar.dart';
import 'package:newgps/src/ui/repport/details/repport_detials.dart';
import 'package:newgps/src/ui/repport/rapport_provider.dart';
import 'package:newgps/src/widgets/buttons/audio_widget.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:newgps/src/widgets/date_time_picker/date_map_picker.dart';
import 'package:newgps/src/widgets/date_time_picker/time_range_widget.dart';
import 'package:provider/provider.dart';
import 'auto_search_repport_type.dart';
import 'fuel/fuel_repport_view.dart';
import 'repport_auto_search.dart';
import 'resume/resume_repport.dart';
import 'trips/trips_view.dart';

class RepportView extends StatelessWidget {
  const RepportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeviceProvider deviceProvider =
        Provider.of<DeviceProvider>(context, listen: false);

    return ChangeNotifierProvider<RepportProvider>(
      create: (_) => RepportProvider(deviceProvider.devices),
      builder: (BuildContext context, Widget? child) {
        return child ?? const SizedBox();
      },
      child: const RepportDataView(),
    );
  }
}

class RepportDataView extends StatelessWidget {
  const RepportDataView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RepportProvider repportProvider = Provider.of<RepportProvider>(context);
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      appBar: const CustomAppBar(),
      body:
          _BuildBody(repportProvider: repportProvider, isPortrait: isPortrait),
    );
  }
}

class _BuildBody extends StatelessWidget {
  const _BuildBody({
    Key? key,
    required this.repportProvider,
    required this.isPortrait,
  }) : super(key: key);

  final RepportProvider repportProvider;
  final bool isPortrait;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InteractiveViewer(
      minScale: 0.1,
      maxScale: 4.0,
      boundaryMargin: const EdgeInsets.all(50),
      constrained: false,
      child: SizedBox(
        height: size.height,
        width:  repportProvider.selectedRepport.index !=0 ? ( Platform.isAndroid ? 870  : 915): 810,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BuildHead(
                repportProvider: repportProvider, isPortrait: isPortrait),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConsts.outsidePadding),
                child: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, __) {
                    switch (repportProvider.selectedRepport.index) {
                      case 0:
                        return const ResumeRepport();
                      case 1:
                        return const RepportDetailsView();
                      case 2:
                        return const FuelRepportView();
                      case 3:
                        return const TripsView();
                      default:
                        return const Material();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BuildHead extends StatelessWidget {
  const _BuildHead({
    Key? key,
    required this.repportProvider,
    required this.isPortrait,
  }) : super(key: key);

  final RepportProvider repportProvider;
  final bool isPortrait;

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.zero,
      child: SafeArea(
        top: false,
        bottom: false,
        right: false,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            child: Row(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 5),
                    const AutoSearchField(),
                    const AutoSearchType(),
                    //if (repportProvider.selectedRepport.index != 0)
                      DateTimePicker(
                        width: 220,
                        dateFrom: repportProvider.dateFrom,
                        dateTo: repportProvider.dateTo,
                        onTapDateFrom: () =>
                            repportProvider.updateDateFrom(context),
                        onTapDateTo: () =>
                            repportProvider.updateDateTo(context),
                        onTapTime: () {
                          showDialog(
                            context: context,
                            builder: (_) => Dialog(
                              child: TimeRangeWigdet(
                                provider: repportProvider,
                                onRestaure: () =>
                                    repportProvider.restaureTime(context),
                                onSave: () =>
                                    repportProvider.updateTime(context),
                              ),
                            ),
                          );
                        },
                      ),
                    if (repportProvider.selectedRepport.index != 0)
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: MainButton(
                          width: 70,
                          height: 24,
                          onPressed: () {
                            locator<DriverPhoneProvider>().checkPhoneDriver(
                                context: context,
                                device: repportProvider.selectedDevice,
                                callNewData: () async {
                                  await deviceProvider.fetchDevice();
                                  repportProvider.selectedDevice =
                                      deviceProvider.selectedDevice;
                                });
                          },
                          label: 'Conducteur',
                          icon: Icons.call,
                          fontSize: 8,
                        ),
                      ),
                    const SizedBox(width: 6),
                    MainButton(
                      width: 70,
                      onPressed: () =>
                          repportProvider.downloadDocument(context),
                      label: 'Télécharger',
                      height: 24,
                      fontSize: 10,
                    ),
                    const SizedBox(width: 10),
                    if( repportProvider.selectedRepport.index == 0 )
                    Selector<RepportProvider, bool>(
                      builder: (_, bool isFetching, __) {
                        String message = isFetching ? 'Arrêter' : 'Démarrer';
                        return MainButton(
                          width: 120,
                          height: 24,
                          fontSize: 10,
                          borderColor:  isFetching ?  Colors.red : Colors.green,
                          textColor: isFetching ? Colors.white : Colors.green,
                          backgroundColor: isFetching ? Colors.red : Colors.white,
                          onPressed: () => repportProvider.isFetching =
                              !repportProvider.isFetching,
                          label: "$message l'actualisation",
                        );
                      },
                      selector: (_, p) => p.isFetching,
                    ),
                  ],
                ),
                if (repportProvider.selectedRepport.index == 0)
                  SizedBox(
                      width: isPortrait
                          ? 120
                          : Platform.isAndroid
                              ? 120
                              : 75),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const VolumeWidget(),
                    MainButton(
                      height: 24,
                      onPressed: () {
                        try {
                          LastPositionProvider lastPositionProvider =
                              Provider.of(context, listen: false);
                          HistoricProvider historicProvider =
                              Provider.of(context, listen: false);
                          lastPositionProvider.fresh();
                          historicProvider.fresh();
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/login', (_) => false);
                      },
                      label: 'Déconnexion',
                      backgroundColor: Colors.red,
                      width: 112,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
