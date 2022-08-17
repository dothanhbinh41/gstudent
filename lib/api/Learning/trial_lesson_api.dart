import 'package:gstudent/api/base/ApiBase.dart';
import 'package:gstudent/api/dtos/mission/mission_data.dart';
import 'package:gstudent/api/dtos/trial_class/trial_class_dto.dart';
import 'package:injectable/injectable.dart';

@injectable
class TrialApi {
  @factoryMethod
  Future<TrialClassData> getTrialClass( String token) async {
    try {
      var res = await httpFullGet(
          "/api/trial-class",
          {
          },
          token);
      print(res.body);
      if ( res.body != null) {
        var response = trialClassDataFromJson(res.body.toString());
        return response;
      }
    } catch (e) {
      print('eror api getTrialClass');
      print(e);
    }

    return null;
  }

}
