import 'package:gstudent/api/Mission/mission_api.dart';
import 'package:gstudent/api/base/HeaderProvider.dart';
import 'package:gstudent/api/dtos/Reward/item_reward.dart';
import 'package:gstudent/api/dtos/base/message_response.dart';
import 'package:gstudent/api/dtos/mission/mission_data.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';
import 'package:injectable/injectable.dart';

@injectable
class MissionService {
  MissionApi api;
  HeaderProvider headerProvider;
  ApplicationSettings applicationSettings;

  MissionService({this.api, this.headerProvider, this.applicationSettings});

  Future<MissionDataResponse> getMissionDaily(int classroomId) async {
    var token = await headerProvider.getAuthorization();
    var res = api.getMissionDaily(classroomId, token);
    return res;
  }

  Future<MissionDataResponse> getMissionProgress(int classroomId,) async {
    var token = await headerProvider.getAuthorization();
    var res = api.getMissionProgress(classroomId, token);
    return res;
  }

  Future<DataReward> receiveRewardMission(int missionUserId,) async {
    var token = await headerProvider.getAuthorization();
    var res = api.receiveRewardMission(missionUserId, token);
    return res;
  }


}
