import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:newgps/src/models/account.dart';
import 'package:newgps/src/models/user_droits.dart';
import 'package:newgps/src/models/user_model.dart';
import 'package:newgps/src/services/newgps_service.dart';

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

  Future<void> _deleteUser(User user) async {
    if (user.userId.isEmpty) {
      _users.remove(user);
    } else {
      Account? account = shared.getAccount();
      //debugPrint("${user.toJson()}");
      String res = await api.post(url: '/user/delete', body: {
        'account_id': account?.account.accountId,
        'data': json.encode(user.toJson())
      });

      if (res.isNotEmpty) {
        Fluttertoast.showToast(
          msg: '${user.userId.toUpperCase()} supprimé avec succès',
          timeInSecForIosWeb: 5,
          // green
          webBgColor: '#4caf50',
        );
        _users.remove(user);
      } else {
        Fluttertoast.showToast(
            msg:
                'Erreur lors de la suppression de ${user.userId.toUpperCase()}! Veuillez réessayer ultérieurement.');
      }
    }
    notifyListeners();
  }

  // dialog to confirm save or delete user
  void confirmDeleteUser(BuildContext context, User user) {
    _showConfirmDialog(
      context,
      user,
      'Voulez-vous vraiment supprimer ',
      () => _deleteUser(user),
      'Supprimer',
    );
  }

  // confime save user
  void confirmSaveUser(BuildContext context, User newUser, int index) {
    _showConfirmDialog(
      context,
      newUser,
      'Voulez-vous vraiment enregistrer ',
      () => _onSave(newUser, context, index),
      'Enregistrer',
    );
  }

  // show confirm dialog
  Future<void> _showConfirmDialog(BuildContext context, User user, String title,
      void Function() onConfirme, String action) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmation'),
            content: RichText(
              text: TextSpan(
                text: title,
                style: const TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: user.userId.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const TextSpan(
                    text: '?',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
/*             content: Row(
              children: [
                Expanded(child: Text(title)),
                Text(
                  user.userId.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(' ?'),
              ],
            ), */
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () {
                  onConfirme.call();
                  Navigator.of(context).pop();
                },
                child: Text(action),
              ),
            ],
          );
        });
  }

  Future<void> _onSave(User newUser, BuildContext context, int index) async {
    bool res = false;
    newUser.devices.removeWhere((e) => e.isEmpty);
    if (newUser.userId.isEmpty) {
      res = await addNewuser(newUser);
    } else {
      res = await updateUser(newUser, index);
    }

    if (!res) {
      Fluttertoast.showToast(
        msg:
            "Erreur lors de l'enregistrement ! Utilisateur déjà existant ou données incorrectes",
        timeInSecForIosWeb: 6,
        webBgColor: "#e74c3c",
      );
    } else {
      Fluttertoast.showToast(
        msg: '${newUser.newUserId.toUpperCase()} enregistré avec succès',
        timeInSecForIosWeb: 5,
      );
      fetchUsers();
    }
  }

  Future<bool> addNewuser(User newUser) async {
    // save the new matricule
    Account? account = shared.getAccount();
    //debugPrint("${newUser.toJson()}");
    String res = await api.post(url: '/user/add', body: {
      'account_id': account?.account.accountId,
      'data': json.encode(newUser.toJson())
    });

    if (res.isEmpty) {
      //log("user exist");
      return false;
    }
    String userId = jsonDecode(res)['userID'];
    await createNewUserDroits(userId);
    return true;
  }

  Future<void> fetchUserDroits() async {
    Account? account = shared.getAccount();

    // fetch all userDroits at once
    String res = await api.post(url: '/user/droits/all', body: {
      'account_id': account?.account.accountId,
    });

    if (res.isNotEmpty) {
      List<dynamic> data = jsonDecode(res);
      userDroits = data.map((e) => UserDroits.fromJson(e)).toList();
    }

    // remove user drois for deleted users
    //userDroits.removeWhere((e) => !_users.any((u) => u.userId == e.userId));
  }

  Future<bool> updateUser(User newUser, int index) async {
    Account? account = shared.getAccount();
    await updateUserDroits(index);
    String res = await api.post(url: '/user/update', body: {
      'account_id': account?.account.accountId,
      'data': json.encode(newUser.toJson()),
    });
    if (res.isEmpty) {
      //log("user exist");
      return false;
    }
    return true;
  }

  Future<void> updateUserDroits(int index) async {
    UserDroits newuserDroits =
        UserDroits.fromJson(userDroits.elementAt(index).toJson());
    newuserDroits.droits.removeAt(index);
    await api.post(url: '/user/droits/update', body: {
      'droits': json.encode(newuserDroits.toJson()),
    });
  }

  Future<void> createNewUserDroits(String userid) async {
    Account? account = shared.getAccount();
    UserDroits newuserDroits =
        UserDroits.fromJson(userDroits.elementAt(0).toJson());
    newuserDroits.droits.removeAt(0);
    //debugPrint(json.encode(_userDroits.toJson()));

    await api.post(url: '/user/droits/create', body: {
      'user_id': userid,
      'account_id': account!.account.accountId,
      'droits': json.encode(newuserDroits.toJson()),
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
        devices: [],
      ),
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
    fetchUsers(true);
  }
  bool loading = false;
  Future<void> fetchUsers([bool mustLoading = false]) async {
    if (mustLoading) {
      if (loading) return;
      loading = true;
      notifyListeners();
    }
    Account? account = shared.getAccount();
    String res;
    res = await api.post(
      url: '/users/index',
      body: {'account_id': account?.account.accountId},
    );
    if (res.isNotEmpty) {
      _users = userFromJson(res);
      await fetchUserDroits();
    }
    loading = false;
    notifyListeners();
  }
}
