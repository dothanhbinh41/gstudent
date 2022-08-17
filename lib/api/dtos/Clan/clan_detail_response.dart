// To parse this JSON data, do
//
//     final clanDetailResponse = clanDetailResponseFromJson(jsonString);

import 'dart:convert';

ClanDetailResponse clanDetailResponseFromJson(String str) => ClanDetailResponse.fromJson(json.decode(str));

String clanDetailResponseToJson(ClanDetailResponse data) => json.encode(data.toJson());

class ClanDetailResponse {
  ClanDetailResponse({
    this.error,
    this.data,
  });

  bool error;
  ClanDetail data;

  factory ClanDetailResponse.fromJson(Map<String, dynamic> json) => ClanDetailResponse(
    error: json["error"],
    data: json["data"] != null ? ClanDetail.fromJson(json["data"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "data": data.toJson(),
  };
}

class ClanDetail {
  ClanDetail({
    this.id,
    this.name,
    this.generalId,
    this.rank,
    this.attackStatus,
    this.approveStatus,
    this.classroomId,
    this.courseId,
    this.win,
    this.lose,
    this.code,
    this.userClans,
  });

  int id;
  String name;
  int generalId;
  int rank;
  int attackStatus;
  int approveStatus;
  int classroomId;
  int courseId;
  int win;
  int lose;
  int code;
  List<UserClan> userClans;

  factory ClanDetail.fromJson(Map<String, dynamic> json) => ClanDetail(
    id: json["id"],
    name: json["name"],
    generalId: json["general_id"],
    rank: json["rank"],
    attackStatus: json["attack_status"],
    approveStatus: json["approve_status"],
    classroomId: json["classroom_id"],
    courseId: json["course_id"],
    win: json["win"] != null ? json["win"] : 0,
    lose: json["lose"] != null ? json["lose"] : 0,
    code: json["code"],
    userClans: json["user_clans"] != null ? List<UserClan>.from(json["user_clans"].map((x) => UserClan.fromJson(x))) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "general_id": generalId,
    "rank": rank,
    "attack_status": attackStatus,
    "approve_status": approveStatus,
    "classroom_id": classroomId,
    "course_id": courseId,
    "win": win,
    "lose": lose,
    "code": code,
    "user_clans": List<dynamic>.from(userClans.map((x) => x.toJson())),
  };
}

class UserClan {
  UserClan({
    this.id,
    this.courseStudentId,
    this.studentId,
    this.clanId,
    this.hp,
    this.characterId,
    this.nickname,
    this.mvp,
    this.position,
  });

  int id;
  int courseStudentId;
  int studentId;
  int clanId;
  int hp;
  int characterId;
  String nickname;
  int mvp;
  int position;

  factory UserClan.fromJson(Map<String, dynamic> json) => UserClan(
    id: json["id"],
    courseStudentId: json["course_student_id"],
    studentId: json["student_id"],
    clanId: json["clan_id"],
    hp: json["HP"],
    characterId: json["character_id"],
    nickname: json["nickname"],
    mvp: json["mvp"],
    position: json["position"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "course_student_id": courseStudentId,
    "student_id": studentId,
    "clan_id": clanId,
    "HP": hp,
    "character_id": characterId,
    "nickname": nickname,
    "mvp": mvp,
    "position": position,
  };
}
