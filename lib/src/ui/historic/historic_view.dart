import 'package:flutter/material.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/ui/auto_search/auto_search.dart';
import 'package:newgps/src/ui/historic/historic_provider.dart';
import 'package:newgps/src/ui/historic/histroric_map_view.dart';
import 'package:newgps/src/ui/historic/play_card.dart';
import 'package:newgps/src/ui/last_position/card_info.dart';
import 'package:newgps/src/ui/navigation/top_app_bar.dart';
import 'package:newgps/src/widgets/buttons/appele_condcuteur_button.dart';
import 'package:newgps/src/widgets/buttons/log_out_button.dart';
import 'package:newgps/src/widgets/buttons/retate_icon_map.dart';
import 'package:newgps/src/widgets/date_hour_widget.dart';
import 'package:newgps/src/widgets/map_type_widget.dart';
import 'package:provider/provider.dart';

class HistoricView extends StatelessWidget {
  const HistoricView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HistoricProvider provider =
        Provider.of<HistoricProvider>(context, listen: false);
    DeviceProvider deviceProvider =
        Provider.of<DeviceProvider>(context, listen: false);
    provider.init(context);
    provider.initTimeRange();
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          Selector<HistoricProvider, bool>(
              selector: (_, p) => p.historicIsPlayed,
              builder: (_, bool isPlayed, ___) {
                if (isPlayed) return const SizedBox();
                return AutoSearchDevice(
                  onSelectDeviceFromOtherView: (Device device) async =>
                      provider.fetchHistorics(1, true),
                );
              }),
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: LogoutButton(),
          ),
          Builder(builder: (context) {
            bool _isPortrait =
                MediaQuery.of(context).orientation == Orientation.portrait;
            return Positioned(
              right: _isPortrait ? AppConsts.outsidePadding : 11,
              top: 41,
              child: AppelCondicteurButton(
                device: deviceProvider.selectedDevice,
                callNewData: () async {
                  await deviceProvider.fetchDevice();
                },
              ),
            );
          }),
          Selector<HistoricProvider, bool>(
              selector: (_, p) => p.historicIsPlayed,
              builder: (_, bool isPlayed, ___) {
                if (isPlayed) return const SizedBox();
                return Positioned(
                  left: 4,
                  top: 39,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 1),
                      Builder(builder: (context) {
                        bool _isPortrait = MediaQuery.of(context).orientation ==
                            Orientation.portrait;
                        Size size = MediaQuery.of(context).size;
                        return DateHourWidget(
                            width: _isPortrait
                                ? size.width * .6
                                : size.width * 0.35);
                      }),
/*                       Selector<HistoricProvider, GoogleMapController?>(
                        builder: (_, c, __) {
                          if (c == null) return const SizedBox();
                          return MapZoomWidget(controller: c);
                        },
                        selector: (_, p) => p.mapController,
                      ), */
                    ],
                  ),
                );
              }),
          Selector<HistoricProvider, bool>(
              selector: (_, p) => p.historicIsPlayed,
              builder: (_, bool isPlayed, ___) {
                if (isPlayed) return const SizedBox();
                return const CardInfoView();
              }),
        ],
      ),
    );
  }
}
