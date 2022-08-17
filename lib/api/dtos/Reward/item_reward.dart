// To parse this JSON data, do
//
//     final dataReward = dataRewardFromJson(jsonString);

import 'dart:convert';

DataReward dataRewardFromJson(String str) => DataReward.fromJson(json.decode(str));

String dataRewardToJson(DataReward data) => json.encode(data.toJson());

class DataReward {
  DataReward({
    this.error,
    this.message,
    this.data,
  });

  bool error;
  String message;
  List<ItemReward> data;

  factory DataReward.fromJson(Map<String, dynamic> json) => DataReward(
    error: json["error"],
    message: json["message"],
    data: List<ItemReward>.from(json["data"].map((x) => ItemReward.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ItemReward {
  ItemReward({
    this.name,
    this.quantity,
    this.avatar,
  });

  String name;
  int quantity;
  String avatar;

  factory ItemReward.fromJson(Map<String, dynamic> json) => ItemReward(
    name: json["name"],
    quantity: json["quantity"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "quantity": quantity,
    "avatar": avatar,
  };
}
