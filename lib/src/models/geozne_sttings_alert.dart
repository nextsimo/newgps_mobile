// To parse this JSON data, do
//
//     final geozoneSttingsAlert = geozoneSttingsAlertFromJson(jsonString);

import 'dart:convert';

GeozoneSttingsAlert geozoneSttingsAlertFromJson(String str) =>
    GeozoneSttingsAlert.fromJson(json.decode(str));

String geozoneSttingsAlertToJson(GeozoneSttingsAlert data) =>
    json.encode(data.toJson());

class GeozoneSttingsAlert {
  GeozoneSttingsAlert({
    required this.id,
    required this.notificationId,
    required this.isActive,
  });

  int id;
  int notificationId;
  bool isActive;

  factory GeozoneSttingsAlert.fromJson(Map<String, dynamic> json) =>
      GeozoneSttingsAlert(
        id: json["id"],
        notificationId: json["notification_id"],
        isActive: json["is_active"] == 0 ? false : true,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "notification_id": notificationId,
        "is_active": isActive,
      };
}
