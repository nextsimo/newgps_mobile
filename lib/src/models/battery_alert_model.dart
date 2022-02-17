

import 'dart:convert';

BatteryNotifcationSetting batteryNotifcationSettingFromJson(String str) =>
    BatteryNotifcationSetting.fromJson(json.decode(str));

String batteryNotifcationSettingToJson(BatteryNotifcationSetting data) =>
    json.encode(data.toJson());

class BatteryNotifcationSetting {
  BatteryNotifcationSetting({
    required this.isActive,
    required this.notificationId,
    required this.id,
    required this.selectedDevices
  });

  bool isActive;
  int notificationId;
  int id;
  final List<String> selectedDevices;

  factory BatteryNotifcationSetting.fromJson(Map<String, dynamic> json) =>
      BatteryNotifcationSetting(
        isActive: json["is_active"],
        notificationId: json["notification_id"],
        id: json['id'],
        selectedDevices: json["devices"].toString().split(','),
      );

  Map<String, dynamic> toJson() => {
        "is_active": isActive,
        "notification_id": notificationId,
      };
}
