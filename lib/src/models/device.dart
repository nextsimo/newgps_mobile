// To parse this JSON data, do
//
//     final device = deviceFromMap(jsonString);

import 'dart:convert';

List<Device> deviceFromMap(String str) =>
    List<Device>.from(json.decode(str).map((x) => Device.fromMap(x)));

String deviceToMap(List<Device> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Device {
  Device({
    required this.markerText,
    required this.description,
    required this.deviceId,
    required this.dateTime,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.distanceKm,
    required this.odometerKm,
    required this.city,
    required this.heading,
    required this.speedKph,
    required this.index,
    required this.colorR,
    required this.colorG,
    required this.colorB,
    required this.statut,
    required this.markerPng,
    required this.phone1,
    required this.phone2,
    required this.markerTextPng,
    this.equipmentType = '',
    required this.deviceIcon,
    this.batteryLevel = 0,
    this.signalStrength = 0,
  });

  final String description;
  final String deviceId;
  final DateTime dateTime;
  final double latitude;
  final double longitude;
  final String address;
  final double distanceKm;
  final double odometerKm;
  final String city;
  final int heading;
  final int speedKph;
  final int index;
  final int colorR;
  final int colorG;
  final int colorB;
  final String statut;
  final String markerPng;
  final String markerText;
  final String phone1;
  final String phone2;
  final String markerTextPng;
  final String equipmentType;
  final String deviceIcon;
  final double batteryLevel;
  final int signalStrength;

  factory Device.fromMap(Map<String, dynamic> json) {
    return Device(
      description: json["description"],
      deviceId: json["DeviceID"],
      deviceIcon: json["deviceIcon"] ?? 'default',
      dateTime: DateTime.fromMillisecondsSinceEpoch(json["timestamp"] * 1000),
      latitude: json["latitude"].toDouble(),
      longitude: json["longitude"].toDouble(),
      address: json["address"],
      distanceKm: json["distanceKM"].toDouble(),
      odometerKm: json["odometerKM"].toDouble(),
      city: json["city"],
      heading: json["heading"],
      speedKph: json["speedKPH"],
      index: json["index"],
      colorR: json["colorR"],
      colorG: json["colorG"],
      colorB: json["colorB"],
      statut: json["statut"],
      markerPng: json["marker_png"],
      markerText: json["marker_text"] ?? '',
      phone1: json["phone1"] ?? '',
      phone2: json["phone2"] ?? '',
      markerTextPng: json["marker_text_png"],
      equipmentType: json['equipmentType'] ?? '',
      batteryLevel: (json['batteryLevel'] ?? 0).toDouble(),
      signalStrength: json['signalStrength'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        "description": description,
        "DeviceID": deviceId,
        "timestamp": dateTime,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
        "distanceKM": distanceKm,
        "odometerKM": odometerKm,
        "city": city,
        "heading": heading,
        "speedKPH": speedKph,
        "index": index,
        "colorR": colorR,
        "colorG": colorG,
        "colorB": colorB,
        "statut": statut,
        "marker_png": markerPng,
      };
}
