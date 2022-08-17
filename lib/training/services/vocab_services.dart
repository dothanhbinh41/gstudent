import 'package:gstudent/api/Training/vocab_api.dart';
import 'package:gstudent/api/base/HeaderProvider.dart';
import 'package:gstudent/api/dtos/Training/vocab/result_vocab.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';
import 'package:injectable/injectable.dart';

import '../../api/dtos/Training/vocab/vocab.dart';

@injectable
class VocabService {
  VocabApi api;
  HeaderProvider headerProvider;
  ApplicationSettings applicationSettings;

  VocabService({this.api, this.headerProvider, this.applicationSettings});

  Future<VocabData> getQuestionVocab( int classroomId, int lesson) async {
    var token = await headerProvider.getAuthorization();
    var res = await api.getQsVocab(classroomId, lesson, token);
    return res;
  }

  Future<ResultVocab> submitQuestion( int classroomId, int lesson, int testId,List<AnswerVocab> answers) async {
    var token = await headerProvider.getAuthorization();
    var res = await api.submitQuestionVocab(classroomId, lesson,testId,answers, token);
    return res;
  }
}