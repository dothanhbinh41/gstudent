// To parse this JSON data, do
//
//     final resultTestData = resultTestDataFromJson(jsonString);

import 'dart:convert';

import 'package:gstudent/api/dtos/Exam/GroupQuestionExam.dart';

ResultTestData resultTestDataFromJson(String str) => ResultTestData.fromJson(json.decode(str));

String resultTestDataToJson(ResultTestData data) => json.encode(data.toJson());

class ResultTestData {
  ResultTestData({
    this.error,
    this.message,
    this.data,
  });

  bool error;
  String message;
  List<Datum> data;

  factory ResultTestData.fromJson(Map<String, dynamic> json) => ResultTestData(
    error: json["error"],
    message: json["message"],
    data: json["data"] != null ? List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))) : null,
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.score,
    this.totalScore,
    this.process,
    this.test,
  });

  int score;
  int totalScore;
  String process;
  List<PracticeGroupQuestion> test;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    score: json["score"],
    totalScore: json["total_score"],
    process: json["process"],
    test: List<PracticeGroupQuestion>.from(json["test"].map((x) => PracticeGroupQuestion.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "score": score,
    "total_score": totalScore,
    "process": process,
    "test": List<dynamic>.from(test.map((x) => x.toJson())),
  };
}
