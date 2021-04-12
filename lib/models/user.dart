// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.username,
    this.email,
    this.token,
    this.admin,
  });

  String username;
  String email;
  String token;
  bool admin;

  factory User.fromJson(Map<String, dynamic> json) => User(
        username: json["username"],
        email: json["email"],
        token: json["token"],
        admin: json["admin"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "token": token,
        "admin": admin,
      };
}
