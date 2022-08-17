import 'dart:convert';

DataDtoBase fromJson(String str) => DataDtoBase.fromJson(json.decode(str));

String toJson(DataDtoBase data) => json.encode(data.toJson());

class DataDtoBase {
  DataDtoBase({
    this.error,
    this.message,
  });

  bool error;
  String message;

  factory DataDtoBase.fromJson(Map<String, dynamic> json) => DataDtoBase(
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
  };
}

DataDto dataFromJson(String str) => DataDto.fromJson(json.decode(str));

String dataToJson(DataDtoBase data) => json.encode(data.toJson());

class DataDto {
  DataDto({
    this.error,
    this.msg,
  });

  bool error;
  String msg;

  factory DataDto.fromJson(Map<String, dynamic> json) => DataDto(
    error: json["error"],
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "msg": msg,
  };
}

DatasDto datasFromJson(String str) => DatasDto.fromJson(json.decode(str));

String datasToJson(DataDtoBase data) => json.encode(data.toJson());

class DatasDto {
  DatasDto({
    this.errors,
    this.message,
  });

  bool errors;
  String message;

  factory DatasDto.fromJson(Map<String, dynamic> json) => DatasDto(
    errors: json["errors"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "errors": errors,
    "message": message,
  };
}

ResultDatasDto rsdatasFromJson(String str) =>
    ResultDatasDto.fromJson(json.decode(str));

String rsdatasToJson(DataDtoBase data) => json.encode(data.toJson());

class ResultDatasDto {
  ResultDatasDto({
    this.error,
    this.messages,
  });

  bool error;
  dynamic messages;

  factory ResultDatasDto.fromJson(Map<String, dynamic> json) => ResultDatasDto(
    error: json["error"],
    messages:  json["messages"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "messages": error == true
        ? List<dynamic>.from(messages.map((x) => x))
        : messages,
  };
}
