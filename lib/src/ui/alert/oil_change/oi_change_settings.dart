// To parse this JSON data, do
//
//     final OilChangeAlertSettings = OilChangeAlertSettingsFromJson(jsonString);
import 'dart:convert';

OilChangeAlertSettings oilChangeAlertSettingsFromJson(String str) =>
    OilChangeAlertSettings.fromJson(json.decode(str));

String oilChangeAlertSettingsToJson(OilChangeAlertSettings data) =>
    json.encode(data.toJson());

class OilChangeAlertSettings {
  OilChangeAlertSettings({
    required this.accountId,
    required this.userId,
    required this.notificationId,
    required this.isActive,
    required this.id,
  });

  final int id;
  final String accountId;
  final String userId;
  final int notificationId;
  final bool isActive;

  factory OilChangeAlertSettings.fromJson(Map<String, dynamic> json) =>
      OilChangeAlertSettings(
          accountId: json["account_id"],
          userId: json["user_id"],
          notificationId: json["notification_id"],
          isActive: json['is_active'],
          id: json['id']);

  Map<String, dynamic> toJson() => {
        "account_id": accountId,
        "user_id": userId,
        "notification_id": notificationId,
      };
}
