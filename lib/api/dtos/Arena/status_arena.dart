// To parse this JSON data, do
//
//     final statusArena = statusArenaFromJson(jsonString);

import 'dart:convert';

StatusArena statusArenaFromJson(String str) => StatusArena.fromJson(json.decode(str));

String statusArenaToJson(StatusArena data) => json.encode(data.toJson());

class StatusArena {
  StatusArena({
    this.type,
    this.message,
  });

  String type;
  String message;

  factory StatusArena.fromJson(Map<String, dynamic> json) => StatusArena(
    type: json["type"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "message": message,
  };
}
