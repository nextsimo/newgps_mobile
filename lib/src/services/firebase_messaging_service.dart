import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:newgps/src/models/account.dart';
import 'package:newgps/src/utils/device_size.dart';
import 'package:newgps/src/ui/login/login_as/save_account_provider.dart';
import 'package:provider/provider.dart';
import 'newgps_service.dart';

class FirebaseMessagingService {
  late int notificationID;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  FirebaseMessagingService() {
    saveUserMessagingToken();
    SavedAcountProvider acountProvider =
        Provider.of<SavedAcountProvider>(DeviceSize.c, listen: false);
    _initmessage();
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      navigationViewProvider.navigateToAlertHistoric(
          accountId: remoteMessage.data['account_id']);
      acountProvider.checkNotifcation();
      log("work work work");
    });

    FirebaseMessaging.onBackgroundMessage((message) async {
      acountProvider.checkNotifcation();
    });
  }

  Future<void> _initmessage() async {
    RemoteMessage? remoteMessage = await messaging.getInitialMessage();
    if (remoteMessage != null) {
      SavedAcountProvider acountProvider =
          Provider.of<SavedAcountProvider>(DeviceSize.c, listen: false);
      navigationViewProvider.navigateToAlertHistoric(
          accountId: remoteMessage.data['account_id']);
      acountProvider.checkNotifcation();
    }
  }

  Future<void> saveUserMessagingToken() async {
    await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        announcement: true,
        criticalAlert: true);

    String? token = await messaging.getToken();
    Account? account = shared.getAccount();
    String? deviceId = await _getDeviceToken();
    // save the new token to database
    log(deviceId.toString());
    String res = await api.post(
      url: '/update/notification',
      body: {
        'accountId': account?.account.accountId,
        'token': token,
        'deviceId': deviceId,
      },
    );
    if (res.isNotEmpty) {
      notificationID = json.decode(res);
    }
    log("Token update $res\nToken : $token");
  }

  Future<String?> _getDeviceToken() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return "android_${androidInfo.model}_${androidInfo.androidId}";
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return "ios_${iosInfo.model}_${iosInfo.identifierForVendor}";
    }
  }
}
