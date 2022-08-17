// To parse this JSON data, do
//
//     final userLeaderBoard = userLeaderBoardFromJson(jsonString);

import 'dart:convert';
TopQuick topQuickFromJson(String str) => TopQuick.fromJson(json.decode(str));

String topQuickToJson(TopQuick data) => json.encode(data.toJson());

TopLeader topLeaderFromJson(String str) => TopLeader.fromJson(json.decode(str));

String topLeaderToJson(TopLeader data) => json.encode(data.toJson());

class TopQuick {
  TopQuick({
    this.topquick,
  });

  List<UserLeaderBoard> topquick;

  factory TopQuick.fromJson(Map<String, dynamic> json) => TopQuick(
    topquick: List<UserLeaderBoard>.from(json["topquick"].map((x) => UserLeaderBoard.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "topquick": List<dynamic>.from(topquick.map((x) => x.toJson())),
  };
}

class TopLeader {
  TopLeader({
    this.topLeader,
  });

  List<UserLeaderBoard> topLeader;

  factory TopLeader.fromJson(Map<String, dynamic> json) => TopLeader(
    topLeader: List<UserLeaderBoard>.from(json["topLeader"].map((x) => UserLeaderBoard.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "topquick": List<dynamic>.from(topLeader.map((x) => x.toJson())),
  };
}

class UserLeaderBoard {
  UserLeaderBoard({
    this.id,
    this.email,
    this.accessToken,
    this.point,
    this.numTrue,
    this.numFalse,
    this.time,
    this.mess,
    this.courseStudentId,
    this.name
  });

  int id;
  String email;
  String name;
  String accessToken;
  int courseStudentId;
  int point;
  int numTrue;
  int numFalse;
  int time;
  String mess;

  factory UserLeaderBoard.fromJson(Map<String, dynamic> json) => UserLeaderBoard(
    id: json["id"],
    email: json["email"],
    name: json["name"],
    accessToken: json["accessToken"],
    courseStudentId: json["course_student_id"] is String ? int.parse(json["course_student_id"]) : json["course_student_id"],
    point: json["point"],
    numTrue: json["num_true"],
    numFalse: json["num_false"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "name":name,
    "courseStudentId" : courseStudentId,
    "accessToken": accessToken,
    "point": point,
    "num_true": numTrue,
    "num_false": numFalse,
    "time": time,
  };
}
