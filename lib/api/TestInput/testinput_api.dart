import 'dart:convert';
import 'dart:io';

import 'package:gstudent/api/base/ApiBase.dart';
import 'package:gstudent/api/base/dtos_base.dart';
import 'package:gstudent/api/dtos/TestInput/ResultDto.dart';
import 'package:gstudent/api/dtos/TestInput/ResultSubmitDto.dart';
import 'package:gstudent/api/dtos/TestInput/answer_submit.dart';
import 'package:gstudent/api/dtos/TestInput/data.dart';
import 'package:gstudent/api/dtos/TestInput/image.dart';
import 'package:gstudent/api/dtos/TestInput/schedule_testinput.dart';
import 'package:gstudent/api/dtos/UploadFile/image_response.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';

@injectable
class TestInputApi {
  @factoryMethod
  Future<DataTestInputDto> getSkillTestInput(String type, String token) async {
    try{
      var res = await get(Uri.https(base, "/backend/test-income-question", {'exam_type': type,}),
          headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'Bearer ${token}'});
      print(res.body);
      if (res.statusCode == 200 && res.body != null) {
        var response = DataTestInputDto.fromJson(jsonDecode(res.body.toString()));
        return response;
      }
    }catch(e){
      print(e);
    }
    return null;
  }

  @factoryMethod
  Future<Images> uploadImage(String filename, String path, String type, String token) async {
    //
    // Map<String, String> headers = {"Authorization": "Bearer 3706bf9c-41b2-4daa-b36c-56bbd6cf1e26"};
    // try {
    //   var req = MultipartRequest('POST', Uri.https("api.edutalk.edu.vn", "/api/v3/mobile/student/exam/upload-image"));
    //   req.headers.addAll(headers);
    //   var file = MultipartFile.fromBytes('images[0]', File(path).readAsBytesSync(), filename: filename);
    //   req.files.add(file);
    //   req.fields['type'] = '$type';
    //   var res = await req.send();
    //   if (res.statusCode == 200) {
    //     var str = await res.stream.transform(utf8.decoder).firstWhere((element) => element != null);
    //     var body = jsonDecode(str);
    //     var response = ImagesResultDto.fromJson(body);
    //
    //     return response.data[0];
    //   }
    // } catch (e) {
    //   print(e);
    // }
    return null;
  }

  @factoryMethod
  Future<ResultSubmitDto> submitTest(String type, String skill, List<AnswerSubmit> qs, int idImport, bool isFinish, String token, int studentId) async {
    try {
      String js = jsonEncode(qs);
      var a = jsonEncode({'import_id': idImport, 'student_id': studentId, 'total_time_spent': 1, 'exam_type': type, 'questions': qs, 'skill': skill, 'is_finish': isFinish});
      print(a);
      var res = await post(Uri.https(base, "/backend/post-result"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            // ignore: unnecessary_brace_in_string_interps
            'Authorization': 'Bearer ${token}'
          },
          body: jsonEncode({'import_id': idImport, 'student_id': studentId, 'total_time_spent': 1, 'exam_type': type, 'questions': qs, 'skill': skill, 'is_finish': isFinish}));
      print(res.body);
      if (res.body != null) {
        var result = ResultSubmitDto.fromJson(jsonDecode(res.body));
        return result != null ? result : null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @factoryMethod
  Future<ResultTestInputData> getResultTestInput(int studentId, token) async {
    try {
      var res = await get(Uri.https(base, "/backend/get-point-test", {'user_id': studentId.toString()}),
          headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'Bearer $token'});
      print(res.body);
      if (res.body != null) {
        var result = ResultTestInputData.fromJson(jsonDecode(res.body));
        return result;
      }
      return null;
    } catch (e) {
      print(e);
    }
    return null;
  }

  @factoryMethod
  Future<CheckScheduleTestinput> checkZoomTestinput(int userId, String token) async {
    try {
      var res = await get(Uri.https(base, "/backend/get-income-active", {'user_id': userId.toString()}),
          headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'Bearer $token'});

      print(res.body);
      if (res.body != null && res.statusCode == 200) {
        var data = checkScheduleTestinputFromJson(res.body);
        if (data != null) {
          return data;
        }
      }
      return null;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
