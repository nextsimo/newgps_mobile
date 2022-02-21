import 'package:flutter/material.dart';
import 'package:newgps/src/models/user_droits.dart';
import 'package:newgps/src/services/firebase_messaging_service.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/ui/login/login_as/save_account_provider.dart';
import 'package:newgps/src/ui/navigation/top_app_bar.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:provider/provider.dart';
import '../alert_widgets/shwo_all_device_widget.dart';
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
                const CustomAppBar(actions: [CloseButton(color: Color.fromRGBO(0, 0, 0, 1))]),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Padding(
                    padding: const EdgeInsets.all(AppConsts.outsidePadding),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Notification statut'),
                            Switch(value: true, onChanged: (_) {}),
                          ],
                        ),
                        MainButton(
                          onPressed: () {},
                          label: 'Ajouter vitesse',
                          icon: Icons.add,
                        ),
                        SizedBox(height: 15),
                        _BuildVitesseRow(),
                        _BuildVitesseRow(),
                        _BuildVitesseRow(),
/*                         Row(
                          children: [
                            _buildInput(provider, readOnly: !droit.write),
                            const SizedBox(width: 10),
                            Switch(
                                value: provider.active,
                                onChanged:
                                    droit.write ? provider.onTapSwitch : null),
                          ],
                        ), */

/*                         Row(
                          children: [
                            _buildInput(provider, readOnly: !droit.write),
                            const SizedBox(width: 10),
                            Switch(
                                value: provider.active,
                                onChanged:
                                    droit.write ? provider.onTapSwitch : null),
                          ],
                        ),
                        const SizedBox(height: 20),
                        if (droit.write)
                          MainButton(
                            width: 210,
                            backgroundColor: provider.active
                                ? AppConsts.mainColor
                                : Colors.blueGrey,
                            onPressed: provider.onTapSaved,
                            label: 'Enregistrer',
                          ), */
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
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

class _BuildVitesseRow extends StatelessWidget {
  const _BuildVitesseRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const _BuildTextField(),
        ShowAllDevicesWidget(
          onSaveDevices: (_) async {},
          selectedDevices: [],
          shortText: true,
        ),
        MainButton(
            onPressed: () {}, label: 'Enregister', width: 100, height: 40),
        Container(
          margin: const EdgeInsets.all(10),
          width: 30,
          height: 30,
          decoration:
              const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
          child: const Center(
            child: Icon(Icons.remove, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _BuildTextField extends StatelessWidget {
  const _BuildTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: AppConsts.mainColor),
    );
    return const SizedBox(
      width: 90,
      height: 40,
      child: TextField(
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.send,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            labelText: 'Vitesse km/h',
            labelStyle: TextStyle(
                fontSize: 11, color: Colors.black, fontWeight: FontWeight.w400),
            border: outlineInputBorder,
            focusedBorder: outlineInputBorder,
            enabledBorder: outlineInputBorder),
      ),
    );
  }
}
