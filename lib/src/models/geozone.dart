// To parse this JSON data, do
//
//     final geozoneModel = geozoneModelFromJson(jsonString);

import 'dart:convert';

List<GeozoneModel> geozoneModelFromJson(String str) => List<GeozoneModel>.from(
    json.decode(str).map((x) => GeozoneModel.fromJson(x)));

String geozoneModelToJson(List<GeozoneModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GeozoneModel {
  GeozoneModel({
    required this.cordinates,
    required this.geozoneId,
    required this.innerOuterValue,
    required this.radius,
    required this.zoneType,
    required this.mapImage,
    required this.description,
    required this.devices,
  });

  List<List<double>> cordinates;
  String geozoneId;
  int innerOuterValue;
  num radius;
  int zoneType;
  String mapImage;
  String description;
  final List<String> devices;

  factory GeozoneModel.fromJson(Map<String, dynamic> json) => GeozoneModel(
        cordinates: List<List<double>>.from(json["cordinates"]
            .map((x) => List<double>.from(x.map((x) => x.toDouble())))),
        geozoneId: json["geozoneID"],
        innerOuterValue: json["innerOuterValue"],
        radius: json["radius"],
        zoneType: json["zoneType"],
        mapImage: json["map_image"],
        description: json["description"],
        devices: List<String>.from(json['devices'].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "cordinates": List<dynamic>.from(
            cordinates.map((x) => List<dynamic>.from(x.map((x) => x)))),
        "geozoneID": geozoneId,
        "innerOuterValue": innerOuterValue,
        "radius": radius,
        "zoneType": zoneType,
        "map_image": mapImage,
        "description": description,
      };
}
