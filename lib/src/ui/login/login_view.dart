import 'package:flutter/material.dart';
import 'package:newgps/src/ui/login/login_landscape.dart';
import 'package:newgps/src/ui/login/login_portrait.dart';
import 'package:newgps/src/ui/login/login_provider.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
      ],
      child: ChangeNotifierProvider<LoginProvider>(
          create: (_) => LoginProvider(),
          builder: (context, __) {
            LoginProvider provider =
                Provider.of<LoginProvider>(context, listen: false);
            final loginButton = MainButton(
              label: 'Se connecter',
              onPressed: () => provider.login(context),
            );
            return UpgradeAlert(
              messages: UpgraderMessages(code: 'fr'),
              countryCode: 'MA',
              showIgnore: false,
              shouldPopScope: () => false,
              showLater: false,
              canDismissDialog: false,
              //debugAlwaysUpgrade: true,
              child: Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: SafeArea(
                    child: Builder(
                      builder: (BuildContext context) {
                        bool isLandScape = MediaQuery.of(context).orientation ==
                            Orientation.landscape;
                        if (isLandScape) {
                          return LoginLandscape(loginButton: loginButton);
                        }
                        return LoginPortrait(loginButton: loginButton);
                      },
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
