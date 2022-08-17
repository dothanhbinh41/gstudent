// To parse this JSON data, do
//
//     final calendarArenaResponse = calendarArenaResponseFromJson(jsonString);

import 'dart:convert';

CalendarArenaResponse calendarArenaResponseFromJson(String str) => CalendarArenaResponse.fromJson(json.decode(str));

String calendarArenaResponseToJson(CalendarArenaResponse data) => json.encode(data.toJson());

class CalendarArenaResponse {
  CalendarArenaResponse({
    this.error,
    this.data,
  });

  bool error;
  List<CalendarArena> data;

  factory CalendarArenaResponse.fromJson(Map<String, dynamic> json) => CalendarArenaResponse(
    error: json["error"],
    data: List<CalendarArena>.from(json["data"].map((x) => CalendarArena.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class CalendarArena {
  CalendarArena({
    this.arenaId,
    this.fromClanId,
    this.fromClanName,
    this.toClanId,
    this.toClanName,
    this.dateTimeStart,
    this.letter,
  });

  
  int arenaId;
  int fromClanId;
  String fromClanName;
  int toClanId;
  String toClanName;
  DateTime dateTimeStart;
  String letter;

  factory CalendarArena.fromJson(Map<String, dynamic> json) => CalendarArena(
    arenaId: json["arena_id"],
    fromClanId: json["from_clan_id"],
    fromClanName: json["from_clan_name"],
    toClanId: json["to_clan_id"],
    toClanName: json["to_clan_name"],
    dateTimeStart: DateTime.parse(json["date_time_start"]).toLocal(),
    letter: json["letter"],
  );

  Map<String, dynamic> toJson() => {
    "arena_id": arenaId,
    "from_clan_id": fromClanId,
    "from_clan_name": fromClanName,
    "to_clan_id": toClanId,
    "to_clan_name": toClanName,
    "date_time_start": dateTimeStart.toIso8601String(),
    "letter": letter,
  };
}
