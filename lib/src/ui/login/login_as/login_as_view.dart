import 'dart:convert';

import 'package:flutter/material.dart';
import '../../../models/account.dart';
import '../../../services/newgps_service.dart';
import 'save_account_provider.dart';
import '../login_provider.dart';
import 'package:provider/provider.dart';

import '../../connected_device/connected_device_provider.dart';

class LoginAsView extends StatelessWidget {
  const LoginAsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SavedAcountProvider>(
        create: (_) => SavedAcountProvider(),
        builder: (BuildContext proContext, __) {
          return Consumer<SavedAcountProvider>(
              builder: (context, provider, __) {
            return SizedBox(
              width: double.infinity,
              child: Wrap(
                runSpacing: 7,
                spacing: 0,
                alignment: WrapAlignment.spaceBetween,
                children: provider.savedAcounts
                    .map(
                        (account) => _BuildLoginAsWidget(savedAccount: account))
                    .toList(),
              ),
            );
          });
        });
  }
}

class _BuildLoginAsWidget extends StatefulWidget {
  final SavedAccount savedAccount;
  const _BuildLoginAsWidget({
    Key? key,
    required this.savedAccount,
  }) : super(key: key);

  @override
  State<_BuildLoginAsWidget> createState() => _BuildLoginAsWidgetState();
}

class _BuildLoginAsWidgetState extends State<_BuildLoginAsWidget> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final SavedAcountProvider provider =
        Provider.of<SavedAcountProvider>(context, listen: false);
    final LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.44,
      child: ElevatedButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.blueAccent),
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)))),
        onPressed: () async {
          // log('Bearer ${savedAccount.key}');
          setState(() => loading = true);
          Account? account;
          if (widget.savedAccount.underUser != null &&
              widget.savedAccount.underUser!.isNotEmpty) {
            account = await api.underAccountLogin(
              accountId: widget.savedAccount.user ?? "",
              password: widget.savedAccount.key ?? "",
              underAccountLogin: widget.savedAccount.underUser ?? "",
            );
          } else {
            account = await api.login(
              accountId: widget.savedAccount.user ?? "",
              password: widget.savedAccount.key ?? "",
            );
          }
          if (account != null) {
/*             final HistoricProvider historicProvider =
                Provider.of<HistoricProvider>(context, listen: false); */
/*             final LastPositionProvider lastPositionProvider =
                Provider.of<LastPositionProvider>(context, listen: false);
            lastPositionProvider.fresh(); */
            shared.saveAccount(account);
/*             await fetchInitData(
                historicProvider: historicProvider,
                lastPositionProvider: lastPositionProvider,
                context: context); */
            setState(() => loading = false);
            ConnectedDeviceProvider connectedDeviceProvider =
                Provider.of(context, listen: false);
            connectedDeviceProvider.updateConnectedDevice(true);
            connectedDeviceProvider.createNewConnectedDeviceHistoric(true);
            Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
          } else {
            int? isActive = json.decode(await api.post(url: '/isactive', body: {
              'account_id': widget.savedAccount.user,
            }));

            if (isActive == -1) {
              loginProvider.errorText = 'Le propriétaire du compte peut avoir changé le mot de passe';
            } else if (isActive == 0) {
              loginProvider.errorText = 'Votre compte est suspendu';
            }
          }

          setState(() => loading = false);

/*           String src = await api.post(
              body: {
                'accountId': savedAccount.user,
                'userID': savedAccount.underUser,
              },
              url: '/profile',
              newHeader: {
                HttpHeaders.authorizationHeader: 'Bearer ${savedAccount.key}'
              });
          Account? account = accountFromMap(src);
          account!.token = savedAccount.key;
          final HistoricProvider historicProvider =
              Provider.of<HistoricProvider>(context, listen: false);
                        final LastPositionProvider lastPositionProvider =
              Provider.of<LastPositionProvider>(context, listen: false);
          shared.saveAccount(account);
          fetchInitData(historicProvider: historicProvider,lastPositionProvider: lastPositionProvider, context: context);
          nav.pushNamedAndRemoveUntil(Routes.customNavigationView); */
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (loading)
              const SizedBox(
                width: 12,
                height: 12,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            if (!loading)
              Icon(
                (widget.savedAccount.underUser == null ||
                        widget.savedAccount.underUser!.isEmpty)
                    ? Icons.person
                    : Icons.supervisor_account,
                size: 17,
              ),
            Text(
              widget.savedAccount.underUser!.isNotEmpty
                  ? widget.savedAccount.underUser!.toUpperCase()
                  : widget.savedAccount.user!.toUpperCase(),
            ),
            IconButton(
              iconSize: 16,
              icon: const Icon(Icons.close),
              onPressed: () => provider.deleteAcount(widget.savedAccount.user,
                  disableSetting: true),
            ),
          ],
        ),
      ),
    );
  }
}
