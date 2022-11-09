// To parse this JSON data, do
//
//     final infoModel = infoModelFromJson(jsonString);

import 'dart:convert';

InfoModel infoModelFromJson(String str) => InfoModel.fromJson(json.decode(str));

String infoModelToJson(InfoModel data) => json.encode(data.toJson());

class InfoModel {
  InfoModel({
    required this.distance,
    required this.maxSpeed,
    required this.odometer,
    required this.carbNiveau,
    required this.stopedTime,
    required this.carbConsomation,
    required this.drivingTime,
    required this.lastUpdate,
  });

  double distance;
  double maxSpeed;
  double odometer;
  double carbNiveau;
  int stopedTime;
  double carbConsomation;
  String drivingTime;
  DateTime lastUpdate;

  factory InfoModel.fromJson(Map<String, dynamic> json) => InfoModel(
        distance: json["distance"].toDouble(),
        maxSpeed: json["max_speed"].toDouble(),
        odometer: json["odometer"].toDouble(),
        carbNiveau: json["carb_niveau"].toDouble(),
        stopedTime: json["stoped_time"],
        carbConsomation: json["carb_consomation"].toDouble(),
        drivingTime: json["driving_time"],
        lastUpdate: DateTime.fromMillisecondsSinceEpoch(json["date"] * 1000),
      );

  Map<String, dynamic> toJson() => {
        "distance": distance,
        "max_speed": maxSpeed,
        "odometer": odometer,
        "carb_niveau": carbNiveau,
        "stoped_time": stopedTime,
        "carb_consomation": carbConsomation,
        "driving_time": drivingTime,
      };
}
