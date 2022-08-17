// To parse this JSON data, do
//
//     final fightClanData = fightClanDataFromJson(jsonString);

import 'dart:convert';

import 'package:gstudent/api/dtos/Clan/clan_model.dart';

ListClanData listClanDataFromJson(String str) => ListClanData.fromJson(json.decode(str));

String listClanDataToJson(ListClanData data) => json.encode(data.toJson());

class ListClanData {
  ListClanData({
    this.error,
    this.data,
  });

  bool error;
  List<ClanModel> data;

  factory ListClanData.fromJson(Map<String, dynamic> json) => ListClanData(
    error: json["error"],
    data: List<ClanModel>.from(json["data"].map((x) => ClanModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}


