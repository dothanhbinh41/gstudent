import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gstudent/api/dtos/Course/course.dart';
import 'package:gstudent/clan/services/clan_services.dart';
import 'package:gstudent/home/services/home_services.dart';
import 'package:gstudent/home/services/route_services.dart';
import 'package:gstudent/main.dart';
import 'package:gstudent/map/cubit/map_state.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';
import 'package:zoom/zoom.dart';

class MapCubit extends Cubit<MapState> {
  List<CourseModel> course;

  ApplicationSettings settings;
  HomeService service;
  ClanService clanService;
  RouteService routeService;

  MapCubit({this.course, this.settings, this.service, this.clanService, this.routeService}) : super(MapStateInitial());

  islandRouteClicked(int idIsland) async {
    emit(ChoiceIsland());
    var c = course.where((element) =>  element.course != null && element.course.islandId == idIsland && element.isLearning == true).first;
    if (c != null) {
      showLoading();
      var route = await routeService.loadRoute(c.classroomId);
      hideLoading();
      emit(LoadRouteIsland(classroomId: c.classroomId, idIsland: idIsland, isLongRoute: route.data.length));
    }
  }

  islandClick(int idIsland) async {
    var c = course.where((element) => element.course != null && element.course.islandId == idIsland && element.isLearning == true).first;
    if (c.clan == null) {
      showLoading();
      var route = await routeService.loadRoute(c.classroomId);
      hideLoading();
      if (route != null) {
        var currentLesson = route.data.where((element) => element.date.isBefore(DateTime.now().add(Duration(hours: 1)))).isNotEmpty
            ? route.data.where((element) => element.date.isBefore(DateTime.now().add(Duration(hours: 1))) && element.lesson != null).last.lesson
            : 0;
        if (currentLesson == 0) {
          emit(MapErrorState(message: 'Khóa học chưa bắt đầu'));
          return;
        }
        emit(CreateClan(classroomId: c.classroomId, idIsland: idIsland));
      }
      return;
    } else {
      showLoading();
      var clanDetail = await clanService.getDetailClan(c.clan.id);
      hideLoading();
      if (clanDetail == null) {
        emit(CreateClan(classroomId: c.classroomId, idIsland: idIsland));
      } else {
        if (c.clan.characterId == null) {
          emit(CreateCharacter(classroomId: c.classroomId, idIsland: idIsland));
        } else {
          loadStory(c.classroomId, idIsland);
        }
      }
    }
  }

  void loadStory(int classroomId, int idIsland) async {
    if(idIsland == 7){
      emit(NavigateToHome(data: course.where((element) => element.course.islandId == idIsland && element.classroomId == classroomId).first));
    }else{
      var u = await settings.getCurrentUser();
      var id = u.userInfo.id;
      var route = await routeService.loadRoute(classroomId);
      if (route != null) {
        var currentLesson = route.data.where((element) => element.date.isBefore(DateTime.now())).isNotEmpty
            ? route.data.where((element) => element.date.isBefore(DateTime.now()) && element.lesson != null).last.lesson
            : 0;
        if (currentLesson < 2 && await settings.getIsland(idIsland, id.toString()) == false) {
          emit(NavigateStory(islandId: idIsland, id: id, classroomId: classroomId));
          return;
        }

        print(route.data.where((element) => element.lesson != null).length - 4);
        if (currentLesson >= route.data.where((element) => element.lesson != null).length - 4 && await settings.getIslandMiddle(idIsland, id.toString()) == false) {
          emit(NavigateStoryMiddle(islandId: idIsland, id: id, classroomId: classroomId));
          return;
        }
        if (currentLesson >= route.data.where((element) => element.lesson != null).length - 1 && await settings.getIslandEnd(idIsland, id.toString()) == false) {
          if (route.data.where((element) => element.exam == 1).isNotEmpty) {
            var resultExam = await routeService.getResultHomework(classroomId, route.data.where((element) => element.exam == 1).last.lesson, type: "test");
            if (resultExam.data != null) {
              emit(NavigateStoryEnd(islandId: idIsland, id: id, classroomId: classroomId,isSuccess: double.parse(resultExam.data.first.process) >  resultExam.data.first.totalScore.toDouble()*0.75 ));
              return;
            }
          }
        }

        emit(NavigateToHome(data: course.where((element) => element.course.islandId == idIsland && element.classroomId == classroomId).first));
      }
    }

  }

  navigateStoryWorld() async {
    var storyWorld = await settings.getStoryWorld();
    if (storyWorld == false) {
      var currentCourse = course.where((element) => element.isLearning).isNotEmpty ? course.where((element) => element.isLearning).first : null;
      if (currentCourse != null) {
        showLoading();
        var route = await routeService.loadRoute(currentCourse.classroomId);
        hideLoading();
        if (route != null) {
          var currentLesson = route.data.where((element) => element.date.isBefore(DateTime.now())).isNotEmpty
              ? route.data.where((element) => element.date.isBefore(DateTime.now()) && element.lesson != null).last.lesson
              : 0;
          if (currentLesson <= 1) {
            emit(NavigateStoryWorld());
            return;
          }
        }
      }
    }
  }

  bool _isMeetingEnded(String status) {
    if (Platform.isAndroid) {
      return status == "MEETING_STATUS_DISCONNECTING" || status == "MEETING_STATUS_FAILED";
    }
    return status == "MEETING_STATUS_ENDED";
  }

  _joinMeeting(ZoomOptions zoomOptions, ZoomMeetingOptions meetingOptions) {
    Timer timer;
    var zoom = Zoom();
    zoom.init(zoomOptions).then((results) {
      if (results[0] == 0) {
        zoom.onMeetingStateChanged.listen((status) async {
          print("[Meeting Status Stream] : " + status[0] + " - " + status[1]);
          if (status[0] == "MEETING_STATUS_CONNECTING") {}
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
              print("[Meeting Status Polling] : " + status[0] + " - " + status[1]);
            });
          });
        });
      }
    }).catchError((error) {
      print("[Error Generated] : " + error);
    });
  }

  initZoomOptions(String idZoom, String passZoom) async {
    var user = await settings.getCurrentUser();
    var zoomOptions = ZoomOptions(
      domain: "zoom.us",
      //https://marketplace.zoom.us/docs/sdk/native-sdks/auth
      //https://jwt.io/
      //--todo from server
      //jwtToken: "your jwtToken",
      appKey: 'NiYtz5xA1H3uIDK7GnUTjgXwADZNIp02WHZn', // Replace with with key got from the Zoom Marketplace ZOOM SDK Section
      appSecret: '6o8zI0xpOG1YM1lRCnZTKC3An2ZpoD7GNAuk', // Replace with with secret got from the Zoom Marketplace ZOOM SDK Section
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

    _joinMeeting(zoomOptions, meetingOptions);
  }
}
