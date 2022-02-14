import 'package:flutter/material.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/ui/last_position/last_position_provider.dart';
import 'package:newgps/src/ui/login/login_as/save_account_provider.dart';
import 'package:provider/provider.dart';

import '../connected_device/connected_device_provider.dart';

class SplashViewModel with ChangeNotifier {
  Future<void> init(BuildContext context) async {
    checkIfUserIsAuth(context);
  }

  void checkIfUserIsAuth(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));
    if (shared.getAccount() != null) {
      LastPositionProvider lastPositionProvider =
          Provider.of<LastPositionProvider>(context, listen: false);

      SavedAcountProvider savedAcountProvider =
          Provider.of<SavedAcountProvider>(context, listen: false);
      savedAcountProvider.initUserDroit();

      await fetchInitData(
          lastPositionProvider: lastPositionProvider, context: context);

      final ConnectedDeviceProvider connectedDeviceProvider =
          Provider.of<ConnectedDeviceProvider>(context, listen: false);
      connectedDeviceProvider.init();

      Navigator.of(context)
          .pushNamedAndRemoveUntil('/navigation', (_) => false);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
    }
  }
}
