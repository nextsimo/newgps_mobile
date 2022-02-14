import 'dart:convert';

List<ConnectedDeviceModel> connectedDeviceModelFromJson(String str) => List<ConnectedDeviceModel>.from(json.decode(str).map((x) => ConnectedDeviceModel.fromJson(x)));

String connectedDeviceModelToJson(List<ConnectedDeviceModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ConnectedDeviceModel {
    ConnectedDeviceModel({
        required this.deviceUid,
        required this.lastConnectedDate,
        required this.deviceBrand,
        required this.phoneNumber,
        required this.platform,
        required this.isConnected,
        required this.lastLogoutDate,
        required this.os,
    });

    final String deviceUid;
    final DateTime lastConnectedDate;
    final String deviceBrand;
    final String phoneNumber;
    final String platform;
    final bool isConnected;
    final DateTime lastLogoutDate;
    final String os;

    factory ConnectedDeviceModel.fromJson(Map<String, dynamic> json) => ConnectedDeviceModel(
        deviceUid: json["device_uid"],
        lastConnectedDate: DateTime.parse(json["last_connected_date"]),
        deviceBrand: json["device_brand"],
        phoneNumber: json["phone_number"] ?? '',
        platform: json["platform"],
        isConnected: json["is_connected"] == 1 ? true : false,
        lastLogoutDate:DateTime.parse(json["last_logout_date"]),
        os: json["os"]
    );

    Map<String, dynamic> toJson() => {
        "device_uid": deviceUid,
        "last_connected_date": lastConnectedDate,
        "device_brand": deviceBrand,
        "phone_number": phoneNumber,
        "platform": platform,
        "is_connected": isConnected,
        "last_logout_date": lastLogoutDate,
    };
}
