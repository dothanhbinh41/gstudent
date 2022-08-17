// To parse this JSON data, do
//
//     final resultTestInputData = resultTestInputDataFromJson(jsonString);

import 'dart:convert';

ResultTestInputData resultTestInputDataFromJson(String str) => ResultTestInputData.fromJson(json.decode(str));

String resultTestInputDataToJson(ResultTestInputData data) => json.encode(data.toJson());

class ResultTestInputData {
  ResultTestInputData({
    this.error,
    this.message,
    this.data,
  });

  bool error;
  String message;
  DataResultTest data;

  factory ResultTestInputData.fromJson(Map<String, dynamic> json) => ResultTestInputData(
    error: json["error"],
    message: json["message"],
    data: json["data"] != null ? DataResultTest.fromJson(json["data"]): null,
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "data": data.toJson(),
  };
}

class DataResultTest {
  DataResultTest({
    this.reading,
    this.listening,
    this.common,
    this.speaking,
    this.writing,
    this.general,
    this.statusMark,
  });

  DataSkill reading;
  DataSkill listening;
  DataSkill writing;
  DataSkill speaking;
  DataSkill general;
  Common common;
  bool statusMark;

  factory DataResultTest.fromJson(Map<String, dynamic> json) => DataResultTest(
    reading: json["reading"] != null ?DataSkill.fromJson(json["reading"]): null,
    listening: json["listening"] != null ?DataSkill.fromJson(json["listening"]): null,
    writing:json["writing"] != null ? DataSkill.fromJson(json["writing"]): null,
    speaking: json["speaking"] != null ?DataSkill.fromJson(json["speaking"]): null,
    general:json["general test"] != null ?  DataSkill.fromJson(json["general test"]) : null,
    common:json["common"] != null ? Common.fromJson(json["common"]): null,
    statusMark: json["status_mark"] == 2,
  );

  Map<String, dynamic> toJson() => {
    "reading": reading.toJson(),
    "listening": listening.toJson(),
    "common": common.toJson(),
    "speaking": speaking.toJson(),
    "writing": writing.toJson(),
    "general": general.toJson(),
    "status_mark": statusMark,
  };
}

class Common {
  Common({
    this.courseSuggest,
    this.comment,
    this.type,
  });

  dynamic courseSuggest;
  dynamic comment;
  String type;

  factory Common.fromJson(Map<String, dynamic> json) => Common(
    courseSuggest: json["course_suggest"],
    comment: json["comment"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "course_suggest": courseSuggest,
    "comment": comment,
    "type": type,
  };
}

class DataSkill {
  DataSkill({
    this.exactly,
    this.total,
    this.exchange,
    this.commentItem,
  });

  double exactly;
  dynamic total;
  double exchange;
  String commentItem;

  factory DataSkill.fromJson(Map<String, dynamic> json) => DataSkill(
    exactly:json["exactly"].toDouble(),
    exchange: json["exchange"].toDouble(),
    total:json["total"] != "" ?  json["total"].toDouble() : json["total"],
    commentItem: json["comment_item"],
  );

  Map<String, dynamic> toJson() => {
    "exactly": exactly,
    "total": total,
    "exchange": exchange,
    "comment_item": commentItem,
  };
}
