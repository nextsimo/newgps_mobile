// To parse this JSON data, do
//
//     final repportResumeModel = repportResumeModelFromJson(jsonString);

import 'dart:convert';

List<RepportResumeModel> repportResumeModelFromJson(String str) =>
    List<RepportResumeModel>.from(
        json.decode(str).map((x) => RepportResumeModel.fromJson(x)));

String repportResumeModelToJson(List<RepportResumeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RepportResumeModel {
  RepportResumeModel({
    required this.description,
    required this.lastOdometerKm,
    required this.lastValidSpeedKph,
    required this.deviceId,
    required this.lastGpsTimestamp,
    required this.lastValideDate,
    required this.distance,
    required this.maxSpeed,
    required this.carbNiveau,
    required this.stopedTime,
    required this.carbConsomation,
    required this.drivingTime,
    required this.index,
    required this.adresse,
    required this.city,
    required this.phone1,
    required this.phone2,
    required this.driverName,
    required this.drivingTimeBySeconds,
    required this.colorR,
    required this.colorG,
    required this.colorB,
    required this.statut
  });

  String description;
  double lastOdometerKm;
  int lastValidSpeedKph;
  String deviceId;
  int lastGpsTimestamp;
  DateTime lastValideDate;
  double distance;
  int maxSpeed;
  int carbNiveau;
  int stopedTime;
  double carbConsomation;
  String drivingTime;
  int drivingTimeBySeconds;
  int index;
  String adresse;
  String city;
  String phone1;
  String phone2;
  final String driverName;
  int colorR;
  int colorG;
  int colorB;
  String statut;

  factory RepportResumeModel.fromJson(Map<String, dynamic> json) =>
      RepportResumeModel(
        description: json["description"],
        lastOdometerKm: json["lastOdometerKM"].toDouble(),
        lastValidSpeedKph: json["lastValidSpeedKPH"],
        deviceId: json["deviceID"],
        lastGpsTimestamp: json["lastGpsTimestamp"],
        lastValideDate: DateTime.parse(json["lastValideDate"]),
        distance: json["distance"].toDouble(),
        maxSpeed: json["max_speed"],
        carbNiveau: json["carb_niveau"],
        stopedTime: json["stoped_time"],
        carbConsomation: json["carb_consomation"].toDouble(),
        drivingTime: json["driving_time"],
        index: json["index"],
        adresse: json["adresse"],
        city: json["city"],
        phone1: json["phone1"],
        phone2: json["phone2"],
        driverName: json["driverName"] ?? '',
        drivingTimeBySeconds: json['driving_time_by_seconds'],
        colorR: json['colorR'],
        colorG: json['colorG'],
        colorB: json['colorB'],
        statut: json['statut']
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "lastOdometerKM": lastOdometerKm,
        "lastValidSpeedKPH": lastValidSpeedKph,
        "deviceID": deviceId,
        "lastGPSTimestamp": lastGpsTimestamp,
        "lastValideDate": lastValideDate.toIso8601String(),
        "distance": distance,
        "max_speed": maxSpeed,
        "carb_niveau": carbNiveau,
        "stoped_time": stopedTime,
        "carb_consomation": carbConsomation,
        "driving_time": drivingTime,
        "index": index,
        "adresse": adresse,
        "city": city,
        "phone1": phone1,
        "phone2": phone2,
        "driverName": driverName,
      };
}
