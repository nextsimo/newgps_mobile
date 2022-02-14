import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:newgps/src/models/account.dart';
import 'package:newgps/src/models/matricule.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/utils/styles.dart';

class MatriculeProvider with ChangeNotifier {
  List<MatriculeModel> _matricules = [];
  List<MatriculeModel> oldMatricules = [];

  List<MatriculeModel> get matricules => _matricules;
  bool _loading = false;

  bool get loading => _loading;

  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  set matricules(List<MatriculeModel> matricules) {
    _matricules = matricules;
    notifyListeners();
  }

  Future<void> search(String str) async =>
      await fetchMatricules(searchStr: str);

  Future<void> onSave(
      MatriculeModel newMatriculeData, BuildContext context) async {
    // save the new matricule
    Account? account = shared.getAccount();
    debugPrint(jsonEncode(newMatriculeData.toJson()));
    String res = await api.post(
      url: '/matricules/update',
      body: {
        'account_id': account?.account.accountId,
        'data': json.encode(newMatriculeData.toJson())
      },
    );

    if (res.isNotEmpty) {
      showDialog(
        context: context,
        builder: (_) => Dialog(
          child: Container(
            width: 125,
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConsts.mainradius),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(
                  Icons.check_box,
                  color: Colors.green,
                  size: 50,
                ),
                Text('Modification effectuée'),
              ],
            ),
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => Dialog(
          child: Container(
            width: 125,
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConsts.mainradius),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(
                  Icons.wifi_off_sharp,
                  color: Colors.orange,
                  size: 50,
                ),
                Text(
                  'Enregistrement non effectuée veuillez vérifier votre connexion',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
      _matricules.clear();
      _matricules = oldMatricules;
      notifyListeners();
    }
    //_dismissDialog(context);
  }

  MatriculeProvider() {
    fetchMatricules();
  }
  Future<void> fetchMatricules({String? searchStr}) async {
    Account? account = shared.getAccount();
    String res;
    if (searchStr == null) {
      res = await api.post(
        url: '/matricules',
        body: {
          'account_id': account?.account.accountId,
          'user_id': account?.account.userID
        },
      );
    } else {
      res = await api.post(
        url: '/matricules',
        body: {
          'account_id': account?.account.accountId,
          'search': searchStr,
          'user_id': account?.account.userID
        },
      );
    }

    if (res.isNotEmpty) {
      oldMatricules.clear();
      oldMatricules = matriculeModelFromJson(res);
      matricules = matriculeModelFromJson(res);
    }
  }
}
