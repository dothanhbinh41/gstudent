import 'dart:convert';
import 'dart:io';

import 'package:gstudent/api/base/ApiBase.dart';
import 'package:gstudent/api/dtos/Route/route.dart';
import 'package:gstudent/api/dtos/TestInput/image.dart';
import 'package:gstudent/api/dtos/UploadFile/image_response.dart';
import 'package:gstudent/api/dtos/base/message_response.dart';
import 'package:gstudent/api/dtos/homework/answer_homework_submit.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';
import 'package:gstudent/api/dtos/homework/result_homework.dart';
import 'package:gstudent/api/dtos/homework/submit_response.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';

@injectable
class RouteApi {
  @factoryMethod
  Future<RouteData> loadRoute(int idClassroom, String token) async {
    try {
      var res = await httpFullGet('/api/classroom/class-info', {'classroom_id': idClassroom.toString()}, token);
      print(res.body);
      var response = routeDataFromJson(res.body);
      return response;
    } catch (e) {
      print('eror api loadRoute');
      print(e);
      return null;
    }
  }

  @factoryMethod
  Future<MessageResponse> sendFeedback(int classroomId, int sessionNumber, int mark, String token, String comment) async {
    try {
      var res = await httpFullPost(
          '/api/classroom/feedback', token, {"classroom_id": classroomId, "session_number": sessionNumber, "marks": mark, "comments": comment});
      print(res.body);
      var response = MessageResponseFromJson(res.body);
      return response;
    } catch (e) {
      print('eror api sendFeedback');
      print(e);
      return null;
    }
  }

  @factoryMethod
  Future<HomeworkData> getHomework(int classroomId, int lesson, String token, String type) async {
    try {
      var res = await httpFullGet('/api/classroom/homeworks', {"classroom_id": classroomId.toString(), "lesson": lesson.toString(), "type": type}, token);
      print(res.body);
      var response = homeworkDataFromJson(res.body);
      return response;
    } catch (e) {
      print('eror api getHomework');
      print(e);
      return null;
    }
  }

  @factoryMethod
  Future<HomeworkAdvanceData> getHomeworkAdvance(int classroomId, int lesson, String token) async {
    try {
      var res = await httpFullGet(
          '/api/classroom/homework-advance',
          {
            "classroom_id": classroomId.toString(),
            "lesson": lesson.toString(),
          },
          token);
      print(res.body);
      var response = homeworkAdvanceDataFromJson(res.body);
      return response;
    } catch (e) {
      print('eror api getHomework advance');
      print(e);
      return null;
    }
  }

  @factoryMethod
  Future<ResultHomeworkData> getResultHomework(int classroomId, int lesson, String token, String type) async {
    try {
      var res = await httpFullGet('/api/classroom/result', {"classroom_id": classroomId.toString(), "lesson_id": lesson.toString(), "type": type}, token);
      print(res.body);
      if (res.statusCode != 200) {
        return null;
      }
      var response = resultHomeworkDataFromJson(res.body);
      return response;
    } catch (e) {
      print('eror api getResultHomework');
      print(e);
      return null;
    }
  }

  @factoryMethod
  Future<SubmitResponse> submitHomework(int classroomId, int lesson, int testId, String type, List<QuestionAnswer> data, String token) async {
    try {
      var qs = data
          .map((e) => AnswerSubmitHomework(
              answer: e.content != null ? e.content : "",
              images: e.image != null ? e.image : "",
              records: e.record != null ? e.record : "",
              question: e?.questionId != null ? e.questionId : null,
              position: e.position != null ? e.position.toString() : null))
          .toList();
      var a = jsonEncode({"classroom_id": classroomId.toString(), "lesson_id": lesson.toString(), "test_id": testId.toString(), "type": type, "results": qs});
      print(a);
      var res = await httpFullPost('/api/classroom/submit', token,
          {"classroom_id": classroomId.toString(), "lesson_id": lesson.toString(), "test_id": testId.toString(), "type": type, "results": qs});

      print(res.body);
      if (res.statusCode != 200) {
        return null;
      }
      var response = submitResponseFromJson(res.body);
      return response;
    } catch (e) {
      print('eror api submitHomework');
      print(e);
      return null;
    }
  }

  @factoryMethod
  Future<SubmitResponse> submitHomeworkAdvance(int classroomId, int lesson, List<QuestionAnswer> data, List<int> listIdGroupQs, String token) async {
    try {
      var qs = data
          .map((e) => AnswerSubmitHomework(
              answer: e.content != null ? e.content : "",
              images: e.image != null ? e.image : "",
              records: e.record != null ? e.record : "",
              question: e?.questionId != null ? e.questionId : null,
              position: e.position != null ? e.position.toString() : null))
          .toList();
      var a = jsonEncode({
        "classroom_id": classroomId.toString(),
        "lesson": lesson.toString(),
        "type": "homework-advance",
        "test_group_id": listIdGroupQs,
        "test_id": 0,
        "results": qs
      });
      print(a);
      var res = await httpFullPost('/api/classroom/homework-advance', token, {
        "classroom_id": classroomId.toString(),
        "lesson": lesson.toString(),
        "type": "homework-advance",
        "test_group_id": listIdGroupQs,
        "test_id": 0,
        "results": qs
      });

      print(res.body);
      if (res.statusCode != 200) {
        return null;
      }
      var response = submitResponseFromJson(res.body);
      return response;
    } catch (e) {
      print('eror api submitHomework');
      print(e);
      return null;
    }
  }

  @factoryMethod
  Future<Images> uploadRecord(String filename, String path, String token) async {
    Map<String, String> headers = {"Authorization": "Bearer " + token};
    try {
      var req = MultipartRequest('POST', Uri.http(apiUrl, "api/classroom/upload-audio"));
      req.headers.addAll(headers);
      var file = MultipartFile.fromBytes('myFile', File(path).readAsBytesSync(), filename: filename);
      req.files.add(file);
      var res = await req.send();
      if (res.statusCode == 200) {
        var str = await res.stream.transform(utf8.decoder).firstWhere((element) => element != null);
        print(str);
        var body = jsonDecode(str);
        var response = ImagesResultDto.fromJson(body);

        return response.data[0];
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
