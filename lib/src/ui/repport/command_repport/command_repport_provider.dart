import 'dart:developer';
import 'package:flutter/material.dart';
import '../../../models/account.dart';
import '../../../services/newgps_service.dart';
import '../rapport_provider.dart';
import 'command_repport_model.dart';

class CommandTripProvider with ChangeNotifier {
  List<CommandRepportModel> commands = [];

  late RepportProvider repportProvider;
  CommandTripProvider(RepportProvider provider) {
    repportProvider = provider;
  }

  Future<void> fetchCommands(String deviceId, String orderBy) async {
    Account? account = shared.getAccount();
    String str = await api.post(
      url: '/repport/trips',
      body: {
        'account_id': account?.account.accountId,
        'device_id': deviceId,
        'date_from': repportProvider.dateFrom.millisecondsSinceEpoch / 1000,
        'date_to': repportProvider.dateTo.millisecondsSinceEpoch / 1000,
        'download': false,
        'order_by': orderBy,
      },
    );

    log("fetch Commands: $str");
  }
}
