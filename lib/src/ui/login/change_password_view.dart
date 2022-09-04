import 'package:flutter/material.dart';
import '../../utils/device_size.dart';
import '../../utils/functions.dart';
import '../../utils/styles.dart';
import 'login_provider.dart';
import '../../widgets/buttons/main_button.dart';
import '../../widgets/inputs/main_input.dart';
import '../../widgets/inputs/password_input.dart';
import 'package:provider/provider.dart';

class ChangePasswordView extends StatelessWidget {
  final BuildContext context;
  const ChangePasswordView({Key? key, required this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginProvider model = Provider.of<LoginProvider>(context, listen: false);
    return Container(
      width: DeviceSize.width * 0.3,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConsts.mainradius),
      ),
      child: Form(
        key: model.updateFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Change votre mot de passe',
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 22),
            MainInput(
              icon: Icons.folder,
              controller: model.compteController,
              validator: FormValidatorService.isNotEmpty,
              onEditeComplete: () {},
              hint: 'Compte',
            ),
            const SizedBox(height: 15),
            PasswordInput(
                icon: Icons.lock,
                controller: model.passwordController,
                validator: FormValidatorService.isNotEmpty,
                onEditeComplete: () {},
                hint: 'Ancien mot de passe'),
            const SizedBox(height: 15),
            PasswordInput(
                icon: Icons.lock,
                controller: model.newPasswordController,
                validator: FormValidatorService.isNotEmpty,
                onEditeComplete: () {},
                hint: 'Nouveau mot de passe'),
            const SizedBox(height: 22),
            MainButton(
                onPressed: () => model.updatePassword(context),
                label: 'Mettre à jour'),
          ],
        ),
      ),
    );
  }
}
