import 'dart:convert';

import 'package:flutter/material.dart';
import '../../models/account.dart';
import '../../models/matricule.dart';
import '../../services/newgps_service.dart';
import '../../utils/styles.dart';

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

  final ScrollController scrollController = ScrollController();

  void _init() {
    scrollController.addListener(_scrollListner);
  }

  bool _stopPagination = false;

  void _scrollListner() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent) {
      if (!_stopPagination) {
        fetchMatricules(searchStr: searchStr, fromListner: true);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.removeListener(_scrollListner);
    scrollController.dispose();
  }
 
  set matricules(List<MatriculeModel> matricules) {
    _matricules = matricules;
    notifyListeners();
  }

  Future<void> search(String str) async {
    searchStr = str;
    await fetchMatricules(searchStr: str);
  }

  String searchStr = '';

  Future<void> onSave(
      MatriculeModel newMatriculeData, BuildContext context) async {
    // save the new matricule
    Account? account = shared.getAccount();
    debugPrint(jsonEncode(newMatriculeData.toJson()));
    String res = await api.post(
      url: '/matricules/update2',
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
    fetchMatricules(init: true);
    _init();
  }
  int page = 1;
  bool loadding = false;
  Future<void> fetchMatricules(
      {String? searchStr, bool init = false, bool fromListner = false}) async {
    if (loadding) return;
    loadding = true;
    if (!init) {
      notifyListeners();
    }
    Account? account = shared.getAccount();
    String res;
    if (fromListner) {
      page++;
    }
    if (searchStr == null) {
      res = await api.post(
        url: '/matricules2',
        body: {
          'account_id': account?.account.accountId,
          'user_id': account?.account.userID,
          'page': page,
        },
      );
    } else {
      res = await api.post(
        url: '/matricules2',
        body: {
          'account_id': account?.account.accountId,
          'search': searchStr,
          'user_id': account?.account.userID,
          'page': page,
        },
      );
    }

    if (res.isNotEmpty) {
      oldMatricules.clear();
      List<MatriculeModel> ms = matriculeModelFromJson(res);
      if (ms.isEmpty) {
        _stopPagination = true;
      }
      oldMatricules.addAll(List<MatriculeModel>.from(ms));
      matricules.addAll(List<MatriculeModel>.from(ms));
    }
    loadding = false;
    notifyListeners();
  }
}
