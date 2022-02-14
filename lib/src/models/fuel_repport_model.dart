// To parse this JSON data, do
//
//     final fuelRepportData = fuelRepportDataFromJson(jsonString);

import 'dart:convert';

List<FuelRepportData> fuelRepportDataFromJson(String str) =>
    List<FuelRepportData>.from(
        json.decode(str).map((x) => FuelRepportData.fromJson(x)));

String fuelRepportDataToJson(List<FuelRepportData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FuelRepportData {
  FuelRepportData({
    required this.date,
    required this.carbConsomation,
    required this.distance,
    required this.carbConsomation100,
    required this.drivingTime,
    required this.drivingTimeBySeconds,
    required this.odometerKM,
  });

  DateTime date;
  double carbConsomation;
  double carbConsomation100;
  String drivingTime;
  int drivingTimeBySeconds;
  double distance;
  double odometerKM;

  factory FuelRepportData.fromJson(Map<String, dynamic> json) =>
      FuelRepportData(
        odometerKM: json['odometerKM'].toDouble(),
        date: DateTime.parse(json["date"]),
        carbConsomation: json["carb_consomation"].toDouble(),
        distance: json["distance"].toDouble(),
        drivingTime: json["driving_time"],
        carbConsomation100: json["carb_consomation_100"].toDouble(),
        drivingTimeBySeconds: json["driving_time_by_seconds"],
      );

  Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
        "carb_consomation": carbConsomation,
        "distance": distance,
      };
}
