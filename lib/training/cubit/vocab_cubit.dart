import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gstudent/api/dtos/Training/vocab/result_vocab.dart';
import 'package:gstudent/training/cubit/vocab_state.dart';
import 'package:gstudent/training/services/vocab_services.dart';

import '../../api/dtos/Training/vocab/vocab.dart';

class VocabCubit extends Cubit<VocabState> {
  VocabService services;

  VocabCubit({this.services})
      : super(VocabStateInitial());


  Future<VocabData> getQuestionVocab( int classroomId, int lesson) async {
    var res = await services.getQuestionVocab(classroomId, lesson);
    return res;
  }


 Future<ResultVocab> submit( int classroomId, int lesson, int testId,List<AnswerVocab> answers) async {
    var res = await services.submitQuestion(classroomId, lesson,testId,answers);
    return res;
  }

}
