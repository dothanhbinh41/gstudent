
import 'dart:convert';

import 'package:gstudent/api/dtos/TestInput/image.dart';

ImagesResultDto imgFromJson(String str) => ImagesResultDto.fromJson(json.decode(str));

String toJson(ImagesResultDto data) => json.encode(data.toJson());

class ImagesResultDto {
  ImagesResultDto({
    this.errors,
    this.data,
  });

  bool errors;
  List<Images> data;

  factory ImagesResultDto.fromJson(Map<String, dynamic> json) => ImagesResultDto(
    errors: json["errors"],
    data: List<Images>.from(json["data"].map((x) => Images.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "errors": errors,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

