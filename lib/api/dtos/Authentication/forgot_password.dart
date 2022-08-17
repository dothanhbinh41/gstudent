// To parse this JSON data, do
//
//     final fogotPasswordResponse = fogotPasswordResponseFromJson(jsonString);

import 'dart:convert';

FogotPasswordResponse fogotPasswordResponseFromJson(String str) => FogotPasswordResponse.fromJson(json.decode(str));

String fogotPasswordResponseToJson(FogotPasswordResponse data) => json.encode(data.toJson());

class FogotPasswordResponse {
  FogotPasswordResponse({
    this.error,
    this.message,
    this.data,
  });

  bool error;
  String message;
  dynamic data;

  factory FogotPasswordResponse.fromJson(Map<String, dynamic> json) => FogotPasswordResponse(
    error: json["error"],
    message: json["message"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "data": data,
  };
}
