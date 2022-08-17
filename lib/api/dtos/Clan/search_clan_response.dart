// To parse this JSON data, do
//
//     final searchClanResponse = searchClanResponseFromJson(jsonString);

import 'dart:convert';

SearchClanResponse searchClanResponseFromJson(String str) => SearchClanResponse.fromJson(json.decode(str));

String searchClanResponseToJson(SearchClanResponse data) => json.encode(data.toJson());

class SearchClanResponse {
  SearchClanResponse({
    this.error,
    this.message,
    this.data,
  });

  bool error;
  String message;
  List<ClanFindByName> data;

  factory SearchClanResponse.fromJson(Map<String, dynamic> json) => SearchClanResponse(
    error: json["error"],
    message: json["message"],
    data: List<ClanFindByName>.from(json["data"].map((x) => ClanFindByName.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ClanFindByName {
  ClanFindByName({
    this.id,
    this.name,
    this.generalId,
    this.rank,
    this.attackStatus,
    this.approveStatus,
    this.numAttackRequest,
    this.classroomId,
    this.courseId,
    this.win,
    this.lose,
    this.code,
    this.generalInfo,
  });

  int id;
  String name;
  int generalId;
  int rank;
  int attackStatus;
  int approveStatus;
  dynamic numAttackRequest;
  int classroomId;
  int courseId;
  dynamic win;
  dynamic lose;
  int code;
  GeneralInfo generalInfo;

  factory ClanFindByName.fromJson(Map<String, dynamic> json) => ClanFindByName(
    id: json["id"],
    name: json["name"],
    generalId: json["general_id"],
    rank: json["rank"],
    attackStatus: json["attack_status"],
    approveStatus: json["approve_status"],
    numAttackRequest: json["num_attack_request"],
    classroomId: json["classroom_id"],
    courseId: json["course_id"],
    win: json["win"],
    lose: json["lose"],
    code: json["code"],
    generalInfo: GeneralInfo.fromJson(json["general_info"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "general_id": generalId,
    "rank": rank,
    "attack_status": attackStatus,
    "approve_status": approveStatus,
    "num_attack_request": numAttackRequest,
    "classroom_id": classroomId,
    "course_id": courseId,
    "win": win,
    "lose": lose,
    "code": code,
    "general_info": generalInfo.toJson(),
  };
}

class GeneralInfo {
  GeneralInfo({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory GeneralInfo.fromJson(Map<String, dynamic> json) => GeneralInfo(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
