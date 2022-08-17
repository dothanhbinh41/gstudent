import 'package:gstudent/api/Test/test_api.dart';
import 'package:gstudent/api/base/HeaderProvider.dart';
import 'package:gstudent/api/dtos/Exam/GroupQuestionExam.dart';
import 'package:gstudent/api/dtos/Exam/exam_data.dart';
import 'package:gstudent/api/dtos/Exam/result_submit.dart';
import 'package:gstudent/api/dtos/Exam/result_test_data.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';
import 'package:injectable/injectable.dart';

@injectable
class TestService {
  TestApi api;
  HeaderProvider headerProvider;
  ApplicationSettings applicationSettings;

  TestService({this.api, this.headerProvider, this.applicationSettings});


  @factoryMethod
  Future<TestData> getListTestByType(String type) async {
    var token = await headerProvider.getAuthorization();
    var res = await api.getDataTestByType(type,token);
    if (res == null) {
      return null;
    }
    return res;
  }

  @factoryMethod
  Future<QuestionExamData> getExamTest(int  idExam) async {
    var token = await headerProvider.getAuthorization();
    var res = await api.getExamTest(idExam,token);
    if (res == null) {
      return null;
    }
    return res;
  }

  @factoryMethod
  Future<ResultTestData> getResultExamTest(int  idExam) async {
    var token = await headerProvider.getAuthorization();
    var res = await api.getResultExamTest(idExam,token);
    if (res == null) {
      return null;
    }
    return res;
  }

  @factoryMethod
  Future<ResultSubmitTest> submitExamTest(int  idExam,List<PracticeAnswer> ans) async {
    var token = await headerProvider.getAuthorization();
    var res = await api.submitExamTest(idExam,ans,token);
    if (res == null) {
      return null;
    }
    return res;
  }

}