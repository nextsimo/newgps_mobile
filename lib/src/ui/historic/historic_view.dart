import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newgps/src/ui/historic/parking/parking_provider.dart';
import 'package:provider/provider.dart';
import '../../models/device.dart';
import '../../services/device_provider.dart';
import '../../utils/styles.dart';
import '../../widgets/buttons/appele_condcuteur_button.dart';
import '../../widgets/buttons/log_out_button.dart';
import '../../widgets/buttons/retate_icon_map.dart';
import '../../widgets/date_hour_widget.dart';
import '../../widgets/map_type_widget.dart';
import '../auto_search/auto_search.dart';
import '../last_position/card_info.dart';
import '../navigation/top_app_bar.dart';
import 'historic_provider.dart';
import 'histroric_map_view.dart';
import 'parking/parking_button.dart';
import 'play_card.dart';

class HistoricViews extends StatelessWidget {
  const HistoricViews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HistoricProvider provider =
        Provider.of<HistoricProvider>(context, listen: false);
    DeviceProvider deviceProvider =
        Provider.of<DeviceProvider>(context, listen: false);
    provider.init(context);
    provider.initTimeRange();
    return ChangeNotifierProvider<ParkingProvider>(
        create: (_) => ParkingProvider(),
        builder: (context, snapshot) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            extendBodyBehindAppBar: true,
            appBar: CustomAppBar(
              onTap: deviceProvider.handleSelectDevice,
              actions: [
                InkWell(
                  onTap: provider.playHistoric,
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: Consumer<HistoricProvider>(
                      builder: (_, provider, __) {
                        if (provider.loading) {
                          return const Center(
                            child: SizedBox(
                              width: 15,
                              height: 15,
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppConsts.mainColor),
                                ),
                              ),
                            ),
                          );
                        }
                        return Icon(
                          provider.historicIsPlayed
                              ? Icons.stop_circle_outlined
                              : Icons.play_circle_outline_outlined,
                          color: Colors.black,
                        );
                      },
                    ),
                  ),
                ),
                RotateIconMap(normalview: provider.normaleView),
                MapTypeWidget(onChange: (mapType) {
                  deviceProvider.mapType = mapType;
                }),
              ],
            ),
            body: Stack(
              children: [
                const HistoricMapView(),
                Selector<HistoricProvider, bool>(
                    selector: (_, p) => p.historicIsPlayed,
                    builder: (_, bool isPlayed, ___) {
                      if (!isPlayed) return const SizedBox();
                      return const PlayCard();
                    }),
                  Positioned(
                    top: 72.r.h,
                    child: Selector<HistoricProvider, bool>(
                      selector: (_, p) => p.historicIsPlayed,
                      builder: (_, bool isPlayed, ___) {
                        if (isPlayed) return const SizedBox();
                        return AutoSearchDevice(
                          onSelectDeviceFromOtherView: (Device device) async =>
                              provider.fetchHistorics(context,device, 1, true),
                        );
                      },
                    ),
                  ),
                Positioned(
                  top: 75.r.h,
                  right: 0,
                  child: const LogoutButton(),
                ),
                Builder(builder: (context) {
                  bool isPortrait = MediaQuery.of(context).orientation ==
                      Orientation.portrait;
                  return Positioned(
                    right: isPortrait ? AppConsts.outsidePadding : 11,
                    top: 105.r.h,
                    child: AppelCondicteurButton(
                      device: deviceProvider.selectedDevice,
                      callNewData: () async {
                        await deviceProvider.fetchDevice();
                      },
                    ),
                  );
                }),
                const ParkingButton(),
                //const ShowAllMarkersButton(),
                Selector<HistoricProvider, bool>(
                    selector: (_, p) => p.historicIsPlayed,
                    builder: (_, bool isPlayed, ___) {
                      if (isPlayed) return const SizedBox();
                      return Positioned(
                        left: 4,
                        top: 103.r.h,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 1),
                            Builder(builder: (context) {
                              bool isPortrait =
                                  MediaQuery.of(context).orientation ==
                                      Orientation.portrait;
                              Size size = MediaQuery.of(context).size;
                              return DateHourWidget(
                                dateTo: provider.dateTo,
                                dateFrom: provider.dateFrom,
                                width: isPortrait
                                    ? size.width * .6
                                    : size.width * 0.35,
                              );
                            }),
                          ],
                        ),
                      );
                    }),
/*                 Positioned(
                  left: 4,
                  top: 130.r.h,
                  child: Selector<HistoricProvider, GoogleMapController?>(
                    builder: (_, c, __) {
                      if (c == null) return const SizedBox();
                      return MapZoomWidget(controller: c);
                    },
                    selector: (_, p) => p.mapController,
                  ),
                ), */
                Selector<HistoricProvider, bool>(
                    selector: (_, p) => p.historicIsPlayed,
                    builder: (_, bool isPlayed, ___) {
                      if (isPlayed) return const SizedBox();
                      return const CardInfoView();
                    }),
              ],
            ),
          );
        });
  }
}
