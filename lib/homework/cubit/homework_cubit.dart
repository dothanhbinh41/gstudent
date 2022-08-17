import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gstudent/api/dtos/TestInput/image.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';
import 'package:gstudent/api/dtos/homework/result_homework.dart';
import 'package:gstudent/api/dtos/homework/submit_response.dart';
import 'package:gstudent/home/services/route_services.dart';
import 'package:gstudent/homework/cubit/homework_state.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';

class HomeworkCubit extends Cubit<HomeworkState> {
  RouteService service;
  ApplicationSettings applicationSettings;

  HomeworkCubit({this.service,this.applicationSettings}) : super(HomeworkStateInitial());

  Future<HomeworkData> getHomework(int classroomId, int lesson,
      {String type = "homework"}) async {
    var res = await service.getHomework(classroomId, lesson, type);
    return res;
  }

  Future<HomeworkAdvanceData> getHomeworkAdvance(
      int classroomId, int lesson) async {
    var res = await service.getHomeworkAdvance(
      classroomId,
      lesson,
    );
    return res;
  }

  Future<SubmitResponse> submitHomework(int classroomId, int lesson, int testId,
      String type, List<QuestionAnswer> data) async {
    var qs = data
        .where((element) =>
            element != null &&
            element.content != null &&
            element.content.isNotEmpty)
        .toList();
    var res =
        await service.submitHomework(classroomId, lesson, testId, type, qs);
    return res;
  }

  Future<SubmitResponse> submitHomeworkAdvance(int classroomId, int lesson,
      List<int> testId, List<QuestionAnswer> data) async {
    var qs = data
        .where((element) =>
            element != null &&
            element.content != null &&
            element.content.isNotEmpty)
        .toList();
    var res =
        await service.submitHomeworkAdvance(classroomId, lesson, testId, qs);
    return res;
  }

  Future<ResultHomeworkData> getResult(
      int classroomId, int lesson, String type) async {
    var res = await service.getResultHomework(classroomId, lesson, type: type);
    return res;
  }

  Future<Images> uploadRecord(String filename, String path) async {
    var result = await service.uploadRecord(filename, path);
    if (result == null) {
      return null;
    }
    return result;
  }

  Future<bool> saveQuestionTodo(List<GroupQuestion> data, int classroomId,   int lesson, bool isTest,int time) async {
   var res = await applicationSettings.saveQuestionTodo(data, classroomId, lesson, isTest,time) ;
   return res;
  }

  Future<SaveQuestionTodo> getQuestionTodo (  int classroomId,   int lesson, bool isTest) async {
    var res = await applicationSettings.getQuestionTodo(classroomId, lesson, isTest);
    return res;
  }

  Future<bool> deleteQuestionTodo( int classroomId,   int lesson, bool isTest) async {
    var res = await applicationSettings.deleteLocalQuestionTodo( classroomId, lesson, isTest) ;
    return res;
  }

}
