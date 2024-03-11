import 'package:flutter/material.dart';
import 'login_landscape.dart';
import 'login_portrait.dart';
import 'package:upgrader/upgrader.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      upgrader: Upgrader(
        debugDisplayOnce: false,
        debugDisplayAlways: false,
        messages: UpgraderMessages(code: 'fr'),
        languageCode: 'fr',
        durationUntilAlertAgain: const Duration(days: 1),
      ),
      //debugAlwaysUpgrade: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SafeArea(
            child: Builder(
              builder: (BuildContext context) {
                bool isLandScape =
                    MediaQuery.of(context).orientation == Orientation.landscape;
                if (isLandScape) {
                  return const LoginLandscape();
                }
                return const LoginPortrait();
              },
            ),
          ),
        ),
      ),
    );
  }
}
