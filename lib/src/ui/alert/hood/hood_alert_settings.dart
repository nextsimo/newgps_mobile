// To parse this JSON data, do
//
//     final HoodAlertSettings = HoodAlertSettingsFromJson(jsonString);
import 'dart:convert';

HoodAlertSettings hoodAlertSettingsFromJson(String str) =>
    HoodAlertSettings.fromJson(json.decode(str));

String hoodAlertSettingsToJson(HoodAlertSettings data) =>
    json.encode(data.toJson());

class HoodAlertSettings {
  HoodAlertSettings({
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

  factory HoodAlertSettings.fromJson(Map<String, dynamic> json) =>
      HoodAlertSettings(
          accountId: json["account_id"],
          userId: json["user_id"],
          notificationId: json["notification_id"],
          selectedDevices: json["devices_id"].toString().split(','),
          isActive: json['is_active'],
          id: json['id']);

  Map<String, dynamic> toJson() => {
        "account_id": accountId,
        "user_id": userId,
        "notification_id": notificationId,
        "devices_id": List<dynamic>.from(selectedDevices.map((x) => x)),
      };
}
