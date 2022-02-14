import 'package:flutter/material.dart';
import 'package:newgps/src/ui/connected_device/connected_device_provider.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/ui/historic/historic_provider.dart';
import 'package:newgps/src/ui/last_position/last_position_provider.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:provider/provider.dart';

import 'audio_widget.dart';

class LogoutButton extends StatelessWidget {
  final bool pop;
  const LogoutButton({Key? key, this.pop = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.portrait) {
      return const _LogoutButtonPortrait();
    }
    return const _LogoutButtonLandscape();
  }
}

class _LogoutButtonLandscape extends StatelessWidget {
  const _LogoutButtonLandscape({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            const VolumeWidget(),
            MainButton(
              height: 28,
              onPressed: () {
                try {
                  LastPositionProvider lastPositionProvider =
                      Provider.of(context, listen: false);
                  HistoricProvider historicProvider =
                      Provider.of(context, listen: false);
                  ConnectedDeviceProvider connectedDeviceProvider =
                      Provider.of(context, listen: false);
                  lastPositionProvider.fresh();
                  historicProvider.fresh();
                  connectedDeviceProvider.updateConnectedDevice(false);
                } catch (e) {
                  debugPrint(e.toString());
                }
                Navigator.of(context).pushNamed('/login');
              },
              label: 'Déconnexion',
              backgroundColor: Colors.red,
              width: 112,
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoutButtonPortrait extends StatelessWidget {
  final double height;
  const _LogoutButtonPortrait({
    Key? key,
    this.height = 35,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(right: AppConsts.outsidePadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            const VolumeWidget(),
            MainButton(
              height: height,
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
                ConnectedDeviceProvider connectedDeviceProvider =
                    Provider.of(context, listen: false);
                connectedDeviceProvider.updateConnectedDevice(false);

                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (_) => false);
              },
              label: 'Deconnexion',
              backgroundColor: Colors.red,
              width: 112,
            ),
          ],
        ),
      ),
    );
  }
}
