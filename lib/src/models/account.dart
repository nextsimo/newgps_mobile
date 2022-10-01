import 'dart:convert';

Account? accountFromMap(String str) => Account.fromMap(json.decode(str));

String accountToMap(Account data) => json.encode(data.toMap());

class Account {
  Account({
    required this.account,
    required this.token,
  });

  final AccountClass account;
  String? token;

  factory Account.fromMap(Map<String, dynamic> json) => Account(
        account: AccountClass.fromMap(json["account"]),
        token: json["token"]
      );

  Map<String, dynamic> toMap() => {
        "account": account.toMap(),
        "token": token,
      };
}

class AccountClass {
  AccountClass({
    required this.accountId,
    required this.description,
    required this.userID,
    required this.password
  });

  final String? accountId;
  final String? description;
  final String? userID;
  final String password;

  factory AccountClass.fromMap(Map<String, dynamic> json) => AccountClass(
        accountId: json["accountID"],
        description: json["description"],
        userID: json["userID"], password: json['password'],
      );

  String? get key => null;

  Map<String, dynamic> toMap() =>
      {"accountID": accountId, "description": description, "userID": userID, 'password' : password};
}