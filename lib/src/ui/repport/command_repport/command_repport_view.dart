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
    return ChangeNotifierProvider<CommandTripProvider>(
      create: (_) => CommandTripProvider(
          Provider.of<RepportProvider>(context, listen: false)),
      builder: (context, __) {
        RepportProvider provider = Provider.of<RepportProvider>(context);
        CommandTripProvider commandTripProvider =
            Provider.of<CommandTripProvider>(context, listen: false);
        commandTripProvider.fetchCommands(
            provider.selectedDevice.deviceId, 'action_date');
        return Material(
          child: SafeArea(
            right: false,
            bottom: false,
            top: false,
            child: Column(
              children: [
                const _BuildHead(),
                Consumer<CommandTripProvider>(builder: (context, __, ___) {
                  return Expanded(
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      itemCount: commandTripProvider.commands.length,
                      itemBuilder: (_, int index) {
                        return _RepportRow(
                            model:
                                commandTripProvider.commands.elementAt(index));
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
        children: [
          const BuildDivider(),
          BuildClickableTextCell(
            'Description',
            ontap: (_) {},
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Date',
            ontap: (_) {},
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Description de l\'appareil',
            ontap: (_) {},
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Numéro de téléphone',
            ontap: (_) {},
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Utilisateur',
            ontap: (_) {},
          ),
          const BuildDivider(),
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
            model.actionDescription,
            flex: 2,
          ),
          const BuildDivider(),
          BuildTextCell(
            formatDeviceDate(model.actionDate),
            flex: 3,
          ),
          const BuildDivider(),
          BuildTextCell(
            model.deviceDescription,
            flex: 2,
          ),
          const BuildDivider(),
          BuildTextCell(
            model.phoneDescription,
            flex: 3,
          ),
          const BuildDivider(),
          BuildTextCell(
            model.userId,
            flex: 2,
          ),
          const BuildDivider(),
        ],
      ),
    );
  }
}
