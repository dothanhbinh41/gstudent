import 'dart:convert';

import 'package:gstudent/api/dtos/Reward/item_reward.dart';

ResultVocab resultVocabFromJson(String str) => ResultVocab.fromJson(json.decode(str));

String resultVocabToJson(ResultVocab data) => json.encode(data.toJson());

class ResultVocab {
  ResultVocab({
    this.error,
    this.message,
    this.data,
  });

  bool error;
  String message;
  Data data;

  factory ResultVocab.fromJson(Map<String, dynamic> json) => ResultVocab(
    error: json["error"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.score,
    this.process,
    this.data
  });

  int score;
  String process;
  List<ItemReward> data;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    score: json["score"],
    process: json["process"],
    data: List<ItemReward>.from(json["reward"].map((x) => ItemReward.fromJson(x)))
  );

  Map<String, dynamic> toJson() => {
    "score": score,
    "process": process,
    "data" : List<dynamic>.from(data.map((x) => x.toJson()))
  };
}
