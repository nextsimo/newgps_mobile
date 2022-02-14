import 'package:flutter/material.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/ui/last_position/last_position_provider.dart';
import 'package:newgps/src/widgets/buttons/appele_condcuteur_button.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:provider/provider.dart';

class GroupedButton extends StatelessWidget {
  const GroupedButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LastPositionProvider provider =
        Provider.of<LastPositionProvider>(context, listen: false);
    DeviceProvider deviceProvider =
        Provider.of<DeviceProvider>(context, listen: false);
    bool _isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    bool fetchGroupes = context.select<LastPositionProvider, bool>(
        (p) => p.markersProvider.fetchGroupesDevices);
    if (!fetchGroupes) {
      return Positioned(
        top: 40,
        right: _isPortrait ? AppConsts.outsidePadding : 11.5,
        child: Column(
          children: [
            AppelCondicteurButton(
              device: deviceProvider.selectedDevice,
              callNewData: () async {
                await provider
                    .fetchDevice(deviceProvider.selectedDevice.deviceId);
              },
            ),
          ],
        ),
      );
    }
    return Positioned(
      right: _isPortrait ? AppConsts.outsidePadding : 10,
      top: _isPortrait ? 42 : 39,
      child: Column(children: [
        Selector<LastPositionProvider, bool>(
          builder: (_, bool clicked, __) {
            return MainButton(
              borderColor: AppConsts.mainColor,
              height: _isPortrait ? 30 : 25,
              width: 112,
              textColor: clicked ? AppConsts.mainColor : Colors.white,
              backgroundColor: clicked ? Colors.white : AppConsts.mainColor,
              onPressed: () {
                provider.onClickRegoupement(!clicked);
              },
              label: 'Regrouper',
            );
          },
          selector: (_, p) => p.regrouperClicked,
        ),
        const SizedBox(height: 5),
        Selector<LastPositionProvider, bool>(
          builder: (_, bool clicked, __) {
            return MainButton(
              borderColor: AppConsts.mainColor,
              height: _isPortrait ? 30 : 25,
              width: 112,
              textColor: clicked ? AppConsts.mainColor : Colors.white,
              backgroundColor: clicked ? Colors.white : AppConsts.mainColor,
              onPressed: () {
                provider.onClickMatricule(!clicked);
              },
              label: 'Matricule',
            );
          },
          selector: (_, p) => p.matriculeClicked,
        ),
        const SizedBox(height: 5),
        Selector<LastPositionProvider, bool>(
          builder: (_, bool clicked, __) {
            return MainButton(
              borderColor: AppConsts.mainColor,
              height: _isPortrait ? 30 : 25,
              width: 112,
              textColor: clicked ? AppConsts.mainColor : Colors.white,
              backgroundColor: clicked ? Colors.white : AppConsts.mainColor,
              onPressed: () {
                provider.ontraficClicked(!clicked);
              },
              label: 'Trafic',
            );
          },
          selector: (_, p) => p.traficClicked,
        ),
      ]),
    );
  }
}
