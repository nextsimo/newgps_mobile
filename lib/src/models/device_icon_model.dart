// To parse this JSON data, do
//
//     final deviceIcon = deviceIconFromJson(jsonString);
import 'dart:convert';

List<DeviceIconModel> deviceIconFromJson(String str) => List<DeviceIconModel>.from(json.decode(str).map((x) => DeviceIconModel.fromJson(x)));

class DeviceIconModel {
    DeviceIconModel({
        required this.name,
        required this.iconBase64,
    });

    final String name;
    final String iconBase64 ;

    factory DeviceIconModel.fromJson(Map<String, dynamic> json) => DeviceIconModel(
        name: json["name"],
        iconBase64: json["iconBase64"],
    );
}
