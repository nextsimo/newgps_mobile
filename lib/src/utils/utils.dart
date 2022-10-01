import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static void handleSplashScreen(WidgetsBinding widgetsBinding) async {
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    await Future.delayed(const Duration(seconds: 5));
    FlutterNativeSplash.remove();
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
    final shared = await SharedPreferences.getInstance();
    final accounts = shared.getStringList('accounts') ?? const [];
  }


}
