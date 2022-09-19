// To parse this JSON data, do
//
//     final myDriverModel = myDriverModelFromJson(jsonString);

import 'dart:convert';

List<MyDriverModel> myDriverModelFromJson(String str) => List<MyDriverModel>.from(json.decode(str).map((x) => MyDriverModel.fromJson(x)));

String myDriverModelToJson(List<MyDriverModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyDriverModel {
    MyDriverModel({
        required this.id,
        required this.ibuttonId,
        required this.firstName,
        required this.lastName,
        required this.phone1,
        required this.phone2,
        required this.licenseNumber,
        required this.licenseState,
        required this.licenseExpiration,
    });

    final int id;
    final String ibuttonId;
    final String firstName;
    final String lastName;
    final String phone1;
    final String phone2;
    final String licenseNumber;
    final String licenseState;
    final String licenseExpiration;

    factory MyDriverModel.fromJson(Map<String, dynamic> json) => MyDriverModel(
        id: json["id"],
        ibuttonId: json["ibutton_id"],
        firstName: json["first_name"] ?? 'Prénom non renseigné',
        lastName: json["last_name"] ?? 'Nom non renseigné',
        phone1: json["phone1"] ?? '',
        phone2: json["phone2"] ?? '',
        licenseNumber: json["license_number"] ?? '',
        licenseState: json["license_state"] ?? '',
        licenseExpiration: json["license_expiration"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "ibutton_id": ibuttonId,
        "first_name": firstName,
        "last_name": lastName,
        "phone1": phone1,
        "phone2": phone2,
        "license_number": licenseNumber,
        "license_state": licenseState,
        "license_expiration": licenseExpiration,
    };
}
