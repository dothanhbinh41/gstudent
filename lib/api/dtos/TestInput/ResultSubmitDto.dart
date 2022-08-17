// To parse this JSON data, do
//
//     final resultSubmitDto = resultSubmitDtoFromJson(jsonString);

import 'dart:convert';

ResultSubmitDto resultSubmitDtoFromJson(String str) => ResultSubmitDto.fromJson(json.decode(str));

String resultSubmitDtoToJson(ResultSubmitDto data) => json.encode(data.toJson());

class ResultSubmitDto {
  ResultSubmitDto({
    this.error,
    this.message,
    this.data,
  });

  bool error;
  String message;
  ResultTestInput data;

  factory ResultSubmitDto.fromJson(Map<String, dynamic> json) => ResultSubmitDto(
    error: json["error"],
    message: json["message"],
    data: ResultTestInput.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "data": data.toJson(),
  };
}

class ResultTestInput {
  ResultTestInput({
    this.markPoint,
    this.comment,
    this.speakingComment,
    this.writingComment,
    this.readingComment,
    this.listeningComment,
  });

  MarkPoint markPoint;
  dynamic comment;
  dynamic speakingComment;
  dynamic writingComment;
  dynamic readingComment;
  dynamic listeningComment;

  factory ResultTestInput.fromJson(Map<String, dynamic> json) => ResultTestInput(
    markPoint: MarkPoint.fromJson(json["mark_point"]),
    comment: json["comment"],
    speakingComment: json["speaking_comment"],
    writingComment: json["writing_comment"],
    readingComment: json["reading_comment"],
    listeningComment: json["listening_comment"],
  );

  Map<String, dynamic> toJson() => {
    "mark_point": markPoint.toJson(),
    "comment": comment,
    "speaking_comment": speakingComment,
    "writing_comment": writingComment,
    "reading_comment": readingComment,
    "listening_comment": listeningComment,
  };
}

class MarkPoint {
  MarkPoint({
    this.reading,
    this.listening,
  });

  TotalPointSkill reading;
  TotalPointSkill listening;

  factory MarkPoint.fromJson(Map<String, dynamic> json) => MarkPoint(
    reading: TotalPointSkill.fromJson(json["reading"]),
    listening: TotalPointSkill.fromJson(json["listening"]),
  );

  Map<String, dynamic> toJson() => {
    "reading": reading.toJson(),
    "listening": listening.toJson(),
  };
}

class TotalPointSkill {
  TotalPointSkill({
    this.exactly,
    this.total,
  });

  int exactly;
  int total;

  factory TotalPointSkill.fromJson(Map<String, dynamic> json) => TotalPointSkill(
    exactly: json["exactly"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "exactly": exactly,
    "total": total,
  };
}
