import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import '../../models/account.dart';
import '../../services/newgps_service.dart';
import 'login_as/save_account_provider.dart';
import 'package:provider/provider.dart';

class LoginProvider with ChangeNotifier {
  final TextEditingController compteController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController underCompteController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updateFormKey = GlobalKey<FormState>();

  late String _errorText = '';
  bool isUnderCompte = false;

  // set under user checkbox value
  void setUnderCompte(bool? value) {
    if (value != null) {
      underCompteController.text = '';
      isUnderCompte = value;
      notifyListeners();
    }
  }

  String get errorText => _errorText;

  set errorText(String errorText) {
    _errorText = errorText;
    notifyListeners();
  }

  Future<void> updatePassword(BuildContext context) async {
    if (updateFormKey.currentState!.validate()) {
      String res = await api.simplePost(
        url: '/update/password',
        body: <String, String>{
          'accountId': compteController.text,
          'oldPassword': passwordController.text,
          'newPassword': newPasswordController.text,
        },
      );

      var data = json.decode(res);

      if (data['code'] == 200) {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            title: Icon(
              Icons.check_circle_sharp,
              color: Colors.green,
            ),
            content: Text('Mote de passe change avec succes'),
          ),
        );
        return;
      }

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Icon(
            Icons.dangerous,
            color: Colors.orange,
          ),
          content: Text(data['message']),
        ),
      );
    }
  }

  Future<void> login(BuildContext context) async {
    errorText = '';
    if (formKey.currentState!.validate()) {
      // request login

      if (underCompteController.text.isNotEmpty) {
        await underAccountLogin(context);
      } else {
        Account? account = await api.login(
          accountId: compteController.text,
          password: passwordController.text,
        );
        if (account != null) {
          await shared.saveAccount(account);
          SavedAcountProvider savedAcountProvider =
              // ignore: use_build_context_synchronously
              Provider.of<SavedAcountProvider>(context, listen: false);
          savedAcountProvider.savedAcount(
            account.account.accountId,
            passwordController.text,
            account.account.userID ?? '',
          );
          // ignore: use_build_context_synchronously
          Phoenix.rebirth(context);
/*           resumeRepportProvider.fresh();

          final LastPositionProvider lastPositionProvider =
              // ignore: use_build_context_synchronously
              Provider.of<LastPositionProvider>(context, listen: false);
          final ConnectedDeviceProvider connectedDeviceProvider =
              // ignore: use_build_context_synchronously
              Provider.of<ConnectedDeviceProvider>(context, listen: false);
          final SavedAcountProvider savedAcountProvider =
              // ignore: use_build_context_synchronously
              Provider.of<SavedAcountProvider>(context, listen: false);
          savedAcountProvider.savedAcount(
              account.account.accountId, passwordController.text);
          savedAcountProvider.initUserDroit();

          await shared.saveAccount(account);

          await fetchInitData(
              lastPositionProvider: lastPositionProvider, context: context);

          connectedDeviceProvider.init();
          connectedDeviceProvider.createNewConnectedDeviceHistoric(true);
          // ignore: use_build_context_synchronously
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/navigation', (_) => false); */
        } else {
          int? isActive = json.decode(await api.post(url: '/isactive', body: {
            'account_id': compteController.text,
            'password': passwordController.text,
          }));

          if (isActive == -1) {
            errorText = 'Mot de passe ou compte est inccorect';
          } else if (isActive == 0) {
            errorText = 'Votre compte est suspendu';
          }
        }
      }
    }
  }

  Future<void> underAccountLogin(BuildContext context) async {
    errorText = '';
    // request login
    Account? account = await api.underAccountLogin(
      accountId: compteController.text,
      password: passwordController.text,
      underAccountLogin: underCompteController.text,
    );
    if (account != null) {
      await shared.saveAccount(account);
      SavedAcountProvider savedAcountProvider =
          // ignore: use_build_context_synchronously
          Provider.of<SavedAcountProvider>(context, listen: false);
      savedAcountProvider.savedAcount(
        account.account.accountId,
        passwordController.text,
        account.account.userID,
      );
      // ignore: use_build_context_synchronously
      Phoenix.rebirth(context);
/*       final SavedAcountProvider savedAcountProvider =
          Provider.of<SavedAcountProvider>(context, listen: false);
      final LastPositionProvider lastPositionProvider =
          Provider.of<LastPositionProvider>(context, listen: false);
      final ConnectedDeviceProvider connectedDeviceProvider =
          Provider.of<ConnectedDeviceProvider>(context, listen: false);
      savedAcountProvider.savedAcount(
        account.account.accountId,
        passwordController.text,
        account.account.userID,
      );
      shared.saveAccount(account);
      await fetchInitData(
          context: context, lastPositionProvider: lastPositionProvider);
      connectedDeviceProvider.init();
      connectedDeviceProvider.createNewConnectedDeviceHistoric(true);
      Navigator.of(context).pushNamed('/navigation'); */
    } else {
      errorText = 'Mot de passe ou account est inccorect';
    }
  }
}
