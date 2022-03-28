import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:newgps/src/models/account.dart';
import 'package:provider/provider.dart';

import '../../services/newgps_service.dart';
import '../../utils/functions.dart';
import '../connected_device/connected_device_provider.dart';
import '../last_position/last_position_provider.dart';
import '../login/login_as/save_account_provider.dart';

class SplashViewModel with ChangeNotifier {
  Future<void> init(BuildContext context) async {
    checkIfUserIsAuth(context);
  }

  void checkIfUserIsAuth(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));
    Account? account = shared.getAccount();
    if (account != null) {
      int? isActive = json.decode(await api.post(url: '/isactive', body: {
        'account_id': account.account.accountId,
        'password': account.account.password,
      }));

      SavedAcountProvider savedAcountProvider =
          Provider.of<SavedAcountProvider>(context, listen: false);

      if (isActive == 1) {
        LastPositionProvider lastPositionProvider =
            Provider.of<LastPositionProvider>(context, listen: false);
        savedAcountProvider.initUserDroit();
/*         SavedAcountProvider savedAcountProvider =
            Provider.of<SavedAcountProvider>(context, listen: false);
        savedAcountProvider.initUserDroit(); */
        String userID = shared.getAccount()?.account.userID ?? '';
        if (userID.isNotEmpty) {
          await savedAcountProvider.fetchUserDroits();
        }
        fetchInitData(
          lastPositionProvider: lastPositionProvider,
          context: context,
        );

        final ConnectedDeviceProvider connectedDeviceProvider =
            Provider.of<ConnectedDeviceProvider>(context, listen: false);
        connectedDeviceProvider.init();

        Navigator.of(context)
            .pushNamedAndRemoveUntil('/navigation', (_) => false);
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
      }
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
    }
  }
}
