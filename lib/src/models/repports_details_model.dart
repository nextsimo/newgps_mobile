// To parse this JSON data, do
//
//     final repportDetailsPaginateModel = repportDetailsPaginateModelFromJson(jsonString);

import 'dart:convert';

RepportDetailsPaginateModel repportDetailsPaginateModelFromJson(String str) =>
    RepportDetailsPaginateModel.fromJson(json.decode(str));

String repportDetailsPaginateModelToJson(RepportDetailsPaginateModel data) =>
    json.encode(data.toJson());

class RepportDetailsPaginateModel {
  RepportDetailsPaginateModel({
    this.currentPage = 0,
    required this.repportsDetailsModel,
    this.lastPage = 0,
    this.perPage = 0,
    this.total = 0,
  });

  int currentPage;
  List<RepportsDetailsModel> repportsDetailsModel;
  int lastPage;
  int perPage;
  int total;

  factory RepportDetailsPaginateModel.fromJson(Map<String, dynamic> json) =>
      RepportDetailsPaginateModel(
        currentPage: json["current_page"],
        repportsDetailsModel: List<RepportsDetailsModel>.from(
            json["data"].map((x) => RepportsDetailsModel.fromJson(x))),
        lastPage: json["last_page"],
        perPage: json["per_page"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(repportsDetailsModel.map((x) => x.toJson())),
        "last_page": lastPage,
        "per_page": perPage,
        "total": total,
      };
}

class RepportsDetailsModel {
  RepportsDetailsModel({
    required this.timestamp,
    required this.address,
    required this.speedKph,
    required this.fuelRemain,
    required this.fuelLevel,
    required this.fuelTotal,
    required this.heading,
    required this.colorR,
    required this.colorG,
    required this.colorB,
    required this.statut,
    required this.odometerKM,
  });

  DateTime timestamp;
  String address;
  int speedKph;
  int fuelRemain;
  double fuelLevel;
  double fuelTotal;
  int heading;
  int colorR;
  int colorG;
  int colorB;
  String statut;
  double odometerKM;

  factory RepportsDetailsModel.fromJson(Map<String, dynamic> json) =>
      RepportsDetailsModel(
        timestamp: DateTime.parse(json["timestamp"]),
        address: json["address"],
        speedKph: json["speedKPH"],
        fuelRemain: json["fuelRemain"].toInt(),
        fuelLevel: json["FuelLevel"].toDouble(),
        fuelTotal: json["FuelTotal"].toDouble(),
        heading: json["heading"],
        colorR: json["colorR"],
        colorG: json["colorG"],
        colorB: json["colorB"],
        statut: json["statut"],
        odometerKM: json["odometerKM"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "timestamp": timestamp,
        "address": address,
        "speedKPH": speedKph,
        "fuelRemain": fuelRemain,
        "FuelLevel": fuelLevel,
        "FuelTotal": fuelTotal,
        "heading": heading,
        "colorR": colorR,
        "colorG": colorG,
        "colorB": colorB,
        "statut": statut,
        "odometerKM": odometerKM,
      };
}
