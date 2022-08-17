// To parse this JSON data, do
//
//     final vocabData = vocabDataFromJson(jsonString);

import 'dart:convert';

VocabData vocabDataFromJson(String str) => VocabData.fromJson(json.decode(str));

String vocabDataToJson(VocabData data) => json.encode(data.toJson());

class VocabData {
  VocabData({
    this.error,
    this.message,
    this.data,
    this.folderName,
  });

  bool error;
  String message;
  List<Vocab> data;
  String folderName;

  factory VocabData.fromJson(Map<String, dynamic> json) => VocabData(
    error: json["error"],
    message: json["message"],
    data: List<Vocab>.from(json["data"].map((x) => Vocab.fromJson(x))),
    folderName: json["folder_name"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "folder_name": folderName,
  };
}

class Vocab {
  Vocab({
    this.id,
    this.courseId,
    this.testId,
    this.video,
    this.engsub,
    this.vietsub,
    this.vocabOrWord,
    this.meaning,
    this.pronunciation,
    this.scheduleId,
  });

  int id;
  int courseId;
  int testId;
  String video;
  String engsub;
  String vietsub;
  String vocabOrWord;
  String meaning;
  String pronunciation;
  int scheduleId;

  factory Vocab.fromJson(Map<String, dynamic> json) => Vocab(
    id: json["id"],
    courseId: json["course_id"],
    testId: json["test_id"],
    video: json["video"],
    engsub: json["engsub"],
    vietsub: json["vietsub"],
    vocabOrWord: json["vocab_or_word"],
    meaning: json["meaning"],
    pronunciation: json["pronunciation"],
    scheduleId: json["schedule_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "course_id": courseId,
    "test_id": testId,
    "video": video,
    "engsub": engsub,
    "vietsub": vietsub,
    "vocab_or_word": vocabOrWord,
    "meaning": meaning,
    "pronunciation": pronunciation,
    "schedule_id": scheduleId,
  };
}


AnswerVocabSubmit answerVocabFromJson(String str) => AnswerVocabSubmit.fromJson(json.decode(str));

String answerVocabToJson(AnswerVocabSubmit data) => json.encode(data.toJson());

class AnswerVocabSubmit {
  AnswerVocabSubmit({
    this.classroomId,
    this.testId,
    this.lesson,
    this.results,
  });

  int classroomId;
  String testId;
  int lesson;
  List<AnswerVocab> results;

  factory AnswerVocabSubmit.fromJson(Map<String, dynamic> json) => AnswerVocabSubmit(
    classroomId: json["classroom_id"],
    testId: json["test_id"],
    lesson: json["lesson"],
    results: List<AnswerVocab>.from(json["results"].map((x) => AnswerVocab.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "classroom_id": classroomId,
    "test_id": testId,
    "lesson": lesson,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class AnswerVocab {
  AnswerVocab({
    this.questionId,
    this.answer,
    this.istrue,
    this.vocabOrWord,
  });

  int questionId;
  String answer;
  bool istrue;
  String vocabOrWord;

  factory AnswerVocab.fromJson(Map<String, dynamic> json) => AnswerVocab(
    questionId: json["question_id"],
    answer: json["answer"],
    istrue: json["istrue"],
    vocabOrWord: json["vocab_or_word"] == null ? null : json["vocab_or_word"],
  );

  Map<String, dynamic> toJson() => {
    "question_id": questionId,
    "answer": answer,
    "istrue": istrue,
    "vocab_or_word": vocabOrWord == null ? null : vocabOrWord,
  };
}


class QuestionVocab {
  QuestionVocab({this.question});
  dynamic question;
}
