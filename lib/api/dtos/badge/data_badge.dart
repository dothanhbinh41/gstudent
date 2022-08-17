// To parse this JSON data, do
//
//     final dataBadge = dataBadgeFromJson(jsonString);

import 'dart:convert';

DataBadge dataBadgeFromJson(String str) => DataBadge.fromJson(json.decode(str));

String dataBadgeToJson(DataBadge data) => json.encode(data.toJson());

class DataBadge {
  DataBadge({
    this.error,
    this.message,
    this.data,
  });

  bool error;
  String message;
  List<Badge> data;

  factory DataBadge.fromJson(Map<String, dynamic> json) => DataBadge(
    error: json["error"],
    message: json["message"],
    data: List<Badge>.from(json["data"].map((x) => Badge.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Badge {
  Badge({
    this.id,
    this.name,
    this.image,
    this.description,
    this.isActive = false,
  });

  bool isActive;
  int id;
  String name;
  String image;
  String description;

  factory Badge.fromJson(Map<String, dynamic> json) => Badge(
    id: json["id"],
    name: json["name"],
    image: json["image"] == null ? null : json["image"],
    description: json["description"] != null ?  json["description"] : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image == null ? null : image,
    "description": description,
  };
}
