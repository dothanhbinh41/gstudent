// To parse this JSON data, do
//
//     final submitResponse = submitResponseFromJson(jsonString);

import 'dart:convert';

SubmitResponse submitResponseFromJson(String str) => SubmitResponse.fromJson(json.decode(str));

String submitResponseToJson(SubmitResponse data) => json.encode(data.toJson());

class SubmitResponse {
  SubmitResponse({
    this.error,
    this.message,
    this.data,
  });

  bool error;
  String message;
  DataSubmitHomework data;

  factory SubmitResponse.fromJson(Map<String, dynamic> json) => SubmitResponse(
    error: json["error"],
    message: json["message"],
    data:json["data"] != null ? DataSubmitHomework.fromJson(json["data"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "data": data.toJson(),
  };
}

class DataSubmitHomework {
  DataSubmitHomework({
    this.score,
    this.process,
    this.statusMark,
    this.duration,
    this.avgDuration,
    this.lesson,
    this.classroomId,
  });

  int lesson;
  int classroomId;
  int duration;
  int avgDuration;
  int score;
  String process;
  int statusMark;

  factory DataSubmitHomework.fromJson(Map<String, dynamic> json) =>
      DataSubmitHomework(
        score: json["score"],
        process: json["process"],
        statusMark: json["status_mark"],
      );

  Map<String, dynamic> toJson() =>
      {
        "score": score,
        "process": process,
        "status_mark": statusMark,
      };

}
