// To parse this JSON data, do
//
//     final diaryClanData = diaryClanDataFromJson(jsonString);

import 'dart:convert';

DiaryClanData diaryClanDataFromJson(String str) => DiaryClanData.fromJson(json.decode(str));

String diaryClanDataToJson(DiaryClanData data) => json.encode(data.toJson());

class DiaryClanData {
  DiaryClanData({
    this.error,
    this.message,
    this.data,
  });

  bool error;
  String message;
  List<Diary> data;

  factory DiaryClanData.fromJson(Map<String, dynamic> json) => DiaryClanData(
    error: json["error"],
    message: json["message"],
    data: List<Diary>.from(json["data"].map((x) => Diary.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Diary {
  Diary({
    this.id,
    this.clanId,
    this.title,
    this.message,
  });

  int id;
  int clanId;
  String title;
  String message;

  factory Diary.fromJson(Map<String, dynamic> json) => Diary(
    id: json["id"],
    clanId: json["clan_id"],
    title: json["title"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "clan_id": clanId,
    "title": title,
    "message": message,
  };
}
