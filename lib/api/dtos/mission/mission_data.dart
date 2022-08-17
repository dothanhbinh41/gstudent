// To parse this JSON data, do
//
//     final missionData = missionDataFromJson(jsonString);

import 'dart:convert';

MissionDataResponse missionDataFromJson(String str) => MissionDataResponse.fromJson(json.decode(str));

String missionDataToJson(MissionDataResponse data) => json.encode(data.toJson());

class MissionDataResponse {
  MissionDataResponse({
    this.error,
    this.message,
    this.data,
  });

  bool error;
  String message;
  List<GroupMission> data;

  factory MissionDataResponse.fromJson(Map<String, dynamic> json) => MissionDataResponse(
    error: json["error"],
    message: json["message"],
    data: List<GroupMission>.from(json["data"].map((x) => GroupMission.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class GroupMission {
  GroupMission({
    this.id,
    this.name,
    this.slug,
    this.type,
    this.missions,
  });

  int id;
  String name;
  String slug;
  int type;
  List<Mission> missions;

  factory GroupMission.fromJson(Map<String, dynamic> json) => GroupMission(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    type: json["type"],
    missions: List<Mission>.from(json["missions"].map((x) => Mission.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "type": type,
    "missions": List<dynamic>.from(missions.map((x) => x.toJson())),
  };
}

class Mission {
  Mission({
    this.id,
    this.name,
    this.slug,
    this.category,
    this.image,
    this.reward,
    this.missionUsers,
  });

  int id;
  String name;
  String slug;
  String category;
  Reward reward;
  String image;
  List<MissionUser> missionUsers;

  factory Mission.fromJson(Map<String, dynamic> json) => Mission(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    category: json["category"],
    image: json["image"],
    reward: json["reward"] != null ? Reward.fromJson(json["reward"]) : null,
    missionUsers:  List<MissionUser>.from(json["mission_users"].map((x) => MissionUser.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "image": image,
    "category": category,
    "reward": reward.toJson(),
    // "mission_users": List<dynamic>.from(missionUsers.map((x) => x)),
  };
}


class Reward {
  Reward({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory Reward.fromJson(Map<String, dynamic> json) =>
      Reward(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "name": name,
      };
}


class MissionUser {
  MissionUser({
    this.id,
    this.missionId,
    this.slug,
    this.dateClaim,
  });

  int id;
  int missionId;
  String slug;
  DateTime dateClaim;

  factory MissionUser.fromJson(Map<String, dynamic> json) => MissionUser(
    id: json["id"],
    missionId: json["mission_id"],
    slug: json["slug"],
    dateClaim: json["date_claim"] != null ? DateTime.parse(json["date_claim"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mission_id": missionId,
    "slug": slug,
    "date_claim": dateClaim,
  };
}

