// To parse this JSON data, do
//
//     final speedAlertSettings = speedAlertSettingsFromJson(jsonString);

import 'dart:convert';
SpeedAlertSettings speedAlertSettingsFromJson(String str) =>
    SpeedAlertSettings.fromJson(json.decode(str));

String speedAlertSettingsToJson(SpeedAlertSettings data) =>
    json.encode(data.toJson());

class SpeedAlertSettings {
  SpeedAlertSettings({
    required this.id,
    required this.maxSpeed,
    required this.isActive,
  });

  int id;
  int maxSpeed;
  bool isActive;

  factory SpeedAlertSettings.fromJson(Map<String, dynamic> json) =>
      SpeedAlertSettings(
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


SpeedAlertSetting1 speedAlertSetting1FromJson(String str) => SpeedAlertSetting1.fromJson(json.decode(str));

String speedAlertSetting1ToJson(SpeedAlertSetting1 data) => json.encode(data.toJson());

class SpeedAlertSetting1 {
    SpeedAlertSetting1({
        required this.isActive,
        required this.options,
    });

    final bool isActive;
    final List<Option> options;

    factory SpeedAlertSetting1.fromJson(Map<String, dynamic> json) => SpeedAlertSetting1(
        isActive: json["is_active"],
        options: List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "is_active": isActive,
        "options": List<dynamic>.from(options.map((x) => x.toJson())),
    };
}

class Option {
    Option({
        required this.isActive,
        required this.devices,
        required this.maxSpeed,
    });

    final bool isActive;
    final List<String> devices;
    final int maxSpeed;

    factory Option.fromJson(Map<String, dynamic> json) => Option(
        isActive: json["is_active"],
        devices: List<String>.from(json["devices"].map((x) => x)),
        maxSpeed: json["max_speed"],
    );

    Map<String, dynamic> toJson() => {
        "is_active": isActive,
        "devices": List<dynamic>.from(devices.map((x) => x)),
        "max_speed": maxSpeed,
    };
}
