import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';
import 'package:gstudent/api/dtos/homework/submit_response.dart';
import 'package:gstudent/clan/views/arena_waiting_view.dart';
import 'package:gstudent/common/controls/resize_text.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/homework/components/ArrangeSentences.dart';
import 'package:gstudent/homework/components/FillScript.dart';
import 'package:gstudent/homework/components/FillTextAudio.dart';
import 'package:gstudent/homework/components/FillTextImage.dart';
import 'package:gstudent/homework/components/FillTextScript.dart';
import 'package:gstudent/homework/components/MatchImageAudio.dart';
import 'package:gstudent/homework/components/MatchTextAudio.dart';
import 'package:gstudent/homework/components/MatchTextImage.dart';
import 'package:gstudent/homework/components/MultiSelection.dart';
import 'package:gstudent/homework/components/RecordAudioView.dart';
import 'package:gstudent/homework/components/SingleChoice.dart';
import 'package:gstudent/homework/components/Writing.dart';
import 'package:gstudent/homework/cubit/homework_cubit.dart';
import 'package:gstudent/homework/views/homework_dialog_list_question.dart';
import 'package:gstudent/main.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';
import 'package:gstudent/settings/views/notification_dialog.dart';

class TestPage extends StatefulWidget {
  int lesson;
  int classroomId;
  int timeExam;
  bool isTest;
  List<GroupQuestion> gqs;

  TestPage(
      {this.lesson, this.classroomId, this.isTest, this.timeExam, this.gqs});

  @override
  State<StatefulWidget> createState() => TestPageState(
      classroomId: this.classroomId,
      lesson: this.lesson,
      isTest: this.isTest,
      timeExam: this.timeExam,
      gqs: this.gqs);
}

class TestPageState extends State<TestPage> with TickerProviderStateMixin {
  int lesson;
  int classroomId;
  int timeExam;
  bool isTest;

  TestPageState(
      {this.lesson, this.classroomId, this.isTest, this.timeExam, this.gqs});

  int timeDoTest = 0;

  HomeworkCubit cubit;
  List<GroupQuestion> gqs;
  int index = 0;
  int timeStart = 0;
  int avgTime = 0;
  int currentTime = 0;
  List<int> testGroupId;
  ApplicationSettings settings;

  final ScrollController _scrollController = ScrollController();
  bool isShowScript = false;

  AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    settings = GetIt.instance.get<ApplicationSettings>();
    cubit = BlocProvider.of<HomeworkCubit>(context);
    loadData();
  }

  Future loadData() async {
    showLoading();
    var oldData = await cubit.getQuestionTodo(classroomId, lesson, isTest);
    if (oldData != null) {
      setState(() {
        gqs = oldData.data;
      });
      loadTime();
    } else {
      var res = await cubit.getHomework(classroomId, lesson, type: "test");
      if (res != null && res.data != null) {
        setState(() {
          gqs = res.data;
        });
        loadTime();
      } else {
        await showDialog(
            context: context,
            builder: (context) => NotificationDialogView(
                  message: res.message,
                ));
        Navigator.of(context).pop();
      }
    }

    hideLoading();
  }

  disableFocus() {
    SystemChannels.textInput.invokeListMethod("TextInput.hide");
  }

  Future loadTime() async {
    var dur = await settings.getDurationTest(classroomId, lesson);
    if (dur != null) {
      setState(() {
        timeStart = DateTime.now().millisecondsSinceEpoch - dur;
      });
    } else {
      setState(() {
        timeStart = DateTime.now().millisecondsSinceEpoch;
      });
      await settings.saveDurationTest(timeStart, classroomId, lesson);
    }
    setState(() {
      timeDoTest = Duration(minutes: timeExam ?? 60).inMilliseconds;
    });

    if (timeDoTest > 0) {
      _controller = AnimationController(
          vsync: this,
          duration: Duration(
              milliseconds:
                  timeDoTest) // gameData.levelClock is a user entered number elsewhere in the applciation
          )
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            toast(context, 'Hết giờ làm bài');
            submitQuestion(false);
          }
        });
      startAnimation();
    } else {
      toast(context, 'Hết thời gian làm bài!');
      submitQuestion(false);
    }
  }

  startAnimation() async {
    try {
      await _controller.forward().orCancel;
    } on TickerCanceled {
      print(' animation canceled');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller?.stop();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned(
                top: 0,
                right: 0,
                left: 0,
                bottom: 0,
                child: Image(
                  image: AssetImage('assets/game_bg_arena.png'),
                  fit: BoxFit.fill,
                )),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              bottom: 0,
              child: SafeArea(
                child: Container(
                    child: Stack(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Image(
                                    image: AssetImage(
                                        'assets/images/game_button_back.png'),
                                    height: 48,
                                    width: 48,
                                  ),
                                  margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                'KIỂM TRA',
                                style: ThemeStyles.styleBold(font: 24),
                              ),
                            ),
                            Expanded(child: Container())
                          ],
                        ),
                        Container(
                          height: 52,
                          child: Stack(children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              bottom: 0,
                              width: 140,
                              child: Container(
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    borderRadius: BorderRadius.circular(4)),
                                child: TextButton(
                                  onPressed: () async {
                                    var currentIndex = await showDialog(
                                      context: context,
                                      builder: (context) =>
                                          HomeworkDialogListQuestion(
                                        current: index,
                                        qs: gqs,
                                      ),
                                    );
                                    if (currentIndex != null) {
                                      setState(() {
                                        index = currentIndex;
                                      });
                                    }
                                  },
                                  style: ButtonStyle(
                                    overlayColor:
                                        MaterialStateProperty.resolveWith<
                                            Color>((Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.pressed))
                                        return Colors.white;
                                      return null;
                                    }),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .lbl_review_question,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'SourceSerifPro',
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              child: Center(
                                child: _controller != null
                                    ? Countdown(
                                        color: Colors.red,
                                        fontSize: 20,
                                        isTextBold: true,
                                        animation: StepTween(
                                          begin: (timeDoTest / 1000).toInt(),
                                          // THIS IS A USER ENTERED NUMBER
                                          end: 0,
                                        ).animate(_controller),
                                      )
                                    : Text(
                                        '00:00',
                                        style: ThemeStyles.styleBold(
                                            textColors: Colors.red),
                                      ),
                              ),
                              top: 0,
                              right: 0,
                              left: 0,
                              bottom: 0,
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              bottom: 0,
                              child: GestureDetector(
                                onTap: () => submitQuestion(true),
                                child: Container(
                                  width: 80,
                                  margin: EdgeInsets.fromLTRB(4, 8, 8, 8),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(1, 1), blurRadius: 1)
                                      ]),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context).lbl_submit,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'SourceSerifPro',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ]),
                        ),
                        Expanded(
                            child: ListView(
                          controller: _scrollController,
                          children: [
                            gqs != null && gqs[index].description != null
                                ? GestureDetector(
                                    onTap: () => disableFocus(),
                                    child: Container(
                                      child: Text(
                                        gqs[index].description,
                                        style:
                                            ThemeStyles.styleNormal(font: 14),
                                      ),
                                      margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
                                    ),
                                  )
                                : Container(),
                            gqs != null && gqs[index].script != null
                                ? GestureDetector(
                                    onTap: () => disableFocus(),
                                    child: Container(
                                      child: Text(
                                        gqs[index].script,
                                        style:
                                            ThemeStyles.styleNormal(font: 14),
                                      ),
                                      margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
                                    ),
                                  )
                                : Container(),
                            gqs != null ? content(context) : Container(),
                          ],
                        )),
                        Row(
                          children: [
                            Visibility(
                              visible: index == 0 ? false : true,
                              child: GestureDetector(
                                  onTap: () => prevQuestion(),
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(16, 4, 8, 8),
                                    child: Image(
                                      image: AssetImage(
                                          'assets/images/game_select_character_left.png'),
                                      height: 40,
                                    ),
                                    height: 28,
                                  )),
                            ),
                            Expanded(child: Container()),
                            Visibility(
                              visible: gqs != null && index == gqs.length - 1
                                  ? false
                                  : true,
                              child: GestureDetector(
                                  onTap: () => nextQuestion(),
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(16, 4, 8, 8),
                                    child: Image(
                                      image: AssetImage(
                                          'assets/images/game_select_character_right.png'),
                                      height: 40,
                                    ),
                                    height: 28,
                                  )),
                            )
                          ],
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                    ),
                    isShowScript &&
                            gqs != null &&
                            gqs[index].description != null &&
                            gqs[index].description.isNotEmpty
                        ? Positioned(
                            child: ExpandableText(
                              child: gqs[index].description,
                              maxHeight:
                                  MediaQuery.of(context).size.height - 100,
                            ),
                            top: 60,
                            left: 0,
                            right: 0,
                          )
                        : Container(),
                    Positioned(
                      child: gqs != null &&
                              gqs[index].description != null &&
                              gqs[index].description.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  isShowScript = !isShowScript;
                                });
                              },
                              child: Container(
                                child: Center(
                                  child: Image(
                                    image: AssetImage('assets/images/pin.png'),
                                    height: 24,
                                  ),
                                ),
                                height: 32,
                                width: 32,
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                            )
                          : Container(),
                      top: 96,
                      right: 16,
                    )
                  ],
                )),
              ),
            ),
          ],
        ));
  }

  content(BuildContext context) {
    if (gqs[index] != null) {
      switch (gqs[index].type) {
        case QuestionType.FILL_TEXT_SCRIPT:
          return FillTextScript(
            grQuestion: gqs[index],
            key: GlobalKey<ScaffoldState>(),
          );
        case QuestionType.MATCH_TEXT_IMAGE:
          return MatchTextImage(
            question: gqs[index],
            key: GlobalKey<ScaffoldState>(),
          );
        case QuestionType.FILL_TEXT_AUDIO:
          return FillTextAudio(
            grQuestions: gqs[index],
            key: GlobalKey<ScaffoldState>(),
          );
        case QuestionType.ARRANGE_SENTENCES:
          return ArrangeSentencesView(
            question: gqs[index],
            key: GlobalKey<ScaffoldState>(),
          );
        case QuestionType.FILL_TEXT_IMAGE:
          return FillTextImage(
            groupQuestion: gqs[index],
            key: GlobalKey<ScaffoldState>(),
          );
        case QuestionType.SINGLE_CHOICE:
          return SingleChoice(
              grQuestions: gqs[index], key: GlobalKey<ScaffoldState>());
        case QuestionType.RECORD_AUDIO:
          return RecordAudioView(
              grQuestions: gqs[index], key: GlobalKey<ScaffoldState>());
        case QuestionType.MATCH_TEXT_AUDIO:
          return MatchTextAudio(
              question: gqs[index], key: GlobalKey<ScaffoldState>());
        case QuestionType.MATCH_IMAGE_AUDIO:
          return MatchImageAudio(
              question: gqs[index], key: GlobalKey<ScaffoldState>());
        case QuestionType.MULTI_SELECTION:
          return MultiSelection(
              grQuestion: gqs[index], key: GlobalKey<ScaffoldState>());
        case QuestionType.FILL_SCRIPT:
          return FillScript(
              question: gqs[index], key: GlobalKey<ScaffoldState>());
        case QuestionType.WRITING:
          return Writing(
            question: gqs[index],
            key: GlobalKey<ScaffoldState>(),
          );
        default:
          return SingleChoice(
              grQuestions: gqs[index], key: GlobalKey<ScaffoldState>());
      }
    }
    return Container();
  }

  nextQuestion() async {
    if (gqs != null && index < gqs.length - 1) {
      setState(() {
        index++;
      });
      _scrollController.animateTo(_scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn);
      await cubit.saveQuestionTodo(gqs, classroomId, lesson, isTest, 0);
    }
  }

  prevQuestion() async {
    if (gqs != null && index > 0) {
      setState(() {
        index--;
      });
      _scrollController.animateTo(_scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn);
      await cubit.saveQuestionTodo(gqs, classroomId, lesson, isTest, 0);
    }
  }

  submitQuestion(bool isCanShowDialog) async {
    showLoading();
    List<QuestionAnswer> qs = [];
    gqs.forEach((e) {
      var qss = e.questions
          .map((e) => e.answer)
          .toList()
          .where((element) =>
              element != null &&
              (element.content.isNotEmpty ||
                  (element.audio != null && element.audio.isNotEmpty)))
          .toList();
      qs.addAll(qss);
    });
    hideLoading();
    if (isCanShowDialog) {
      var res = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              TextButton(
                child: Text(
                  'Hủy',
                  style: ThemeStyles.styleNormal(),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text(
                  'Nộp bài',
                  style: ThemeStyles.styleNormal(),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
            title: Text(
              'Nộp bài',
              style: ThemeStyles.styleBold(font: 20),
            ),
            content: Text('Bạn chắc chắn nộp bài chưa?',
                style: ThemeStyles.styleNormal()),
          );
        },
      );
      if (res != null && res == true) {
        submit(qs);
      }
    } else {
      submit(qs);
    }
  }

  submit(List<QuestionAnswer> qs) async {
    var time = DateTime.now().millisecondsSinceEpoch - timeStart;
    print(time / 1000);
    if (qs.isEmpty) {
      toast(context, "Bạn chưa làm câu hỏi nào");
      return;
    }
    var avgTime = 0;
    qs.forEach((element) {
      avgTime = avgTime + element.timeAnswer;
    });
    avgTime = (avgTime / qs.length).toInt();
    print(avgTime);
    showLoading();
    var result = await cubit.submitHomework(
        classroomId, lesson, gqs[0].testId, isTest ? "test" : "homework", qs);
    hideLoading();
    if (result.error == false) {
      if (result.data != null) {
        await settings.deleteTimeTest(classroomId, lesson);
        await cubit.deleteQuestionTodo(classroomId, lesson, isTest);
        toast(context, "Nộp thành công");
        DataSubmitHomework param = result.data;
        param.duration = time;
        param.avgDuration = avgTime;
        param.lesson = this.lesson;
        param.classroomId = this.classroomId;
        Navigator.of(context).pop(param);
      } else {
        toast(context, "Lỗi");
      }
    } else {
      toast(context, result.message);
    }
  }
}
