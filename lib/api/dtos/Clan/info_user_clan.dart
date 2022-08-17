// To parse this JSON data, do
//
//     final userClanInfo = userClanInfoFromJson(jsonString);

import 'dart:convert';

import 'package:gstudent/api/dtos/Character/character.dart';
import 'package:gstudent/api/dtos/badge/data_badge.dart';

UserClanInfoData userClanInfoFromJson(String str) => UserClanInfoData.fromJson(json.decode(str));

String userClanInfoToJson(UserClanInfoData data) => json.encode(data.toJson());


class UserClanInfoData {
  UserClanInfoData({
    this.error,
    this.message,
    this.data,
  });

  bool error;
  String message;
  UserClanInfo data;

  factory UserClanInfoData.fromJson(Map<String, dynamic> json) => UserClanInfoData(
    error: json["error"],
    message: json["message"],
    data: UserClanInfo.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "data": data.toJson(),
  };
}



class UserClanInfo {
  UserClanInfo({
    this.hp,
    this.nickName,
    this.exp,
    this.coin,
    this.level,
    this.levelName,
    this.levelAvatar,
    this.clanName,
    this.clanPosition,
    this.clanMvp,
    this.ratio,
    this.word,
    this.character,
    this.badges,
    this.attendance,
    this.resultTest,
    this.nextLevel,
  });


  int hp;
  String nickName;
  int exp;
  int coin;
  int level;
  String levelName;
  String levelAvatar;
  String clanName;
  String clanPosition;
  int clanMvp;
  NextLevel nextLevel;
  String ratio;
  String word;
  Character character;
  List<Badge> badges;
  String attendance;
  String resultTest;

  factory UserClanInfo.fromJson(Map<String, dynamic> json) => UserClanInfo(
    hp: json["hp"],
    nickName: json["nick_name"],
    exp: json["exp"] != null && json["exp"] !="" ? json["exp"] : 0,
    coin: json["coin"] != null && json["coin"] != "" ? json["coin"] : 0,
    nextLevel: NextLevel.fromJson(json["next_level"]),
    level: json["level"],
    levelName: json["level_name"],
    levelAvatar: json["level_avatar"],
    clanName: json["clan_name"],
    clanPosition: json["clan_position"],
    clanMvp: json["clan_mvp"],
    ratio: json["ratio"],
    word: json["word"],
    character: Character.fromJson(json["character"]),
    badges:  List<Badge>.from(json["badges"].map((x) => Badge.fromJson(x))),
    attendance: json["attendance"],
    resultTest: json["result_test"],
  );

  Map<String, dynamic> toJson() => {
    "hp": hp,
    "nick_name": nickName,
    "exp": exp,
    "coin": coin,
    "level": level,
    "level_name": levelName,
    "level_avatar": levelAvatar,
    "clan_name": clanName,
    "clan_position": clanPosition,
    "next_level": nextLevel.toJson(),
    "clan_mvp": clanMvp,
    "ratio": ratio,
    "word": word,
    "character": character.toJson(),
    "badges": List<dynamic>.from(badges.map((x) => x)),
    "attendance": attendance,
    "result_test": resultTest,
  };
}

class NextLevel {
  NextLevel({
    this.level,
    this.levelName,
    this.levelBadge,
    this.nextExp,
  });

  int level;
  String levelName;
  String levelBadge;
  int nextExp;

  factory NextLevel.fromJson(Map<String, dynamic> json) => NextLevel(
    level: json["level"],
    levelName: json["level_name"],
    levelBadge: json["level_badge"],
    nextExp: json["next_exp"],
  );

  Map<String, dynamic> toJson() => {
    "level": level,
    "level_name": levelName,
    "level_badge": levelBadge,
    "next_exp": nextExp,
  };
}

