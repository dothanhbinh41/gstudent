import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:gstudent/api/dtos/Route/route.dart';
import 'package:gstudent/api/dtos/homework/result_homework.dart';
import 'package:gstudent/api/dtos/homework/submit_response.dart';
import 'package:gstudent/common/controls/text_painting.dart';
import 'package:gstudent/home/cubit/route_cubit.dart';
import 'package:gstudent/home/cubit/route_state.dart';
import 'package:gstudent/home/model/result_data_homework.dart';
import 'package:gstudent/home/services/route_services.dart';
import 'package:gstudent/home/views/dialog_detail_lesson.dart';
import 'package:gstudent/home/views/dialog_lesson_route.dart';
import 'package:gstudent/home/views/dialog_lesson_test_route.dart';
import 'package:gstudent/home/views/feedback_view.dart';
import 'package:gstudent/homework/cubit/homework_cubit.dart';
import 'package:gstudent/homework/views/homework_view.dart';
import 'package:gstudent/homework/views/review_homework.dart';
import 'package:gstudent/homework/views/test_view.dart';
import 'package:gstudent/main.dart';
import 'package:gstudent/result/views/dialog_result_homework.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';

class RouteView extends StatefulWidget {
  int classroomId;
  int length;

  RouteView({this.classroomId, this.length});

  @override
  State<StatefulWidget> createState() =>
      RouteViewState(classroomId: this.classroomId, length: this.length);
}

class RouteViewState extends State<RouteView>
    with SingleTickerProviderStateMixin {
  int classroomId;
  int length;

  RouteViewState({this.classroomId, this.length});

  List<Routes> data;

  bool isAnimating;
  ScrollController _scrollController;
  AnimationController _controllerAnimCurrent;
  List<RoutePosition> position;
  int current = 0;
  int total = 0;
  double realHeight;
  List<int> rand = [];
  bool isloadData = false;
  AssetImage background;
  final service = GetIt.instance.get<RouteService>();
  final applicationSetting = GetIt.instance.get<ApplicationSettings>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    background = length < 6
        ? AssetImage('assets/map5.png')
        : length <= 30
            ? AssetImage('assets/bg_route.png')
            : (length < 40
                ? AssetImage('assets/map40.jpg')
                : (length > 40 && length <= 50
                    ? AssetImage('assets/bg_route_large.jpg')
                    : AssetImage('assets/map60.jpg')));
    _scrollController = ScrollController();
    _controllerAnimCurrent = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _controllerAnimCurrent.animateTo(0.5);
    loadDataRoute();
  }

  loadDataRoute() async {
    var res = await BlocProvider.of<RouteCubit>(context).loadRoute(classroomId);
    if (res != null && res.data.isNotEmpty) {
      if (mounted) {
        setState(() {
          data = res.data;
          var currentLesson = data
                  .where((element) => element.date.isBefore(DateTime.now()))
                  .isNotEmpty
              ? data
                  .where((element) => element.date.isBefore(DateTime.now()))
                  .last
              : data.last;
          if (currentLesson != null &&
                  currentLesson.type == TypeLesson.WORKSHOP ||
              currentLesson.type == TypeLesson.CLUB ||
              currentLesson.type == TypeLesson.TUTORING) {
            current = data
                    .where((element) =>
                        element.date.isBefore(DateTime.now()) &&
                        element.type == TypeLesson.HOMEWORK)
                    .isNotEmpty
                ? data
                    .where((element) =>
                        element.date.isBefore(DateTime.now()) &&
                        element.type == TypeLesson.HOMEWORK)
                    .last
                    .lesson
                : data
                    .where((element) => element.type == TypeLesson.HOMEWORK)
                    .last
                    .lesson;
            data
                    .where((element) => element.date.isBefore(DateTime.now()))
                    .isNotEmpty
                ? data
                    .where((element) => element.date.isBefore(DateTime.now()))
                    .last
                    .isCurrentLesson = true
                : data.last.isCurrentLesson = true;
          } else {
            data
                    .where((element) => element.date.isBefore(DateTime.now()))
                    .isNotEmpty
                ? data
                    .where((element) => element.date.isBefore(DateTime.now()))
                    .last
                    .isCurrentLesson = true
                : data.last.isCurrentLesson = true;
            current = data
                .where((element) => element.date.isBefore(DateTime.now()))
                .last
                .lesson;
          }
          total = data.where((element) => element.lesson != null).last.lesson;
          isloadData = true;
        });
      }
    }
  }

  startAnimation() async {
    if (current < total / 2) {
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        _scrollController.animateTo(
            _scrollController.position.maxScrollExtent *
                ((total - current) / total),
            duration: const Duration(milliseconds: 400),
            curve: Curves.fastOutSlowIn);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(background, context);
  }

  @override
  Widget build(BuildContext context) {
    double checkBoxSize = computeCheckBoxSize(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocListener<RouteCubit, RouteState>(
        listener: (context, state) {
          if (state is ShowDialogLesson) {
            showDialogLesson(state.lesson);
          } else if (state is ShowDialogFeedback) {
            showDialogFeedback(state.lesson);
          } else if (state is DoHomeworkState) {
            navigateToHomework(
                state.lesson, state.classroomid, state.isTest, state.timeDoTest,
                data: state.resultHomework, endTime: state.endTime);
          } else if (state is ReadDetailLessonState) {
            showDialogReadLessonDetail(state.lesson);
          } else if (state is StudyOnlineState) {
            navigateZoom(state.lesson);
          }
        },
        child: isloadData
            ? (length < 6
                ? FutureBuilder(
                    future:
                        loadDataListRoute(MediaQuery.of(context).size.width),
                    builder: (context, snapshot) {
                      return Stack(children: [
                        Positioned(
                          child: Image(
                            image: background,
                            fit: BoxFit.fill,
                          ),
                          top: 0,
                          right: 0,
                          bottom: 0,
                          left: 0,
                        ),
                        for (var i = 0; i < position.length; i++)
                          if (position[i].lesson.type == TypeLesson.TUTORING)
                            _tutoringItem(i, checkBoxSize)
                          else if (position[i].lesson.type ==
                              TypeLesson.WORKSHOP)
                            _workShopItem(i, checkBoxSize)
                          else if (position[i].lesson.type == TypeLesson.CLUB)
                            _clubItem(i, checkBoxSize)
                          else
                            lessonItem(i, checkBoxSize),
                        Positioned(
                          child: SafeArea(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Image(
                                image: AssetImage(
                                    'assets/images/game_button_back.png'),
                                height: 48,
                                width: 48,
                              ),
                            ),
                          ),
                          top: 8,
                          left: 8,
                        ),
                      ]);
                    },
                  )
                : Stack(
                    children: [
                      Positioned(
                        child: CustomScrollView(
                          controller: _scrollController,
                          slivers: [
                            SliverToBoxAdapter(
                              child: FutureBuilder(
                                future: loadDataListRoute(
                                    MediaQuery.of(context).size.width),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    startAnimation();
                                    return Stack(children: [
                                      Image(
                                        image: background,
                                        fit: BoxFit.fill,
                                      ),
                                      for (var i = 0; i < position.length; i++)
                                        if (position[i].lesson.type ==
                                            TypeLesson.TUTORING)
                                          _tutoringItem(i, checkBoxSize)
                                        else if (position[i].lesson.type ==
                                            TypeLesson.WORKSHOP)
                                          _workShopItem(i, checkBoxSize)
                                        else if (position[i].lesson.type ==
                                            TypeLesson.CLUB)
                                          _clubItem(i, checkBoxSize)
                                        else
                                          lessonItem(i, checkBoxSize),
                                    ]);
                                  } else
                                    return GestureDetector(
                                      onTap: () => reloadData(),
                                      child: Stack(
                                        children: [
                                          Image(
                                            image: background,
                                            fit: BoxFit.fill,
                                          ),
                                          Positioned(
                                            bottom: MediaQuery.of(context)
                                                .size
                                                .height,
                                            right: 0,
                                            left: 0,
                                            top: 0,
                                            child: Center(
                                              child: Visibility(
                                                visible: isloadData == false,
                                                child: SpinKitFadingCircle(
                                                  color: Colors.purple,
                                                  size: 50.0,
                                                ),
                                              ),
                                            ),
                                          )
                                          // Positioned(child: Container(
                                          //   padding: EdgeInsets.all(8),
                                          //   width: 120,
                                          //   child: Center(child: Text('Xin vui lòng quay lại và vào lại để cập nhật lại data',),),
                                          // ),top: 48,right: 0,left: 0,)
                                        ],
                                      ),
                                    );
                                },
                              ),
                            )
                          ],
                        ),
                        top: 0,
                        right: 0,
                        left: 0,
                        bottom: 0,
                      ),
                      Positioned(
                        child: SafeArea(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Image(
                              image: AssetImage(
                                  'assets/images/game_button_back.png'),
                              height: 48,
                              width: 48,
                            ),
                          ),
                        ),
                        top: 8,
                        left: 8,
                      ),
                    ],
                  ))
            : loadData(),
      ),
    );
  }

  showDialogLesson(Routes lesson) async {
    showLoading();
    var result = await BlocProvider.of<RouteCubit>(context).getResult(
        classroomId, lesson.lesson,
        type: lesson.exam != 0 ? "test" : "homework");
    hideLoading();
    if (lesson.exam != 0) {
      var res = await showGeneralDialog(
        barrierLabel: "Label",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 300),
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return Align(
            alignment: Alignment.center,
            child: RouteLessonTestDialog(
              lesson: lesson,
              isHaveResult: result != null &&
                  result.data != null &&
                  result.data.isNotEmpty,
              isLastTest: lesson.date ==
                  data.where((element) => element.exam != 0).last.date,
              isMarking: result != null &&
                  result.data != null &&
                  result.data.isNotEmpty &&
                  result.data.first.statusMark == 0,
            ),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position:
                Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim1),
            child: child,
          );
        },
      );
      BlocProvider.of<RouteCubit>(context).emit(RouteStateInitial());
      if (res != null) {
        switch (res) {
          case 2:
            BlocProvider.of<RouteCubit>(context).emit(DoHomeworkState(
                endTime: lesson.exam != 0
                    ? DateTime(
                        lesson.date.year,
                        lesson.date.month,
                        lesson.date.day,
                        int.parse(lesson.endTime.split(":").first),
                        int.parse(lesson.endTime.split(":").skip(1).first))
                    : null,
                resultHomework:
                    result != null && result.data != null ? result : null,
                lesson: lesson.lesson,
                classroomid: this.classroomId,
                isTest: lesson.exam != 0,
                timeDoTest: lesson.timeExam));
            return;
          case 1:
            BlocProvider.of<RouteCubit>(context)
                .emit(StudyOnlineState(lesson: lesson));
            return;
        }
      }
    } else {
      var res = await showGeneralDialog(
        barrierLabel: "Label",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 300),
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return Align(
            alignment: Alignment.center,
            child: RouteLessonDialog(
              lesson: lesson,
              comment: result != null &&
                      result.data != null &&
                      result.data.isNotEmpty &&
                      result.data.first.comment != null
                  ? result.data.first.comment.comment
                  : null,
            ),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position:
                Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim1),
            child: child,
          );
        },
      );

      BlocProvider.of<RouteCubit>(context).emit(RouteStateInitial());
      if (res != null) {
        switch (res) {
          case 2:
            BlocProvider.of<RouteCubit>(context)
                .emit(ShowDialogFeedback(lesson: lesson));
            return;
          case 3:
            BlocProvider.of<RouteCubit>(context).emit(DoHomeworkState(
                endTime: lesson.exam != 0
                    ? DateTime(
                        lesson.date.year,
                        lesson.date.month,
                        lesson.date.day,
                        int.parse(lesson.endTime.split(":").first),
                        int.parse(lesson.endTime.split(":").skip(1).first))
                    : null,
                resultHomework:
                    result != null && result.data != null ? result : null,
                lesson: lesson.lesson,
                classroomid: this.classroomId,
                isTest: lesson.exam != 0,
                timeDoTest: lesson.timeExam));
            return;
          case -1:
            BlocProvider.of<RouteCubit>(context)
                .emit(StudyOnlineState(lesson: lesson));
            return;
          case 5:
            await showDialog(
                context: context,
                builder: (context) => DialogResultHomeWork(
                      comment: result.data.first.comment.comment,
                      score: result.data.first.score,
                      totalScore: result.data.first.totalScore,
                    ));
            return;
          default:
            BlocProvider.of<RouteCubit>(context)
                .emit(ReadDetailLessonState(lesson: lesson));
            return;
        }
      }
    }
  }

  showDialogFeedback(Routes lesson) async {
    RouteCubit cubit = BlocProvider.of<RouteCubit>(context);
    if (lesson.action == null) {
      return;
    }
    if (lesson.action.feedback != null && lesson.action.feedback == false) {
      var res = await showGeneralDialog(
        barrierLabel: "Label",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 700),
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return Align(
              alignment: Alignment.center,
              child: BlocProvider<RouteCubit>.value(
                  value: cubit, //
                  child: FeedbackDialogView(
                    lesson: lesson.lesson,
                    classroomId: this.classroomId,
                    cubit: cubit,
                  )));
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position:
                Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim1),
            child: child,
          );
        },
      );

      loadDataRoute();
      BlocProvider.of<RouteCubit>(context).emit(RouteStateInitial());
      if (res != null) {
        setState(() {
          lesson.action.feedback = true;
        });
        switch (res) {
          case 3:
            BlocProvider.of<RouteCubit>(context).emit(DoHomeworkState(
                resultHomework: null,
                lesson: lesson.lesson,
                classroomid: this.classroomId,
                isTest: lesson.exam != 0,
                timeDoTest: lesson.timeExam));
        }
      }
    } else {
      toast(context, 'Bạn đã gửi feedback rồi!');
    }
  }

  double computeCheckBoxSize(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final MaterialTapTargetSize effectiveMaterialTapTargetSize =
        themeData.checkboxTheme.materialTapTargetSize ??
            themeData.materialTapTargetSize;
    final VisualDensity effectiveVisualDensity =
        themeData.checkboxTheme.visualDensity ?? themeData.visualDensity;
    Size size;
    switch (effectiveMaterialTapTargetSize) {
      case MaterialTapTargetSize.padded:
        size = const Size(kMinInteractiveDimension, kMinInteractiveDimension);
        break;
      case MaterialTapTargetSize.shrinkWrap:
        size = const Size(
            kMinInteractiveDimension - 8.0, kMinInteractiveDimension - 8.0);
        break;
    }
    size += effectiveVisualDensity.baseSizeAdjustment;
    return size.longestSide;
  }

  loadData() {
    return Scaffold(
      body: length < 6
          ? Stack(
              children: [
                Positioned(
                  child: Image(
                    image: background,
                    fit: BoxFit.fill,
                  ),
                  top: 0,
                  right: 0,
                  bottom: 0,
                  left: 0,
                ),
                Positioned.fill(
                  child: CustomPaint(
                    painter: TestPathPainter(
                      height: (value) {
                        if(realHeight == null){
                          realHeight = value;
                        }
                      },
                    ),
                  ),
                ),

                Positioned(
                  bottom: MediaQuery.of(context).size.height,
                  right: 0,
                  left: 0,
                  top: 0,
                  child: Center(
                    child: Visibility(
                      visible: isloadData == false,
                      child: SpinKitFadingCircle(
                        color: Colors.purple,
                        size: 50.0,
                      ),
                    ),
                  ),
                )
              ],
            )
          : NotificationListener(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollEndNotification) {}
                return true;
              },
              child: CustomScrollView(
                controller: _scrollController,
                shrinkWrap: true,
                slivers: [
                  SliverToBoxAdapter(
                    child: Stack(
                      children: [
                        Image(
                          image: background,
                          fit: BoxFit.fill,
                        ),
                        Positioned.fill(
                          child: CustomPaint(
                            painter: TestPathPainter(
                              height: (value) {
                                if(realHeight == null){
                                  realHeight = value;
                                }

                              },
                            ),
                          ),
                        ),

                        Positioned(
                          bottom: MediaQuery.of(context).size.height,
                          right: 0,
                          left: 0,
                          top: 0,
                          child: Center(
                            child: Visibility(
                              visible: isloadData == false,
                              child: SpinKitFadingCircle(
                                color: Colors.purple,
                                size: 50.0,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }

  routeClicked(Routes lesson) {
    if (lesson.lesson != null && lesson.lesson > current) {
      toast(context, 'Bạn chưa học đến buổi này');
      return;
    }

    if (lesson.lesson == null) {
      if ((lesson.type != TypeLesson.HOMEWORK ||
              lesson.type != TypeLesson.EXAM) &&
          lesson.date.isAfter(DateTime.now())) {
        toast(context, 'Bạn chưa học đến buổi này');
        return;
      }
    }
    BlocProvider.of<RouteCubit>(context).emit(ShowDialogLesson(lesson: lesson));
  }

  void navigateToHomework(
      int lesson, int classroomid, bool isTest, int timeExam,
      {ResultHomeworkData data, DateTime endTime}) async {
    if (data != null && data.data != null) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: HomeworkCubit(
                service: service, applicationSettings: applicationSetting),
            child: ReviewHomeworkPage(
              gqs: data.data.first.test,
            ),
          ),
        ),
      );
    } else {
      ResultDataHomeWork res = ResultDataHomeWork();
      if (isTest) {
        if (DateTime.now().isAfter(endTime)) {
          toast(context, "Đã quá thời gian làm bài thi");
        } else {
          var duration = 0;
          var dur = (endTime.millisecondsSinceEpoch -
              DateTime.now().millisecondsSinceEpoch);
          var a = Duration(milliseconds: dur);
          duration = timeExam != null && a.inMinutes > timeExam
              ? timeExam
              : a.inMinutes;

          DataSubmitHomework response = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: HomeworkCubit(
                    service: service, applicationSettings: applicationSetting),
                child: TestPage(
                  timeExam: duration,
                  classroomId: classroomid,
                  lesson: lesson,
                  isTest: isTest,
                ),
              ),
            ),
          );

          if (response != null) {
            setState(() {
              isloadData = false;
              res.result = response;
              res.isTest = isTest;
            });
            loadDataRoute();
            Navigator.of(context).pop(res);
          }
        }
      } else {
        DataSubmitHomework response = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: HomeworkCubit(
                  service: service, applicationSettings: applicationSetting),
              child: HomeworkPage(
                isAdvance: false,
                classroomId: classroomid,
                lesson: lesson,
              ),
            ),
          ),
        );

        if (response != null) {
          setState(() {
            isloadData = false;
            res.result = response;
            res.isTest = isTest;
          });
          loadDataRoute();
          Navigator.of(context).pop(res);
        }
      }
    }

    BlocProvider.of<RouteCubit>(context).emit(RouteStateInitial());
  }

  void showDialogReadLessonDetail(Routes lesson) async {
    var res = await showGeneralDialog(
      barrierLabel: "",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
            alignment: Alignment.center,
            child: DetailLessonDialog(
              lesson: lesson,
            ));
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );

    BlocProvider.of<RouteCubit>(context).emit(RouteStateInitial());
  }

  reloadData() {
    setState(() {
      isloadData = false;
    });
    loadDataRoute();
  }

  void navigateZoom(Routes lesson) async {
    var applicationSetting = GetIt.instance.get<ApplicationSettings>();
    var user = await applicationSetting.getCurrentUser();
    if (lesson.zoomId.isEmpty || lesson.zoomPassword.isEmpty) {
      toast(context, 'Zoom id hoặc password không được để trống');
      return;
    }

    await BlocProvider.of<RouteCubit>(context).initZoomOptions(lesson.zoomId,
        lesson.zoomPassword, lesson.exam != 0, lesson.lesson, classroomId);
  }

  Future<List<RoutePosition>> loadDataListRoute(width) async {
    if (data.length > 50) {
      return await list60Lesson(width);
    }
    if (data.length > 40) {
      return await list50Lesson(width);
    }
    if (data.length > 30) {
      return await list40Lesson(width);
    }

    if (data.length <= 30) {
      if (data.length < 6) {
        return await list6Lesson(width);
      }
      if (data.length <= 12) {
        return await list12Lesson(width);
      }
      if (data.length <= 16) {
        return await list16Lesson(width);
      }
      if (data.length <= 20) {
        return await list20Lesson(width);
      }

      if (data.length <= 24) {
        return await list24Lesson(width);
      }
      if (data.length > 24 && data.length <= 28) {
        return await list28Lesson(width);
      }
      if (data.length > 28 && data.length <= 30) {
        return await list30Lesson(width);
      }
    }
  }

  // list 28 item
  Future<List<RoutePosition>> list28Lesson(width) async {
    Size size = Size(width, realHeight);
    var sizewidth = size.width * 0.62;
    var points = [
      Offset(sizewidth * 0.85, size.height * 0.035),
      Offset(sizewidth * 0.5, size.height * 0.07),
      Offset(sizewidth * 0.4, size.height * 0.14),
      Offset(sizewidth * 0.8, size.height * 0.14),
      Offset(sizewidth * 1.15, size.height * 0.17),

      Offset(sizewidth, size.height * 0.22),

      Offset(sizewidth * 0.65, size.height * 0.255),

      Offset(sizewidth, size.height * 0.275),

      Offset(sizewidth * 1.3, size.height * 0.3),

      Offset(sizewidth * 1, size.height * 0.33),

      Offset(sizewidth * 0.6, size.height * 0.32),

      Offset(sizewidth * 0.32, size.height * 0.365),
//16
      Offset(sizewidth * 0.55, size.height * 0.41),

      Offset(sizewidth * 0.85, size.height * 0.435),

      Offset(sizewidth * 0.6, size.height * 0.47),

      Offset(sizewidth * 0.38, size.height * 0.53),

      Offset(sizewidth * 0.8, size.height * 0.55),

      Offset(sizewidth * 1.15, size.height * 0.58),
      Offset(sizewidth * 0.9, size.height * 0.625),
      Offset(sizewidth * 0.7, size.height * 0.67),
      //8
      Offset(sizewidth * 1.15, size.height * 0.68),
      Offset(sizewidth * 1.15, size.height * 0.74),
      Offset(sizewidth * 0.7, size.height * 0.725),
      Offset(sizewidth * 0.34, size.height * 0.75),
      Offset(sizewidth * 0.45, size.height * 0.81),
      Offset(sizewidth * 0.85, size.height * 0.85),
      //2
      Offset(sizewidth * 0.51, size.height * 0.878),
      //1
      Offset(sizewidth * 0.41, size.height * 0.94),
    ];

    if (data.length < points.length) {
      var l = points.length - data.length;
      for (var i = 0; i < l; i++) {
        if (rand.isEmpty || rand.length < l) {
          rand.add(Random().nextInt(points.length));
        }
        points.removeAt(rand[i]);
      }
    }

    position = List<RoutePosition>();
    var reverseListPoint = points.reversed.toList();

    for (var i = 0; i < reverseListPoint.length; i++) {
      position
          .add(RoutePosition(lesson: data[i], position: reverseListPoint[i]));
    }
    return position;
  }

  //36
  Future<List<RoutePosition>> list40Lesson(width) async {
    Size size = Size(width, realHeight);
    var sizewidth = size.width * 0.62;

    var points = [
      Offset(sizewidth * 1, size.height * 0.05),
      Offset(sizewidth * 0.8, size.height * 0.07),
      Offset(sizewidth * 1.2, size.height * 0.09),
      Offset(sizewidth * 0.9, size.height * 0.125),
      Offset(sizewidth * 0.5, size.height * 0.14),

      Offset(sizewidth * 0.8, size.height * 0.175),
      Offset(sizewidth * 0.6, size.height * 0.21),
      Offset(sizewidth * 0.4, size.height * 0.24),

      Offset(sizewidth * 0.95, size.height * 0.232),
      Offset(sizewidth * 1.3, size.height * 0.255),
      Offset(sizewidth * 1, size.height * 0.29),

      //8

      Offset(sizewidth * 0.8, size.height * 0.315),
      Offset(sizewidth * 1.25, size.height * 0.35),
      Offset(sizewidth * 0.8, size.height * 0.37),
      Offset(sizewidth * 0.55, size.height * 0.395),
      //7
      Offset(sizewidth * 0.8, size.height * 0.43),
      Offset(sizewidth * 0.4, size.height * 0.45),
      Offset(sizewidth * 0.7, size.height * 0.49),
      Offset(sizewidth * 1.15, size.height * 0.5),

      Offset(sizewidth * 1, size.height * 0.53),
//6
      Offset(sizewidth * 0.6, size.height * 0.55),
      Offset(sizewidth * 1.2, size.height * 0.57),
      Offset(sizewidth * 0.4, size.height * 0.595),
      Offset(sizewidth * 0.9, size.height * 0.6),
      Offset(sizewidth * 0.4, size.height * 0.64),

//5
      Offset(sizewidth * 0.9, size.height * 0.66),
      Offset(sizewidth * 0.5, size.height * 0.685),

      Offset(sizewidth * 0.5, size.height * 0.73),
      Offset(sizewidth * 1, size.height * 0.73),
      Offset(sizewidth * 1, size.height * 0.77),
//4

//3
      Offset(sizewidth * 0.65, size.height * 0.795),
//2
      Offset(sizewidth * 1.1, size.height * 0.81),
      Offset(sizewidth * 1.2, size.height * 0.84),
      Offset(sizewidth * 0.7, size.height * 0.835),
      Offset(sizewidth * 0.35, size.height * 0.86),

//1
      Offset(sizewidth * 0.6, size.height * 0.89),
      Offset(sizewidth * 0.8, size.height * 0.92),
      Offset(sizewidth * 0.4, size.height * 0.94),
      Offset(sizewidth * 0.65, size.height * 0.97),

      Offset(sizewidth * 1.1, size.height * 0.98),
    ];

    if (data.length < points.length) {
      var l = points.length - data.length;
      for (var i = 0; i < l; i++) {
        if (rand.isEmpty || rand.length < l) {
          rand.add(Random().nextInt(points.length));
        }
        points.removeAt(rand[i]);
      }
    }

    position = [];
    var reverseListPoint = points.reversed.toList();

    for (var i = 0; i < reverseListPoint.length; i++) {
      position
          .add(RoutePosition(lesson: data[i], position: reverseListPoint[i]));
    }
    return position;
  }

  // list 32 item
  Future<List<RoutePosition>> list30Lesson(width) async {
    Size size = Size(width, realHeight);
    var sizewidth = size.width * 0.62;

    var points = [
      Offset(sizewidth * 0.85, size.height * 0.035),
      Offset(sizewidth * 0.5, size.height * 0.08),
      Offset(sizewidth * 0.4, size.height * 0.14),
      Offset(sizewidth * 1, size.height * 0.18),

      Offset(sizewidth, size.height * 0.22),

      Offset(sizewidth * 0.65, size.height * 0.255),

      Offset(sizewidth, size.height * 0.275),

      Offset(sizewidth * 1.3, size.height * 0.3),

      Offset(sizewidth * 1, size.height * 0.33),

      Offset(sizewidth * 0.6, size.height * 0.32),

      Offset(sizewidth * 0.32, size.height * 0.365),
      Offset(sizewidth * 0.55, size.height * 0.41),

      Offset(sizewidth * 0.85, size.height * 0.435),
      Offset(sizewidth * 0.6, size.height * 0.47),
      Offset(sizewidth * 0.38, size.height * 0.5),

      Offset(sizewidth * 0.5, size.height * 0.55),
      // Offset(sizewidth * 0.85, size.height * 0.545),
      Offset(sizewidth * 1.15, size.height * 0.58),
      Offset(sizewidth * 0.9, size.height * 0.625),

      Offset(sizewidth * 0.7, size.height * 0.67),
      Offset(sizewidth * 1.15, size.height * 0.68),
      Offset(sizewidth * 1.25, size.height * 0.735),
      Offset(sizewidth * 0.85, size.height * 0.73),

      Offset(sizewidth * 0.45, size.height * 0.725),
      Offset(sizewidth * 0.32, size.height * 0.775),
      Offset(sizewidth * 0.55, size.height * 0.82),
      Offset(sizewidth * 0.84, size.height * 0.85),

      Offset(sizewidth * 0.5, size.height * 0.88),
      Offset(sizewidth * 0.35, size.height * 0.925),
      Offset(sizewidth * 0.65, size.height * 0.955),
      Offset(sizewidth * 1, size.height * 0.95),
    ];

    if (data.length < points.length) {
      var l = points.length - data.length;
      for (var i = 0; i < l; i++) {
        if (rand.isEmpty || rand.length < l) {
          rand.add(Random().nextInt(points.length));
        }
        points.removeAt(rand[i]);
      }
    }

    position = List<RoutePosition>();
    var reverseListPoint = points.reversed.toList();

    for (var i = 0; i < reverseListPoint.length; i++) {
      position
          .add(RoutePosition(lesson: data[i], position: reverseListPoint[i]));
    }
    return position;
  }

  // list 24 item
  Future<List<RoutePosition>> list24Lesson(width) async {
    Size size = Size(width, realHeight);
    var sizewidth = size.width * 0.62;

    List<Offset> points = [
      Offset(sizewidth * 0.85, size.height * 0.02),
      Offset(sizewidth * 0.48, size.height * 0.075),
      Offset(sizewidth * 0.45, size.height * 0.14),
      Offset(sizewidth * 0.91, size.height * 0.14),
      Offset(sizewidth * 1.16, size.height * 0.19),
      Offset(sizewidth * 0.76, size.height * 0.222),
      Offset(sizewidth, size.height * 0.27),
      Offset(sizewidth * 1.24, size.height * 0.328),
      Offset(sizewidth * 0.69, size.height * 0.32),
      Offset(sizewidth * 0.33, size.height * 0.34),
      Offset(sizewidth * 0.51, size.height * 0.405),
      Offset(sizewidth * 0.87, size.height * 0.43),
      Offset(sizewidth * 0.45, size.height * 0.48),
      Offset(sizewidth * 0.74, size.height * 0.545),
      Offset(sizewidth * 1.11, size.height * 0.56),
      Offset(sizewidth * 0.82, size.height * 0.622),
      Offset(sizewidth * 0.87, size.height * 0.676),
      Offset(sizewidth * 1.28, size.height * 0.69),
      Offset(sizewidth, size.height * 0.735),
      Offset(sizewidth * 0.57, size.height * 0.72),
      Offset(sizewidth * 0.39, size.height * 0.795),
      Offset(sizewidth * 0.77, size.height * 0.82),
      Offset(sizewidth * 0.51, size.height * 0.878),
      Offset(sizewidth * 0.41, size.height * 0.94),
    ];

    if (data.length < points.length) {
      var l = points.length - data.length;
      for (var i = 0; i < l; i++) {
        if (rand.isEmpty || rand.length < l) {
          rand.add(Random().nextInt(points.length));
        }
        points.removeAt(rand[i]);
      }
    }
    position = List<RoutePosition>();
    var reverseListPoint = points.reversed.toList();

    for (var i = 0; i < reverseListPoint.length; i++) {
      position
          .add(RoutePosition(lesson: data[i], position: reverseListPoint[i]));
    }
    // setState(() {
    //   position = position.reversed.toList();
    // });
    return position;
  }

  // list 20 item
  Future<List<RoutePosition>> list20Lesson(width) async {
    Size size = Size(width, realHeight);
    var sizewidth = size.width * 0.62;
    List<Offset> points = [
      Offset(sizewidth * 0.85, size.height * 0.02),
      Offset(sizewidth * 0.48, size.height * 0.075),
      Offset(sizewidth * 0.45, size.height * 0.14),
      Offset(sizewidth * 1.1, size.height * 0.16),
      //16
      Offset(sizewidth * 0.76, size.height * 0.222),
      Offset(sizewidth, size.height * 0.27),
      Offset(sizewidth * 1.24, size.height * 0.328),
      Offset(sizewidth * 0.6, size.height * 0.322),
      //12
      Offset(sizewidth * 0.51, size.height * 0.405),
      Offset(sizewidth * 0.87, size.height * 0.45),
      Offset(sizewidth * 0.35, size.height * 0.51),
      Offset(sizewidth * 0.8, size.height * 0.55),
      //8
      Offset(sizewidth * 1.1, size.height * 0.622),
      Offset(sizewidth * 0.7, size.height * 0.676),
      Offset(sizewidth * 1.28, size.height * 0.72),
      Offset(sizewidth * 0.7, size.height * 0.725),
      //4
      Offset(sizewidth * 0.38, size.height * 0.8),
      Offset(sizewidth * 0.85, size.height * 0.85),
      Offset(sizewidth * 0.38, size.height * 0.9),
      Offset(sizewidth, size.height * 0.95),
    ];

    if (data.length < points.length) {
      var l = points.length - data.length;
      for (var i = 0; i < l; i++) {
        if (rand.isEmpty || rand.length < l) {
          rand.add(Random().nextInt(points.length));
        }
        points.removeAt(rand[i]);
      }
    }

    position = List<RoutePosition>();
    var reverseListPoint = points.reversed.toList();

    for (var i = 0; i < reverseListPoint.length; i++) {
      position
          .add(RoutePosition(lesson: data[i], position: reverseListPoint[i]));
    }
    return position;
  }

  //list 16
  Future<List<RoutePosition>> list16Lesson(width) async {
    Size size = Size(width, realHeight);
    var sizewidth = size.width * 0.62;
    List<Offset> points = [
      Offset(sizewidth * 0.85, size.height * 0.04),
      Offset(sizewidth * 0.38, size.height * 0.1),
      Offset(sizewidth, size.height * 0.14),
      Offset(sizewidth * 1.1, size.height * 0.21),
      Offset(sizewidth * 0.7, size.height * 0.27),
      Offset(sizewidth * 0.33, size.height * 0.34),
      Offset(sizewidth * 1.24, size.height * 0.328),
      Offset(sizewidth * 0.33, size.height * 0.34),
      Offset(sizewidth * 0.8, size.height * 0.46),
      Offset(sizewidth * 0.4, size.height * 0.54),
      Offset(sizewidth * 1.15, size.height * 0.6),
      Offset(sizewidth * 0.87, size.height * 0.676),
      Offset(sizewidth, size.height * 0.735),
      Offset(sizewidth * 0.32, size.height * 0.77),
      Offset(sizewidth * 0.51, size.height * 0.878),
      Offset(sizewidth, size.height * 0.95),
    ];

    if (data.length < points.length) {
      var l = points.length - data.length;
      for (var i = 0; i < l; i++) {
        if (rand.isEmpty || rand.length < l) {
          rand.add(Random().nextInt(points.length));
        }
        points.removeAt(rand[i]);
      }
    }

    position = List<RoutePosition>();
    var reverseListPoint = points.reversed.toList();

    for (var i = 0; i < reverseListPoint.length; i++) {
      position
          .add(RoutePosition(lesson: data[i], position: reverseListPoint[i]));
    }
    return position;
  }

  Future<List<RoutePosition>> list6Lesson(width) async {
    Size size = Size(width, realHeight);
    var sizewidth = size.width * 0.62;
    List<Offset> points = [
      Offset(sizewidth * 0.8, size.height * 0.1),
      Offset(sizewidth * 1.12, size.height * 0.32),
      Offset(sizewidth * 1.26, size.height * 0.5),
      Offset(sizewidth * 0.35, size.height * 0.63),
      Offset(sizewidth * 0.7, size.height * 0.92),
    ];

    if (data.length < points.length) {
      var l = points.length - data.length;
      for (var i = 0; i < l; i++) {
        if (rand.isEmpty || rand.length < l) {
          rand.add(Random().nextInt(points.length));
        }
        points.removeAt(rand[i]);
      }
    }

    position = List<RoutePosition>();
    var reverseListPoint = points.reversed.toList();

    for (var i = 0; i < reverseListPoint.length; i++) {
      position
          .add(RoutePosition(lesson: data[i], position: reverseListPoint[i]));
    }
    return position;
  }

  Future<List<RoutePosition>> list12Lesson(width) async {
    Size size = Size(width, realHeight);
    var sizewidth = size.width * 0.62;
    List<Offset> points = [
      Offset(sizewidth * 0.85, size.height * 0.04),
      Offset(sizewidth * 0.6, size.height * 0.145),
      Offset(sizewidth, size.height * 0.22),
      Offset(sizewidth * 1.2, size.height * 0.28),
      Offset(sizewidth * 0.4, size.height * 0.33),
      Offset(sizewidth * 0.6, size.height * 0.47),
      Offset(sizewidth * 0.8, size.height * 0.55),
      Offset(sizewidth * 0.65, size.height * 0.65),
      Offset(sizewidth * 1.3, size.height * 0.725),
      Offset(sizewidth * 0.35, size.height * 0.75),
      Offset(sizewidth * 0.6, size.height * 0.87),
      Offset(sizewidth, size.height * 0.95),
    ];

    if (data.length < points.length) {
      var l = points.length - data.length;
      for (var i = 0; i < l; i++) {
        if (rand.isEmpty || rand.length < l) {
          rand.add(Random().nextInt(points.length));
        }
        points.removeAt(rand[i]);
      }
    }

    position = List<RoutePosition>();
    var reverseListPoint = points.reversed.toList();

    for (var i = 0; i < reverseListPoint.length; i++) {
      position
          .add(RoutePosition(lesson: data[i], position: reverseListPoint[i]));
    }
    return position;
  }

  Future<List<RoutePosition>> list60Lesson(width) async {
    Size size = Size(width, realHeight);
    var sizewidth = size.width * 0.62;

    List<Offset> points = [
      Offset(sizewidth * 0.8, size.height * 0.07),
      Offset(sizewidth * 1.2, size.height * 0.11),
      Offset(sizewidth * 1.1, size.height * 0.17),
      Offset(sizewidth * 0.6, size.height * 0.16),

      Offset(sizewidth * 0.5, size.height * 0.24),
      Offset(sizewidth * 0.9, size.height * 0.29),
      Offset(sizewidth * 0.5, size.height * 0.3),
      Offset(sizewidth * 0.45, size.height * 0.355),

      // 50
      Offset(sizewidth * 0.9, size.height * 0.34),
      Offset(sizewidth * 1.3, size.height * 0.38),

      //12
      Offset(sizewidth * 1, size.height * 0.43),
      Offset(sizewidth * 1.1, size.height * 0.5),
      Offset(sizewidth * 0.5, size.height * 0.58),
      Offset(sizewidth * 0.95, size.height * 0.57),

      Offset(sizewidth * 0.8, size.height * 0.62),
      Offset(sizewidth * 0.6, size.height * 0.675),
      Offset(sizewidth * 0.4, size.height * 0.73),
      Offset(sizewidth * 1, size.height * 0.755),

      Offset(sizewidth * 1.1, size.height * 0.83),
      Offset(sizewidth * 0.75, size.height * 0.89),
      Offset(sizewidth * 1.25, size.height * 0.95),
      Offset(sizewidth * 0.85, size.height * 0.94),

      Offset(sizewidth * 0.4, size.height * 0.95),
      Offset(sizewidth * 0.45, size.height * 1.02),
      Offset(sizewidth * 0.85, size.height * 1.05),
      Offset(sizewidth * 0.5, size.height * 1.09),
      Offset(sizewidth * 0.55, size.height * 1.165),

      //8
      Offset(sizewidth * 1, size.height * 1.16),
      Offset(sizewidth * 1.1, size.height * 1.23),
      Offset(sizewidth * 0.65, size.height * 1.28),
      Offset(sizewidth * 1.1, size.height * 1.29),

      Offset(sizewidth * 1.22, size.height * 1.34),
      Offset(sizewidth * 0.65, size.height * 1.34),
      Offset(sizewidth * 0.3, size.height * 1.425),

      Offset(sizewidth * 0.75, size.height * 1.435),
      Offset(sizewidth * 0.6, size.height * 1.49),

      Offset(sizewidth * 0.35, size.height * 1.55),
      Offset(sizewidth * 0.7, size.height * 1.57),
      Offset(sizewidth * 1.1, size.height * 1.58),
      Offset(sizewidth * 1, size.height * 1.64),

      Offset(sizewidth * 0.65, size.height * 1.68),
      Offset(sizewidth * 1.2, size.height * 1.7),
      Offset(sizewidth, size.height * 1.76),
      Offset(sizewidth * 0.5, size.height * 1.75),

      //4
      Offset(sizewidth * 0.33, size.height * 1.8),
      Offset(sizewidth * 0.7, size.height * 1.835),
      Offset(sizewidth * 0.6, size.height * 1.895),
      Offset(sizewidth * 0.35, size.height * 1.95),

      Offset(sizewidth * 0.8, size.height * 1.97),
      Offset(sizewidth * 1.15, size.height * 2),
      Offset(sizewidth * 0.7, size.height * 2.06),
      Offset(sizewidth * 0.95, size.height * 2.1),

      Offset(sizewidth * 1.3, size.height * 2.12),
      Offset(sizewidth * 0.8, size.height * 2.15),
      Offset(sizewidth * 0.4, size.height * 2.16),
      Offset(sizewidth * 0.45, size.height * 2.225),

      Offset(sizewidth * 0.83, size.height * 2.26),
      Offset(sizewidth * 0.4, size.height * 2.32),
      Offset(sizewidth * 0.6, size.height * 2.375),
      Offset(sizewidth * 1.05, size.height * 2.38),
    ];

    print(points.length);
    if (data.length < points.length) {
      var l = points.length - data.length;
      for (var i = 0; i < l; i++) {
        if (rand.isEmpty || rand.length < l) {
          rand.add(Random().nextInt(points.length));
        }
        points.removeAt(rand[i]);
      }
    }

    position = List<RoutePosition>();
    var reverseListPoint = points.reversed.toList();

    for (var i = 0; i < reverseListPoint.length; i++) {
      position
          .add(RoutePosition(lesson: data[i], position: reverseListPoint[i]));
    }
    return position;
  }

  Future<List<RoutePosition>> list50Lesson(width) async {
    Size size = Size(width, realHeight);
    var sizewidth = size.width * 0.62;

    List<Offset> points = [
      Offset(sizewidth * 0.85, size.height * 0.06),
      Offset(sizewidth * 1.2, size.height * 0.08),

      //12
      Offset(sizewidth * 1.1, size.height * 0.145),
      Offset(sizewidth * 0.6, size.height * 0.14),
      Offset(sizewidth * 0.6, size.height * 0.22),
      Offset(sizewidth * 0.95, size.height * 0.26),

      Offset(sizewidth * 0.5, size.height * 0.275),
      Offset(sizewidth * 0.4, size.height * 0.33),
      Offset(sizewidth * 0.85, size.height * 0.32),
      Offset(sizewidth * 1.3, size.height * 0.355),

      Offset(sizewidth * 1.1, size.height * 0.41),
      Offset(sizewidth * 0.75, size.height * 0.44),
      Offset(sizewidth * 1.25, size.height * 0.5),
      Offset(sizewidth * 0.85, size.height * 0.55),

      Offset(sizewidth * 0.45, size.height * 0.6),
      Offset(sizewidth * 0.95, size.height * 0.65),
      Offset(sizewidth * 0.4, size.height * 0.68),
      Offset(sizewidth * 0.65, size.height * 0.735),

      //8
      Offset(sizewidth * 1.2, size.height * 0.73),
      Offset(sizewidth * 1.1, size.height * 0.81),
      Offset(sizewidth * 0.75, size.height * 0.85),
      Offset(sizewidth * 1.1, size.height * 0.88),

      Offset(sizewidth * 0.65, size.height * 0.95),
      Offset(sizewidth * 1.22, size.height * 0.98),
      Offset(sizewidth * 0.75, size.height * 1.01),
      Offset(sizewidth * 0.6, size.height * 1.06),

      Offset(sizewidth * 0.35, size.height * 1.12),
      Offset(sizewidth * 1.1, size.height * 1.16),
      Offset(sizewidth * 0.7, size.height * 1.145),
      Offset(sizewidth * 1, size.height * 1.22),

      Offset(sizewidth * 0.65, size.height * 1.25),
      Offset(sizewidth * 1.2, size.height * 1.28),
      Offset(sizewidth, size.height * 1.33),
      Offset(sizewidth * 0.5, size.height * 1.32),

      //4
      Offset(sizewidth * 0.35, size.height * 1.38),
      Offset(sizewidth * 0.7, size.height * 1.415),
      Offset(sizewidth * 0.6, size.height * 1.465),
      Offset(sizewidth * 0.35, size.height * 1.53),

      Offset(sizewidth * 0.8, size.height * 1.54),
      Offset(sizewidth * 1.15, size.height * 1.59),
      Offset(sizewidth * 0.7, size.height * 1.63),
      Offset(sizewidth * 0.95, size.height * 1.68),

      Offset(sizewidth * 1.3, size.height * 1.72),
      Offset(sizewidth * 0.8, size.height * 1.73),
      Offset(sizewidth * 0.4, size.height * 1.74),
      Offset(sizewidth * 0.45, size.height * 1.805),

      Offset(sizewidth * 0.8, size.height * 1.86),
      Offset(sizewidth * 0.4, size.height * 1.9),
      Offset(sizewidth * 0.6, size.height * 1.95),
      Offset(sizewidth * 1.1, size.height * 1.96),
    ];
    print(points.length);
    if (data.length < points.length) {
      var l = points.length - data.length;
      for (var i = 0; i < l; i++) {
        if (rand.isEmpty || rand.length < l) {
          rand.add(Random().nextInt(points.length));
        }
        points.removeAt(rand[i]);
      }
    }

    position = List<RoutePosition>();
    var reverseListPoint = points.reversed.toList();

    for (var i = 0; i < reverseListPoint.length; i++) {
      position
          .add(RoutePosition(lesson: data[i], position: reverseListPoint[i]));
    }
    return position;
  }

  _workShopItem(int i, double checkBoxSize) {
    return Positioned(
        left: position[i].position.dx - checkBoxSize / 2,
        top: position[i].lesson.isCurrentLesson
            ? position[i].position.dy - checkBoxSize * 1.5
            : position[i].position.dy - checkBoxSize / 2,
        child: GestureDetector(
          onTap: () => routeClicked(position[i].lesson),
          child: position[i].lesson.isCurrentLesson
              ? Container(
                  height: 100,
                  child: Column(
                    children: [
                      Container(
                        height: 52,
                        width: 48,
                        child: Image(
                          image: AssetImage(
                              'assets/images/icon_current_lesson.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        height: 48,
                        width: 48,
                        child: Stack(
                          children: [
                            Image(
                              image: AssetImage(
                                  'assets/images/icon_lesson_current.png'),
                              fit: BoxFit.fill,
                            ),
                            Container(
                              child: textpaintingBase(
                                  "WORKSHOP",
                                  8,
                                  position[i].lesson.lesson != null &&
                                          position[i].lesson.lesson <= current
                                      ? Colors.black
                                      : Colors.white,
                                  position[i].lesson.lesson != null &&
                                          position[i].lesson.lesson <= current
                                      ? Colors.white
                                      : Colors.black,
                                  2),
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              : Container(
                  height: 48,
                  width: 48,
                  child: Stack(
                    children: [
                      Image(
                        image: position.indexOf(position[i]) <
                                position.indexOf(position
                                    .where((element) =>
                                        element.lesson.isCurrentLesson == true)
                                    .first)
                            ? AssetImage(
                                'assets/images/icon_lesson_current.png')
                            : AssetImage(
                                'assets/images/icon_lesson_future.png'),
                        fit: BoxFit.fill,
                      ),
                      Container(
                        child: textpaintingBase(
                            "WORKSHOP",
                            8,
                            position[i].lesson.lesson != null &&
                                    position[i].lesson.lesson <= current
                                ? Colors.black
                                : Colors.white,
                            position[i].lesson.lesson != null &&
                                    position[i].lesson.lesson <= current
                                ? Colors.white
                                : Colors.black,
                            2),
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                      ),
                    ],
                  ),
                ),
        ));
  }

  _clubItem(int i, double checkBoxSize) {
    return Positioned(
        left: position[i].position.dx - checkBoxSize / 2,
        top: position[i].lesson.isCurrentLesson
            ? position[i].position.dy - checkBoxSize * 1.5
            : position[i].position.dy - checkBoxSize / 2,
        child: GestureDetector(
          onTap: () => routeClicked(position[i].lesson),
          child: position[i].lesson.isCurrentLesson
              ? Container(
                  height: 100,
                  child: Column(
                    children: [
                      Container(
                        height: 52,
                        width: 48,
                        child: Image(
                          image: AssetImage(
                              'assets/images/icon_current_lesson.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        height: 48,
                        width: 48,
                        child: Stack(
                          children: [
                            Image(
                              image: AssetImage(
                                  'assets/images/icon_lesson_current.png'),
                              fit: BoxFit.fill,
                            ),
                            Container(
                              child: textpaintingBase(
                                  "CLUB",
                                  8,
                                  position[i].lesson.lesson != null &&
                                          position[i].lesson.lesson <= current
                                      ? Colors.black
                                      : Colors.white,
                                  position[i].lesson.lesson != null &&
                                          position[i].lesson.lesson <= current
                                      ? Colors.white
                                      : Colors.black,
                                  2),
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              : Container(
                  height: 48,
                  width: 48,
                  child: Stack(
                    children: [
                      Image(
                        image: position.indexOf(position[i]) <
                                position.indexOf(position
                                    .where((element) =>
                                        element.lesson.isCurrentLesson == true)
                                    .first)
                            ? AssetImage(
                                'assets/images/icon_lesson_current.png')
                            : AssetImage(
                                'assets/images/icon_lesson_future.png'),
                        fit: BoxFit.fill,
                      ),
                      Container(
                        child: textpaintingBase(
                            "CLUB",
                            8,
                            position[i].lesson.lesson != null &&
                                    position[i].lesson.lesson <= current
                                ? Colors.black
                                : Colors.white,
                            position[i].lesson.lesson != null &&
                                    position[i].lesson.lesson <= current
                                ? Colors.white
                                : Colors.black,
                            2),
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                      ),
                    ],
                  ),
                ),
        ));
  }

  _tutoringItem(int i, double checkBoxSize) {
    return Positioned(
        left: position[i].position.dx - checkBoxSize / 2,
        top: position[i].lesson.isCurrentLesson
            ? position[i].position.dy - checkBoxSize * 1.5
            : position[i].position.dy - checkBoxSize / 2,
        child: GestureDetector(
          onTap: () => routeClicked(position[i].lesson),
          child: position[i].lesson.isCurrentLesson
              ? Container(
                  height: 100,
                  child: Column(
                    children: [
                      Container(
                        height: 52,
                        width: 48,
                        child: Image(
                          image: AssetImage(
                              'assets/images/icon_current_lesson.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        height: 48,
                        width: 48,
                        child: Stack(
                          children: [
                            Image(
                              image: AssetImage(
                                  'assets/images/icon_lesson_current.png'),
                              fit: BoxFit.fill,
                            ),
                            Container(
                              child: textpaintingBase(
                                  "Phụ đạo",
                                  10,
                                  position[i].lesson.lesson != null &&
                                          position[i].lesson.lesson <= current
                                      ? Colors.black
                                      : Colors.white,
                                  position[i].lesson.lesson != null &&
                                          position[i].lesson.lesson <= current
                                      ? Colors.white
                                      : Colors.black,
                                  2),
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              : Container(
                  height: 48,
                  width: 48,
                  child: Stack(
                    children: [
                      Image(
                        image: position.indexOf(position[i]) <
                                position.indexOf(position
                                    .where((element) =>
                                        element.lesson.isCurrentLesson == true)
                                    .first)
                            ? AssetImage(
                                'assets/images/icon_lesson_current.png')
                            : AssetImage(
                                'assets/images/icon_lesson_future.png'),
                        fit: BoxFit.fill,
                      ),
                      Container(
                        child: textpaintingBase(
                            "Phụ đạo",
                            10,
                            position[i].lesson.lesson != null &&
                                    position[i].lesson.lesson <= current
                                ? Colors.black
                                : Colors.white,
                            position[i].lesson.lesson != null &&
                                    position[i].lesson.lesson <= current
                                ? Colors.white
                                : Colors.black,
                            2),
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                      ),
                    ],
                  ),
                ),
        ));
  }

  lessonItem(int i, double checkBoxSize) {
    return Positioned(
        left: position[i].position.dx - checkBoxSize / 2,
        top: position[i].lesson.lesson == current &&
                position
                    .where((element) =>
                        (element.lesson.type == TypeLesson.HOMEWORK ||
                            element.lesson.type == TypeLesson.EXAM) &&
                        element.lesson.isCurrentLesson)
                    .isNotEmpty
            ? position[i].position.dy - checkBoxSize * 1.5
            : position[i].position.dy - checkBoxSize / 2,
        child: GestureDetector(
          onTap: () => routeClicked(position[i].lesson),
          child: position[i].lesson.isCurrentLesson
              ? Container(
                  height: 100,
                  child: Column(
                    children: [
                      Container(
                        height: 52,
                        width: 48,
                        child: Image(
                          image: AssetImage(
                              'assets/images/icon_current_lesson.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        height: 48,
                        width: 48,
                        child: Stack(
                          children: [
                            Image(
                              image: AssetImage(
                                  'assets/images/icon_lesson_current.png'),
                              fit: BoxFit.fill,
                            ),
                            Container(
                              child: textpaintingBase(
                                  position[i].lesson.type == TypeLesson.EXAM
                                      ? "Test"
                                      : (position[i].lesson.lesson != null
                                          ? position[i].lesson.lesson.toString()
                                          : ""),
                                  16,
                                  position[i].lesson.lesson != null &&
                                          position[i].lesson.lesson <= current
                                      ? Colors.black
                                      : Colors.white,
                                  position[i].lesson.lesson != null &&
                                          position[i].lesson.lesson <= current
                                      ? Colors.white
                                      : Colors.black,
                                  2),
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              : Container(
                  height: 48,
                  width: 48,
                  child: Stack(
                    children: [
                      Image(
                        image: position[i].lesson.lesson != null &&
                                position[i].lesson.lesson <= current
                            ? AssetImage(
                                'assets/images/icon_lesson_current.png')
                            : AssetImage(
                                'assets/images/icon_lesson_future.png'),
                        fit: BoxFit.fill,
                      ),
                      Container(
                        child: textpaintingBase(
                            position[i].lesson.type == TypeLesson.EXAM
                                ? "Test"
                                : (position[i].lesson.lesson != null
                                    ? position[i].lesson.lesson.toString()
                                    : "Phụ Đạo"),
                            position[i].lesson.lesson != null ? 16 : 10,
                            position[i].lesson.lesson != null &&
                                    position[i].lesson.lesson <= current
                                ? Colors.black
                                : Colors.white,
                            position[i].lesson.lesson != null &&
                                    position[i].lesson.lesson <= current
                                ? Colors.white
                                : Colors.black,
                            2),
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                      ),
                    ],
                  ),
                ),
        ));
  }
}

class TestPathPainter extends CustomPainter {
  final Function(double) height;

  TestPathPainter({this.height});

  @override
  void paint(Canvas canvas, Size sizez) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.black;

    var size = sizez;
    var sizewidth = size.width * 0.62;
    var sizeheight = size.height * 1;
    // Path number 3

    height(sizeheight);

    // var p = path
    //   ..moveTo(
    //     points[0].dx * size.width,
    //     points[0].dy * size.height,
    //   );
    // points.sublist(1).forEach(
    //       (point) => path.lineTo(
    //         point.dx * size.width,
    //         point.dy * size.height,
    //       ),
    //     );
  }

  @override
  bool shouldRepaint(TestPathPainter oldDelegate) => true;
}

class RoutePosition {
  Offset position;
  Routes lesson;

  RoutePosition({this.lesson, this.position});
}
