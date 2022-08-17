import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:gstudent/authentication/cubit/login_cubit.dart';
import 'package:gstudent/clan/services/clan_services.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/common/controls/draw_progress_tripped.dart';
import 'package:gstudent/common/controls/text_painting.dart';
import 'package:gstudent/home/services/home_services.dart';
import 'package:gstudent/home/services/route_services.dart';
import 'package:gstudent/main.dart';
import 'package:gstudent/map/cubit/map_cubit.dart';
import 'package:gstudent/map/views/map_view.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';
import 'package:gstudent/settings/views/notification_dialog.dart';
import 'package:gstudent/story/chapter_tutorial/chapter_tutorial.dart';
import 'package:gstudent/walkthrough/views/walkthrough_view.dart';

class LoadingScreen extends StatefulWidget {
  Function(bool) isBackLogin;

  LoadingScreen({this.isBackLogin});

  @override
  State<StatefulWidget> createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {
  double progress = 0.0;
  Timer _timer;
  int percent = 0;
  bool isGoInGame = false;

  ApplicationSettings settings;
  AuthenticationCubit cubit;

  @override
  void initState() {
    super.initState();
    startTimer();
    settings = GetIt.instance.get<ApplicationSettings>();
    cubit = BlocProvider.of(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  void startTimer() {
    const oneSec = const Duration(milliseconds: 20);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          percent = percent + 1;
          progress = progress + 1;
          if (percent == 100 || progress == 100) {
            timer.cancel();
            Future.delayed(Duration(milliseconds: 1000)).then((value) {
              setState(() {
                isGoInGame = true;
              });
            });
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(),
        ),
        Container(
          child: Column(
            children: [
              isGoInGame
                  ? GestureDetector(
                      onTap: () async {
                        navigate();
                      },
                      child: Container(
                        height: 48,
                        child: ButtonYellowSmall(
                          'VÀO ĐẢO',
                        ),
                      ),
                    )
                  : Container(
                      height: 64,
                    ),
              Container(
                height: 24,
              ),
              Container(
                height: 20,
                margin: EdgeInsets.fromLTRB(24, 0, 24, 0),
                decoration: BoxDecoration(border: Border.all(color: HexColor("#636363")), borderRadius: BorderRadius.circular(2)),
                child: Stack(children: [
                  Container(
                    decoration: BoxDecoration(color: HexColor("#636363"), border: Border.all(color: HexColor("#636363"), width: 1), borderRadius: BorderRadius.circular(2)),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(2, 0, 2, 0),
                    child: CustomPaint(
                      painter: StripePainter(height: 14, progress: this.progress / 100, distance: (MediaQuery.of(context).size.width * 0.1)),
                      size: Size.infinite,
                    ),
                  ),
                  Center(
                    child: textpaintingBoldBase(percent.toString() + '%', 14, Colors.white, Colors.black, 3),
                  ),
                ]),
              ),
              Container(
                height: 16,
              ),
              Container(
                child: Column(
                  children: [
                    Visibility(
                      visible: percent != 100,
                      child: Text(
                        'Đang tải dữ liệu xin vui lòng chờ',
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400, fontFamily: "SourceSerifPro"),
                      ),
                    ),
                    Visibility(
                      visible: percent != 100,
                      child: SpinKitFadingCircle(
                        color: Colors.white,
                        size: 50.0,
                      ),
                    )
                  ],
                ),
                height: 110,
              )
            ],
          ),
        )
      ],
    );
  }

  navigate() async {
    showLoading();
    var data = await settings.getRoute();
    if(data == null){
      hideLoading();
    }
    var homeService = GetIt.instance.get<HomeService>();
    var clanService = GetIt.instance.get<ClanService>();
    var routeService = GetIt.instance.get<RouteService>();
    var checkFirstTime = await settings.getFirstTimeLogin();
    hideLoading();

    if (checkFirstTime == false) {
      var res = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => WalkThroughView(),
      ));
      if (res == false || res == null) {
        return;
      }
      await settings.saveFirstTimeLogin(true);
      // if (courses.where((element) => element.isLearning == true).isNotEmpty) {
      //   var currentCourse = courses.where((element) => element.isLearning == true).first;
      //   if (currentCourse.classroom.dateStart.isBefore(DateTime.now())) {
      //   await   settings.saveFirstTimeLogin(true);
      //   }
      // }
    }
    if (data != null && data.isNotEmpty) {
      if (data.where((element) => element.isLearning == true).isNotEmpty && data.where((element) => element.isLearning == true).toList().length < 2) {
        var route = await routeService.loadRoute(data.where((element) => element.isLearning == true).first.classroomId);
        if (route != null && route.data.where((element) => element.action != null && (element.action.checkin != null || element.action.homework != null)).isEmpty) {
          var getFirstTimeStudy = await settings.getFirstTimeStudy();
          if (getFirstTimeStudy == false) {
            var tutorial = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChapterTutorial(),
              ),
            );
            if (tutorial == true) {
              await settings.saveFirstTimeStudy(tutorial);
            }
          }
        }
      }

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: MapCubit(course: data, settings: settings, service: homeService, clanService: clanService, routeService: routeService),
            child: MapGameView(
              course: data,
            ),
          ),
        ),
      );
    } else {
      toast(context, 'Bạn chưa có khóa nào!');
      var res = await showGeneralDialog(
        barrierLabel: "Label",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 300),
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return Align(
            alignment: Alignment.topCenter,
            child: NotificationDialogView(
              message: 'Bạn chưa có khóa học nào. Bạn có muốn quay lại đăng nhập không?',
            ),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position: Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim1),
            child: child,
          );
        },
      );
      if (res != null && res == true) {
        widget.isBackLogin(res);
      }
    }
  }
}
