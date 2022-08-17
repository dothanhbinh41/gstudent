import 'dart:convert';

import 'package:gstudent/api/base/ApiBase.dart';
import 'package:gstudent/api/dtos/Training/vocab/result_vocab.dart';
import 'package:injectable/injectable.dart';

import '../dtos/Training/vocab/vocab.dart';

@injectable
class VocabApi {
  @factoryMethod
  Future<VocabData> getQsVocab(int classroomId, int lesson, String token) async {
    try {
      var res = await httpFullGet(
          "/api/classroom/list-vocab",
          {
            "classroom_id": classroomId.toString(),
            "lesson": lesson.toString(),
          },
          token);
      print(res.body);
      if (res.statusCode == 200 && res.body != null) {
        var response = vocabDataFromJson(res.body.toString());
        return response;
      }
    } catch (e) {
      print('error api getQsVocab');
      print(e);
    }
    return null;
  }

  @factoryMethod
  Future<ResultVocab> submitQuestionVocab(int classroomId, int lesson, int testId, List<AnswerVocab> answer, String token) async {
    try {
      print({
        "classroom_id": classroomId.toString(),
        "lesson_id": lesson.toString(),
        "test_id": testId.toString(),
        "results": jsonEncode(answer),
      });
      var res = await httpFullPost(
        "/api/classroom/submits-vocab",
        token,
        {
          "classroom_id": classroomId.toString(),
          "lesson_id": lesson.toString(),
          "test_id": testId.toString(),
          "results": answer,
        },
      );
      print(res.body);
      if (res.statusCode == 200 && res.body != null) {
        var response = resultVocabFromJson(res.body.toString());
        return response;
      }
    } catch (e) {
      print('error api submitQuestionVocab');
      print(e);
    }

    return null;
  }
}
