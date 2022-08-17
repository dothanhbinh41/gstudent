import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gstudent/api/dtos/Route/route.dart';
import 'package:gstudent/api/dtos/base/message_response.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';
import 'package:gstudent/api/dtos/homework/result_homework.dart';
import 'package:gstudent/home/cubit/route_state.dart';
import 'package:gstudent/home/services/route_services.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';
import 'package:zoom/zoom.dart';

class RouteCubit extends Cubit<RouteState> {
  RouteService service;
  ApplicationSettings settings;

  RouteCubit({this.service, this.settings}) : super(RouteStateInitial());

  Future<MessageResponse> sendFeesback(
      int classroomId, int sessionNumber, int mark, String comment) async {
    var res = await service.sendFeesback(classroomId, sessionNumber, mark,comment);
    return res;
  }

  Future<ResultHomeworkData> getResult(int classroomId, int lesson,
      {String type = "homework"}) async {
    var res = await service.getResultHomework(classroomId, lesson, type: type);
    return res;
  }

  Future<RouteData> loadRoute(int classroomId) async {
    var res = await service.loadRoute(classroomId);
    if (res == null) {
      return null;
    }
    return res;
  }

  Future<bool> checkMeetZoomTest(int classroomId, int lesson) async {
    var c = await settings.getMeetingTestRoute(classroomId, lesson);
    return c;
  }

  bool _isMeetingEnded(String status) {
    if (Platform.isAndroid) {
      return status == "MEETING_STATUS_DISCONNECTING" ||
          status == "MEETING_STATUS_FAILED";
    }
    return status == "MEETING_STATUS_ENDED";
  }

  joinMeeting(ZoomOptions zoomOptions, ZoomMeetingOptions meetingOptions,
      bool isTest, int lesson, int classroomId) {
    Timer timer;
    var zoom = Zoom();
    zoom.init(zoomOptions).then((results) {
      if (results[0] == 0) {
        zoom.onMeetingStateChanged.listen((status) async {
          print("[Meeting Status Stream] : " + status[0] + " - " + status[1]);
          if (status[0] == "MEETING_STATUS_CONNECTING") {
            if (isTest)
              await settings.saveIsMeetingTestRoute(classroomId, lesson, true);
          }
          if (_isMeetingEnded(status[0])) {
            print("[Meeting Status] :- Ended");
            timer.cancel();
            // emit(ZoomStateCancelZoom());
          }
        });
        print("listen on event channel");
        zoom.joinMeeting(meetingOptions).then((joinMeetingResult) {
          timer = Timer.periodic(new Duration(seconds: 2), (timer) {
            zoom.meetingStatus(meetingOptions.meetingId).then((status) {
              print("[Meeting Status Polling] : " +
                  status[0] +
                  " - " +
                  status[1]);
            });
          });
        });
      }
    }).catchError((error) {
      print("[Error Generated] : " + error);
    });
  }

  initZoomOptions(String idZoom, String passZoom, bool isTest, int lesson,
      int classroomId) async {
    var user = await settings.getCurrentUser();
    var zoomOptions = ZoomOptions(
      domain: "zoom.us",
      //https://marketplace.zoom.us/docs/sdk/native-sdks/auth
      //https://jwt.io/
      //--todo from server
      //jwtToken: "your jwtToken",
      appKey: 'NiYtz5xA1H3uIDK7GnUTjgXwADZNIp02WHZn',
      // Replace with with key got from the Zoom Marketplace ZOOM SDK Section
      appSecret:
          '6o8zI0xpOG1YM1lRCnZTKC3An2ZpoD7GNAuk', // Replace with with secret got from the Zoom Marketplace ZOOM SDK Section
    );
    var meetingOptions = ZoomMeetingOptions(
        userId: user.userInfo.name,
        displayName: user.userInfo.name,
        meetingId: idZoom,
        meetingPassword: passZoom,
        disableDialIn: "true",
        disableDrive: "true",
        disableInvite: "true",
        disableShare: "true",
        noAudio: "false",
        noDisconnectAudio: "false");

    joinMeeting(zoomOptions, meetingOptions, isTest, lesson, classroomId);
  }

  Future<HomeworkData> getExamTest(int classroomId, int lesson,
      {String type = "test"}) async {
    var res = await service.getHomework(classroomId, lesson, type);
    if (res != null) {
      return res;
    }
    return null;
  }
}
