import 'package:flutter/material.dart';
import 'package:newgps/src/ui/alert/speed/legal_speed_view.dart';
import '../../../models/user_droits.dart';
import '../../../services/firebase_messaging_service.dart';
import '../../../utils/styles.dart';
import '../../login/login_as/save_account_provider.dart';
import '../../navigation/top_app_bar.dart';
import '../../../widgets/buttons/main_button.dart';
import 'package:provider/provider.dart';
import 'speed_provider.dart';
import '../widgets/build_label.dart';

class SpeedAlertView extends StatelessWidget {
  const SpeedAlertView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<FirebaseMessagingService,
            SpeedAlertProvider>(
        create: (_) => SpeedAlertProvider(null),
        update: (_, messaging, provider) {
          return SpeedAlertProvider(messaging);
        },
        builder: (context, _) {
          final SpeedAlertProvider provider =
              Provider.of<SpeedAlertProvider>(context);
          Droit droit = Provider.of<SavedAcountProvider>(context, listen: false)
              .userDroits
              .droits[4];
          return Scaffold(
            appBar:
                const CustomAppBar(actions: [CloseButton(color: Colors.black)]),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Column(
                    children: [
                      _buildNordmalSpeedAlert(provider, droit),
                      const SizedBox(height: 20),
                      const LegalSpeedView(),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Container _buildNordmalSpeedAlert(SpeedAlertProvider provider, Droit droit) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const BuildLabel(
            icon: Icons.speed,
            label: 'vitesse',
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              _buildInput(provider, readOnly: !droit.write),
              const SizedBox(width: 10),
              Switch(
                  value: provider.active,
                  onChanged: droit.write ? provider.onTapSwitch : null),
            ],
          ),
          const SizedBox(height: 20),
          if (droit.write)
            MainButton(
              width: 210,
              backgroundColor:
                  provider.active ? AppConsts.mainColor : Colors.blueGrey,
              onPressed: provider.onTapSaved,
              label: 'Enregistrer',
            ),
        ],
      ),
    );
  }

  Widget _buildInput(SpeedAlertProvider provider, {bool readOnly = false}) {
    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConsts.outsidePadding),
      borderSide: const BorderSide(
          color: AppConsts.mainColor, width: AppConsts.borderWidth),
    );
    return SizedBox(
      width: 150,
      child: TextField(
        readOnly: readOnly,
        controller: provider.controller,
        autofocus: true,
        onTap: provider.onTap,
        keyboardType:
            const TextInputType.numberWithOptions(signed: true, decimal: true),
        textAlign: TextAlign.center,
        enabled: provider.active,
        decoration: InputDecoration(
          border: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          enabledBorder: outlineInputBorder,
        ),
      ),
    );
  }
}
