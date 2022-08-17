// To parse this JSON data, do
//
//     final acceptInviteArena = acceptInviteArenaFromJson(jsonString);

import 'dart:convert';

AcceptInviteArena acceptInviteArenaFromJson(String str) => AcceptInviteArena.fromJson(json.decode(str));

String acceptInviteArenaToJson(AcceptInviteArena data) => json.encode(data.toJson());

class AcceptInviteArena {
  AcceptInviteArena({
    this.error,
    this.message,
    this.data,
  });

  bool error;
  String message;
  Data data;

  factory AcceptInviteArena.fromJson(Map<String, dynamic> json) => AcceptInviteArena(
    error: json["error"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.clanId,
    this.anotherClanId,
    this.status,
    this.dateTimeStart,
    this.letter,
    this.type,
    this.clan,
    this.anotherClan,
  });

  int id;
  int clanId;
  int anotherClanId;
  int status;
  DateTime dateTimeStart;
  String letter;
  int type;
  ClanNotify clan;
  ClanNotify anotherClan;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    clanId: json["clan_id"],
    anotherClanId: json["another_clan_id"],
    status: json["status"],
    dateTimeStart: DateTime.parse(json["date_time_start"]).toLocal(),
    letter: json["letter"],
    type: json["type"],
    clan: ClanNotify.fromJson(json["clan"]),
    anotherClan: ClanNotify.fromJson(json["anotherClan"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "clan_id": clanId,
    "another_clan_id": anotherClanId,
    "status": status,
    "date_time_start": dateTimeStart.toIso8601String(),
    "letter": letter,
    "type": type,
    "clan": clan.toJson(),
    "anotherClan": anotherClan.toJson(),
  };
}

class ClanNotify {
  ClanNotify({
    this.id,
    this.name,
    this.generalId,
    this.rank,
    this.approveStatus,
    this.classroomId,
    this.courseId,
    this.code,
  });

  int id;
  String name;
  int generalId;
  int rank;
  int approveStatus;
  int classroomId;
  int courseId;
  int code;

  factory ClanNotify.fromJson(Map<String, dynamic> json) => ClanNotify(
    id: json["id"],
    name: json["name"],
    generalId: json["general_id"],
    rank: json["rank"],
    approveStatus: json["approve_status"],
    classroomId: json["classroom_id"],
    courseId: json["course_id"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "general_id": generalId,
    "rank": rank,
    "approve_status": approveStatus,
    "classroom_id": classroomId,
    "course_id": courseId,
    "code": code,
  };
}

