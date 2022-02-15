// To parse this JSON data, do
//
//     final settingPerDevice = settingPerDeviceFromJson(jsonString);

import 'dart:convert';

SettingPerDevice settingPerDeviceFromJson(String str) =>
    SettingPerDevice.fromJson(json.decode(str));

String settingPerDeviceToJson(SettingPerDevice data) =>
    json.encode(data.toJson());

class SettingPerDevice {
  SettingPerDevice({
    required this.isActive,
    required this.nextOilChange,
    required this.alertBefor,
    required this.deviceId,
  });

  final bool isActive;
  final double nextOilChange;
  final double alertBefor;
  final String deviceId;

  factory SettingPerDevice.fromJson(Map<String, dynamic> json) =>
      SettingPerDevice(
        isActive: json["is_active"],
        nextOilChange: json["next_oil_change"].toDouble(),
        alertBefor: json["alert_befor"].toDouble(),
        deviceId: json["device_id"],
      );

  Map<String, dynamic> toJson() => {
        "is_active": isActive,
        "next_oil_change": nextOilChange,
        "alert_befor": alertBefor,
        "device_id": deviceId,
      };
}
