// To parse this JSON data, do
//
//     final speedAlertSettings = speedAlertSettingsFromJson(jsonString);

import 'dart:convert';

SpeedAlertSettings speedAlertSettingsFromJson(String str) => SpeedAlertSettings.fromJson(json.decode(str));

String speedAlertSettingsToJson(SpeedAlertSettings data) => json.encode(data.toJson());

class SpeedAlertSettings {
    SpeedAlertSettings({
        required this.id,
        required this.maxSpeed,
        required this.isActive,
    });

    int id;
    int maxSpeed;
    bool isActive;

    factory SpeedAlertSettings.fromJson(Map<String, dynamic> json) => SpeedAlertSettings(
        id: json["id"],
        maxSpeed: json["max_speed"],
        isActive: json["is_active"] == 1 ? true : false,
    );

    Map<String, dynamic> toJson() => {
        "id": id,
         "max_speed": maxSpeed,
        "is_active": isActive,
    };
}
