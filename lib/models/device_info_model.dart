// To parse this JSON data, do
//
//     final deviceInfoModel = deviceInfoModelFromJson(jsonString);
import 'dart:convert';

import 'package:latlong2/latlong.dart';

List<DeviceInfoModel> deviceInfoModelFromJson(String str) =>
    List<DeviceInfoModel>.from(
        json.decode(str).map((x) => DeviceInfoModel.fromJson(x)));

String deviceInfoModelToJson(List<DeviceInfoModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DeviceInfoModel {
  DeviceInfoModel({
    required this.startDate,
    required this.endDate,
    required this.distance,
    required this.startAddress,
    required this.endAddress,
    required this.timeStr,
    required this.type,
    required this.maxSpeed,
    required this.consumption,
    required this.latitude,
    required this.longitude,
    required this.heading,
    required this.points,
    required this.maxSpeedLatitude,
    required this.maxSpeedLongitude,

  });

  final DateTime startDate;
  final DateTime endDate;
  final double distance;
  final String startAddress;
  final String endAddress;
  final String timeStr;
  final int type;
  final double maxSpeed;
  final double consumption;
  final double latitude;
  final double longitude;
  final double heading;
  final List<LatLng> points;
  final double maxSpeedLatitude;
  final double maxSpeedLongitude;


  factory DeviceInfoModel.fromJson(Map<String, dynamic> json) =>
      DeviceInfoModel(
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        distance: json["distance"].toDouble(),
        startAddress: json["start_address"],
        endAddress: json["end_address"],
        timeStr: json["time_str"],
        type: json["type"],
        maxSpeed: json["max_speed"].toDouble(),
        consumption: json["consumption"].toDouble(),
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        heading: json["heading"].toDouble(),
        points:
            List<LatLng>.from(json["points"].map((x) => LatLng(x[0], x[1]))),
        maxSpeedLatitude: json["max_speed_latitude"].toDouble(),
        maxSpeedLongitude: json["max_speed_longitude"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "distance": distance,
        "start_address": startAddress,
        "end_address": endAddress,
        "time_str": timeStr,
        "type": type,
        "max_speed": maxSpeed,
        "consumption": consumption,
      };
}
