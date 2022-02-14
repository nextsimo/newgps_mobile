// To parse this JSON data, do
//
//     final ImobilityAlertSettings = ImobilityAlertSettingsFromJson(jsonString);
import 'dart:convert';

ImobilityAlertSettings imobilityAlertSettingsFromJson(String str) =>
    ImobilityAlertSettings.fromJson(json.decode(str));

String imobilityAlertSettingsToJson(ImobilityAlertSettings data) =>
    json.encode(data.toJson());

class ImobilityAlertSettings {
  ImobilityAlertSettings({
    required this.accountId,
    required this.userId,
    required this.notificationId,
    required this.selectedDevices,
    required this.isActive,
    required this.id,
    required this.hours,
  });

  final int id;
  final String accountId;
  final String userId;
  final int notificationId;
  final List<String> selectedDevices;
  final bool isActive;
  final int hours;

  factory ImobilityAlertSettings.fromJson(Map<String, dynamic> json) =>
      ImobilityAlertSettings(
          accountId: json["account_id"],
          userId: json["user_id"],
          notificationId: json["notification_id"],
          selectedDevices: json["devices_id"].toString().split(','),
          isActive: json['is_active'],
          id: json['id'],
          hours: json['max_hours']);

  Map<String, dynamic> toJson() => {
        "account_id": accountId,
        "user_id": userId,
        "notification_id": notificationId,
        "devices_id": List<dynamic>.from(selectedDevices.map((x) => x)),
      };
}
