import 'package:gstudent/api/Home/route_api.dart';
import 'package:gstudent/api/base/HeaderProvider.dart';
import 'package:gstudent/api/dtos/Route/route.dart';
import 'package:gstudent/api/dtos/TestInput/image.dart';
import 'package:gstudent/api/dtos/base/message_response.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';
import 'package:gstudent/api/dtos/homework/result_homework.dart';
import 'package:gstudent/api/dtos/homework/submit_response.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';
import 'package:injectable/injectable.dart';

@injectable
class RouteService {
  RouteApi api;
  HeaderProvider headerProvider;
  ApplicationSettings applicationSettings;

  RouteService({this.api, this.headerProvider, this.applicationSettings});

  Future<MessageResponse> sendFeesback(
      int classroomId, int sessionNumber, int mark,String comment) async {
    var token = await headerProvider.getAuthorization();
    var res = api.sendFeedback(classroomId, sessionNumber, mark, token,comment);
    return res;
  }

  Future<HomeworkData> getHomework(
      int classroomId, int lesson, String type) async {
    var token = await headerProvider.getAuthorization();
    var res = api.getHomework(classroomId, lesson, token, type);
    return res;
  }

  Future<HomeworkAdvanceData> getHomeworkAdvance(
      int classroomId, int lesson) async {
    var token = await headerProvider.getAuthorization();
    var res = api.getHomeworkAdvance(classroomId, lesson, token);
    return res;
  }

  Future<RouteData> loadRoute(int classroomId) async {
    var token = await headerProvider.getAuthorization();
    var res = await api.loadRoute(classroomId, token);
    if (res == null) {
      return null;
    }
    return res;
  }

  Future<SubmitResponse> submitHomework(int classroomId, int lesson, int testId,
      String type, List<QuestionAnswer> data) async {
    var token = await headerProvider.getAuthorization();
    var res =
        api.submitHomework(classroomId, lesson, testId, type, data, token);
    return res;
  }

  Future<SubmitResponse> submitHomeworkAdvance(int classroomId, int lesson, List<int> testId,  List<QuestionAnswer> data) async {
    var token = await headerProvider.getAuthorization();
    var res =
        api.submitHomeworkAdvance(classroomId, lesson,   data, testId, token);
    return res;
  }

  Future<ResultHomeworkData> getResultHomework(int classroomId, int lesson,
      {String type = "homework"}) async {
    var token = await headerProvider.getAuthorization();
    var res = api.getResultHomework(classroomId, lesson, token, type);
    return res;
  }

  Future<Images> uploadRecord(
      String filename, String path) async {
    var token = await headerProvider.getAuthorization();
    var result = await api.uploadRecord(
        filename, path,token);
    if (result == null) {
      return null;
    }
    return result;
  }
}
