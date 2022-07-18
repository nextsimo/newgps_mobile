// To parse this JSON data, do
//
//     final tempGlobalSetting = tempGlobalSettingFromJson(jsonString);

import 'dart:convert';

TempGlobalSetting tempGlobalSettingFromJson(String str) =>
    TempGlobalSetting.fromJson(json.decode(str));

String tempGlobalSettingToJson(TempGlobalSetting data) =>
    json.encode(data.toJson());

class TempGlobalSetting {
  TempGlobalSetting({
    required this.id,
    required this.isActive,
  });

  final int id;
  final bool isActive;

  factory TempGlobalSetting.fromJson(Map<String, dynamic> json) =>
      TempGlobalSetting(
        id: json["id"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_active": isActive,
      };
}
