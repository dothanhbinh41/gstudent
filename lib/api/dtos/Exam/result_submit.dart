// To parse this JSON data, do
//
//     final resultSubmitTest = resultSubmitTestFromJson(jsonString);

import 'dart:convert';

ResultSubmitTest resultSubmitTestFromJson(String str) => ResultSubmitTest.fromJson(json.decode(str));

String resultSubmitTestToJson(ResultSubmitTest data) => json.encode(data.toJson());

class ResultSubmitTest {
  ResultSubmitTest({
    this.error,
    this.message,
    this.data,
  });

  bool error;
  String message;
  ResultTest data;

  factory ResultSubmitTest.fromJson(Map<String, dynamic> json) => ResultSubmitTest(
    error: json["error"],
    message: json["message"],
    data: ResultTest.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "data": data.toJson(),
  };
}

class ResultTest {
  ResultTest({
    this.score,
    this.process,
  });

  int score;
  String process;

  factory ResultTest.fromJson(Map<String, dynamic> json) => ResultTest(
    score: json["score"],
    process: json["process"],
  );

  Map<String, dynamic> toJson() => {
    "score": score,
    "process": process,
  };
}
