import '../models/account.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefrencesService {
  late SharedPreferences sharedPreferences;

  SharedPrefrencesService() {
    init();
  }

  void init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  void clear(String key) {
    sharedPreferences.remove(key);
  }

  Future<void> saveAccount(Account account) async {
    String myAccount = accountToMap(account);

   await  sharedPreferences.setString('account', myAccount);
  }

  dynamic getKey(String key) {
    sharedPreferences.get(key);
  }




  List<String> getAcountsList(String key) {
    return sharedPreferences.getStringList(key) ?? const [];
  }

  void setStringList(String key, List<String> data) async {
    await sharedPreferences.setStringList(key, data);
  }

  Account? getAccount() {
    String? res = sharedPreferences.getString('account');
    if (res != null) {
      return accountFromMap(res);
    }
    return null;
  }
}
