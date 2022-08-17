import 'dart:convert';

import 'package:gstudent/api/dtos/TestInput/ielts.dart';

DataTestInputDto fromJson(String str) => DataTestInputDto.fromJson(json.decode(str));

String toJson(DataTestInputDto data) => json.encode(data.toJson());

class DataTestInputDto {
  DataTestInputDto({
    this.error,
    this.message,
    this.importId,
    this.data,
  });

  bool error;
  String message;
  int importId;
  TestInputDto data;

  factory DataTestInputDto.fromJson(Map<String, dynamic> json) => DataTestInputDto(
    error: json["error"],
    message: json["message"],
    importId: json["import_id"],
    data:TestInputDto.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "import_id": importId,
    "data": data.toJson(),
  };
}