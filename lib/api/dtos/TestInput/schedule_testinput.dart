// To parse this JSON data, do
//
//     final checkScheduleTestinput = checkScheduleTestinputFromJson(jsonString);

import 'dart:convert';

CheckScheduleTestinput checkScheduleTestinputFromJson(String str) => CheckScheduleTestinput.fromJson(json.decode(str));

String checkScheduleTestinputToJson(CheckScheduleTestinput data) => json.encode(data.toJson());

class CheckScheduleTestinput {
  CheckScheduleTestinput({
    this.error,
    this.message,
    this.data,
  });

  bool error;
  dynamic message;
  Data data;

  factory CheckScheduleTestinput.fromJson(Map<String, dynamic> json) => CheckScheduleTestinput(
    error: json["error"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.zoomId,
    this.zoomPassword,
    this.typeTest,
    this.timeZoom
  });

  int id;
  String zoomId;
  String zoomPassword;
  String typeTest;
  DateTime timeZoom;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    zoomId: json["zoom_id"],
    zoomPassword: json["zoom_password"],
    typeTest: json["type_test"] != null ? json["type_test"]  : null,
    timeZoom: json["schedule"] != null ? DateTime.parse(json["schedule"]).toLocal()  : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "zoom_id": zoomId,
    "zoom_password": zoomPassword,
    "type_test": typeTest,
    "timeZoom" : timeZoom.toIso8601String(),
  };
}
