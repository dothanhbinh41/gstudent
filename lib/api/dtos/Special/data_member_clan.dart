
import 'dart:convert';

import 'package:gstudent/api/dtos/Clan/clan_detail_response.dart';

DataMemberClan dataMemberClanFromJson(String str) => DataMemberClan.fromJson(json.decode(str));

String dataMemberClanToJson(DataMemberClan data) => json.encode(data.toJson());

class DataMemberClan {
  DataMemberClan({
    this.error,
    this.message,
    this.userClans,
  });

  bool error;
  String message;
  List<UserClan> userClans;

  factory DataMemberClan.fromJson(Map<String, dynamic> json) => DataMemberClan(
    error: json["error"],
    message: json["message"],
    userClans: json["data"] != null ? List<UserClan>.from(json["data"].map((x) => UserClan.fromJson(x))) : null,
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "data":List<dynamic>.from(userClans.map((x) => x.toJson())),
  };
}
