import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'last_temp/last_temp_icon.dart';
import 'package:provider/provider.dart';
import '../../services/device_provider.dart';
import '../../utils/styles.dart';
import '../../widgets/buttons/log_out_button.dart';
import '../../widgets/buttons/main_button.dart';
import '../../widgets/buttons/retate_icon_map.dart';
import '../../widgets/buttons/zoom_button.dart';
import '../../widgets/loading_icon.dart';
import '../../widgets/map_type_widget.dart';
import '../auto_search/auto_search_with_all.dart';
import '../navigation/top_app_bar.dart';
import 'card_info.dart';
import 'date_widget.dart';
import 'grouped_buttons.dart';
import 'last_position_provider.dart';
import 'lastposition_map_view.dart';
import 'suivi/suivi_widget.dart';

class LastPositionView extends StatefulWidget {
  const LastPositionView({Key? key}) : super(key: key);

  @override
  State<LastPositionView> createState() => _LastPositionViewState();
}

class _LastPositionViewState extends State<LastPositionView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (!mounted) return;
    if (state == AppLifecycleState.resumed) {
      LastPositionProvider provider =
          Provider.of<LastPositionProvider>(context, listen: false);
      provider.mapController?.setMapStyle("[]");
    }
  }

  @override
  Widget build(BuildContext context) {
    final LastPositionProvider lastPositionProvider =
        Provider.of<LastPositionProvider>(context, listen: false);
    final DeviceProvider deviceProvider =
        Provider.of<DeviceProvider>(context, listen: false);
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        onTap: lastPositionProvider.handleSelectDevice,
        actions: [
          const LoadingIcon(),
          RotateIconMap(normalview: lastPositionProvider.normaleView),
          MapTypeWidget(onChange: (mapType) {
            deviceProvider.mapType = mapType;
          }),
          const LastTempIcon(),
        ],
      ),
      body: Stack(
        children: [
          const LastpositionMap(),
          const CardInfoView(),
          const DateWidget(),
          Positioned(
            left: 5,
            top: 103.r.h,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SuiviWidget(),
                Selector<LastPositionProvider, GoogleMapController?>(
                  builder: (_, c, __) {
                    if (c == null) return const SizedBox();
                    return MapZoomWidget(controller: c);
                  },
                  selector: (_, p) => p.mapController,
                ),
              ],
            ),
          ),
          Positioned(
            top: 74.r.h,
            right: isPortrait ? AppConsts.outsidePadding : 11.5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const LogoutButton(),
                SizedBox(height: 5.h),
                const GroupedButton(),
                const SizedBox(height: 5),
                Selector<LastPositionProvider, bool>(
                  builder: (_, bool clicked, __) {
                    return MainButton(
                      borderColor: AppConsts.mainColor,
                      height: isPortrait ? 30 : 25,
                      width: 112,
                      textColor: clicked ? AppConsts.mainColor : Colors.white,
                      backgroundColor:
                          clicked ? Colors.white : AppConsts.mainColor,
                      onPressed: () {
                        lastPositionProvider.ontraficClicked(!clicked);
                      },
                      label: 'Trafic',
                    );
                  },
                  selector: (_, p) => p.traficClicked,
                ),
                const SizedBox(height: 5),
                Selector<LastPositionProvider, bool>(
                  builder: (_, bool clicked, __) {
                    return MainButton(
                      borderColor: AppConsts.mainColor,
                      height: isPortrait ? 30 : 25,
                      width: 112,
                      textColor: clicked ? AppConsts.mainColor : Colors.white,
                      backgroundColor:
                          clicked ? Colors.white : AppConsts.mainColor,
                      onPressed: () {
                        lastPositionProvider.fetch(context);
                        lastPositionProvider.showGeozone =
                            !lastPositionProvider.showGeozone;
                      },
                      label: 'Geozone',
                    );
                  },
                  selector: (_, p) => p.showGeozone,
                ),
              ],
            ),
          ),
          Positioned(
            top: 72.r.h,
            child: const AutoSearchDeviceWithAll(),
          ),
        ],
      ),
    );
  }
}
