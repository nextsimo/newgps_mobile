import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:newgps/src/models/account.dart';
import 'package:newgps/src/models/user_droits.dart';
import 'package:newgps/src/models/user_model.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];

  List<UserDroits> userDroits = [];

  List<User> get users => _users;

  List<String> devices = [];

  set users(List<User> users) {
    _users = users;
    notifyListeners();
  }

  bool empyRowExist() {
    if (_users.isEmpty) return false;

    bool exist = _users.first.userId.isEmpty;

    return exist;
  }

  Future<void> deleteUser(User user) async {
    if (user.userId.isEmpty) {
      _users.remove(user);
    } else {
      Account? account = shared.getAccount();
      debugPrint("${user.toJson()}");
      String res = await api.post(url: '/user/delete', body: {
        'account_id': account?.account.accountId,
        'data': json.encode(user.toJson())
      });

      if (res.isNotEmpty) {
        _users.remove(user);
      }
    }
    notifyListeners();
  }

  Future<void> onSave(User newUser, BuildContext context, int index) async {
    bool res = false;
    newUser.devices.removeWhere((e) => e.isEmpty);
    if (newUser.userId.isEmpty) {
      res = await addNewuser(newUser);
    } else {
      res = await updateUser(newUser, index);
    }

    if (!res) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Nom utilisateur déja exister'),
          actions: [
            MainButton(
              onPressed: () => Navigator.of(context).pop(),
              label: 'Fermer',
            ),
          ],
        ),
      );
    } else {
      fetchUsers();
    }
  }

  Future<bool> addNewuser(User newUser) async {
    // save the new matricule
    Account? account = shared.getAccount();
    debugPrint("${newUser.toJson()}");
    String res = await api.post(url: '/user/add', body: {
      'account_id': account?.account.accountId,
      'data': json.encode(newUser.toJson())
    });

    if (res.isEmpty) {
      log("user exist");
      return false;
    }
    String userId = jsonDecode(res)['userID'];
    await createNewUserDroits(userId);
    return true;
  }

  Future<void> fetchUserDroits() async {
    Account? account = shared.getAccount();
    for (var user in users) {
      String res = await api.post(url: '/user/droits/show', body: {
        'account_id': account!.account.accountId,
        'user_id': user.userId,
      });
      userDroits.add(userDroitsFromJson(res));
    }
  }

  Future<bool> updateUser(User newUser, int index) async {
    Account? account = shared.getAccount();
    await updateUserDroits(index);
    String res = await api.post(url: '/user/update', body: {
      'account_id': account?.account.accountId,
      'data': json.encode(newUser.toJson()),
    });
    if (res.isEmpty) {
      log("user exist");
      return false;
    }
    return true;
  }

  Future<void> updateUserDroits(int index) async {
    UserDroits _userDroits =
        UserDroits.fromJson(userDroits.elementAt(index).toJson());
    _userDroits.droits.removeAt(index);
    await api.post(url: '/user/droits/update', body: {
      'droits': json.encode(_userDroits.toJson()),
    });
  }

  Future<void> createNewUserDroits(String userid) async {
    Account? account = shared.getAccount();
    UserDroits _userDroits =
        UserDroits.fromJson(userDroits.elementAt(0).toJson());
    _userDroits.droits.removeAt(0);
    debugPrint(json.encode(_userDroits.toJson()));

    await api.post(url: '/user/droits/create', body: {
      'user_id': userid,
      'account_id': account!.account.accountId,
      'droits': json.encode(_userDroits.toJson()),
    });
  }

  void addUserUi() {
    if (empyRowExist()) return;
    _users.insert(
      0,
      User(
          index: 0,
          userId: '',
          displayName: '',
          contactPhone: '',
          password: '',
          devices: []),
    );

    userDroits.insert(
      0,
      UserDroits(
        id: 0,
        userId: 'test',
        accountId: 'test',
        droits: [
          Droit(read: false, write: false, index: 10),
          Droit(read: false, write: false, index: 0),
          Droit(read: false, write: false, index: 1),
          Droit(read: false, write: false, index: 2),
          Droit(read: false, write: false, index: 3),
          Droit(read: false, write: false, index: 4),
          Droit(read: false, write: false, index: 5),
          Droit(read: false, write: false, index: 6),
          Droit(read: false, write: false, index: 7),
          Droit(read: false, write: false, index: 8),
          Droit(read: false, write: false, index: 9),
        ],
      ),
    );

    notifyListeners();
  }

  UserProvider() {
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    Account? account = shared.getAccount();
    String res;
    res = await api.post(
      url: '/users/index',
      body: {'account_id': account?.account.accountId},
    );
    if (res.isNotEmpty) {
      _users = userFromJson(res);
      await fetchUserDroits();
      notifyListeners();
    }
  }
}
