import 'dart:convert';

import 'package:gstudent/api/base/ApiBase.dart';
import 'package:gstudent/api/dtos/Exam/GroupQuestionExam.dart';
import 'package:gstudent/api/dtos/Exam/exam_data.dart';
import 'package:gstudent/api/dtos/Exam/result_submit.dart';
import 'package:gstudent/api/dtos/Exam/result_test_data.dart';
import 'package:gstudent/api/dtos/homework/answer_homework_submit.dart';
import 'package:injectable/injectable.dart';

@injectable
class TestApi {

  @factoryMethod
  Future<TestData> getDataTestByType(String type, String token) async {
    try {
      var res = await httpFullGet("/api/test/list-practice", {"type": type}, token);
      print(res.body);
      var data = testDataFromJson(res.body);
      return data;
    } catch (e) {
      print(e);
    }
    return null;
  }

  @factoryMethod
  Future<QuestionExamData> getExamTest(int idExam, String token) async {
    try {
      var res = await httpFullGet("api/test/get-practice", {"practice_id": idExam.toString()}, token);
      print(res.body);
      var data = questionExamFromJson(res.body);
      return data;
    } catch (e) {
      print(e);
    }
    return null;
  }

  @factoryMethod
  Future<ResultTestData> getResultExamTest(int idExam, String token) async {
    try {
      var res = await httpFullGet("/api/test/result", {"practice_id": idExam.toString()}, token);
      print(res.body);
      var data = resultTestDataFromJson(res.body);
      return data;
    } catch (e) {
      print(e);
    }
    return null;
  }

  @factoryMethod
  Future<ResultSubmitTest> submitExamTest(int idExam,List<PracticeAnswer> ans ,  String token) async {
    try {
      var qs = ans.map((e) => AnswerSubmitHomework(
          answer: e.content != null ? e.content : "",
          question: e?.questionId != null ? e.questionId :null,
          position: e.position != null ? e.position.toString() : null
      )).toList();
      var a = jsonEncode({"practice_id": idExam, 'results': qs});
      print(a);
      var res = await httpFullPost("/api/test/post-practice",  token,{"practice_id": idExam, 'results': qs});
      print(res.body);
      var data = resultSubmitTestFromJson(res.body);
      return data;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
