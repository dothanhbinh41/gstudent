// To parse this JSON data, do
//
//     final arenaDetailReponse = arenaDetailReponseFromJson(jsonString);

import 'dart:convert';

ArenaDetailReponse arenaDetailReponseFromJson(String str) => ArenaDetailReponse.fromJson(json.decode(str));

String arenaDetailReponseToJson(ArenaDetailReponse data) => json.encode(data.toJson());

class ArenaDetailReponse {
  ArenaDetailReponse({
    this.error,
    this.data,
  });

  bool error;
  DataArena data;

  factory ArenaDetailReponse.fromJson(Map<String, dynamic> json) => ArenaDetailReponse(
        error: json["error"],
        data: DataArena.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "data": data.toJson(),
      };
}

class DataArena {
  DataArena({
    this.clan,
    this.anotherClan,
  });

  ClanDataArena clan;
  ClanDataArena anotherClan;

  factory DataArena.fromJson(Map<String, dynamic> json) => DataArena(
        clan: ClanDataArena.fromJson(json["clan"]),
        anotherClan: ClanDataArena.fromJson(json["anotherClan"]),
      );

  Map<String, dynamic> toJson() => {
        "clan": clan.toJson(),
        "anotherClan": anotherClan.toJson(),
      };
}

class ClanDataArena {
  ClanDataArena({
    this.name,
    this.rank,
    this.winRate,
    this.student,
  });

  String name;
  int rank;
  String winRate;
  List<Student> student;

  factory ClanDataArena.fromJson(Map<String, dynamic> json) => ClanDataArena(
        name: json["name"],
        rank: json["rank"],
        winRate: json["win_rate"],
        student: List<Student>.from(json["student"].map((x) => Student.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "rank": rank,
        "win_rate": winRate,
        "student": List<dynamic>.from(student.map((x) => x.toJson())),
      };
}

class Student {
  Student({ this.id,
    this.name,
    this.characterId,
    this.position,
    this.levelName,
    this.levelAvatar,});

  int id;
  String name;
  int characterId;
  String position;
  String levelName;
  String levelAvatar;
  bool online;

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    id: json["id"],
    name: json["name"],
    characterId: json["character_id"],
    position: json["position"],
    levelName: json["level_name"],
    levelAvatar: json["level_avatar"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "character_id": characterId,
    "position": position,
    "level_name": levelName,
    "level_avatar": levelAvatar,
      };
}
