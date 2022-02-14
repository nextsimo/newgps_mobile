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
  });

  int notificationId;
  bool isActive;

  factory FuelNotifSetting.fromJson(Map<String, dynamic> json) =>
      FuelNotifSetting(
        notificationId: json["notifcation_id"],
        isActive: json["is_active"] == 1 ? true : false,
      );

  Map<String, dynamic> toJson() => {
        "notification_id": notificationId,
        "is_active": isActive,
      };
}
