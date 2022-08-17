// To parse this JSON data, do
//
//     final homeworkData = homeworkDataFromJson(jsonString);

import 'dart:convert';

import 'package:gstudent/api/dtos/TestInput/image.dart';

SaveQuestionTodo saveQuestionTodoFromJson(String str) =>
    SaveQuestionTodo.fromJson(json.decode(str));

String saveQuestionTodoJson(SaveQuestionTodo data) =>
    json.encode(data.toJson());

class SaveQuestionTodo {
  SaveQuestionTodo({
    this.data,
    this.time,
  });

  int time;

  List<GroupQuestion> data;

  factory SaveQuestionTodo.fromJson(Map<String, dynamic> json) =>
      SaveQuestionTodo(
        time: json['time'],
        data: List<GroupQuestion>.from(
            json["data"].map((x) => GroupQuestion.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "time": this.time,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

HomeworkData homeworkDataFromJson(String str) =>
    HomeworkData.fromJson(json.decode(str));

String homeworkDataToJson(HomeworkData data) => json.encode(data.toJson());

class HomeworkData {
  HomeworkData({
    this.error,
    this.message,
    this.data,
  });

  bool error;
  String message;
  List<GroupQuestion> data;

  factory HomeworkData.fromJson(Map<String, dynamic> json) => HomeworkData(
        error: json["error"],
        message: json["message"],
        data: json["data"] != null && json["data"] != ""
            ? List<GroupQuestion>.from(
                json["data"].map((x) => GroupQuestion.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

HomeworkAdvanceData homeworkAdvanceDataFromJson(String str) =>
    HomeworkAdvanceData.fromJson(json.decode(str));

String homeworkAdvanceDataToJson(HomeworkAdvanceData data) =>
    json.encode(data.toJson());

class HomeworkAdvanceData {
  HomeworkAdvanceData({
    this.error,
    this.message,
    this.data,
  });

  bool error;
  String message;
  Data data;

  factory HomeworkAdvanceData.fromJson(Map<String, dynamic> json) =>
      HomeworkAdvanceData(
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
    this.question,
    this.testGroupId,
  });

  List<GroupQuestion> question;
  List<int> testGroupId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        question: List<GroupQuestion>.from(
            json["question"].map((x) => GroupQuestion.fromJson(x))),
        testGroupId: List<int>.from(json["test_group_id"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "question": List<dynamic>.from(question.map((x) => x.toJson())),
        "test_group_id": List<dynamic>.from(testGroupId.map((x) => x)),
      };
}

class GroupQuestion {
  GroupQuestion({
    this.id,
    this.testId,
    this.title,
    this.description,
    this.script,
    this.audio,
    this.image,
    this.type,
    this.questions,
  });

  int id;
  int testId;
  String title;
  String description;
  String script;
  String audio;
  String image;
  QuestionType type;
  List<Question> questions;

  factory GroupQuestion.fromJson(Map<String, dynamic> json) => GroupQuestion(
        id: json["id"] != null ? json["id"] : null,
        testId: json["test_id"] != null ? json["test_id"] : null,
        title: json["title"] == null ? null : json["title"],
        description: json["description"] != null ? json["description"] : null,
        script: json["script"] != null ? json["script"] : null,
        audio: json["audio"] != null ? json["audio"] : null,
        image: json["image"] != null ? json["image"] : null,
        type: json["type"] != null
            ? homeworkQuestionTypeValues.map[json["type"]]
            : null,
        questions: json["test_questions"] != null
            ? List<Question>.from(
                json["test_questions"].map((x) => Question.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id != null ? id : null,
        "test_id": testId != null ? testId : null,
        "title": title == null ? null : title,
        "description": description != null ? description : null,
        "script": script != null ? script : null,
        "audio": audio != null ? audio : null,
        "image": image != null ? image : null,
        "type": type != null ? homeworkQuestionTypeValues.reverse[type] : null,
        "test_questions": questions != null
            ? List<dynamic>.from(questions.map((x) => x.toJson()))
            : null,
      };
}

class Question {
  Question({
    this.id,
    this.groupQuestionId,
    this.title,
    this.correctAnswer,
    this.image,
    this.audio,
    this.type,
    this.vocab,
    this.answers,
    this.answer,
    this.isTrue,
    this.studentAnswer,
  });

  int id;
  int groupQuestionId;
  String title;
  String correctAnswer;
  String image;
  String audio;
  QuestionType type;
  String vocab;
  List<QuestionAnswer> answers;
  QuestionAnswer answer;
  bool isTrue;
  String studentAnswer;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["id"] != null ? json["id"] : null,
        groupQuestionId: json["group_question_id"] != null
            ? json["group_question_id"]
            : null,
        title: json["title"] == null ? null : json["title"],
        correctAnswer:
            json["correct_answer"] != null ? json["correct_answer"] : null,
        image: json["image"] != null ? json["image"] : null,
        audio: json["audio"] != null ? json["audio"] : null,
        type: json["type"] != null
            ? homeworkQuestionTypeValues.map[json["type"]]
            : null,
        vocab: json["vocab"] == null ? null : json["vocab"],
        answer: json["answer"] != null
            ? QuestionAnswer.fromJson(json["answer"])
            : null,
        answers: json["test_answers"] != null
            ? List<QuestionAnswer>.from(
                json["test_answers"].map((x) => QuestionAnswer.fromJson(x)))
            : null,
        isTrue: json["is_true"] != null ? json["is_true"] : null,
        studentAnswer:
            json["student_answer"] != null ? json["student_answer"] : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id != null ? id : null,
        "group_question_id": groupQuestionId != null ? groupQuestionId : null,
        "title": title == null ? null : title,
        "correct_answer": correctAnswer != null ? correctAnswer : null,
        "image": image != null ? image : null,
        "audio": audio != null ? audio : null,
        "type": type != null ? homeworkQuestionTypeValues.reverse[type] : null,
        "vocab": vocab == null ? null : vocab,
        "answer": answer != null ? answer.toJson() : null,
        "test_answers": answers != null
            ? List<dynamic>.from(answers.map((x) => x.toJson()))
            : null,
        "is_true": isTrue != null ? isTrue : null,
        "student_answer": studentAnswer != null ? studentAnswer : null,
      };
}

class QuestionAnswer {
  QuestionAnswer(
      {this.id,
      this.questionId,
      this.content,
      this.position,
      this.audio,
      this.image,
      this.isSelected,
      this.record,
      this.images,
      this.timeAnswer = 0});

  int id;
  int questionId;
  String content;
  int position;
  String audio;
  String record;
  String image;
  List<Images> images;
  bool isSelected;
  int timeAnswer;

  factory QuestionAnswer.fromJson(Map<String, dynamic> json) => QuestionAnswer(
      id: json["id"] != null ? json["id"] : null,
      questionId: json["question_id"] != null ? json["question_id"] : null,
      content: json["content"] != null ? json["content"] : null,
      position: json["position"] == null ? null : json["position"],
      audio: json["audio"] != null ? json["audio"] : null,
      image: json["image"] != null ? json["image"] : null,
      timeAnswer: json["timeAnswer"] != null ? json["timeAnswer"] : null,
      isSelected: json["isSelected"] != null ? json["isSelected"] : false);

  Map<String, dynamic> toJson() => {
        "id": id != null ? id : null,
        "question_id": questionId != null ? questionId : null,
        "content": content != null ? content : null,
        "position": position == null ? null : position,
        "audio": audio != null ? audio : null,
        "image": image != null ? image : null,
        "images": images != null
            ? List<dynamic>.from(images.map((x) => x.toJson()))
            : null,
        "timeAnswer": timeAnswer != null ? timeAnswer : null,
        "isSelected": isSelected != null ? isSelected : false
      };
}

enum QuestionType {
  MATCH_TEXT_IMAGE,
  FILL_TEXT_SCRIPT,
  FILL_TEXT_IMAGE,
  SINGLE_CHOICE,
  ARRANGE_SENTENCES,
  FILL_TEXT_AUDIO,
  MATCH_TEXT_AUDIO,
  MATCH_IMAGE_AUDIO,
  RECORD_AUDIO,
  MULTI_SELECTION,
  FILL_SCRIPT,
  WRITING
}

final homeworkQuestionTypeValues = EnumValues({
  "arrange_sentences": QuestionType.ARRANGE_SENTENCES,
  "fill_text_script": QuestionType.FILL_TEXT_SCRIPT,
  "match_text_image": QuestionType.MATCH_TEXT_IMAGE,
  "single_choice": QuestionType.SINGLE_CHOICE,
  "fill_text_audio": QuestionType.FILL_TEXT_AUDIO,
  "fill_text_image": QuestionType.FILL_TEXT_IMAGE,
  "match_text_audio": QuestionType.MATCH_TEXT_AUDIO,
  "match_image_audio": QuestionType.MATCH_IMAGE_AUDIO,
  "record_audio": QuestionType.RECORD_AUDIO,
  "multi_selection": QuestionType.MULTI_SELECTION,
  "multiple_choice": QuestionType.MULTI_SELECTION,
  "fill_script": QuestionType.FILL_SCRIPT,
  "write_paragraph": QuestionType.WRITING
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
