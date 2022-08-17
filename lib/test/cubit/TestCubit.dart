import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gstudent/api/dtos/Exam/GroupQuestionExam.dart';
import 'package:gstudent/api/dtos/Exam/exam_data.dart';
import 'package:gstudent/api/dtos/Exam/result_submit.dart';
import 'package:gstudent/api/dtos/Exam/result_test_data.dart';
import 'package:gstudent/test/cubit/TestState.dart';
import 'package:gstudent/test/services/TestServices.dart';

class TestCubit extends Cubit<TestState> {
  TestService services;

  TestCubit({this.services})
      : super(TestStateInitial());


  Future<TestData> getListTestByType(String type) async {
    var res = await services.getListTestByType(type);
    if (res == null) {
      return null;
    }
    return res;
  }

  Future<QuestionExamData> getExamTest(int  idExam) async {
    var res = await services.getExamTest(idExam);
    if (res == null) {
      return null;
    }
    return res;
  }


  Future<ResultTestData> getResultExamTest(int  idExam) async {
    var res = await services.getResultExamTest(idExam);
    if (res == null) {
      return null;
    }
    return res;
  }

  Future<ResultSubmitTest> submit(int  idExam,List<PracticeAnswer> ans) async {
    var res = await services.submitExamTest(idExam,ans);
    if (res == null) {
      return null;
    }
    return res;
  }

}