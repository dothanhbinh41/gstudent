import 'dart:convert';

import 'package:gstudent/api/dtos/homework/homework.dart';

ResultHomeworkData resultHomeworkDataFromJson(String str) =>
    ResultHomeworkData.fromJson(json.decode(str));

String resultHomeworkDataToJson(ResultHomeworkData data) =>
    json.encode(data.toJson());

class ResultHomeworkData {
  ResultHomeworkData({
    this.error,
    this.message,
    this.data,
  });

  bool error;
  String message;
  List<ResultHomework> data;

  factory ResultHomeworkData.fromJson(Map<String, dynamic> json) =>
      ResultHomeworkData(
        error: json["error"],
        message: json["message"],
        data: json["data"] != null
            ? List<ResultHomework>.from(
                json["data"].map((x) => ResultHomework.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ResultHomework {
  ResultHomework({
    this.score,
    this.totalScore,
    this.process,
    this.countNotMark,
    this.statusMark,
    this.test,
    this.general,
    this.details,
    this.comment,
    this.avgScore,
  });

  int score;
  int totalScore;
  String process;
  int countNotMark;
  int statusMark;
  double avgScore;
  List<GroupQuestion> test;
  List<Detail> details;
  List<General> general;
  CommentLesson comment;

  factory ResultHomework.fromJson(Map<String, dynamic> json) => ResultHomework(
        score: json["score"],
        totalScore: json["total_score"],
        process: json["process"],
        countNotMark: json["count_not_mark"],
        statusMark: json["status_mark"],
        avgScore: json['avg_score'],
        test: List<GroupQuestion>.from(
            json["test"].map((x) => GroupQuestion.fromJson(x))),
        general: json["general"] != null
            ? List<General>.from(
                json["general"].map((x) => General.fromJson(x)))
            : null,
        details: json["details"] != null
            ? List<Detail>.from(json["details"].map((x) => Detail.fromJson(x)))
            : null,
        comment: json["comment_lesson"] != null ? CommentLesson.fromJson(json["comment_lesson"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "score": score,
        "total_score": totalScore,
        "status_mark": statusMark,
        "process": process,
        "avgScore": avgScore,
        "count_not_mark": countNotMark,
        "test": List<dynamic>.from(test.map((x) => x.toJson())),
        "general": general != null
            ? List<dynamic>.from(general.map((x) => x.toJson()))
            : null,
        "details": details != null
            ? List<dynamic>.from(details.map((x) => x.toJson()))
            : null,
        "comment_lesson": comment.toJson(),
      };
}

class General {
  General({
    this.type,
    this.courseType,
    this.status,
    this.speakingComment,
    this.autoMarkComment,
    this.writingComment,
    this.avgScore,
  });

  String type;
  String courseType;
  int status;
  String speakingComment;
  String autoMarkComment;
  String writingComment;
  double avgScore;

  factory General.fromJson(Map<String, dynamic> json) => General(
        type: json["type"] != null ? json["type"] : "",
        courseType: json["course_type"]!= null  ? json["course_type"] : "",
        status: json["status"] != null ? json["status"] : 0,
        speakingComment:
            json["speaking_comment"] != null ? json["speaking_comment"] : '',
        autoMarkComment:
            json["auto_mark_comment"] != null ? json["auto_mark_comment"] : '',
        writingComment:
            json["writing_comment"] != null ? json["writing_comment"] : '',
        avgScore: json["avg_score"] != null ? json["avg_score"].toDouble() : 0,
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "courseType": courseType,
        "status": status,
        "speaking_comment": speakingComment,
        "auto_mark_comment": autoMarkComment,
        "writing_comment": writingComment,
        "avg_score": avgScore,
      };
}

class Detail {
  Detail({
    this.id,
    this.overallId,
    this.key,
    this.value,
    this.status,
  });

  int id;
  int overallId;
  String key;
  double value;
  dynamic status;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        id: json["id"],
        overallId: json["overall_id"],
        key: json["key"],
        value: json["value"] != null ? json["value"].toDouble() : 0,
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "overall_id": overallId,
        "key": key,
        "value": value,
        "status": status,
      };
}

class CommentLesson {
  CommentLesson({
    this.id,
    this.classroomId,
    this.lesson,
    this.courseStudentId,
    this.comment,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int classroomId;
  int lesson;
  int courseStudentId;
  String comment;
  DateTime createdAt;
  DateTime updatedAt;

  factory CommentLesson.fromJson(Map<String, dynamic> json) => CommentLesson(
        id: json["id"],
        classroomId: json["classroom_id"],
        lesson: json["lesson"],
        courseStudentId: json["course_student_id"],
        comment: json["comment"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "classroom_id": classroomId,
        "lesson": lesson,
        "course_student_id": courseStudentId,
        "comment": comment,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
