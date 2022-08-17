// To parse this JSON data, do
//
//     final routeData = routeDataFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

RouteData routeDataFromJson(String str) => RouteData.fromJson(json.decode(str));

String routeDataToJson(RouteData data) => json.encode(data.toJson());

class RouteData {
  RouteData({
    this.error,
    this.data,
  });

  bool error;
  List<Routes> data;

  factory RouteData.fromJson(Map<String, dynamic> json) => RouteData(
        error: json["error"],
        data: List<Routes>.from(json["data"].map((x) => Routes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Routes {
  Routes({
    this.date,
    this.dateOfWeek,
    this.startTime,
    this.endTime,
    this.lesson,
    this.exam,
    this.reading,
    this.grammar,
    this.speaking,
    this.writing,
    this.vocabulary,
    this.listening,
    this.material,
    this.zoomId,
    this.zoomPassword,
    this.type,
    this.isFinish,
    this.action,
    this.isCurrentLesson = false,
    this.timeExam,
  });

  bool isCurrentLesson;
  DateTime date;
  String dateOfWeek;
  String startTime;
  String endTime;
  int lesson;
  int exam;
  String reading;
  String grammar;
  String speaking;
  String writing;
  String vocabulary;
  String listening;
  String material;
  String zoomId;
  String zoomPassword;
  TypeLesson type;
  int isFinish;
  int timeExam;
  Action action;

  DateTime getStartDate() {
    try {
      return DateTime(
          date.year,
          date.month,
          date.day,
          int.parse(startTime.split(":").first),
          int.parse(startTime.split(":").skip(1).first));
    } catch (e) {
      return date;
    }
  }

  DateTime getEndDate() {
    try {
      return DateTime(
          date.year,
          date.month,
          date.day,
          int.parse(endTime.split(":").first),
          int.parse(endTime.split(":").skip(1).first));
    } catch (e) {
      return date;
    }
  }

  factory Routes.fromJson(Map<String, dynamic> json) => Routes(
        date: DateFormat("dd-MM-yyyy").parse(json["date"]),
        dateOfWeek: json["date_of_week"] == null ? null : json["date_of_week"],
        startTime: json["start_time"] == null ? null : json["start_time"],
        endTime: json["end_time"] == null ? null : json["end_time"],
        lesson: json["lesson"] == null ? null : json["lesson"],
        exam: json["exam"] == null ? null : json["exam"],
        reading: json["reading"] == null ? null : json["reading"],
        grammar: json["grammar"] == null ? null : json["grammar"],
        speaking: json["speaking"] == null ? null : json["speaking"],
        writing: json["writing"] == null ? null : json["writing"],
        vocabulary: json["vocabulary"] == null ? null : json["vocabulary"],
        listening: json["listening"] == null ? null : json["listening"],
        material: json["material"] == null ? null : json["material"],
        zoomId: json["zoom_id"] == null ? null : json["zoom_id"],
        zoomPassword:
            json["zoom_password"] == null ? null : json["zoom_password"],
        type: typeLessonValues.map[json["type"]],
        isFinish: json["is_finish"] == null ? null : json["is_finish"],
        action: json["action"] == null ? null : Action.fromJson(json["action"]),
        timeExam: json["time_exam"] == null ? null : json["time_exam"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "date_of_week": dateOfWeek == null ? null : dateOfWeek,
        "start_time": startTime == null ? null : startTime,
        "end_time": endTime == null ? null : endTime,
        "lesson": lesson == null ? null : lesson,
        "exam": exam == null ? null : exam,
        "reading": reading == null ? null : reading,
        "grammar": grammar == null ? null : grammar,
        "speaking": speaking == null ? null : speaking,
        "writing": writing == null ? null : writing,
        "vocabulary": vocabulary == null ? null : vocabulary,
        "listening": listening == null ? null : listening,
        "material": material == null ? null : material,
        "zoom_id": zoomId == null ? null : zoomId,
        "zoom_password": zoomPassword == null ? null : zoomPassword,
        "type": typeLessonValues.reverse[type],
        "is_finish": isFinish == null ? null : isFinish,
        "action": action == null ? null : action.toJson(),
        "time_exam": timeExam == null ? null : timeExam,
      };
}

class Action {
  Action({
    this.checkin,
    this.feedback,
    this.feedbackFinish,
    this.learn,
    this.homework,
    this.test,
  });

  bool checkin;
  bool feedback;
  dynamic feedbackFinish;
  Learn learn;
  Homework homework;
  dynamic test;

  factory Action.fromJson(Map<String, dynamic> json) => Action(
        checkin: json["checkin"] != null ? true : false,
        feedback: json["feedback"] != null ? true : false,
        feedbackFinish:
            json["feedback_finish"] != null ? json["feedback_finish"] : null,
        learn: json["learn"] != null ? Learn.fromJson(json["learn"]) : null,
        homework: json["homework"] != null
            ? Homework.fromJson(json["homework"])
            : null,
        test: json["test"] != null ? json["test"] : null,
      );

  Map<String, dynamic> toJson() => {
        "checkin": checkin,
        "feedback": feedback,
        "feedback_finish": feedbackFinish,
        "learn": learn.toJson(),
        "homework": homework.toJson(),
        "test": test,
      };
}

class Homework {
  Homework({
    this.process,
    this.xu,
    this.statusMark,
  });

  double process;
  int xu;
  bool statusMark;

  factory Homework.fromJson(Map<String, dynamic> json) => Homework(
        process: json["process"].toDouble(),
        xu: json["xu"],
        statusMark: json["status_mark"],
      );

  Map<String, dynamic> toJson() => {
        "process": process,
        "xu": xu,
        "status_mark": statusMark,
      };
}

class Learn {
  Learn({
    this.xu,
  });

  int xu;

  factory Learn.fromJson(Map<String, dynamic> json) => Learn(
        xu: json["xu"],
      );

  Map<String, dynamic> toJson() => {
        "xu": xu,
      };
}

enum TypeLesson { HOMEWORK, TUTORING, EXAM, WORKSHOP, CLUB }

final typeLessonValues = EnumValues({
  "exam": TypeLesson.EXAM,
  "homework": TypeLesson.HOMEWORK,
  "tutoring": TypeLesson.TUTORING,
  "workshop": TypeLesson.WORKSHOP,
  "club": TypeLesson.CLUB,
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
