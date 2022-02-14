import 'package:flutter/material.dart';
import 'package:newgps/src/ui/alert/oil_change/oil_change_view_provider.dart';
import 'package:provider/provider.dart';

import '../../../widgets/inputs/auto_search_all.dart';
import '../../login/login_as/save_account_provider.dart';
import '../../navigation/top_app_bar.dart';
import '../widgets/build_label.dart';

class OilChangeAertView extends StatelessWidget {
  const OilChangeAertView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OilChangeAlertProvider>(
        create: (_) => OilChangeAlertProvider(),
        builder: (context, __) {
          OilChangeAlertProvider provider = Provider.of<OilChangeAlertProvider>(context,listen: false);
          return Scaffold(
            appBar: const CustomAppBar(
              actions: [CloseButton(color: Colors.black)],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const BuildLabel(
                    label: 'Vidange', icon: Icons.verified_user_rounded),
                const SizedBox(height: 10),
                _buildStatusLabel(context),
                const SizedBox(height: 10),
                AutoSearchWithAllWidget(
                  withoutAll: true,
                  clearTextController: provider.auto.clear,
                  controller: provider.auto.controller,
                  handleSelectDevice: provider.auto.handleSelectDevice,
                  initController: provider.auto.initController,
                  onClickAll: provider.auto.onClickAll,
                  onSelectDevice: provider.auto.onTapDevice,
                  width: MediaQuery.of(context).size.width *0.99,
                ),
              ],
            ),
          );
        });
  }

  Widget _buildStatusLabel(BuildContext context) {
    var droit = Provider.of<SavedAcountProvider>(context, listen: false)
        .userDroits
        .droits[4];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Notification statut:'),
        Switch(value: true, onChanged: (_) {}),
      ],
    );
  }
}
