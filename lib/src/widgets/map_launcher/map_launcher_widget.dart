import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:newgps/src/ui/last_position/last_position_provider.dart';
import 'package:provider/provider.dart';

import '../../models/device.dart';

void openMapsSheet(BuildContext context, Device device,
    [bool secondPop = true]) async {
  try {
    final destination = Coords(device.latitude, device.longitude);
    final availableMaps = await MapLauncher.installedMaps;

    // ignore: use_build_context_synchronously
    showModalBottomSheet(
      // ignore: use_build_context_synchronously
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        final provider = context.read<LastPositionProvider>();
        return SafeArea(
          child: SingleChildScrollView(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  onTap: () {
                    provider.buildRoutes();
                    Navigator.pop(context);
                    if (secondPop) {
                      Navigator.pop(context);
                    }
                  },
                  title: const Text('NEW GPS'),
                  leading: Image.asset(
                    'assets/50.png',
                    height: 30.0,
                    width: 30.0,
                  ),
                ),
                for (var map in availableMaps)
                  ListTile(
                    onTap: () => map.showDirections(destination: destination),
                    title: Text(map.mapName.toUpperCase()),
                    leading: SvgPicture.asset(
                      map.icon,
                      height: 30.0,
                      width: 30.0,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}
