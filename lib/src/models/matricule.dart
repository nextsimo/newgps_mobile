// To parse this JSON data, do
//
//     final matriculeModel = matriculeModelFromJson(jsonString);

import 'dart:convert';

List<MatriculeModel> matriculeModelFromJson(String str) =>
    List<MatriculeModel>.from(
        json.decode(str).map((x) => MatriculeModel.fromJson(x)));

String matriculeModelToJson(List<MatriculeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MatriculeModel {
  MatriculeModel({
    required this.vehicleId,
    required this.description,
    required this.lastOdometerKM,
    required this.fuelCapacity,
    required this.vehicleColor,
    required this.vehicleModel,
    required this.phone1,
    required this.phone2,
    required this.driverName,
    required this.index,
    required this.deviceID,
  });

   String vehicleId;
  String description;
  double lastOdometerKM;
  int fuelCapacity;
  String vehicleColor;
  String vehicleModel;
  String phone1;
  String phone2;
  String driverName;
  final int index;
  final String deviceID;

  factory MatriculeModel.fromJson(Map<String, dynamic> json) => MatriculeModel(
      vehicleId: json["vehicleID"],
      description: json["description"],
      lastOdometerKM: json["lastOdometerKM"].toDouble(),
      fuelCapacity: json["fuelCapacity"],
      vehicleColor: json["vehicleColor"],
      vehicleModel: json["vehicleModel"],
      phone1: json["phone1"],
      phone2: json["phone2"],
      driverName: json["driverName"] ?? '',
      index: json["index"],
      deviceID: json["deviceID"]);

  Map<String, dynamic> toJson() => {
        "vehicleID": vehicleId,
        "description": description,
        "lastOdometerKM": lastOdometerKM,
        "fuelCapacity": fuelCapacity,
        "vehicleColor": vehicleColor,
        "vehicleModel": vehicleModel,
        "phone1": phone1,
        "phone2": phone2,
        "driverName": driverName,
        "deviceID": deviceID
      };
}
