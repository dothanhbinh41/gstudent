
import 'package:gstudent/api/dtos/TestInput/enum.dart';
import 'package:gstudent/api/dtos/TestInput/image.dart';


class ListAnswer {
  ListAnswer({
    this.answers,
  });

  List<Answer> answers;

  factory ListAnswer.fromJson(Map<String, dynamic> json) => ListAnswer(
    answers: List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "answers": List<dynamic>.from(answers.map((x) => x.toJson())),
  };
}

class Answer {
  Answer({
    this.questionId,
    this.noiDung,
    this.isTrue,
    this.isSelected,
    this.images
  });

  int questionId;
  String noiDung;
  List<Images> images;
  int isTrue;
  bool isSelected ;

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
    questionId: json["question_id"] != null ? json["question_id"] : null,
    noiDung: json["noi_dung"].toString(),
    isTrue: json["is_true"],
  );

  Map<String, dynamic> toJson() => {
    "question_id": questionId,
    "noi_dung": noiDung,
    "is_true": isTrue,
  };
}

class AnswerQuestion{
  int id;
  dynamic answers;
  String records;
  GroupQuestionType type;
  AnswerType answerType;
  String image;
  List<String> images;
  AnswerQuestion({this.id,this.answers,this.image,this.records, this.answerType, this
      .type});


  factory AnswerQuestion.fromJson(Map<String, dynamic> json) => AnswerQuestion(
  id: json["id"] != null ?json["id"] : null,
    answers:  json["answers"] != null ?  json["answers"] : null,
    // records: json["records"],
    type:json["type"] != null ?  groupQuestionTypeValues.map[json["type"]] : null,
    answerType: json["answerType"] != null ? answerTypeValues.map[ json["answerType"]] : null,
    // image: json["image"]
  );


  Map<String, dynamic> toJson() => {
    "id": id != null ? id : null,
    "answers": answers != null ? answers : null,
    // "images": image,
    // "records": records,
    "type" : type != null ?  groupQuestionTypeValues.reverse[type] : null,
    "answerType" :answerType != null ? answerTypeValues.reverse[answerType] : null
  };
}
