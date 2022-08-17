// To parse this JSON data, do
//
//     final dataJoinArena = dataJoinArenaFromJson(jsonString);

import 'dart:convert';

DataJoinArena dataJoinArenaFromJson(String str) => DataJoinArena.fromJson(json.decode(str));

String dataJoinArenaToJson(DataJoinArena data) => json.encode(data.toJson());

class DataJoinArena {
  DataJoinArena({
    this.error,
    this.message,
    this.data,
  });

  bool error;
  String message;
  JoinArenaInfo data;

  factory DataJoinArena.fromJson(Map<String, dynamic> json) => DataJoinArena(
    error: json["error"],
    message: json["message"],
    data: JoinArenaInfo.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "data": data.toJson(),
  };
}

class JoinArenaInfo {
  JoinArenaInfo({
    this.id,
    this.clanId,
    this.anotherClanId,
    this.status,
    this.dateTimeStart,
  });

  int id;
  int clanId;
  int anotherClanId;
  int status;
  DateTime dateTimeStart;

  factory JoinArenaInfo.fromJson(Map<String, dynamic> json) => JoinArenaInfo(
    id: json["id"],
    clanId: json["clan_id"],
    anotherClanId: json["another_clan_id"],
    status: json["status"],
    dateTimeStart: DateTime.parse(json["date_time_start"]).toLocal(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "clan_id": clanId,
    "another_clan_id": anotherClanId,
    "status": status,
    "date_time_start": dateTimeStart.toIso8601String(),
  };
}
