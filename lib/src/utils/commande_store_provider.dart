import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:newgps/src/services/newgps_service.dart';

import '../models/device.dart';

class CommandeStoreProvider {
  final String startCommande = 'start-device';
  final String stopCommande = 'stop-device';

  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  // save the commande in the sercver
  Future<void> saveCommandeHisto(Device device, String commande) async {
    var description = '';
    if (commande == startCommande) {
      description = "Démarrage du boitier";
    } else if (commande == stopCommande) {
      description = "Arrêt du boitier";
    }
    var account = shared.getAccount();
    var deviceInfo = await _getDeviceInfo();
    String? phoneNumber = "**";
    if (Platform.isAndroid) {
      // request permission
      await MobileNumber.requestPhonePermission;
      if (await MobileNumber.hasPhonePermission) {
        phoneNumber = await MobileNumber.mobileNumber;
      }
    }

    var body = {
      'account_id': account?.account.accountId,
      'user_id': account?.account.userID ?? "**",
      'device_id': device.deviceId,
      'commande': commande,
      'commande_description': description,
      'commande_date': DateTime.now().toString(),
      'device_description':
          "${deviceInfo['device_brand']}, ${deviceInfo['platform']}, ${deviceInfo['os']}",
      'gps_device_description': device.description,
      'phone_number': phoneNumber ?? "**",
    };

    await api.post(url: '/commande/store', body: body);
  }

  Future<Map<String, String?>> _getDeviceInfo() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo info = await _deviceInfo.androidInfo;
      return {
        'device_brand': info.brand,
        'platform': 'android',
        'device_uid': info.androidId,
        'os': info.version.release
      };
    } else {
      IosDeviceInfo info = await _deviceInfo.iosInfo;
      return {
        'device_brand': info.name,
        'platform': 'ios',
        'device_uid': info.identifierForVendor,
        'os': info.systemVersion,
      };
    }
  }
}
