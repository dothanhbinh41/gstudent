


import 'package:gstudent/api/base/HeaderProvider.dart';
import 'package:gstudent/api/dtos/noti/notification_model.dart';
import 'package:gstudent/api/notification/notification_api.dart';
import 'package:injectable/injectable.dart';

@injectable
class NotificationService {
  NotificationApi api;
  HeaderProvider headerProvider;

  NotificationService({this.api, this.headerProvider});


  Future<List<NotificationModel>> getAllNoti() async {
    var token = await headerProvider.getAuthorization();
    var res = await api.getAllNotification( token);
    if(res != null){
      return res;
    }
    return null;
  }
}