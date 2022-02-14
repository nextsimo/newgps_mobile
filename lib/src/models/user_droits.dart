// To parse this JSON data, do
//
//     final userDroits = userDroitsFromJson(jsonString);

import 'dart:convert';

UserDroits userDroitsFromJson(String str) =>
    UserDroits.fromJson(json.decode(str));

String userDroitsToJson(UserDroits data) => json.encode(data.toJson());

class UserDroits {
  UserDroits({
    required this.id,
    required this.userId,
    required this.accountId,
    required this.droits,
  });

  int id;
  String userId;
  String accountId;
  List<Droit> droits;

  factory UserDroits.fromJson(Map<String, dynamic> json) => UserDroits(
        id: json["id"],
        userId: json["user_id"],
        accountId: json["account_id"],
        droits: List<Droit>.from(json["droits"].map((x) => Droit.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "account_id": accountId,
        "droits": List<dynamic>.from(droits.map((x) => x.toJson())),
      };
}

class Droit {
  Droit({
    required this.read,
    required this.write,
    required this.index,
  });

  bool read;
  bool write;
  int index;

  factory Droit.fromJson(Map<String, dynamic> json) => Droit(
        read: json["read"],
        write: json["write"],
        index: json["index"],
      );

  Map<String, dynamic> toJson() => {
        "read": read,
        "write": write,
        "index": index,
      };
}
