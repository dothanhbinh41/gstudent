// To parse this JSON data, do
//
//     final quantitySpecial = quantitySpecialFromJson(jsonString);

import 'dart:convert';

QuantitySpecial quantitySpecialFromJson(String str) => QuantitySpecial.fromJson(json.decode(str));

String quantitySpecialToJson(QuantitySpecial data) => json.encode(data.toJson());

class QuantitySpecial {
  QuantitySpecial({
    this.error,
    this.message,
    this.data,
  });

  bool error;
  String message;
  int data;

  factory QuantitySpecial.fromJson(Map<String, dynamic> json) => QuantitySpecial(
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
