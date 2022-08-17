// To parse this JSON data, do
//
//     final groupQuestionArena = groupQuestionArenaFromJson(jsonString);

import 'dart:convert';

List<GroupQuestionArena> groupQuestionArenaFromJson(String str) =>
    List<GroupQuestionArena>.from(
        json.decode(str).map((x) => GroupQuestionArena.fromJson(x)));

String groupQuestionArenaToJson(List<GroupQuestionArena> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GroupQuestionArena {
  GroupQuestionArena({
    this.id,
    this.groupQuestionId,
    this.title,
    this.correctAnswer,
    this.image,
    this.audio,
    this.testAnswers,
  });

  int id;
  int groupQuestionId;
  String title;
  String correctAnswer;
  String image;
  String audio;
  List<AnswerQuestionArena> testAnswers;

  factory GroupQuestionArena.fromJson(Map<String, dynamic> json) =>
      GroupQuestionArena(
        id: json["id"],
        groupQuestionId: json["group_question_id"],
        title: json["title"],
        correctAnswer: json["correct_answer"],
        image: json["image"],
        audio: json["audio"],
        testAnswers: List<AnswerQuestionArena>.from(
            json["test_answers"].map((x) => AnswerQuestionArena.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "group_question_id": groupQuestionId,
        "title": title,
        "correct_answer": correctAnswer,
        "image": image,
        "audio": audio,
        "test_answers": List<dynamic>.from(testAnswers.map((x) => x.toJson())),
      };
}

class AnswerQuestionArena {
  AnswerQuestionArena(
      {this.id,
      this.questionId,
      this.content,
      this.position,
      this.audio,
      this.image,
      this.createdAt,
      this.updatedAt,
      this.isSelected});

  int id;
  int questionId;
  String content;
  int position;
  String audio;
  String image;
  DateTime createdAt;
  DateTime updatedAt;
  bool isSelected;

  factory AnswerQuestionArena.fromJson(Map<String, dynamic> json) =>
      AnswerQuestionArena(
        id: json["id"],
        questionId: json["question_id"],
        content: json["content"],
        position: json["position"] == null ? null : json["position"],
        audio: json["audio"],
        image: json["image"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question_id": questionId,
        "content": content,
        "position": position == null ? null : position,
        "audio": audio,
        "image": image,
        "isSelected": isSelected,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
