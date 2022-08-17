
import 'package:gstudent/api/dtos/TestInput/answer.dart';
import 'package:gstudent/api/dtos/TestInput/enum.dart';
import 'package:gstudent/api/dtos/TestInput/ielts.dart';

class CommunicateSkillTestDto {
  CommunicateSkillTestDto({
    this.listening,
    this.reading,
    this.generalTest,
  });

  List<QuestionTestInputDto> listening;
  List<QuestionTestInputDto> reading;
  List<QuestionTestInputDto> generalTest;

  factory CommunicateSkillTestDto.fromJson(Map<String, dynamic> json) =>
      CommunicateSkillTestDto(
        listening: List<QuestionTestInputDto>.from(
            json["listening"].map((x) => QuestionTestInputDto.fromJson(x))),
        reading: List<QuestionTestInputDto>.from(
            json["reading"].map((x) => QuestionTestInputDto.fromJson(x))),
        generalTest: List<QuestionTestInputDto>.from(
            json["general test"].map((x) => QuestionTestInputDto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "listening": List<dynamic>.from(listening.map((x) => x.toJson())),
    "reading": List<dynamic>.from(reading.map((x) => x.toJson())),
    "general test": List<dynamic>.from(generalTest.map((x) => x.toJson())),
  };
}

class GeneralTest {
  GeneralTest({
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
  String groupQuestionMediaType;
  String groupQuestionMediaContent;
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

  factory GeneralTest.fromJson(Map<String, dynamic> json) => GeneralTest(
    id: json["id"],
    idQuestionImport: json["id_question_import"],
    examType: examTypeValues.map[json["exam_type"]],
    questionType: questionTypeValues.map[json["question_type"]],
    section: sectionValues.map[json["section"]],
    sectionMediaType:
    questionMediaTypeValues.map[json["section_media_type"]],
    sectionMediaContent: json["section_media_content"],
    groupQuestion: json["group_question"],
    groupQuestionType:
    groupQuestionTypeValues.map[json["group_question_type"]],
    groupQuestionMediaType: json["group_question_media_type"],
    groupQuestionMediaContent: json["group_question_media_content"],
    content: json["content"],
    rowTable: json["row_table"],
    answerType: answerTypeValues.map[json["answer_type"]],
    questionMediaType: json["question_media_type"],
    questionMediaContent: json["question_media_content"],
    answers:
    List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
    mark: json["mark"],
    answered: json["answered"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_question_import": idQuestionImport,
    "exam_type": examTypeValues.reverse[examType],
    "question_type": questionTypeValues.reverse[questionType],
    "section": sectionValues.reverse[section],
    "section_media_type": groupQuestionTypeValues.reverse[sectionMediaType],
    "section_media_content": sectionMediaContent,
    "group_question": groupQuestion,
    "group_question_type":
    groupQuestionTypeValues.reverse[groupQuestionType],
    "group_question_media_type": groupQuestionMediaType,
    "group_question_media_content": groupQuestionMediaContent,
    "content": content,
    "row_table": rowTable,
    "answer_type": answerTypeValues.reverse[answerType],
    "question_media_type": questionMediaType,
    "question_media_content": questionMediaContent,
    "answers": List<dynamic>.from(answers.map((x) => x.toJson())),
    "mark": mark,
    "answered": answered,
  };
}

