import 'dart:convert';

List<CommandRepportModel> commandRepportModelFromJson(String str) =>
    List<CommandRepportModel>.from(
        json.decode(str).map((x) => CommandRepportModel.fromJson(x)));

class CommandRepportModel {
  CommandRepportModel({
    required this.commandeDescription,
    required this.commandeDate,
    required this.deviceDescription,
    required this.phoneNumber,
    required this.userId,
    required this.gpsDeviceDescription,
  });

  final String commandeDescription;
  final DateTime commandeDate;
  final String deviceDescription;
  final String phoneNumber;
  final String userId;
  final String gpsDeviceDescription;

  factory CommandRepportModel.fromJson(Map<String, dynamic> json) =>
      CommandRepportModel(
        commandeDescription: json["commande_description"],
        commandeDate: DateTime.parse(json["commande_date"]),
        deviceDescription: json["device_description"],
        phoneNumber: json["phone_number"],
        userId: json["user_id"],
        gpsDeviceDescription: json["gps_device_description"],
      );
}
