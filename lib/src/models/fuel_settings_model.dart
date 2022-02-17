// To parse this JSON data, do
//
//     final fuelNotifSetting = fuelNotifSettingFromJson(jsonString);

import 'dart:convert';

FuelNotifSetting fuelNotifSettingFromJson(String str) =>
    FuelNotifSetting.fromJson(json.decode(str));

String fuelNotifSettingToJson(FuelNotifSetting data) =>
    json.encode(data.toJson());

class FuelNotifSetting {
  FuelNotifSetting({
    required this.notificationId,
    required this.isActive,
    required this.selectedDevices,
    required this.id,
  });

  int notificationId;
  bool isActive;
  final int id;
  final List<String> selectedDevices;

  factory FuelNotifSetting.fromJson(Map<String, dynamic> json) =>
      FuelNotifSetting(
        notificationId: json["notifcation_id"],
        isActive: json["is_active"],
        selectedDevices: json["devices"].toString().split(','),
        id: json["id"]
      );

  Map<String, dynamic> toJson() => {
        "notification_id": notificationId,
        "is_active": isActive,
      };
}
