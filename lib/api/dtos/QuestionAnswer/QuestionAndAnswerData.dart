// To parse this JSON data, do
//
//     final questionAndAnswerData = questionAndAnswerDataFromJson(jsonString);

import 'dart:convert';

QuestionAndAnswerData questionAndAnswerDataFromJson(String str) => QuestionAndAnswerData.fromJson(json.decode(str));

String questionAndAnswerDataToJson(QuestionAndAnswerData data) => json.encode(data.toJson());

class QuestionAndAnswerData {
  QuestionAndAnswerData({
    this.error,
    this.message,
    this.data,
  });

  bool error;
  String message;
  List<QuestionAndAnswer> data;

  factory QuestionAndAnswerData.fromJson(Map<String, dynamic> json) => QuestionAndAnswerData(
    error: json["error"],
    message: json["message"],
    data: List<QuestionAndAnswer>.from(json["data"].map((x) => QuestionAndAnswer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class QuestionAndAnswer {
  QuestionAndAnswer({
    this.id,
    this.name,
    this.qAndAs,
  });

  int id;
  String name;
  List<QAndA> qAndAs;

  factory QuestionAndAnswer.fromJson(Map<String, dynamic> json) => QuestionAndAnswer(
    id: json["id"],
    name: json["name"],
    qAndAs: List<QAndA>.from(json["q_and_as"].map((x) => QAndA.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "q_and_as": List<dynamic>.from(qAndAs.map((x) => x.toJson())),
  };
}

class QAndA {
  QAndA({
    this.id,
    this.question,
    this.answer,
    this.status,
    this.categoryId,
  });

  int id;
  String question;
  String answer;
  int status;
  int categoryId;

  factory QAndA.fromJson(Map<String, dynamic> json) => QAndA(
    id: json["id"],
    question: json["question"],
    answer: json["answer"],
    status: json["status"],
    categoryId: json["category_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "answer": answer,
    "status": status,
    "category_id": categoryId,
  };
}
