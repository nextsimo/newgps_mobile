// To parse this JSON data, do
//
//     final batteryNotifcationHistoric = batteryNotifcationHistoricFromJson(jsonString);

import 'dart:convert';

List<BatteryNotifcationHistoric> batteryNotifcationHistoricFromJson(
        String str) =>
    List<BatteryNotifcationHistoric>.from(
        json.decode(str).map((x) => BatteryNotifcationHistoric.fromJson(x)));

String batteryNotifcationHistoricToJson(
        List<BatteryNotifcationHistoric> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BatteryNotifcationHistoric {
  BatteryNotifcationHistoric({
    required this.description,
    required this.notificationId,
    required this.deviceName,
    required this.isBatteryDown,
    required this.isIntern,
    required this.date,
  });

  String description;
  int notificationId;
  String deviceName;
  bool isBatteryDown;
  bool isIntern;
  String date;

  factory BatteryNotifcationHistoric.fromJson(Map<String, dynamic> json) =>
      BatteryNotifcationHistoric(
        description: json["description"],
        notificationId: json["notification_id"],
        deviceName: json["device_name"],
        isBatteryDown: json["is_battery_down"] == 1 ? true : false,
        isIntern: json["is_intern"] == 1 ? true : false,
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "notification_id": notificationId,
        "device_name": deviceName,
        "is_battery_down": isBatteryDown,
        "is_intern": isIntern,
        "date": date,
      };
}
