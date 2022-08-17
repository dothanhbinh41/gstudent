// To parse this JSON data, do
//
//     final joinClanResponse = joinClanResponseFromJson(jsonString);

import 'dart:convert';

JoinClanResponse joinClanResponseFromJson(String str) => JoinClanResponse.fromJson(json.decode(str));

String joinClanResponseToJson(JoinClanResponse data) => json.encode(data.toJson());

class JoinClanResponse {
  JoinClanResponse({
    this.error,
    this.message,
    this.userClan,
  });

  bool error;
  String message;
  UserClan userClan;

  factory JoinClanResponse.fromJson(Map<String, dynamic> json) => JoinClanResponse(
    error: json["error"],
    message: json["message"],
    userClan:  json["data"] != null ? UserClan.fromJson(json["data"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "userClan": userClan.toJson(),
  };
}

class UserClan {
  UserClan({
    this.id,
    this.status,
    this.clanId,
    this.clanCode,
  });

  int id;
  int status;
  int clanId;
  int clanCode;

  factory UserClan.fromJson(Map<String, dynamic> json) => UserClan(
    id: json["id"],
    status: json["status"],
    clanId: json["clan_id"],
    clanCode: json["clan_code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "clan_id": clanId,
    "clan_code": clanCode,
  };
}
