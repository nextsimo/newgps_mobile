import 'package:flutter/material.dart';
import 'package:newgps/src/ui/repport/command_repport/command_repport_model.dart';
import 'package:newgps/src/ui/repport/command_repport/command_repport_provider.dart';
import '../../../utils/functions.dart';
import '../../../utils/styles.dart';
import '../rapport_provider.dart';
import 'package:provider/provider.dart';

import '../clickable_text_cell.dart';
import '../custom_devider.dart';
import '../text_cell.dart';

class CommandRepportView extends StatelessWidget {
  const CommandRepportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CommandRepportProvider>(
      create: (_) => CommandRepportProvider(
          Provider.of<RepportProvider>(context, listen: false)),
      builder: (context, __) {
        RepportProvider provider = Provider.of<RepportProvider>(context);
        CommandRepportProvider commandRepportProvider =
            Provider.of<CommandRepportProvider>(context, listen: false);
        commandRepportProvider.fetchCommands(
          provider.selectedDevice.deviceId,
          provider.selectAllDevices,
        );
        return Material(
          child: SafeArea(
            right: false,
            bottom: false,
            top: false,
            child: Column(
              children: [
                const _BuildHead(),
                Consumer<CommandRepportProvider>(builder: (context, __, ___) {
                  return Expanded(
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      itemCount: commandRepportProvider.commands.length,
                      itemBuilder: (_, int index) {
                        return _RepportRow(
                            model: commandRepportProvider.commands
                                .elementAt(index));
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BuildHead extends StatelessWidget {
  const _BuildHead({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var borderSide = const BorderSide(
        color: AppConsts.mainColor, width: AppConsts.borderWidth);
    return Container(
      decoration: BoxDecoration(
        color: AppConsts.mainColor.withOpacity(0.2),
        border: Border(bottom: borderSide, top: borderSide),
      ),
      child: Row(
        children: const [
          BuildDivider(),
          BuildClickableTextCell(
            'Matricule',
          ),
          BuildDivider(),
          BuildClickableTextCell(
            'Description',
          ),
          BuildDivider(),
          BuildClickableTextCell(
            'Date',
          ),
          BuildDivider(),
          BuildClickableTextCell(
            'Description de l\'appareil',
          ),
          BuildDivider(),
          BuildClickableTextCell(
            'Numéro de téléphone',
          ),
          BuildDivider(),
          BuildClickableTextCell(
            'Utilisateur',
          ),
          BuildDivider(),
        ],
      ),
    );
  }
}

class _RepportRow extends StatelessWidget {
  const _RepportRow({
    Key? key,
    required this.model,
  }) : super(key: key);

  final CommandRepportModel model;

  @override
  Widget build(BuildContext context) {
    // read provdider
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
          BuildTextCell(
            model.gpsDeviceDescription,
          ),
          const BuildDivider(),
          BuildTextCell(
            model.commandeDescription,
          ),
          const BuildDivider(),
          BuildTextCell(
            formatDeviceDate(model.commandeDate),
          ),
          const BuildDivider(),
          BuildTextCell(
            model.deviceDescription,
          ),
          const BuildDivider(),
          BuildTextCell(
            model.phoneNumber,
          ),
          const BuildDivider(),
          BuildTextCell(
            model.userId,
          ),
          const BuildDivider(),
        ],
      ),
    );
  }
}
