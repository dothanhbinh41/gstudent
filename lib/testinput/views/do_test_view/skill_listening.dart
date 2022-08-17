import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gstudent/api/dtos/TestInput/enum.dart';
import 'package:gstudent/api/dtos/TestInput/group_question.dart';
import 'package:gstudent/api/dtos/TestInput/ielts.dart';
import 'package:gstudent/testinput/component/border.dart';
import 'package:gstudent/testinput/component/diagram.dart';
import 'package:gstudent/testinput/component/fillimage.dart';
import 'package:gstudent/testinput/component/filllimitword.dart';
import 'package:gstudent/testinput/component/form.dart';
import 'package:gstudent/testinput/component/lecturescomments.dart';
import 'package:gstudent/testinput/component/multiselection.dart';
import 'package:gstudent/testinput/component/singlechoice.dart';
import 'package:gstudent/testinput/cubit/testinput_cubit.dart';
import 'package:gstudent/testinput/views/do_test_view/list_question_dialog.dart';

enum stateAudio { play, pause, resume, stop }

// ignore: must_be_immutable
class ListeningSkillPage extends StatefulWidget {
  String type;
  List<GroupQuestionTest> data;
  int idImport;
  int idStudent;
  bool isLast;

  ListeningSkillPage({this.type, this.data, this.idImport, this.isLast,this.idStudent});

  @override
  State<StatefulWidget> createState() => ListeningSkillPageState(
      type: this.type,
      data: this.data,
      idImport: this.idImport,
      idStudent: this.idStudent,
      isLast: this.isLast);
}

class ListeningSkillPageState extends State<ListeningSkillPage>
    with SingleTickerProviderStateMixin {
  String type;
  List<GroupQuestionTest> data;
  bool isLast;
  int idStudent;

  ListeningSkillPageState({this.type, this.data, this.idImport, this.isLast,this.idStudent});

  stateAudio state = stateAudio.stop;
  bool isPlay = false;
  final String skill = "listening";
  int idImport;
  final getIt = GetIt.instance;
  int current;
  GroupQuestionTest currentQs;
  AnimationController _animationController;
  AudioPlayer audioPlayer;
  TestInputCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of(context);
    setState(() {
      audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
      current = 0;
      currentQs = data[current];
      _animationController = AnimationController(
          vsync: this, duration: Duration(milliseconds: 400));
    });
  }

  @override
  dispose() {
    super.dispose();
    _animationController.dispose();
  }

  void submitQs() async {
    List<QuestionTestInputDto> listSave = [];
    data.forEach((element) {
      listSave.addAll(element.groupQuestion.where((e) => (e.answerSubmit != null && e.answerSubmit.answers.isNotEmpty) || e.answersSubmit != null && e.answersSubmit.isNotEmpty));
    });

  var res = await   cubit.saveTestInput(skill, listSave, idStudent);
    //
    // List<AnswerQuestion> ans = [];
    // data.forEach((element) {
    //   element.groupQuestion.forEach((c) {
    //     if (c.answerSubmit != null && c.answerSubmit.answers != "") {
    //       ans.add(c.answerSubmit);
    //     }
    //   });
    //
    //   if (element.groupQuestion[0].groupQuestionType ==
    //       GroupQuestionType.SELECT_MULTIPLE) {
    //     element.groupQuestion.forEach((c) {
    //       if (c.answersSubmit != null) {
    //         c.answersSubmit.forEach((e) {
    //           ans.add(e);
    //         });
    //       }
    //     });
    //   }
    // });
    //
    // List<AnswerSubmit> answers = [];
    // ans.forEach((element) {
    //   var a = AnswerSubmit(id: element.id);
    //   if (element.type == GroupQuestionType.YES_NO_NOTGIVEN ||
    //       element.type == GroupQuestionType.TRUE_FALSE_NOTGIVEN) {
    //     a.answers = element.answers;
    //   } else if (element.type == GroupQuestionType.TABLE ||
    //       element.type == GroupQuestionType.TEXT) {
    //     if (element.answerType == AnswerType.MULTIPLE_CHOICE) {
    //       a.answers = List<String>.empty(growable: true);
    //       a.answers.add(element.answers);
    //     } else {
    //       a.answers = element.answers;
    //       a.type = "text";
    //     }
    //   } else if (element.type == GroupQuestionType.SELECT_MULTIPLE) {
    //     a.answers = List<String>.empty(growable: true);
    //     a.answers.addAll(element.answers);
    //   } else {
    //     a.answers = List<String>.empty(growable: true);
    //     a.answers.add(element.answers);
    //   }
    //   answers.add(a);
    // });
    // var result = await cubit.submitQuestion(type, skill, answers, idImport, false,idStudent);

    if (res) {
     Navigator.of(context).pop(true);
    }
  }

  disableFocus() {
    SystemChannels.textInput.invokeListMethod("TextInput.hide");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
          onTap: () =>  disableFocus(),
          child: Stack(
      children: [
          Positioned(
              top: 0,
              right: 0,
              left: 0,
              bottom: 0,
              child: Image(
                image: AssetImage('assets/game_bg_arena_light.png'),
                fit: BoxFit.fill,
              )),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                child: Column(
                  children: [
                    SafeArea(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 60,
                              child: Row(children: [
                                GestureDetector(
                                  onTap: () => navigationBack(),
                                  child: Container(
                                    child: Icon(
                                      Icons.chevron_left,
                                      size: 24,
                                    ),
                                    margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    width: 160,
                                    child: TextButton(
                                      style: ButtonStyle(
                                        overlayColor:
                                            MaterialStateProperty.resolveWith<
                                                Color>((Set<MaterialState> states) {
                                          if (states
                                              .contains(MaterialState.pressed))
                                            return Colors.blue;
                                          return null;
                                        }),
                                      ),
                                      onPressed: () => showDialogAsync(),
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .lbl_review_question,
                                        style: TextStyle(
                                            fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  child: Container(
                                    width: 100,
                                    margin: EdgeInsets.fromLTRB(4, 8, 4, 8),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(1, 1), blurRadius: 1)
                                        ]),
                                    child: Center(
                                      child: Text(
                                          "Lưu kết quả",style: TextStyle(  fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400,),),
                                    ),
                                  ),
                                  onTap: () => submitQs(),
                                )
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            child: Text(currentQs.groupQuestion[0].groupQuestion),
                            margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          ),
                          Container(
                            child: Center(
                                child: IconButton(
                              icon: AnimatedIcon(
                                icon: AnimatedIcons.play_pause,
                                progress: _animationController,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              splashRadius: 20,
                              splashColor: Theme.of(context).colorScheme.primary,
                              onPressed: () => buttonAudioClick(),
                            )),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(20)),
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          ),
                          content(context)
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    )),
                    Row(
                      children: [
                        Expanded(
                            child: Visibility(
                          visible: current == 0 ? false : true,
                          child: GestureDetector(
                              onTap: () => prevQuestion(),
                              child: Container(
                                margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
                                child: Center(
                                    child: Text(
                                  AppLocalizations.of(context).lbl_pre,
                                  style: TextStyle(color: Colors.white),
                                )),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(24)),
                                height: 40,
                              )),
                        )),
                        Expanded(
                            child: Visibility(
                          visible: current == data.length - 1 ? false : true,
                          child: GestureDetector(
                              onTap: () => nextQuestion(),
                              child: Container(
                                margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
                                child: Center(
                                    child: Text(
                                  AppLocalizations.of(context).lbl_next,
                                  style: TextStyle(color: Colors.white),
                                )),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(24)),
                                height: 40,
                              )),
                        ))
                      ],
                    )
                  ],
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                ),
              ),
            ),
          )
      ],
    ),
        ));
  }

  content(context) {
    switch (currentQs.groupQuestion[0].groupQuestionType) {
      case GroupQuestionType.TEXT:
        return SingleChoicePage(
          groupQuestionTest: currentQs,
          key: GlobalKey<ScaffoldState>(),
        );

      case GroupQuestionType.FILL_IMAGE:
        return FillImagePage(
          groupQuestionTest: currentQs,
          key: GlobalKey<ScaffoldState>(),
        );

      case GroupQuestionType.SELECT_MULTIPLE:
        return MultiSelectionPage(
          groupQuestionTest: currentQs,
          key: GlobalKey<ScaffoldState>(),
        );
      case GroupQuestionType.LECTURES_COMMENTS:
        return LectureCommentPage(
          key: GlobalKey<ScaffoldState>(),
          groupQuestionTest: currentQs,
        );
      case GroupQuestionType.FILL_LIMIT_WORD:
        return FillLimitWordPage(
          key: GlobalKey<ScaffoldState>(),
          groupQuestionTest: currentQs,
        );
      case GroupQuestionType.DIAGRAM:
        return DiagramPage(
          key: GlobalKey<ScaffoldState>(),
          groupQuestionTest: currentQs,
        );
      case GroupQuestionType.BORDER:
        return BorderPage(
          groupQuestionTest: currentQs,
          key: GlobalKey<ScaffoldState>(),
        );

      default:
        return FormPage(
          groupQuestionTest: currentQs,
          key: GlobalKey<ScaffoldState>(),
        );
    }
  }

  nextQuestion() {
    stopAudio();
    setState(() {
      if (current < data.length - 1) {
        data[current] = currentQs;
        current++;
        currentQs = data[current];
      }
    });
  }

  prevQuestion() {
    stopAudio();
    setState(() {
      if (current > 0) {
        data[current] = currentQs;
        current--;
        currentQs = data[current];
      }
    });
  }

  void showDialogAsync() async {
    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    var result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return TestInputQuestionDialog(
              itemHeight: itemHeight,
              itemWidth: itemWidth,
              qs: data,
              current: current,
              type: type);
        });
    setState(() {
      current = result != null ? result : current;
      currentQs = data[current];
    });
  }

  navigationBack() {
    Navigator.of(context).pop(isLast);
    stopAudio();
  }

  buttonAudioClick() {
    setState(() {
      isPlay = !isPlay;
    });
    checkState();

    if (isPlay == true) {
      if (state == stateAudio.stop) {
        state = stateAudio.play;
        playAudio();
      }
      if (state == stateAudio.pause) {
        state = stateAudio.resume;
        resumeAudio();
      }
    } else {
      state = stateAudio.pause;
      pauseAudio();
    }
  }

  checkState() {
    isPlay ? _animationController.forward() : _animationController.reverse();
  }

  playAudio() async {
    try {
      await audioPlayer.play((currentQs.groupQuestion
              .where((e) =>
                  e.sectionMediaContent != null &&
                  e.sectionMediaContent.isNotEmpty)
              .first)
          .sectionMediaContent);
    } catch (e) {
      print(e);
    }
  }

  pauseAudio() async {
    await audioPlayer.pause();
  }

  resumeAudio() async {
    await audioPlayer.resume();
  }

  stopAudio() async {
    if (isPlay == true) {
      state = stateAudio.stop;
      await audioPlayer.stop();
      isPlay = false;
      checkState();
    }
  }
}
