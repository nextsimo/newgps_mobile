import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:newgps/src/services/newgps_service.dart';
import '../../utils/styles.dart';
import 'main_button.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

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
  const _LogoutButtonLandscape();

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
            MainButton(
              height: 28,
              onPressed: () {
                deviceProvider.selectedTabIndex = 0;
                deviceProvider.infoModel = null;
                Phoenix.rebirth(context);

/* 
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
                connectedDeviceProvider.createNewConnectedDeviceHistoric(false);
                shared.clear('account'); */
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
  const _LogoutButtonPortrait();

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
            MainButton(
              height: 35,
              onPressed: () {
                deviceProvider.selectedTabIndex = 0;
                deviceProvider.infoModel = null;
                shared.clear('account');
                Phoenix.rebirth(context);

/*                 try {
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
                connectedDeviceProvider.createNewConnectedDeviceHistoric(false);
                shared.clear('account'); */
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
