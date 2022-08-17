import 'package:gstudent/api/base/ApiBase.dart';
import 'package:gstudent/api/dtos/noti/notification_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class NotificationApi {
  @factoryMethod
  Future<List<NotificationModel>> getAllNotification(    String token) async {
    try {
      var res = await httpFullGet("api/home/notification", {}, token);
      print(res.body);
      if (res.statusCode == 200 && res.body != null) {
        var response = listNotificationModelFromJson(res.body.toString());
        return response;
      }
    } catch (e) {
      print('eror api getAllNotification');
      print(e);
    }

    return null;
  }
}
