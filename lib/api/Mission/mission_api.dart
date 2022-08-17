import 'package:gstudent/api/base/ApiBase.dart';
import 'package:gstudent/api/dtos/Reward/item_reward.dart';
import 'package:gstudent/api/dtos/base/message_response.dart';
import 'package:gstudent/api/dtos/mission/mission_data.dart';
import 'package:injectable/injectable.dart';

@injectable
class MissionApi {
  @factoryMethod
  Future<MissionDataResponse> getMissionDaily(int classroomId, String token) async {
    try {
      var res = await httpFullGet(
          "/api/mission/daily",
          {
            "classroom_id": classroomId.toString(),
          },
          token);
      print(res.body);
      if (res.statusCode == 200 && res.body != null) {
        var response = missionDataFromJson(res.body.toString());
        return response;
      }
    } catch (e) {
      print('eror api getMissionDaily');
      print(e);
    }

    return null;
  }

  @factoryMethod
  Future<MissionDataResponse> getMissionProgress(int classroomId, String token) async {
    try {
      var res = await httpFullGet(
          "/api/mission/progress",
          {
            "classroom_id": classroomId.toString(),
          },
          token);
      print(res.body);
      if (res.statusCode == 200 && res.body != null) {
        var response = missionDataFromJson(res.body.toString());
        return response;
      }
    } catch (e) {
      print('eror api getMissionProgress');
      print(e);
    }
    return null;
  }

  @factoryMethod
  Future<DataReward> receiveRewardMission(int missionUserId, String token) async {
    print({
        "mission_user_id": missionUserId,
    });
    try {
      var res = await httpFullPost(
        "/api/mission/receive-reward",
        token,
        {
          "mission_user_id": missionUserId,
        },
      );
      print(res.body);
      var response = dataRewardFromJson(res.body.toString());
      return response;
    } catch (e) {
      print('eror api receiveRewardMission');
      print(e);
    }
    return null;
  }
}
