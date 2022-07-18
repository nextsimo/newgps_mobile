// To parse this JSON data, do
//
//     final configTempBle = configTempBleFromJson(jsonString);
import 'dart:convert';

List<ConfigTempBle> configTempBleFromJson(String str) =>
    List<ConfigTempBle>.from(
        json.decode(str).map((x) => ConfigTempBle.fromJson(x)));

String configTempBleToJson(List<ConfigTempBle> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ConfigTempBle {
  ConfigTempBle({
    required this.id,
    required this.name,
    required this.isActive,
    required this.timing,
    required this.inRange,
    required this.minValue,
    required this.maxValue,
    required this.createdAt,
    required this.updatedAt,
    required this.settingId,
    required this.selectedDevices,
  });

  final int id;
  final String name;
  final bool isActive;
  final int timing;
  final bool inRange;
  final int minValue;
  final int maxValue;
  final int createdAt;
  final int updatedAt;
  final int settingId;
  final List<String> selectedDevices;

  factory ConfigTempBle.fromJson(Map<String, dynamic> json) => ConfigTempBle(
        id: json["id"],
        name: json["name"],
        isActive: json["is_active"],
        timing: json["timing"],
        inRange: json["in_range"],
        minValue: json["min_value"],
        maxValue: json["max_value"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        settingId: json["setting_id"],
        selectedDevices:
            List<String>.from(json["selected_devices"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "is_active": isActive,
        "timing": timing,
        "in_range": inRange,
        "min_value": minValue,
        "max_value": maxValue,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "setting_id": settingId,
        "selected_devices": List<dynamic>.from(selectedDevices.map((x) => x)),
      };
}
