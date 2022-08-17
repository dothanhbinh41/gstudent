import 'package:gstudent/api/TestInput/testinput_api.dart';
import 'package:gstudent/api/base/HeaderProvider.dart';
import 'package:gstudent/api/dtos/TestInput/ResultDto.dart';
import 'package:gstudent/api/dtos/TestInput/ResultSubmitDto.dart';
import 'package:gstudent/api/dtos/TestInput/answer_submit.dart';
import 'package:gstudent/api/dtos/TestInput/data.dart';
import 'package:gstudent/api/dtos/TestInput/image.dart';
import 'package:gstudent/api/dtos/TestInput/schedule_testinput.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';
import 'package:injectable/injectable.dart';

@injectable
class TestInputService {
  TestInputApi api;
  HeaderProvider headerProvider;
  ApplicationSettings applicationSettings;

  TestInputService({this.api, this.headerProvider, this.applicationSettings});

  @factoryMethod
  Future<DataTestInputDto> getExamByType(String type) async {
    var token = await headerProvider.getAuthorization();
    var res = await api.getSkillTestInput(type,  token);
    if (res == null) {
      return null;
    }
    // return await applicationSettings.saveLocalUser(res.user);
    return res;
  }

  @factoryMethod
  Future<Images> uploadFile(String filename, String path) async {
    var token = await headerProvider.getAuthorization();
    var result = await api.uploadImage(filename, path, "testinput", token);
    if (result != null) {
      return result;
    }
    return null;
  }

  @factoryMethod
  Future<ResultSubmitDto> submitQuestion(String type, String skill, List<AnswerSubmit> qs,
      int idImport, bool isFinish,int idStudent) async {
    var token = await headerProvider.getAuthorization();
    var result = await api.submitTest(
        type, skill, qs, idImport, isFinish, token, idStudent);
    return result;
  }

  @factoryMethod
  Future<ResultTestInputData> getResultTest(int idStudent) async {
    var token = await headerProvider.getAuthorization();
    var result = await api.getResultTestInput(idStudent,  token);
    return result;
  }


  @factoryMethod
  Future<CheckScheduleTestinput> checkZoomTestInput(int userId) async {
    var token = await headerProvider.getAuthorization();
    var result = await api.checkZoomTestinput(userId,token);
    return result;
  }

}
