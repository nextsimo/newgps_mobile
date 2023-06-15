import 'dart:convert';
import 'dart:developer';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:newgps/src/utils/styles.dart';
import '../models/account.dart';
import '../utils/device_size.dart';
import '../ui/login/login_as/save_account_provider.dart';
import 'package:provider/provider.dart';
import 'newgps_service.dart';

class FirebaseMessagingService {
  late int notificationID;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  void init() {
    _saveUserMessagingToken();
    SavedAcountProvider acountProvider =
        Provider.of<SavedAcountProvider>(DeviceSize.c, listen: false);
    _initmessage();
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      navigationViewProvider.navigateToAlertHistoric(
          accountId: remoteMessage.data['account_id']);
      acountProvider.checkNotifcation();
      log("work work work");
    });
  }

  Future<void> _saveUserMessagingToken() async {
    await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        announcement: true,
        criticalAlert: true);

    // check if the user already has a token saved
    String? token =
        NewgpsService.sharedPrefrencesService.getKey('messaging_token');

    token ??= await messaging.getToken();

    Account? account = shared.getAccount();
    //String? deviceId = await _getDeviceToken();
    // save the new token to database
    String res = await api.post(
      url: '/update/notification',
      body: {
        'accountId': account?.account.accountId,
        'token': token,
        'deviceId': token,
      },
    );
    if (res.isNotEmpty) {
      notificationID = json.decode(res);
    }
    log("Token update $res\nToken : $token");
  }

  Future<void> disableAllSettings(String? account) async {
    Account? account = shared.getAccount();
    String? token =
        NewgpsService.sharedPrefrencesService.getKey('messaging_token');
    String? deviceUID = token;
    await api.post(
      url: '/disable/alert',
      body: {'account_id': account, 'device_uid': deviceUID, 'state': false},
    );
    debugPrint('test');
  }

  // subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    await messaging.subscribeToTopic(topic);
  }

  // hanle subscribe to topic depending on the state and add account to the end of the topic
  Future<void> handleSubscribeToTopic(
      {required bool? state, required String topic}) async {
    final accountId = shared.getAccount()?.account.accountId;
    if (accountId == null) return;
    if (state == true) {
      await messaging.subscribeToTopic("$topic-$accountId");
    } else {
      await messaging.unsubscribeFromTopic("$topic-$accountId");
    }
  }

  // unsubscribe from all topics
  Future<void> unsubscribeFromAllTopics() async {
    await messaging.unsubscribeFromTopic(AppConsts.startUpAlertTopic);
  }

/*   Future<void> enableAllSettings() async {
    Account? account = shared.getAccount();
    String? deviceUID = await _getDeviceToken();
    await api.post(
      url: '/disable/alert',
      body: {
        'account_id': account?.account.accountId,
        'device_uid': deviceUID,
        'state': true
      },
    );
    debugPrint('test');
  } */

  Future<void> _initmessage() async {
    RemoteMessage? remoteMessage = await messaging.getInitialMessage();
    if (remoteMessage != null) {
      SavedAcountProvider acountProvider =
          // ignore: use_build_context_synchronously
          Provider.of<SavedAcountProvider>(DeviceSize.c, listen: false);
      navigationViewProvider.navigateToAlertHistoric(
          accountId: remoteMessage.data['account_id']);
      acountProvider.checkNotifcation();
    }
  }
}
