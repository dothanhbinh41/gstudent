// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

CreateClanReponse CreateClanReponseFromJson(String str) => CreateClanReponse.fromJson(json.decode(str));

String CreateClanReponseToJson(CreateClanReponse data) => json.encode(data.toJson());

class CreateClanReponse {
  CreateClanReponse({
    this.error,
    this.message,
    this.data,
  });

  bool error;
  String message;
  DataCreateClanReponse data;

  factory CreateClanReponse.fromJson(Map<String, dynamic> json) => CreateClanReponse(
    error: json["error"],
    message: json["message"],
    data: json["data"] != null ?  DataCreateClanReponse.fromJson(json["data"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "data": data.toJson(),
  };
}

class DataCreateClanReponse {
  DataCreateClanReponse({
    this.id,
    this.name,
    this.generalId,
    this.code,
    this.userClanId,
  });

  int id;
  String name;
  int generalId;
  int code;
  int userClanId;

  factory DataCreateClanReponse.fromJson(Map<String, dynamic> json) => DataCreateClanReponse(
    id: json["id"],
    name: json["name"],
    generalId: json["general_id"],
    code: json["code"],
    userClanId: json["user_clan_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "general_id": generalId,
    "code": code,
    "user_clan_id": userClanId,
  };
}
