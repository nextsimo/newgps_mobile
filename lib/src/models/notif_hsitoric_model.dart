// To parse this JSON data, do
//
//     final notifHistoric = notifHistoricFromJson(jsonString);

import 'dart:convert';

List<NotifHistoric> notifHistoricFromJson(String str) =>
    List<NotifHistoric>.from(
        json.decode(str).map((x) => NotifHistoric.fromJson(x)));

String notifHistoricToJson(List<NotifHistoric> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotifHistoric {
  NotifHistoric({
    required this.address,
    required this.date,
    required this.message,
    required this.device,
    required this.colorR,
    required this.colorG,
    required this.colorB,
    required this.createdAt,
    required this.countNotRead,
    required this.type,
    required this.hexIcon,
    required this.deviceId,
    required this.timestamp
  });

  String address;
  DateTime date;
  String message;
  String device;
  int colorR;
  int colorG;
  int colorB;
  DateTime createdAt;
  int countNotRead;
  String type;
  int hexIcon;
  String deviceId;
  int timestamp;

  factory NotifHistoric.fromJson(Map<String, dynamic> json) => NotifHistoric(
        address: json["address"],
        date: getDate('date'),
        message: json["message"],
        device: json["device"],
        colorR: json["colorR"],
        colorG: json["colorG"],
        colorB: json["colorB"],
        createdAt: DateTime.parse(json['created_at']),
        countNotRead: json['countNotRead'],
        type: json['type'],
        hexIcon: json['hex_icon'],
        deviceId: json['device_id'],
        timestamp: json['timestamp']
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "date": date,
        "message": message,
        "device": device,
        "colorR": colorR,
        "colorG": colorG,
        "colorB": colorB,
        'created_at': createdAt,
        'countNotRead': countNotRead,
        'type': type,
      };

  static DateTime getDate(dynamic date) {
    try {
      return DateTime.parse(date);
    } catch (e) {
      return DateTime(2000);
    }
  }
}
