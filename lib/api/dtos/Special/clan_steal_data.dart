
import 'dart:convert';

import 'package:gstudent/api/dtos/Clan/clan_detail_response.dart';


ClanStealData clanStealDataFromJson(String str) => ClanStealData.fromJson(json.decode(str));

String clanStealDataToJson(ClanStealData data) => json.encode(data.toJson());

class ClanStealData {
  ClanStealData({
    this.error,
    this.message,
    this.data,
  });

  bool error;
  String message;
  List<UserClan> data;

  factory ClanStealData.fromJson(Map<String, dynamic> json) => ClanStealData(
    error: json["error"],
    message: json["message"],
    data: List<UserClan>.from(json["data"].map((x) => UserClan.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}
