// To parse this JSON data, do
//
//     final tripsRepport = tripsRepportFromJson(jsonString);

import 'dart:convert';

List<TripsRepport> tripsRepportFromJson(String str) => List<TripsRepport>.from(
    json.decode(str).map((x) => TripsRepport.fromJson(x)));

String tripsRepportToJson(List<TripsRepport> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TripsRepport {
  TripsRepport({
    required this.startDate,
    required this.endDate,
    required this.drivingTime,
    required this.distance,
    required this.odometer,
    required this.startAddress,
    required this.endAddress,
  });

  DateTime startDate;
  DateTime endDate;
  String drivingTime;
  double distance;
  double odometer;
  String startAddress;
  String endAddress;

  factory TripsRepport.fromJson(Map<String, dynamic> json) => TripsRepport(
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        drivingTime: json["driving_time"],
        distance: json["distance"].toDouble(),
        odometer: json["odometer"].toDouble(),
        startAddress: json["start_address"],
        endAddress: json["end_address"],
      );

  Map<String, dynamic> toJson() => {
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "driving_time": drivingTime,
        "distance": distance,
        "odometer": odometer,
        "start_address": startAddress,
        "end_address": endAddress,
      };
}
