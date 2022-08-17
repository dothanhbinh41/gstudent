import 'dart:convert';

import 'package:gstudent/api/dtos/Authentication/user_info.dart';

Message messageFromJson(String str) => Message.fromJson(json.decode(str));

String messageToJson(Message data) => json.encode(data.toJson());

class Message {
  Message({
    this.user,
    this.message,
  });

  User user;
  String message;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    user: User.fromJson(json["user"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
    "message": message,
  };
}

