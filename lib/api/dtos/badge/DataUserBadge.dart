// To parse this JSON data, do
//
//     final dataUserBadge = dataUserBadgeFromJson(jsonString);

import 'dart:convert';

import 'package:gstudent/api/dtos/badge/data_badge.dart';

DataUserBadge dataUserBadgeFromJson(String str) => DataUserBadge.fromJson(json.decode(str));

String dataUserBadgeToJson(DataUserBadge data) => json.encode(data.toJson());

class DataUserBadge {
  DataUserBadge({
    this.error,
    this.message,
    this.data,
  });

  bool error;
  String message;
  List<Datum> data;

  factory DataUserBadge.fromJson(Map<String, dynamic> json) => DataUserBadge(
    error: json["error"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.badgeId,
    this.badge,
  });

  int id;
  int badgeId;
  Badge badge;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    badgeId: json["badge_id"],
    badge: Badge.fromJson(json["badge"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "badge_id": badgeId,
    "badge": badge.toJson(),
  };
}

