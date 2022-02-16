import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../services/device_provider.dart';
import '../../widgets/buttons/log_out_button.dart';
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
    WidgetsBinding.instance!.addObserver(this);
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

    lastPositionProvider.fetchInitDevice();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        onTap: lastPositionProvider.handleSelectDevice,
        actions: [
          const LoadingIcon(),
          RotateIconMap(normalview: lastPositionProvider.normaleView),
          MapTypeWidget(onChange: (mapType) {
            deviceProvider.mapType = mapType;
          }),
        ],
      ),
      body: Stack(
        children: [
          const LastpositionMap(),
          const CardInfoView(),
          const Padding(
            padding: EdgeInsets.only(top: 2.5),
            child: LogoutButton(),
          ),
          const DateWidget(),
          Positioned(
            left: 5,
            top: 40,
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
          const GroupedButton(),
          const AutoSearchDeviceWithAll(),
        ],
      ),
    );
  }
}
