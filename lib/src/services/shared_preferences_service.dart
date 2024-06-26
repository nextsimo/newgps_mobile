import '../models/account.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefrencesService {
  SharedPreferences? sharedPreferences;

  SharedPrefrencesService() {
    init();
  }

  Future<void> init() async {
    if (sharedPreferences != null) {
      return;
    }
    sharedPreferences = await SharedPreferences.getInstance();
  }

  void clear(String key) {
    sharedPreferences?.remove(key);
  }

  Future<void> saveAccount(Account account) async {
    String myAccount = accountToMap(account);

    await sharedPreferences?.setString('account', myAccount);
  }

  dynamic getKey(String key) {
    sharedPreferences?.get(key);
  }

  Future<List<String>> getAcountsList(String key) async {
    sharedPreferences ??= await SharedPreferences.getInstance();
    return sharedPreferences?.getStringList(key) ?? const [];
  }

  void setStringList(String key, List<String> data) async {
    await sharedPreferences?.setStringList(key, data);
  }

  Account? getAccount() {
    if (sharedPreferences == null) {
      return null;
    }
    String? res = sharedPreferences?.getString('account');
    if (res != null) {
      return accountFromMap(res);
    }
    return null;
  }
}
