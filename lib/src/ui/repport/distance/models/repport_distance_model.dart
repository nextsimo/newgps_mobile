// To parse this JSON data, do
//
//     final repportDistanceModel = repportDistanceModelFromJson(jsonString);

import 'dart:convert';

RepportDistanceModel repportDistanceModelFromJson(String str) =>
    RepportDistanceModel.fromJson(json.decode(str));

String repportDistanceModelToJson(RepportDistanceModel data) =>
    json.encode(data.toJson());

class RepportDistanceModel {
  RepportDistanceModel({
    required this.distanceSum,
    required this.repports,
  });

   int distanceSum;
   List<Repport> repports;

  factory RepportDistanceModel.fromJson(Map<String, dynamic> json) =>
      RepportDistanceModel(
        distanceSum: json["distance_sum"],
        repports: List<Repport>.from(
            json["repports"].map((x) => Repport.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "distance_sum": distanceSum,
        "repports": List<dynamic>.from(repports.map((x) => x.toJson())),
      };
}

class Repport {
  Repport({
    required this.description,
    required this.startKm,
    required this.endKm,
    required this.distance,
    required this.date,
  });

  final String description;
  final int startKm;
  final int endKm;
  final int distance;
  final DateTime date;

  factory Repport.fromJson(Map<String, dynamic> json) => Repport(
        description: json["description"],
        startKm: json["start_km"],
        endKm: json["end_km"],
        distance: json["distance"],
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "start_km": startKm,
        "end_km": endKm,
        "distance": distance,
      };
}
