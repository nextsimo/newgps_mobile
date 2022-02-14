// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  User({
    required this.userId,
    required this.displayName,
    required this.contactPhone,
    required this.password,
    required this.devices,
    required this.index,
    this.newUserId = '',
  });

  String userId;
  String displayName;
  String contactPhone;
  String password;
  List<String> devices;
  String newUserId;
  final int index;

  factory User.fromJson(Map<String, dynamic> json) => User(
        index: json['index'],
        userId: json["userID"],
        displayName: json["displayName"],
        contactPhone: json["contactPhone"],
        password: json["password"],
        newUserId: json["userID"],
        devices: List<String>.from(json["devices"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "userID": userId,
        "displayName": displayName,
        "contactPhone": contactPhone,
        "password": password,
        'newuserID': newUserId,
        "devices": List<dynamic>.from(devices.map((x) => x)),
      };
}
