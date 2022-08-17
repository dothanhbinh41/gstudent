
import 'dart:convert';

import 'package:gstudent/api/dtos/Course/course.dart';

CourseResponse CourseResponseFromJson(String str) => CourseResponse.fromJson(json.decode(str));

String CourseResponseToJson(CourseResponse data) => json.encode(data.toJson());


class CourseResponse {
  CourseResponse({
    this.error,
    this.message,
    this.data,
  });

  bool error;
  String message;
  DataCourse data;

  factory CourseResponse.fromJson(Map<String, dynamic> json) => CourseResponse(
      error: json["error"],
      message: json["message"],
      data:  json["data"] == null ? null : DataCourse.fromJson(json["data"])
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "data": data.toJson(),
  };
}


class DataCourse {
  DataCourse({
    // this.userInfo,
    this.course,
  });

  // User userInfo;
  List<CourseModel> course;

  factory DataCourse.fromJson(Map<String, dynamic> json) => DataCourse(
    // userInfo:json["user_info"] != null ? User.fromJson(json["user_info"]) : null,
    course: List<CourseModel>.from(json["course"].map((x) => CourseModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    // "user_info": userInfo.toJson(),
    "course": List<dynamic>.from(course.map((x) => x.toJson())),
  };
}
