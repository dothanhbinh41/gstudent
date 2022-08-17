// To parse this JSON data, do
//
//     final createSupportResponse = createSupportResponseFromJson(jsonString);

import 'dart:convert';

CreateSupportResponse createSupportResponseFromJson(String str) => CreateSupportResponse.fromJson(json.decode(str));

String createSupportResponseToJson(CreateSupportResponse data) => json.encode(data.toJson());

class CreateSupportResponse {
  CreateSupportResponse({
    this.error,
    this.message,
    this.data,
  });

  bool error;
  String message;
  Data data;

  factory CreateSupportResponse.fromJson(Map<String, dynamic> json) => CreateSupportResponse(
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
    this.content,
    this.title,
    this.userId,
    this.updatedAt,
    this.createdAt,
  });

  int id;
  String content;
  String title;
  int userId;
  DateTime updatedAt;
  DateTime createdAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    content: json["content"],
    title: json["title"],
    userId: json["user_id"],
    updatedAt: DateTime.parse(json["updatedAt"]),
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "content": content,
    "title": title,
    "user_id": userId,
    "updatedAt": updatedAt.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
  };
}
