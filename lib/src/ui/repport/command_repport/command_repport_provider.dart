import 'package:flutter/material.dart';
import '../../../models/account.dart';
import '../../../services/newgps_service.dart';
import '../rapport_provider.dart';
import 'command_repport_model.dart';

class CommandRepportProvider with ChangeNotifier {
  List<CommandRepportModel> commands = [];

  late RepportProvider repportProvider;
  CommandRepportProvider(RepportProvider provider) {
    repportProvider = provider;
  }

  Future<void> fetchCommands(String deviceId, [bool all = false]) async {
    Account? account = shared.getAccount();
    String str = await api.post(
      url: '/commande/rapport',
      body: {
        'account_id': account?.account.accountId,
        'device_id': deviceId,
        'all': all,
        'date_from': "${repportProvider.dateFrom}",
        'date_to': "${repportProvider.dateTo}",
      },
    );

    if (str.isNotEmpty) {
      commands = commandRepportModelFromJson(str);
      notifyListeners();
    }
  }
}
