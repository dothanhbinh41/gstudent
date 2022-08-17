
import 'dart:convert';

import 'package:gstudent/api/dtos/Authentication/user_info.dart';
import 'package:gstudent/api/dtos/Course/course.dart';

LoginResponse LoginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String LoginResponseToJson(LoginResponse data) => json.encode(data.toJson());


class LoginResponse {
  LoginResponse({
    this.error,
    this.message,
    this.data,
  });

  bool error;
  String message;
  DataLogin data;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    error: json["error"],
    message: json["message"],
    data:  json["data"] == null ? null : DataLogin.fromJson(json["data"])
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "data": data != null ? data.toJson() : null,
  };
}


class DataLogin {
  DataLogin({
    this.userInfo,
    this.course,
  });

  User userInfo;
  List<CourseModel> course;

  factory DataLogin.fromJson(Map<String, dynamic> json) => DataLogin(
    userInfo:json["user_info"] != null ? User.fromJson(json["user_info"]) : null,
    course: json["course"] != null ?  List<CourseModel>.from(json["course"].map((x) => CourseModel.fromJson(x))) : null,
  );

  Map<String, dynamic> toJson() => {
    "user_info": userInfo != null ?  userInfo.toJson() : null,
    "course":course != null ? List<dynamic>.from(course.map((x) => x.toJson())) : null,
  };
}


class LoginResponseVer2 {
  LoginResponseVer2({
    this.error,
    this.message,
    this.data,
  });

  bool error;
  String message;
  DataLoginVer2 data;

  factory LoginResponseVer2.fromJson(Map<String, dynamic> json) => LoginResponseVer2(
      error: json["error"],
      message: json["message"],
      data:  json["data"] == null ? null : DataLoginVer2.fromJson(json["data"])
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "data":data != null ?   data.toJson() : null,
  };
}


class DataLoginVer2 {
  DataLoginVer2({
    this.userInfo,
  });

  User userInfo;

  factory DataLoginVer2.fromJson(Map<String, dynamic> json) => DataLoginVer2(
    userInfo:json["user_info"] != null ? User.fromJson(json["user_info"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "user_info": userInfo.toJson(),
  };
}
