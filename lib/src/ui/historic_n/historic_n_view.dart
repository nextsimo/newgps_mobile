import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:newgps/src/ui/historic_n/historic_n_provider.dart';
import 'package:provider/provider.dart';

import '../navigation/top_app_bar.dart';
import 'buttons_group_view.dart';
import 'my_marker_layer.dart';
import 'select_group.dart';

// ignore: camel_case_types
class HistoricNView_X extends StatelessWidget {
  const HistoricNView_X({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HistoricProviderN>(
        create: (_) => HistoricProviderN(),
        lazy: false,
        builder: (context, snapshot) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            appBar: const CustomAppBar(),
            body: Stack(
              children: [
                FlutterMap(
                  options: const MapOptions(
                    initialCenter: LatLng(33.5731, -7.5898),
                    interactionOptions: InteractionOptions(
                     flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                    ),
                    initialZoom: 9,
                    maxZoom: 18,
                    minZoom: 5,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://maps.googleapis.com/maps/vt?pb=!1m4!1m3!1i{z}!2i{x}!3i{y}!2m3!1e0!2sar-MO!3i420120488!3m7!2sMaroc!2sfr!3sMA!1e68!1sfr!23i4111425!1d6949765.30025005!2d-11.64635036166239!3d31.731186528518357',
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    const MyMarkerLayer(),
                  ],
                ),
                const ButtonsGroup(),
                const SelectGroup(),
              ],
            ),
          );
        });
  }
}
