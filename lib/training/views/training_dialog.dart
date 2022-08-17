import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/home/services/route_services.dart';
import 'package:gstudent/main.dart';
import 'package:gstudent/result/views/result_training_speed.dart';
import 'package:gstudent/test/cubit/TestCubit.dart';
import 'package:gstudent/test/services/TestServices.dart';
import 'package:gstudent/test/views/list_test_view.dart';
import 'package:gstudent/training/cubit/vocab_cubit.dart';
import 'package:gstudent/training/services/vocab_services.dart';
import 'package:gstudent/training/views/speed/training_speed_view.dart';
import 'package:gstudent/training/views/vocab/vocabulary_practice.dart';
import 'package:gstudent/waiting/views/training_speed_waiting.dart';
import 'package:gstudent/waiting/views/waiting_training_vocab.dart';

class TrainningDialog extends StatefulWidget {
  int courseStudentId;
  int classroomId;
  int userClanId;
  int exp;
  String slug;

  TrainningDialog({this.courseStudentId, this.classroomId, this.userClanId, this.slug,this.exp});

  @override
  State<StatefulWidget> createState() => TrainningDialogState(exp:this.exp,slug: this.slug, courseStudentId: this.courseStudentId, classroomId: this.classroomId, userClanId: this.userClanId);
}

class TrainningDialogState extends State<TrainningDialog> {
  int courseStudentId;
  int classroomId;
  int userClanId;
  int exp;
  String slug;

  TrainningDialogState({this.slug, this.courseStudentId, this.classroomId, this.userClanId,this.exp});

  int lessonCurrent;
  RouteService service;
  TestService testService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    service = GetIt.instance.get<RouteService>();
    testService = GetIt.instance.get<TestService>();
    if (slug != null) {
      switch (slug) {
        case "speed":
          Future.delayed(Duration(milliseconds: 500)).whenComplete(() => navigateSpeed());
          return;
        case "vocab":
          Future.delayed(Duration(milliseconds: 500)).whenComplete(() => navigateVocab());
          return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 320,
        width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width * 0.8 : 400,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              left: 0,
              child: Image(
                image: AssetImage('assets/bg_notification_medium.png'),
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
                top: 28,
                bottom: 16,
                right: 36,
                left: 36,
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "PHÒNG LUYỆN",
                        style: ThemeStyles.styleBold(
                          font: 20,
                        ),
                      ),
                    ),
                    Container(
                      height: 24,
                      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Image(
                        image: AssetImage('assets/images/eclipse_login.png'),
                      ),
                    ),
                    luyenTocDo(),
                    Vocab(),
                    test()
                  ],
                )),
            Positioned(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Image(
                  image: AssetImage('assets/images/game_close_dialog_clan.png'),
                  height: 48,
                  width: 48,
                ),
              ),
              top: 8,
              right: 8,
            ),
          ],
        ),
      ),
    );
  }

  Vocab() {
    return GestureDetector(
      onTap: () => navigateVocab(),
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
        height: 60,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: HexColor("#fff6d7"), border: Border.all(color: HexColor("#b4a163"), width: 1)),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.all(4),
              child: Stack(
                children: [
                  Positioned(
                    top: 2,
                    left: 4,
                    bottom: 2,
                    child: Container(
                      height: 48,
                      width: 48,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 4,
                            right: 4,
                            left: 4,
                            bottom: 4,
                            child: Image(
                              image: AssetImage('assets/images/ic_training_vocab.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            left: 0,
                            bottom: 0,
                            child: Image(
                              image: AssetImage('assets/images/game_border_avatar_clan.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              width: 56,
            ),
            Expanded(
                child: Center(
                  child: Text(
              'Luyện Từ Vựng',
              style: ThemeStyles.styleBold(
                  font: 14,
              ),
            ),
                )),
          ],
        ),
      ),
    );
  }

  luyenTocDo() {
    return GestureDetector(
      onTap: () => navigateSpeed(),
      child: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
          height: 60,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: HexColor("#fff6d7"), border: Border.all(color: HexColor("#b4a163"), width: 1)),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.all(4),
                child: Stack(
                  children: [
                    Positioned(
                      top: 2,
                      left: 4,
                      bottom: 2,
                      child: Container(
                        height: 48,
                        width: 48,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 4,
                              right: 4,
                              left: 4,
                              bottom: 4,
                              child: Image(
                                image: AssetImage('assets/images/ic_training_speed.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              left: 0,
                              bottom: 0,
                              child: Image(
                                image: AssetImage('assets/images/game_border_avatar_clan.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                width: 56,
              ),
              Expanded(
                  child: Center(
                    child: Text(
                'Luyện Tốc Độ',
                style: ThemeStyles.styleBold(
                    font: 14,
                ),
              ),
                  ))
            ],
          )),
    );
  }

  test() {
    return GestureDetector(
      onTap: () => navigateTest(),
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: HexColor("#fff6d7"), border: Border.all(color: HexColor("#b4a163"), width: 1)),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.all(4),
              child: Stack(
                children: [
                  Positioned(
                    top: 2,
                    left: 4,
                    bottom: 2,
                    child: Container(
                      height: 48,
                      width: 48,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 4,
                            right: 4,
                            left: 4,
                            bottom: 4,
                            child: Image(
                              image: AssetImage('assets/images/ic_training_test.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            left: 0,
                            bottom: 0,
                            child: Image(
                              image: AssetImage('assets/images/game_border_avatar_clan.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              width: 56,
            ),
            Expanded(
                child: Center(child: Text(
                  'Luyện Thi',
                  style: ThemeStyles.styleBold(
                    font: 14,
                  ),
                ),))
          ],
        ),
      ),
    );
  }

  navigateVocab() async {
    var res = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TrainingVocabWaiting(),
    ));
    if (res == true) {
      showLoading();
      var route = await service.loadRoute(classroomId);
      if(route == null || route.error){
        toast(context, 'Có lỗi xảy ra');
        return;
      }
      lessonCurrent = route.data.where((element) => element.date.isBefore(DateTime.now())) != null ? route.data.where((element) => element.date.isBefore(DateTime.now())).last.lesson : 0;
      hideLoading();
      var vocabServices = GetIt.instance.get<VocabService>();
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: VocabCubit(services: vocabServices),
          child: VocabularyPracticeView(
            classroomId: classroomId,
            lesson: lessonCurrent,
            userClanId: this.userClanId,
          ),
        ),
      ));
    }
  }

  navigateSpeed() async {
    var res = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TrainingSpeedWaiting(),
    ));
    if (res == true) {
      ParamResultSpeed res = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TrainingSpeedView(
            courseStudentId: this.courseStudentId,
            classroomId: this.classroomId,
            userClanId: this.userClanId,
            exp: this.exp,
          ),
        ),
      );
      if (res != null) {
        showDialog(
          context: context,
          builder: (context) => ResultTrainingSpeedView(
            param: res,
          ),
        );
      }
    }
  }

  navigateTest() async {
    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: TestCubit(services: testService),
        child: ListTopicExamView(),
      ),
    );
  }
}
