// To parse this JSON data, do
//
//     final fuelNotifHistoric = fuelNotifHistoricFromJson(jsonString);

import 'dart:convert';

List<FuelNotifHistoric> fuelNotifHistoricFromJson(String str) =>
    List<FuelNotifHistoric>.from(
        json.decode(str).map((x) => FuelNotifHistoric.fromJson(x)));

String fuelNotifHistoricToJson(List<FuelNotifHistoric> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FuelNotifHistoric {
  FuelNotifHistoric({
    required this.id,
    required this.notificationId,
    required this.deviceId,
    required this.deviceName,
    required this.address,
    required this.latitude,
    required this.fuelValue1,
    required this.fuelValue2,
    required this.longitude,
    required this.accountId,
    required this.createdAt,
    required this.updatedAt,
    required this.date,
  });

  int id;
  int notificationId;
  String deviceId;
  String deviceName;
  String address;
  double latitude;
  num fuelValue1;
  num fuelValue2;
  double longitude;
  String accountId;
  DateTime createdAt;
  DateTime updatedAt;
  String date;

  factory FuelNotifHistoric.fromJson(Map<String, dynamic> json) =>
      FuelNotifHistoric(
        id: json["id"],
        notificationId: json["notification_id"],
        deviceId: json["device_id"],
        deviceName: json["device_name"],
        address: json["address"],
        latitude: json["latitude"].toDouble(),
        fuelValue1: json["fuel_value_1"],
        fuelValue2: json["fuel_value_2"].toDouble(),
        longitude: json["longitude"].toDouble(),
        accountId: json["account_id"],
        date: json["date"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "notification_id": notificationId,
        "device_id": deviceId,
        "device_name": deviceName,
        "address": address,
        "latitude": latitude,
        "fuel_value_1": fuelValue1,
        "fuel_value_2": fuelValue2,
        "longitude": longitude,
        "account_id": accountId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
