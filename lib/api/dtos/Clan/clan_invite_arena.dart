// To parse this JSON data, do
//
//     final listClanInviteArena = listClanInviteArenaFromJson(jsonString);

import 'dart:convert';

import 'package:gstudent/api/dtos/Arena/calendar.dart';

ListClanInviteArena listClanInviteArenaFromJson(String str) => ListClanInviteArena.fromJson(json.decode(str));

String listClanInviteArenaToJson(ListClanInviteArena data) => json.encode(data.toJson());

class ListClanInviteArena {
  ListClanInviteArena({
    this.error,
    this.data,
  });

  bool error;
  List<ClanInvite> data;

  factory ListClanInviteArena.fromJson(Map<String, dynamic> json) => ListClanInviteArena(
    error: json["error"],
    data: List<ClanInvite>.from(json["data"].map((x) => ClanInvite.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ClanInvite {
  ClanInvite({
    this.arenaId,
    this.fromClanId,
    this.fromClanName,
    this.toClanId,
    this.toClanName,
    this.dateTimeStart,
    this.letter,
    this.createdAt
  });

  int arenaId;
  int fromClanId;
  String fromClanName;
  int toClanId;
  String toClanName;
  DateTime dateTimeStart;
  DateTime createdAt;
  String letter;


  factory ClanInvite.fromJson(Map<String, dynamic> json) => ClanInvite(
    arenaId: json["arena_id"],
    fromClanId: json["from_clan_id"],
    fromClanName: json["from_clan_name"],
    toClanId: json["to_clan_id"],
    toClanName: json["to_clan_name"],
    dateTimeStart: DateTime.parse(json["date_time_start"]).toLocal(),
    createdAt: DateTime.parse(json["created_at"]).toLocal(),
    letter: json["letter"],
  );

  Map<String, dynamic> toJson() => {
    "arena_id": arenaId,
    "from_clan_id": fromClanId,
    "from_clan_name": fromClanName,
    "to_clan_id": toClanId,
    "to_clan_name": toClanName,
    "date_time_start": dateTimeStart.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "letter": letter,
  };
}

