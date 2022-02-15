import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/firebase_messaging_service.dart';
import '../../../utils/functions.dart';
import '../../../utils/styles.dart';
import '../../../widgets/buttons/main_button.dart';
import '../../../widgets/inputs/auto_search_all.dart';
import '../../login/login_as/save_account_provider.dart';
import '../../navigation/top_app_bar.dart';
import '../widgets/build_label.dart';
import 'oil_change_view_provider.dart';

class OilChangeAertView extends StatelessWidget {
  const OilChangeAertView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<FirebaseMessagingService,
            OilChangeAlertProvider>(
        create: (_) => OilChangeAlertProvider(),
        lazy: false,
        update: (_, messaging, provider) {
          return OilChangeAlertProvider(messaging);
        },
        builder: (context, __) {
          OilChangeAlertProvider provider =
              Provider.of<OilChangeAlertProvider>(context);
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
                const SizedBox(height: 5),
                AutoSearchWithAllWidget(
                  withoutAll: true,
                  clearTextController: provider.auto.clear,
                  controller: provider.auto.controller,
                  handleSelectDevice: provider.auto.handleSelectDevice,
                  initController: provider.auto.initController,
                  onClickAll: provider.auto.onClickAll,
                  onSelectDevice: provider.auto.onTapDevice,
                  width: MediaQuery.of(context).size.width * 0.99,
                ),
                const SizedBox(height: 10),
                if (provider.auto.deviceID != 'all')
                  const _BuildDeviceSetting(),
              ],
            ),
          );
        });
  }

  Widget _buildStatusLabel(BuildContext context) {
    OilChangeAlertProvider provider =
        Provider.of<OilChangeAlertProvider>(context, listen: false);
    var droit = Provider.of<SavedAcountProvider>(context, listen: false)
        .userDroits
        .droits[4];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Notification statut:'),
        Switch(value: provider.globalIsActive, onChanged: provider.updateGlobaleState),
      ],
    );
  }
}

class _BuildDeviceSetting extends StatelessWidget {
  const _BuildDeviceSetting({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    OilChangeAlertProvider provider =
        Provider.of<OilChangeAlertProvider>(context);
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppConsts.mainColor,)
      ),
      child: Form(
        key: provider.formKey,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Statut'),
                Switch(value: provider.isActive, onChanged: provider.onChanged),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Prochaine vidange(Km)'),
                const SizedBox(width: 10),
                _BuilTextField(
                  hint: 'Ex: 4000',
                  controller: provider.nextOilChangeController,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Alert avant(Km)'),
                const SizedBox(width: 10),
                _BuilTextField(
                  hint: 'Ex: 500',
                  controller: provider.alertBeforController,
                ),
              ],
            ),
            const SizedBox(height: 20),
            MainButton(
              onPressed: provider.save,
              label: 'Enregister',
            ),
          ],
        ),
      ),
    );
  }
}

class _BuilTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  const _BuilTextField({
    Key? key,
    this.hint = '',
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: SizedBox(
        width: 150,
        child: TextFormField(
          controller: controller,
          validator: FormValidatorService.isNotEmpty,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.send,
          textAlignVertical: TextAlignVertical.top,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            border: const OutlineInputBorder(
              borderSide: BorderSide(
                width: 1.6,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
