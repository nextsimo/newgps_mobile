import 'package:flutter/material.dart';
import '../../services/device_provider.dart';
import '../../utils/styles.dart';
import 'last_position_provider.dart';
import '../../widgets/buttons/appele_condcuteur_button.dart';
import '../../widgets/buttons/main_button.dart';
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
      return Column(
        children: [
          AppelCondicteurButton(
            device: deviceProvider.selectedDevice,
            callNewData: () async {
              await provider
                  .fetchDevice(deviceProvider.selectedDevice?.deviceId ?? '');
            },
          ),
        ],
      );
    }
    return Column(children: [
      Consumer<LastPositionProvider>(
        builder: (_, provider, __) {
          return MainButton(
            borderColor: AppConsts.mainColor,
            height: _isPortrait ? 30 : 25,
            width: 112,
            textColor: provider.markersProvider.showCluster
                ? AppConsts.mainColor
                : Colors.white,
            backgroundColor: provider.markersProvider.showCluster
                ? Colors.white
                : AppConsts.mainColor,
            onPressed: () {
              provider
                  .onClickRegoupement(!provider.markersProvider.showCluster);
            },
            label: 'Regrouper',
          );
        },
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
    ]);
  }
}
