import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import '../models/account.dart';
import '../services/newgps_service.dart';
import '../ui/connected_device/connected_device_provider.dart';
import '../ui/last_position/last_position_provider.dart';
import '../ui/login/login_as/save_account_provider.dart';
import 'functions.dart';

class Utils {
  static void handleSplashScreen(WidgetsBinding widgetsBinding) async {
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    await Future.delayed(const Duration(seconds: 2));
    FlutterNativeSplash.remove();
  }

  void checkIfUserIsAuth(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Account? account = shared.getAccount();
      if (account != null) {
        int? isActive = json.decode(await api.post(url: '/isactive', body: {
          'account_id': account.account.accountId,
          'password': account.account.password,
          'user_id': account.account.userID,
        }));

        SavedAcountProvider savedAcountProvider =
            // ignore: use_build_context_synchronously
            Provider.of<SavedAcountProvider>(context, listen: false);
        if (isActive == 1) {
          LastPositionProvider lastPositionProvider =
              // ignore: use_build_context_synchronously
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
              // ignore: use_build_context_synchronously
              Provider.of<ConnectedDeviceProvider>(context, listen: false);
          connectedDeviceProvider.init();

          // ignore: use_build_context_synchronously
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/navigation', (_) => false);
        } else {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushReplacementNamed('/login');
        }
      } else {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  static String logoHeroTag = 'logo';

  // init firbase config
  static void initFirebaseConfig() {
    FirebaseRemoteConfig.instance.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
  }

  // define base url
  static String baseUrl = 'https://api.newgps.ma/api/auth';

  // defini the initial route
  static String initialRoute = '/login';
  Future<void> defineInitialRoute() async {
  }
}
