import 'dart:convert';

import 'package:http/http.dart';
import 'package:newgps/src/services/newgps_service.dart';

import '../src/models/device.dart';

class DevicesRepository {
  // fetch devices from API with pagination
   Future<Map<String, dynamic>> fetchDevices(
      {required int page, required numberOfDevice})  async {
    try {
      final Response response = await api.postResponse(
        url: '/devices/paginate',
        body: {
          'page': '$page',
          'limit': '$numberOfDevice',
          'accountId': shared.getAccount()?.account.accountId,
        },
      );
      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        return {
          'devices': deviceFromMap(jsonEncode(res['data'])),
          'current_page': res['current_page'],
          'total_page': res['total_page'],
        };
      } else {
        throw Exception(
            'Failed to load devices from API ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
