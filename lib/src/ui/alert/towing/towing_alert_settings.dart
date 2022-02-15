// To parse this JSON data, do
//
//     final TowingAlertSetting = TowingAlertSettingFromJson(jsonString);
import 'dart:convert';

TowingAlertSetting towingAlertSettingFromJson(String str) =>
    TowingAlertSetting.fromJson(json.decode(str));

String towingAlertSettingToJson(TowingAlertSetting data) =>
    json.encode(data.toJson());

class TowingAlertSetting {
  TowingAlertSetting({
    required this.accountId,
    required this.userId,
    required this.notificationId,
    required this.selectedDevices,
    required this.isActive,
    required this.id,
  });

  final int id;
  final String accountId;
  final String userId;
  final int notificationId;
  final List<String> selectedDevices;
  final bool isActive;

  factory TowingAlertSetting.fromJson(Map<String, dynamic> json) =>
      TowingAlertSetting(
        accountId: json["account_id"],
        userId: json["user_id"],
        notificationId: json["notification_id"],
        selectedDevices:  json["selected_devices"].toString().split(','),
        isActive: json['is_active'],
        id: json['id']
      );

  Map<String, dynamic> toJson() => {
        "account_id": accountId,
        "user_id": userId,
        "notification_id": notificationId,
        "selected_devices": List<dynamic>.from(selectedDevices.map((x) => x)),
      };
}
