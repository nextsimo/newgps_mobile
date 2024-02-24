import 'package:flutter/material.dart';
import 'package:newgps/src/utils/utils.dart';
import '../../utils/functions.dart';
import '../../widgets/buttons/outlined_button.dart';
import 'change_password_view.dart';
import 'login_provider.dart';
import '../../widgets/buttons/main_button.dart';
import '../../widgets/inputs/main_input.dart';
import '../../widgets/inputs/password_input.dart';
import 'package:provider/provider.dart';

import 'call_service_view.dart';
import 'login_as/login_as_view.dart';
import 'sous_user_check.dart';

class LoginPortrait extends StatelessWidget {
  final MainButton loginButton;
  const LoginPortrait({super.key, required this.loginButton});

  @override
  Widget build(BuildContext context) {
    LoginProvider provider = Provider.of<LoginProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Form(
          key: provider.formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: Utils.logoHeroTag,
                  child: Material(
                    color: Colors.transparent,
                    child: Center(
                      child: Image.asset(
                        'assets/logo-200.png',
                        width: 100,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                MainInput(
                  icon: Icons.folder,
                  hint: 'Compte',
                  controller: provider.compteController,
                  validator: FormValidatorService.isNotEmpty,
                  onEditeComplete: () => FocusScope.of(context).nextFocus(),
                ),
                const SizedBox(height: 10),
                PasswordInput(
                  icon: Icons.lock,
                  hint: 'Mot de passe',
                  controller: provider.passwordController,
                  validator: FormValidatorService.isNotEmpty,
                  onEditeComplete: () => loginButton.onPressed(),
                ),
                const SizedBox(height: 10),
                const SousUserCheck(),
                const SizedBox(height: 10),
                loginButton,
                const SizedBox(height: 20),
                CustomOutlinedButton(
                  width: double.infinity,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => Dialog(
                        child: ChangePasswordView(
                          context: context,
                        ),
                      ),
                    );
                  },
                  label: 'Changer le mot de passe',
                ),
                const SizedBox(height: 30),
                const LoginAsView(),
                Selector<LoginProvider, String>(
                  builder: (_, String error, __) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        error,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                  selector: (_, __) => __.errorText,
                ),
                const SizedBox(height: 10),
                const CallServiceView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
