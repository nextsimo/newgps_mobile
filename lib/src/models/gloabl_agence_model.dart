import 'dart:convert';

List<GlobalAgenceModel> globalAgenceModelFromJson(String str) =>
    List<GlobalAgenceModel>.from(
        json.decode(str).map((x) => GlobalAgenceModel.fromJson(x)));

String globalAgenceModelToJson(List<GlobalAgenceModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GlobalAgenceModel {
  GlobalAgenceModel({
    required this.id,
    required this.responsible,
    required this.segment,
    required this.phone,
    required this.email,
    required this.region,
  });

  final int id;
  final String responsible;
  final String segment;
  final String phone;
  final String email;
  final String region;

  factory GlobalAgenceModel.fromJson(Map<String, dynamic> json) =>
      GlobalAgenceModel(
        id: json["id"],
        responsible: json["responsible"],
        segment: json["segment"],
        phone: json["phone"],
        email: json["email"],
        region: json["region"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "responsible": responsible,
        "segment": segment,
        "phone": phone,
        "email": email,
        "region": region,
      };
}
