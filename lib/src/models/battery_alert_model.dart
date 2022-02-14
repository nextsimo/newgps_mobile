

import 'dart:convert';

BatteryNotifcationSetting batteryNotifcationSettingFromJson(String str) =>
    BatteryNotifcationSetting.fromJson(json.decode(str));

String batteryNotifcationSettingToJson(BatteryNotifcationSetting data) =>
    json.encode(data.toJson());

class BatteryNotifcationSetting {
  BatteryNotifcationSetting({
    required this.isActive,
    required this.notificationId,
  });

  bool isActive;
  int notificationId;

  factory BatteryNotifcationSetting.fromJson(Map<String, dynamic> json) =>
      BatteryNotifcationSetting(
        isActive: json["is_active"] == 1 ? true : false,
        notificationId: json["notification_id"],
      );

  Map<String, dynamic> toJson() => {
        "is_active": isActive,
        "notification_id": notificationId,
      };
}
