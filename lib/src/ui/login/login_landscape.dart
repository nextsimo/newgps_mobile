import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:newgps/src/utils/utils.dart';
import '../../utils/functions.dart';
import 'login_provider.dart';
import '../../widgets/buttons/main_button.dart';
import '../../widgets/inputs/main_input.dart';
import '../../widgets/inputs/password_input.dart';
import 'package:provider/provider.dart';

import 'call_service_view.dart';
import 'login_as/login_as_view.dart';

class LoginLandscape extends StatefulWidget {
  const LoginLandscape({super.key});

  @override
  State<LoginLandscape> createState() => _LoginLandscapeState();
}

class _LoginLandscapeState extends State<LoginLandscape> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll();
  }

  void _scroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController
          .jumpTo(_scrollController.position.maxScrollExtent * 0.5);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LoginProvider provider = Provider.of<LoginProvider>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.5,
      child: Center(
        child: Form(
          key: provider.formKey,
          child: Center(
            child: SingleChildScrollView(
              controller: _scrollController,
              reverse: true,
              child: Center(
                child: Transform.scale(
                  scale: 0.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (kIsWeb)
                        Image.network(
                          '${Utils.baseUrl}/icons/logo.svg',
                          width: 100,
                        ),
                      if (!kIsWeb)
                        Image.asset(
                          'assets/logo-200.png',
                          width: 50,
                        ),
                      const SizedBox(height: 20),
                      MainInput(
                        icon: Icons.folder,
                        hint: 'Compte',
                        controller: provider.compteController,
                        validator: FormValidatorService.isNotEmpty,
                        onEditeComplete: () =>
                            FocusScope.of(context).nextFocus(),
                      ),
                      const SizedBox(height: 10),
                      PasswordInput(
                        icon: Icons.lock,
                        hint: 'Mot de passe',
                        controller: provider.passwordController,
                        validator: FormValidatorService.isNotEmpty,
                        onEditeComplete: (){
                          FocusScope.of(context).requestFocus(FocusNode());
                        }
                      ),
                      const SizedBox(height: 10),
                      MainInput(
                        icon: Icons.person,
                        hint: 'Sous utilisateur',
                        controller: provider.underCompteController,
                        onEditeComplete: () =>
                            FocusScope.of(context).nextFocus(),
                      ),
                      const SizedBox(height: 20),
                      MainButton(
                        label: 'Se connecter',
                        onPressed: () => provider.login(context,(){
                          Phoenix.rebirth(context);
                        }),
                      ),
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
                            ),
                          );
                        },
                        selector: (_, __) => __.errorText,
                      ),
                      const CallServiceView(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
