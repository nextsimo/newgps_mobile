import 'package:flutter/material.dart';
import 'login_landscape.dart';
import 'login_portrait.dart';
import 'login_provider.dart';
import '../../widgets/buttons/main_button.dart';
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
              upgrader: Upgrader(
                debugDisplayOnce: false,
                canDismissDialog: false,
                debugDisplayAlways: false,
                dialogStyle: UpgradeDialogStyle.material,
                messages: UpgraderMessages(code: 'fr'),
                shouldPopScope: () => false,
                onLater: () => false,
                onIgnore: () => false,
                showReleaseNotes: true,
              ),
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
