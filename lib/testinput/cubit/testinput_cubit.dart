import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gstudent/api/dtos/TestInput/ResultDto.dart';
import 'package:gstudent/api/dtos/TestInput/ResultSubmitDto.dart';
import 'package:gstudent/api/dtos/TestInput/answer_submit.dart';
import 'package:gstudent/api/dtos/TestInput/data.dart';
import 'package:gstudent/api/dtos/TestInput/ielts.dart';
import 'package:gstudent/api/dtos/TestInput/image.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';
import 'package:gstudent/testinput/cubit/testinput_state.dart';
import 'package:gstudent/testinput/services/testinput_services.dart';

class TestInputCubit extends Cubit<TestInputState> {
  TestInputService services;
  ApplicationSettings settings;
  TestInputCubit({this.services,this.settings})
      : super(TestInputStateInitial());


  Future<DataTestInputDto> getExamByType(String type)async {
    var result = await services.getExamByType(type);
    return result != null ? result : null ;
  }


  Future<Images> uploadFile(String filename, String path) async {
    var result = await services.uploadFile(filename, path);
    if (result != null) {
      return result;
    }
    return null;
  }

  Future<ResultSubmitDto> submitQuestion(String type, String skill, List<AnswerSubmit> qs,
      int idImport, bool isFinish,int idStudent) async {
    var result =
    await services.submitQuestion(type, skill, qs, idImport, isFinish,idStudent);
    return result;
  }

  Future<ResultTestInputData> getResult(int idImport) async {
    var result =
    await services.getResultTest(idImport);
    return result;
  }

  Future<bool> saveTestInput(String typeExam, List<QuestionTestInputDto> data, int idUser) async {
    var res = await settings.saveTestInput(typeExam, data, idUser);
    return res;
  }

  Future<bool> deleteLocalQuestion(String typeExam,  int idUser) async {
    var res = await settings.deleteLocalQuestion(typeExam, idUser);
    return res;
  }

  Future<List<QuestionTestInputDto>> getTestInput(String typeExam,int idUser) async {
    var res = await settings.getTestInput(typeExam, idUser);
    return res;
  }


}
