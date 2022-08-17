// To parse this JSON data, do
//
//     final groupQuestionExam = groupQuestionExamFromJson(jsonString);

import 'dart:convert';

import 'package:gstudent/api/dtos/homework/homework.dart';

QuestionExamData questionExamFromJson(String str) => QuestionExamData.fromJson(json.decode(str));

String questionExamToJson(QuestionExamData data) => json.encode(data.toJson());

class QuestionExamData {
  QuestionExamData({
    this.error,
    this.message,
    this.data,
  });

  bool error;
  String message;
  GroupQuestionExam data;

  factory QuestionExamData.fromJson(Map<String, dynamic> json) => QuestionExamData(
        error: json["error"],
        message: json["message"],
        data: json["data"] != null ? GroupQuestionExam.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": data.toJson(),
      };
}

class GroupQuestionExam {
  GroupQuestionExam({
    this.id,
    this.type,
    this.practiceGroupQuestions,
  });

  int id;
  String type;
  List<PracticeGroupQuestion> practiceGroupQuestions;

  factory GroupQuestionExam.fromJson(Map<String, dynamic> json) => GroupQuestionExam(
        id: json["id"],
        type: json["type"],
        practiceGroupQuestions: List<PracticeGroupQuestion>.from(json["practice_group_questions"].map((x) => PracticeGroupQuestion.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "practice_group_questions": List<dynamic>.from(practiceGroupQuestions.map((x) => x.toJson())),
      };
}

class PracticeGroupQuestion {
  PracticeGroupQuestion({
    this.id,
    this.practiceId,
    this.title,
    this.description,
    this.scripts,
    this.type,
    this.audio,
    this.image,
    this.practiceQuestions,
  });

  int id;
  int practiceId;
  QuestionType title;
  String description;
  String scripts;
  QuestionType type;
  String audio;
  String image;
  List<PracticeQuestion> practiceQuestions;

  factory PracticeGroupQuestion.fromJson(Map<String, dynamic> json) => PracticeGroupQuestion(
        id: json["id"] != null ? json["id"] : null,
        practiceId: json["practice_id"] != null ? json["practice_id"] : null,
        title: json["title"] != null ? homeworkQuestionTypeValues.map[json["title"]] : null,
        description: json["description"] != null ? json["description"] : null,
        scripts: json["scripts"] == null ? null : json["scripts"],
        type: json["type"] != null ? homeworkQuestionTypeValues.map[json["type"]] : null,
        audio: json["audio"] != null ? json["audio"] : null,
        image: json["image"] != null ? json["image"] : null,
        practiceQuestions: json["practice_questions"] != null ? List<PracticeQuestion>.from(json["practice_questions"].map((x) => PracticeQuestion.fromJson(x))) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "practice_id": practiceId,
        "title": title != null ? homeworkQuestionTypeValues.reverse[title] : null,
        "description": description,
        "scripts": scripts == null ? null : scripts,
        "type": type != null ? homeworkQuestionTypeValues.reverse[type] : null,
        "audio": audio,
        "image": image,
        "practice_questions": List<dynamic>.from(practiceQuestions.map((x) => x.toJson())),
      };
}

List<PracticeQuestion> groupPracticeQuestionFromJson(String str) => List<PracticeQuestion>.from(json.decode(str).map((x) => PracticeQuestion.fromJson(x)));

class PracticeQuestion {
  PracticeQuestion({this.id, this.groupQuestionId, this.title, this.correctAnswers, this.practiceAnswers, this.answer, this.studentAnswer, this.isTrue,this
      .practiceGroupQuestion});

  int id;
  int groupQuestionId;
  String title;
  String correctAnswers;
  List<PracticeAnswer> practiceAnswers;
  bool isTrue;
  String studentAnswer;
  PracticeAnswer answer;
  PracticeGroupQuestion practiceGroupQuestion;

  factory PracticeQuestion.fromJson(Map<String, dynamic> json) => PracticeQuestion(
        id: json["id"] != null ? json["id"] : null,
        groupQuestionId: json["group_question_id"] != null ? json["group_question_id"] : null,
        title: json["title"] != null ? json["title"] : null,
        correctAnswers: json["correct_answers"] != null ? json["correct_answers"] : null,
        practiceAnswers: json["practice_answers"] != null ? List<PracticeAnswer>.from(json["practice_answers"].map((x) => PracticeAnswer.fromJson(x))) : null,
        answer: json["answer"] != null ? PracticeAnswer.fromJson(json["answer"]) : null,
        isTrue: json["is_true"] != null ? json["is_true"] : null,
        studentAnswer: json["student_answer"] != null ? json["student_answer"] : null,
        practiceGroupQuestion: json["practice_group_question"]!= null ? PracticeGroupQuestion.fromJson(json["practice_group_question"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id != null ? id : null,
        "group_question_id": groupQuestionId != null ? groupQuestionId : null,
        "title": title != null ? title : null,
        "correct_answers": correctAnswers != null ? correctAnswers : null,
        "practice_answers": List<dynamic>.from(practiceAnswers.map((x) => x.toJson())),
        "answer": answer != null ? answer.toJson() : null,
        "is_true": isTrue != null ? isTrue : null ,
        "student_answer": studentAnswer != null ? studentAnswer : null,
      };
}

class PracticeAnswer {
  PracticeAnswer({this.id, this.questionId, this.content, this.position, this.isSelected = false});

  bool isSelected;
  int id;
  int questionId;
  String content;
  int position;

  factory PracticeAnswer.fromJson(Map<String, dynamic> json) => PracticeAnswer(
        id: json["id"] != null ? json["id"] : null,
        questionId: json["question_id"] != null ? json["question_id"] : null,
        content: json["content"] != null ? json["content"] : null,
        position: json["position"] != null ? json["position"] : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id != null ? id : null,
        "question_id": questionId != null ? questionId : null,
        "content": content != null ? content : null,
        "position": position != null ? position : null,
      };
}
