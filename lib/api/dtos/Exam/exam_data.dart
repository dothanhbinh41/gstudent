// To parse this JSON data, do
//
//     final testData = testDataFromJson(jsonString);

import 'dart:convert';

TestData testDataFromJson(String str) => TestData.fromJson(json.decode(str));

String testDataToJson(TestData data) => json.encode(data.toJson());

class TestData {
  TestData({
    this.error,
    this.message,
    this.data,
  });

  bool error;
  String message;
  List<Exam> data;

  factory TestData.fromJson(Map<String, dynamic> json) => TestData(
    error: json["error"],
    message: json["message"],
    data: List<Exam>.from(json["data"].map((x) => Exam.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Exam {
  Exam({
    this.id,
    this.name,
    this.type,
    this.userCreated,
  });

  int id;
  String name;
  String type;
  int userCreated;

  factory Exam.fromJson(Map<String, dynamic> json) => Exam(
    id: json["id"],
    name: json["name"],
    type:  json["type"],
    userCreated: json["user_created"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
    "user_created": userCreated,
  };
}


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
