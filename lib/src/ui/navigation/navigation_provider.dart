import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/account.dart';
import '../../services/newgps_service.dart';
import '../../utils/device_size.dart';
import '../../utils/functions.dart';
import '../last_position/last_position_provider.dart';
import '../login/login_as/save_account_provider.dart';

class NavigationProvider {
  PageController pageController = PageController();
  String initAlertRoute = 'alert';
  String currentRoute = 'position';

  void navigateToAlertHistoric({required String accountId}) async {
    SavedAcountProvider acountProvider =
        Provider.of<SavedAcountProvider>(DeviceSize.c, listen: false);

    LastPositionProvider lastPositionProvider =
        Provider.of<LastPositionProvider>(DeviceSize.c, listen: false);
        final res = await acountProvider
        .fetchSavedAccount();
    SavedAccount? accounts = 
        res.firstWhere((ac) => ac.user == accountId);
    shared.saveAccount(Account(
      account: AccountClass(
          password: accounts.password,
          accountId: accounts.user,
          userID: accounts.underUser,
          description: ''),
      token: accounts.password,
    ));
    // ignore: use_build_context_synchronously
    fetchInitData(
        // ignore: use_build_context_synchronously
        lastPositionProvider: lastPositionProvider, context: DeviceSize.c);
    pageController.jumpToPage(3);
    initAlertRoute = '/historics';
  }
}
