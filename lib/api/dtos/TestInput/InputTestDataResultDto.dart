// To parse this JSON data, do
//
//     final dataInput = dataInputFromJson(jsonString);

import 'dart:convert';

import 'package:gstudent/api/dtos/TestInput/enum.dart';

InputTestDataResultDto dataInputFromJson(String str) =>
    InputTestDataResultDto.fromJson(json.decode(str));

String dataInputToJson(InputTestDataResultDto data) =>
    json.encode(data.toJson());

class InputTestDataResultDto {
  InputTestDataResultDto({
    this.error,
    this.message,
    this.importId,
    this.data,
  });

  bool error;
  String message;
  int importId;
  InputTestDataDto data;

  factory InputTestDataResultDto.fromJson(Map<String, dynamic> json) =>
      InputTestDataResultDto(
        error: json["error"],
        message: json["message"],
        importId: json["import_id"],
        data: InputTestDataDto.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "import_id": importId,
    "data": data.toJson(),
  };
}

class InputTestDataDto {
  InputTestDataDto({
    this.listening,
    this.reading,
  });

  List<QuestionDto> listening;
  List<QuestionDto> reading;

  factory InputTestDataDto.fromJson(Map<String, dynamic> json) =>
      InputTestDataDto(
        listening: List<QuestionDto>.from(
            json["listening"].map((x) => QuestionDto.fromJson(x))),
        reading: List<QuestionDto>.from(
            json["reading"].map((x) => QuestionDto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "listening": List<dynamic>.from(listening.map((x) => x.toJson())),
    "reading": List<dynamic>.from(reading.map((x) => x.toJson())),
  };
}

class QuestionDto {
  QuestionDto({
    this.id,
    this.idQuestionImport,
    this.examType,
    this.questionType,
    this.section,
    this.sectionMediaType,
    this.sectionMediaContent,
    this.groupQuestion,
    this.groupQuestionType,
    this.groupQuestionMediaType,
    this.groupQuestionMediaContent,
    this.content,
    this.rowTable,
    this.answerType,
    this.questionMediaType,
    this.questionMediaContent,
    this.answers,
    this.mark,
    this.answered,
  });

  int id;
  int idQuestionImport;
  ExamType examType;
  QuestionType questionType;
  String section;
  QuestionMediaType sectionMediaType;
  String sectionMediaContent;
  String groupQuestion;
  GroupQuestionType groupQuestionType;
  QuestionMediaType groupQuestionMediaType;
  dynamic groupQuestionMediaContent;
  String content;
  int rowTable;
  AnswerType answerType;
  QuestionMediaType questionMediaType;
  String questionMediaContent;
  List<InputTestAnswerDto> answers;
  dynamic mark;
  String answered;

  factory QuestionDto.fromJson(Map<String, dynamic> json) => QuestionDto(
    id: json["id"],
    idQuestionImport: json["id_question_import"],
    examType: examTypeValues.map[json["exam_type"]],
    questionType: questionTypeValues.map[json["question_type"]],
    section: json["section"],
    sectionMediaType:
    questionMediaTypeValues.map[json["section_media_type"]],
    sectionMediaContent: json["section_media_content"],
    groupQuestion: json["group_question"],
    groupQuestionType:
    groupQuestionTypeValues.map[json["group_question_type"]],
    groupQuestionMediaType:
    questionMediaTypeValues.map[json["group_question_media_type"]],
    groupQuestionMediaContent: json["group_question_media_content"],
    content: json["content"],
    rowTable: json["row_table"],
    answerType: answerTypeValues.map[json["answer_type"]],
    questionMediaType:
    questionMediaTypeValues.map[json["question_media_type"]],
    questionMediaContent: json["question_media_content"],
    answers: List<InputTestAnswerDto>.from(
        json["answers"].map((x) => InputTestAnswerDto.fromJson(x))),
    mark: json["mark"],
    answered: json["answered"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_question_import": idQuestionImport,
    "exam_type": examTypeValues.reverse[examType],
    "question_type": questionTypeValues.reverse[questionType],
    "section": section,
    "section_media_type": questionMediaTypeValues.reverse[sectionMediaType],
    "section_media_content": sectionMediaContent,
    "group_question": groupQuestion,
    "group_question_type":
    groupQuestionTypeValues.reverse[groupQuestionType],
    "group_question_media_type":
    questionMediaTypeValues.reverse[groupQuestionMediaType],
    "group_question_media_content": groupQuestionMediaContent,
    "content": content,
    "row_table": rowTable,
    "answer_type": answerTypeValues.reverse[answerType],
    "question_media_type":
    questionMediaTypeValues.reverse[questionMediaType],
    "question_media_content": questionMediaContent,
    "answers": List<dynamic>.from(answers.map((x) => x.toJson())),
    "mark": mark,
    "answered": answered,
  };
}


class InputTestAnswerDto {
  InputTestAnswerDto({
    this.questionId,
    this.noiDung,
    this.isTrue,
  });

  int questionId;
  String noiDung;
  int isTrue;

  factory InputTestAnswerDto.fromJson(Map<String, dynamic> json) =>
      InputTestAnswerDto(
        questionId: json["question_id"],
        noiDung: json["noi_dung"],
        isTrue: json["is_true"],
      );

  Map<String, dynamic> toJson() => {
    "question_id": questionId,
    "noi_dung": noiDung,
    "is_true": isTrue,
  };
}

enum ExamType { TOEIC }

final examTypeValues = EnumValues({"toeic": ExamType.TOEIC});

enum QuestionMediaType {
  GROUP_QUESTION_IMAGE,
  EMPTY,
  IMAGE,
  BORDER,
  SOUND,
  TEXT
}

final questionMediaTypeValues = EnumValues({
  "border": QuestionMediaType.BORDER,
  "": QuestionMediaType.EMPTY,
  "group_question_image": QuestionMediaType.GROUP_QUESTION_IMAGE,
  "image": QuestionMediaType.IMAGE,
  "sound": QuestionMediaType.SOUND,
  "text": QuestionMediaType.TEXT
});

enum GroupQuestionType { BORDER, TEXT, EMPTY }

final groupQuestionTypeValues = EnumValues({
  "border": GroupQuestionType.BORDER,
  "": GroupQuestionType.EMPTY,
  "text": GroupQuestionType.TEXT
});

enum QuestionType { LISTENING, READING }

final questionTypeValues = EnumValues(
    {"listening": QuestionType.LISTENING, "reading": QuestionType.READING});

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
