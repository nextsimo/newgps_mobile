import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../utils/functions.dart';
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
  const LoginPortrait({Key? key, required this.loginButton}) : super(key: key);

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
                if (kIsWeb)
                  Image.network(
                    'https://api.newgps.ma/api/icons/logo.svg',
                    width: 100,
                  ),
                if (!kIsWeb) Image.asset('assets/logo-200.png', width: 100),
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

                const SizedBox(height: 20),
                loginButton,
                const SizedBox(height: 10),
                const LoginAsView(),
                const SizedBox(height: 10),
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
