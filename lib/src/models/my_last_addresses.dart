// To parse this JSON data, do
//
//     final myLastAddressDevice = myLastAddressDeviceFromJson(jsonString);
import 'dart:convert';

List<MyLastAddressDevice> myLastAddressDeviceFromJson(String str) => List<MyLastAddressDevice>.from(json.decode(str).map((x) => MyLastAddressDevice.fromJson(x)));

String myLastAddressDeviceToJson(List<MyLastAddressDevice> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyLastAddressDevice {
    MyLastAddressDevice({
        required this.address,
        required this.deviceId,
    });

    final String address;
    final String deviceId;

    factory MyLastAddressDevice.fromJson(Map<String, dynamic> json) => MyLastAddressDevice(
        address: json["address"],
        deviceId: json["device_id"],
    );

    Map<String, dynamic> toJson() => {
        "address": address,
        "device_id": deviceId,
    };
}
