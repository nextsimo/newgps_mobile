import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:newgps/src/ui/classic/classic_view.dart';
import '../../../models/account.dart';
import '../../../models/user_droits.dart';
import '../../../services/newgps_service.dart';

import '../../../utils/functions.dart';
import '../../alert/alert_navigation.dart';
import '../../camera/camera_view.dart';
import '../../geozone/geozone_view.dart';
import '../../gestion/gestion_view.dart';
import '../../historic/historic_view.dart';
import '../../last_position/last_position_view.dart';
import '../../matricule/matricule_view_2.dart';
import '../../repport/repport_view.dart';
import '../../temp_card/temp_card_view.dart';
import '../../user/user_view.dart';
import '../../driver_view/pages/driver_view.dart';
import '../../user_empty_page.dart';

class SavedAcountProvider with ChangeNotifier {
  List<SavedAccount> _savedAcounts = [];

  int _numberOfNotif = 0;

  int get numberOfNotif => _numberOfNotif;

  set numberOfNotif(int numberOfNotif) {
    _numberOfNotif = numberOfNotif;
    notifyListeners();
  }

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  Future<String?> _getDeviceToken() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return "android_${androidInfo.model}_${androidInfo.androidId}";
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

      return "ios_${iosInfo.model}_${iosInfo.identifierForVendor}";
    }
  }

  Future<void> checkNotifcation() async {
    String res = await api.post(
      url: '/notification/historics/count2',
      body: await getBody()
        ..addAll({
          'device_id': await _getDeviceToken(),
          'notification_id': NewgpsService.messaging.notificationID
        }),
    );

    if (res.isNotEmpty) {
      numberOfNotif = jsonDecode(res);
    }
  }

  late UserDroits userDroits = UserDroits(
    id: 0,
    userId: '',
    accountId: '',
    droits: [
      Droit(read: true, write: true, index: 0),
      Droit(read: true, write: true, index: 1),
      Droit(read: true, write: true, index: 2),
      Droit(read: true, write: true, index: 3),
      Droit(read: true, write: true, index: 4),
      Droit(read: true, write: true, index: 5),
      Droit(read: true, write: true, index: 6),
      Droit(read: true, write: true, index: 7),
      Droit(read: true, write: true, index: 8),
      Droit(read: true, write: true, index: 9),
    ],
  );

  void initUserDroit() {
    userDroits = UserDroits(
      id: 0,
      userId: '',
      accountId: '',
      droits: [
        Droit(read: true, write: true, index: 0),
        Droit(read: true, write: true, index: 1),
        Droit(read: true, write: true, index: 2),
        Droit(read: true, write: true, index: 3),
        Droit(read: true, write: true, index: 4),
        Droit(read: true, write: true, index: 5),
        Droit(read: true, write: true, index: 6),
        Droit(read: true, write: true, index: 7),
        Droit(read: true, write: true, index: 8),
        Droit(read: true, write: true, index: 9),
      ],
    );
  }

  final List<Widget> _accountWidget = [
    const LastPositionView(),
    const HistoricView(),
    const RepportView(),
    const AlertNavigation(),
    const GeozoneView(),
    const UsersView(),
    const MatriculeView(),
    const TempCardView(),
    const GestionView(),
    const DriverView(),
    const ClassicView(),
  ];

  List<Widget> buildPages() {
    Account? account = shared.getAccount();
    if (account!.account.userID == null || account.account.userID!.isEmpty) {
      return _accountWidget;
    }

    List<Widget> _userPages = [];

    _userPages = [
      if (userDroits.droits[1].read) const LastPositionView(),
      if (userDroits.droits[2].read) const HistoricView(),
      if (userDroits.droits[3].read) const RepportView(),
      if (userDroits.droits[4].read) const AlertNavigation(),
      if (userDroits.droits[5].read) const GeozoneView(),
      if (userDroits.droits[7].read) const MatriculeView(),
      if (userDroits.droits[8].read) const TempCardView(),
      if (userDroits.droits[9].read) const GestionView(),
      if (userDroits.droits[10].read) const DriverView(),
    ];

    if (_userPages.isEmpty) return [const UserEmptyPage()];
    return _userPages;
  }

  Future<void> fetchUserDroits() async {
    Account? account = shared.getAccount();
    if (account!.account.userID == null || account.account.userID!.isEmpty) {
      return;
    }
    String res = await api.post(url: '/user/droits/show', body: {
      'account_id': account.account.accountId,
      'user_id': account.account.userID,
    });
    userDroits = userDroitsFromJson(res);
  }

  List<SavedAccount> get savedAcounts => _savedAcounts;
  final String acountsKey = 'saved_acounts';
  set savedAcounts(List<SavedAccount> savedAcounts) {
    _savedAcounts = savedAcounts;
    notifyListeners();
  }

  bool _loading = false;

  bool get loading => _loading;

  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  SavedAcountProvider() {
    init();
  }

  Future<void> init() async {
    getSavedAccount();
  }

  Future<bool> accountExist(String? user, String? key) async {
    final list = await shared.getAcountsList(acountsKey);
    final res = list.contains(user);
    return res;
  }

  void savedAcount(String? user, String? key, [String? underUser = '']) {
    log("==> ${_savedAcounts.length}");
    if (underUser!.isNotEmpty) {
      deleteUserAccount(underUser, user);
    } else {
      deleteAcount(user);
    }
    _savedAcounts.add(SavedAccount(user: user, key: key, underUser: underUser));
    saveAcountsList(_savedAcounts);
  }

  void deleteUserAccount(String underUser, String? user) {
    savedAcounts
        .removeWhere((ac) => ac.underUser == underUser && ac.user == user);
    saveAcountsList(savedAcounts);
    notifyListeners();
  }

  Future<void> getSavedAccount() async {
    List<String> strings = await shared.getAcountsList(acountsKey);
    if (strings.isNotEmpty) {
      savedAcounts = List<SavedAccount>.from(strings
          .map<SavedAccount>(
            (e) => SavedAccount(
              user: e.split(',').first,
              key: e.split(',').elementAt(1),
              underUser: e.split(',').last,
            ),
          )
          .toList());
    }
  }

  Future<List<SavedAccount>> fetchSavedAccount() async {
    List<String> strings = await shared.getAcountsList(acountsKey);
    if (strings.isNotEmpty) {
      return List<SavedAccount>.from(strings
          .map<SavedAccount>(
            (e) => SavedAccount(
              user: e.split(',').first,
              key: e.split(',').elementAt(1),
              underUser: e.split(',').last,
            ),
          )
          .toList());
    }
    return [];
  }

  Future<SavedAccount?> getAccount(String? accontID) async {
    List<String> strings = await shared.getAcountsList(acountsKey);
    if (strings.isNotEmpty) {
      List<SavedAccount> _acconts =
          savedAcounts = List<SavedAccount>.from(strings
              .map<SavedAccount>(
                (e) => SavedAccount(
                  user: e.split(',').first,
                  key: e.split(',').elementAt(1),
                  underUser: e.split(',').last,
                ),
              )
              .toList());
      return _acconts.firstWhere((ac) => ac.user == accontID);
    }
    return null;
  }

  void deleteAcount(String? user, {bool disableSetting = false}) {
    log("---> ${_savedAcounts.length}");

    savedAcounts.removeWhere((ac) {
      // check if the user is under another user
      if (ac.underUser == null || ac.underUser!.isEmpty) {
        return ac.user == user;
      } else {
        return ac.underUser == user;
      }
    });

    saveAcountsList(savedAcounts);
    if (disableSetting) disapleAllNotification(user);
    notifyListeners();
  }

  void disapleAllNotification(String? account) {
    NewgpsService.messaging.disableAllSettings(account);
  }

  void saveAcountsList(List<SavedAccount> acounts) {
    _savedAcounts = acounts;
    List<String> newListAcounts = List<String>.from(
        acounts.map((e) => '${e.user},${e.key},${e.underUser}').toList());
    shared.setStringList(acountsKey, newListAcounts);
  }
}

class SavedAccount {
  final String? user;
  final String? underUser;
  final String? key;

  SavedAccount({required this.user, required this.key, this.underUser = ''});

  get password => null;
}
