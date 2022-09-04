import 'package:flutter/material.dart';
import '../rapport_provider.dart';
import '../../../utils/functions.dart';
import '../../../widgets/buttons/main_button.dart';
import 'package:provider/provider.dart';

import '../../../utils/styles.dart';
import '../../connected_device/connected_device_model.dart';
import '../clickable_text_cell.dart';
import '../custom_devider.dart';
import '../text_cell.dart';
import 'connexion_view_provider.dart';

class ConnexionRepportView extends StatelessWidget {
  const ConnexionRepportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ConnexionViewProvider>(
        create: (_) => ConnexionViewProvider(
            Provider.of<RepportProvider>(context, listen: false)),
        builder: (context, __) {
          Provider.of<RepportProvider>(context);
          ConnexionViewProvider connexionViewProvider =
              Provider.of(context, listen: false);
          connexionViewProvider.fetchConnectedDevices();
          return Material(
            child: SafeArea(
              right: false,
              bottom: false,
              top: false,
              child: Column(
                children: [
                  const _BuildHead(),
                  Consumer<ConnexionViewProvider>(builder: (context, pro, __) {
                    return Expanded(
                      child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        itemCount: pro.devices.length,
                        itemBuilder: (_, int index) {
                          return _RepportRow(
                            device: pro.devices.elementAt(index),
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        });
  }
}

class _BuildHead extends StatelessWidget {
  const _BuildHead({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
              ConnexionViewProvider provider =
              Provider.of(context);
    var borderSide = const BorderSide(
        color: AppConsts.mainColor, width: AppConsts.borderWidth);
    return Container(
      decoration: BoxDecoration(
        color: AppConsts.mainColor.withOpacity(0.2),
        border: Border(bottom: borderSide, top: borderSide),
      ),
      child: Row(
        children: [
          const BuildDivider(),
          BuildClickableTextCell(
            "Marque de l'appreil",
            ontap: provider.orderByClick,
            isSlected: 1 == provider.selectedIndex,
            isUp: provider.up,
            index: 1,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Platforme',
            ontap: provider.orderByClick,
            isSlected: 2 == provider.selectedIndex,
            isUp: provider.up,
            index: 2,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Date',
            ontap: provider.orderByClick,
            isSlected: 3 == provider.selectedIndex,
            isUp: provider.up,
            index: 3,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Statut',
            ontap: provider.orderByClick,
            isSlected: 4 == provider.selectedIndex,
            isUp: provider.up,
            index: 4,
          ),
          const BuildDivider(),
        ],
      ),
    );
  }
}

class _RepportRow extends StatelessWidget {
  final ConnectedDeviceModel device;
  const _RepportRow({
    Key? key,
    required this.device,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppConsts.mainColor,
            width: AppConsts.borderWidth,
          ),
        ),
      ),
      child: Row(
        children: [
          const BuildDivider(),
          BuildTextCell(device.deviceBrand),
          const BuildDivider(),
          BuildTextCell("${device.platform} ${device.os}"),
          const BuildDivider(),
          BuildTextCell(device.connectedState
              ? formatDeviceDate(device.lastConnectedDate)
              : formatDeviceDate(device.lastLogoutDate)),
          const BuildDivider(),
          Expanded(
            child: Center(
              child: MainButton(
                width: 80,
                height: 15,
                fontSize: 10,
                backgroundColor:
                    device.connectedState ? Colors.green : Colors.red,
                onPressed: () {},
                label: device.connectedState ? 'Connecté' : 'Déconnecté',
              ),
            ),
          ),
          const BuildDivider(),
        ],
      ),
    );
  }
}
