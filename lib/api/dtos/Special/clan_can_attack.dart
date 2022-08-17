
import 'dart:convert';

import 'package:gstudent/api/dtos/Clan/clan_detail_response.dart';

ClanCanAttack clanCanAttackFromJson(String str) => ClanCanAttack.fromJson(json.decode(str));

String clanCanAttackToJson(ClanCanAttack data) => json.encode(data.toJson());

class ClanCanAttack {
  ClanCanAttack({
    this.error,
    this.message,
    this.data,
  });

  bool error;
  String message;
  List<ClanDetail> data;

  factory ClanCanAttack.fromJson(Map<String, dynamic> json) => ClanCanAttack(
    error: json["error"],
    message: json["message"],
    data: List<ClanDetail>.from(json["data"].map((x) => ClanDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}