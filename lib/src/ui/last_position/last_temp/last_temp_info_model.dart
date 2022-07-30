// To parse this JSON data, do
//
//     final temBleRepportModel = temBleRepportModelFromJson(jsonString);

import 'dart:convert';

TemBleRepportModel temBleRepportModelFromJson(String str) =>
    TemBleRepportModel.fromJson(json.decode(str));

String temBleRepportModelToJson(TemBleRepportModel data) =>
    json.encode(data.toJson());

class TemBleRepportModel {
  TemBleRepportModel({
    required this.id,
    required this.temperature1,
    required this.humidity1,
    required this.imei,
    required this.isActive,
    required this.timestamp,
    required this.createdAt,
    required this.updatedAt,
    required this.temperature2,
    required this.temperature3,
    required this.temperature4,
    required this.humidity2,
    required this.humidity3,
    required this.humidity4,
  });

  final int id;
  final int temperature1;
  final int humidity1;
  final String imei;
  final bool isActive;
  final int timestamp;
  final int createdAt;
  final int updatedAt;
  final int temperature2;
  final int temperature3;
  final int temperature4;
  final int humidity2;
  final int humidity3;
  final int humidity4;

  factory TemBleRepportModel.fromJson(Map<String, dynamic> json) =>
      TemBleRepportModel(
        id: json["id"],
        temperature1: json["temperature1"],
        humidity1: json["humidity1"],
        imei: json["imei"],
        isActive: json["is_active"],
        timestamp: json["timestamp"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        temperature2: json["temperature2"],
        temperature3: json["temperature3"],
        temperature4: json["temperature4"],
        humidity2: json["humidity2"],
        humidity3: json["humidity3"],
        humidity4: json["humidity4"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "temperature1": temperature1,
        "humidity1": humidity1,
        "imei": imei,
        "is_active": isActive,
        "timestamp": timestamp,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "temperature2": temperature2,
        "temperature3": temperature3,
        "temperature4": temperature4,
        "humidity2": humidity2,
        "humidity3": humidity3,
        "humidity4": humidity4,
      };
}
