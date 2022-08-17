// To parse this JSON data, do
//
//     final resultArena = resultArenaFromJson(jsonString);

import 'dart:convert';

Map<String, List<ResultArena>> resultArenaFromJson(String str) => Map.from(json.decode(str)).map((k, v) => MapEntry<String, List<ResultArena>>(k, List<ResultArena>.from(v.map((x) => ResultArena.fromJson(x)))));

String resultArenaToJson(Map<String, List<ResultArena>> data) => json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x.toJson())))));

class DataResultArena{
  DataResultArena({this.resultClan,this.resultClanEnemy,this.users});
  int resultClan;
  int resultClanEnemy;
  List<ResultArena> users;

}

class ResultArena {
  ResultArena({
    this.id,
    this.totalNumberTrue,
    this.totalTime,
    this.clanId,
    this.courseStudentId,
    this.isMvp,
    this.characterId
  });

  bool isMvp;
  int id;
  int totalNumberTrue;
  int totalTime;
  int clanId;
  int courseStudentId;
  int characterId;

  factory ResultArena.fromJson(Map<String, dynamic> json) => ResultArena(
    id: json["student_id"],
    totalNumberTrue: json["total_number_true"] ,
    totalTime: json["total_time"],
    clanId: json["clan_id"],
    characterId: json["character_id"],
    courseStudentId: json["course_student_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "total_number_true": totalNumberTrue,
    "total_time": totalTime,
    "clan_id": clanId,
    "course_student_id": courseStudentId,
  };
}
