import 'package:gstudent/api/Learning/trial_lesson_api.dart';
import 'package:gstudent/api/base/HeaderProvider.dart';
import 'package:gstudent/api/dtos/trial_class/trial_class_dto.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';
import 'package:injectable/injectable.dart';

@injectable
class TrialService {
  TrialApi api;
  HeaderProvider headerProvider;
  ApplicationSettings applicationSettings;

  TrialService({this.api, this.headerProvider, this.applicationSettings});

  Future<String> getToken() async {
    var token = await headerProvider.getAuthorization();
    return token;
  }

  @factoryMethod
  Future<TrialClassData> getTrialClass() async {
    var token = await  getToken();
    var res = await api.getTrialClass(token);
    if (res == null) {
      return null;
    }
    return res;
  }
}