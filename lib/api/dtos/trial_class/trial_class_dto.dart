// To parse this JSON data, do
//
//     final trialClassData = trialClassDataFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gstudent/common/controls/time_ago.dart';
import 'package:intl/intl.dart';

TrialClassData trialClassDataFromJson(String str) => TrialClassData.fromJson(json.decode(str));

String trialClassDataToJson(TrialClassData data) => json.encode(data.toJson());

class TrialClassData {
  TrialClassData({
    this.error,
    this.message,
    this.data,
  });

  bool error;
  String message;
  List<TrialClass> data;

  factory TrialClassData.fromJson(Map<String, dynamic> json) => TrialClassData(
    error: json["error"],
    message: json["message"] != null ?  json["message"] : "",
    data: List<TrialClass>.from(json["data"].map((x) => TrialClass.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class TrialClass {
  TrialClass({
    this.name,
    this.zoomId,
    this.zoomPassword,
    this.id,
    this.startDate,
    this.scheduleStartDate,
    this.scheduleEndDate,
    this.day,
    this.dayOfWeek,
    this.courseStudentId,
  });

  String name;
  String zoomId;
  String zoomPassword;
  int id;
  DateTime startDate;
  String scheduleStartDate;
  String scheduleEndDate;
  String day;
  int dayOfWeek;
  int courseStudentId;

  factory TrialClass.fromJson(Map<String, dynamic> json) => TrialClass(
    name: json["name"],
    zoomId: json["zoom_id"],
    zoomPassword: json["zoom_password"],
    id: json["id"],
    startDate: DateTime.parse(json["start_date"]),
    scheduleStartDate: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(json["start_date"] +' '+json["schedule_start_date"])),
    scheduleEndDate: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(json["start_date"] +' '+json["schedule_end_date"])),
    day: json["day"],
    dayOfWeek: json["day_of_week"],
    courseStudentId: json["course_student_id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "zoom_id": zoomId,
    "zoom_password": zoomPassword,
    "id": id,
    "start_date": startDate.toIso8601String(),
    "schedule_start_date": scheduleStartDate,
    "schedule_end_date": scheduleEndDate,
    "day": day,
    "day_of_week": dayOfWeek,
    "course_student_id": courseStudentId,
  };
}
