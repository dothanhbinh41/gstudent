import 'dart:convert';

MessageResponse MessageResponseFromJson(String str) =>
    MessageResponse.fromJson(json.decode(str));

String MessageResponseToJson(MessageResponse data) =>
    json.encode(data.toJson());

class MessageResponse {
  MessageResponse({
    this.error,
    this.message,
  });

  bool error;
  String message;

  factory MessageResponse.fromJson(Map<String, dynamic> json) =>
      MessageResponse(
        error: json["error"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
      };
}

MessageDataResponse MessageDataResponseFromJson(String str) =>
    MessageDataResponse.fromJson(json.decode(str));

String MessageDataResponseToJson(MessageDataResponse data) =>
    json.encode(data.toJson());

class MessageDataResponse {
  MessageDataResponse({
    this.error,
    this.message,
    this.isSuccess
  });

  bool error;
  String message;
  bool isSuccess;

  factory MessageDataResponse.fromJson(Map<String, dynamic> json) =>
      MessageDataResponse(
          error: json["error"],
          message: json["message"],
          isSuccess: json["data"] == null ? true : false);

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
    "isSuccess" : isSuccess
      };
}
