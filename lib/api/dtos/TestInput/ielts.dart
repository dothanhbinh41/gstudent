import 'dart:convert';

import 'package:gstudent/api/dtos/TestInput/answer.dart';
import 'package:gstudent/api/dtos/TestInput/enum.dart';

class TestInputDto {
  TestInputDto(
      {this.writing,
      this.listening,
      this.reading,
      // this.speaking,
      this.generalTest});

  List<QuestionTestInputDto> writing;
  List<QuestionTestInputDto> listening;
  List<QuestionTestInputDto> reading;

  // List<ListeningIelts> speaking;
  List<QuestionTestInputDto> generalTest;

  factory TestInputDto.fromJson(Map<String, dynamic> json) => TestInputDto(
        writing: json["writing"] != null ? List<QuestionTestInputDto>.from(json["writing"].map((x) => QuestionTestInputDto.fromJson(x))) : null,
        listening: json["listening"] != null ? List<QuestionTestInputDto>.from(json["listening"].map((x) => QuestionTestInputDto.fromJson(x))) : null,
        reading: json["reading"] != null ? List<QuestionTestInputDto>.from(json["reading"].map((x) => QuestionTestInputDto.fromJson(x))) : null,
        // speaking: List<ListeningIelts>.from(json["speaking"].map((x) => ListeningIelts.fromJson(x))),
        generalTest: json["general test"] != null ? List<QuestionTestInputDto>.from(json["general test"].map((x) => QuestionTestInputDto.fromJson(x))) : null,
      );

  Map<String, dynamic> toJson() => {
        "writing": List<dynamic>.from(writing.map((x) => x.toJson())),
        "listening": List<dynamic>.from(listening.map((x) => x.toJson())),
        "reading": List<dynamic>.from(reading.map((x) => x.toJson())),
        // "speaking": List<dynamic>.from(speaking.map((x) => x.toJson())),
        "general test": List<dynamic>.from(generalTest.map((x) => x.toJson())),
      };
}

class QuestionTestInputDto {
  QuestionTestInputDto({
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
    this.answer,
    this.answerSubmit,
    this.answersSubmit,
  });

  int id;
  int idQuestionImport;
  ExamType examType;
  QuestionType questionType;
  Section section;
  QuestionMediaType sectionMediaType;
  String sectionMediaContent;
  String groupQuestion;
  GroupQuestionType groupQuestionType;
  QuestionMediaType groupQuestionMediaType;
  dynamic groupQuestionMediaContent;
  String content;
  int rowTable;
  AnswerType answerType;
  String questionMediaType;
  String questionMediaContent;
  List<Answer> answers;
  dynamic mark;
  String answered;
  Answer answer;
  AnswerQuestion answerSubmit;
  List<AnswerQuestion> answersSubmit;

  factory QuestionTestInputDto.fromJson(Map<String, dynamic> json) => QuestionTestInputDto(
        id: json["id"] != null ? json["id"] : null,
        idQuestionImport: json["id_question_import"] == null ? null : json["id_question_import"],
        examType: json["exam_type"] != null ? examTypeValues.map[json["exam_type"]] : null,
        questionType:json["question_type"] != null ?  questionTypeValues.map[json["question_type"]] : null,
        section:json["section"] != null ?  sectionValues.map[json["section"]] : null,
        sectionMediaType: json["section_media_type"] != null ?  questionMediaTypeValues.map[json["section_media_type"]] : null,
        sectionMediaContent: json["section_media_content"] != null ?  json["section_media_content"] : null,
        groupQuestion: json["group_question"] != null ? json["group_question"] : null,
        groupQuestionType: json["group_question_type"] != null ? groupQuestionTypeValues.map[json["group_question_type"]] : null,
        groupQuestionMediaType: json["group_question_media_type"] != null ? questionMediaTypeValues.map[json["group_question_media_type"]] : null,
        groupQuestionMediaContent: json["group_question_media_content"] != null ? json["group_question_media_type"] : null,
        content:  json["content"] != null ? json["content"] : null,
        rowTable: json["row_table"] != null ? json["row_table"] : null,
        answerType: json["answer_type"] != null ?  answerTypeValues.map[json["answer_type"]] : null,
        questionMediaType: json["question_media_type"],
        questionMediaContent: json["question_media_content"],
        answers: json["answers"] != null && json["answers"] != "" ? List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))) : null,
        mark: json["mark"] != null ? json["mark"] : null,
        answered: json["answered"] is String ? json["answered"] : json["answered"].first,
        answer: json["answer"] != null ?Answer.fromJson(json["answer"] ) : null,
        answerSubmit: json["answerSubmit"] != null ? AnswerQuestion.fromJson(json["answerSubmit"]) : null,
        answersSubmit: json["answersSubmit"] != null ? List<AnswerQuestion>.from(json["answersSubmit"].map((x) => AnswerQuestion.fromJson(x))) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_question_import": idQuestionImport == null ? null : idQuestionImport,
        "exam_type":examType != null ?  examTypeValues.reverse[examType] : null,
        "question_type": questionType !=null ? questionTypeValues.reverse[questionType] : null,
        "section": section != null ? sectionValues.reverse[section] : null,
        "section_media_type":sectionMediaType != null ?  sectionMediaTypeValues.reverse[sectionMediaType]: null,
        "section_media_content": sectionMediaContent != null ? sectionMediaContent : null,
        "group_question": groupQuestion != null ? groupQuestion : null,
        "group_question_type":groupQuestionType != null ?  groupQuestionTypeValues.reverse[groupQuestionType] : null,
        "group_question_media_type":groupQuestionMediaType != null ?  questionMediaTypeValues.reverse[groupQuestionMediaType] : null,
        "group_question_media_content": groupQuestionMediaContent != null ? groupQuestionMediaContent : null,
        "content": content != null ?content : null ,
        "row_table": rowTable != null ? rowTable : null,
        "answer_type": answerType != null ?  answerTypeValues.reverse[answerType] : null,
        "question_media_type": questionMediaType != null ? questionMediaType : null,
        "question_media_content": questionMediaContent != null ? questionMediaContent: null ,
        "answers": answers != null ?  List<dynamic>.from(answers.map((x) => x.toJson())) : null,
        "mark": mark != null ? mark : null,
        "answer": answer != null ? answer.toJson() : null,
        "answered": answered != null ? answered : null,
        "answerSubmit": answerSubmit != null ? answerSubmit.toJson() : null,
        "answersSubmit": answersSubmit != null ? List<dynamic>.from(answersSubmit.map((x) => x.toJson())) : null
      };
}

SaveQuestionTest saveQuestionTestFromJson(String str) => SaveQuestionTest.fromJson(json.decode(str));

String saveQuestionTestToJson(SaveQuestionTest data) => json.encode(data.toJson());

class SaveQuestionTest {
  SaveQuestionTest({
    this.data,
  });

  List<QuestionTestInputDto> data;

  factory SaveQuestionTest.fromJson(Map<String, dynamic> json) => SaveQuestionTest(
        data: List<QuestionTestInputDto>.from(json["data"].map((x) => QuestionTestInputDto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
