
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/TestInput/answer.dart';
import 'package:gstudent/api/dtos/TestInput/answer_submit.dart';
import 'package:gstudent/api/dtos/TestInput/enum.dart';
import 'package:gstudent/api/dtos/TestInput/group_question.dart';
import 'package:gstudent/api/dtos/TestInput/ielts.dart';
import 'package:gstudent/common/controls/audio_recorder.dart';
import 'package:gstudent/testinput/views/do_test_view/list_question_dialog.dart';
import 'package:path_provider/path_provider.dart';

enum RecordStatus { idle, recording, pause, stop }

class SpeakingSkillPage extends StatefulWidget {
  String type;
  List<QuestionTestInputDto> data;
  int idImport;
  bool isLast;
  SpeakingSkillPage({this.type, this.data, this.idImport, this.isLast});

  @override
  State<StatefulWidget> createState() => SpeakingSkillPageState(
      type: this.type,
      data: this.data,
      idImport: this.idImport,
      isLast: this.isLast);
}

class SpeakingSkillPageState extends State<SpeakingSkillPage> {
  String type;
  List<QuestionTestInputDto> data;
  bool isLast;
  SpeakingSkillPageState({this.type, this.data, this.idImport, this.isLast});

  RecordStatus status = RecordStatus.idle;

  final String skill = "speaking";
  int idImport;

  int current;
  QuestionTestInputDto currentQs;
  AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();

    setState(() {
      audioPlayer = AudioPlayer();
      data.forEach((element) {
        if (element.answerSubmit == null) {
          element.answerSubmit = AnswerQuestion(id: element.id, answers: "");
        }
      });
      current = 0;
      currentQs = data[0];
    });
    getPath();
  }

  void submitQs() async {
    List<AnswerQuestion> ans = [];
    // data.forEach((element) {
    //   element.groupQuestion.forEach((c) {
    //     if (c.answer != null && c.answer.answers != "") {
    //       ans.add(c.answer);
    //     }
    //   });
    // });

    List<AnswerSubmit> answers = [];
    ans.forEach((element) {
      var a = AnswerSubmit(id: element.id);
      if (element.type == GroupQuestionType.YES_NO_NOTGIVEN ||
          element.type == GroupQuestionType.TRUE_FALSE_NOTGIVEN) {
        a.answers = element.answers;
      } else if (element.type == GroupQuestionType.TABLE ||
          element.type == GroupQuestionType.TEXT) {
        if (element.answerType == AnswerType.MULTIPLE_CHOICE) {
          a.answers = List<String>.empty(growable: true);
          a.answers.add(element.answers);
        } else {
          a.answers = element.answers;
          a.type = "text";
        }
      } else if (element.type == GroupQuestionType.SELECT_MULTIPLE) {
        a.answers = List<String>.empty(growable: true);
        a.answers.addAll(element.answers);
      } else {
        a.answers = List<String>.empty(growable: true);
        a.answers.add(element.answers);
      }
      answers.add(a);
    });
    answers.add(AnswerSubmit(id: data.first.idQuestionImport,answers: ""));

    // var result =
    // await testHelper.submitQuestion(type, skill, answers, idImport, isLast);
    // if (result) {
    //  Get.back(result: true);
    // }
  }

  navigationBack() {
    Navigator.of(context).pop(isLast);
  }

  disableFocus() {
    SystemChannels.textInput.invokeListMethod("TextInput.hide");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  GestureDetector(
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
            Positioned(  top: 0,
              right: 0,
              left: 0,
              bottom: 0,
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
                                      MaterialStateProperty.resolveWith<Color>(
                                              (Set<MaterialState> states) {
                                            if (states.contains(MaterialState.pressed))
                                              return Colors.blue;
                                            return null;
                                          }),
                                    ),
                                    onPressed: () => showDialogAsync(),
                                    child: Text(
                                      AppLocalizations.of(context).lbl_review_question,
                                      style: TextStyle(
                                          color: Theme.of(context).colorScheme.primary),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                child: Container(
                                  width: 100,
                                  margin: EdgeInsets.fromLTRB(4, 8, 4, 8),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(offset: Offset(1, 1), blurRadius: 1)
                                      ]),
                                  child: Center(
                                    child:
                                    Text(AppLocalizations.of(context).lbl_submit),
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
                  Container(child: Text(currentQs.content,style: TextStyle(fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400),),margin: EdgeInsets.fromLTRB(16, 0, 16, 0),),
                  Expanded(child:  Center(child: content(context, currentQs)),),
                  Row(
                    children: [
                      Expanded(
                          child: Visibility(
                            visible: current == 0 ? false : true,
                            child: GestureDetector(
                                onTap: () => prevQuestion(context),
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
                                onTap: () => nextQuestion(context),
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
              ),
            ),
          ],
        ),
      )
    );
  }

  List<String> img;

  content(context, QuestionTestInputDto qs) {
    return Container(
      height: 56,
      width: 56,
      child:  recorder(),
    );
  }

  nextQuestion(context) {
    setState(() {
      if (current < data.length - 1) {
        data[current] = currentQs;
        current++;
        currentQs = data[current];
      }
    });
  }

  prevQuestion(context) {
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
    var tests =
    groupBy(data, (object) => object.groupQuestion).values.toList();
    List<GroupQuestionTest> list =
    tests.map((e) => GroupQuestionTest(groupQuestion: e)).toList();

    var result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return TestInputQuestionDialog(
              itemHeight: itemHeight,
              itemWidth: itemWidth,
              qs: list,
              current: current,
              type: type);
        });
    setState(() {
      current = result != null ? result : current;
    });
  }

  String path;

  Future<String> getPath() async {
    if (path == null) {
      final dir = await getExternalStorageDirectory();
      path = dir.path +
          '/' +
          DateTime.now().millisecondsSinceEpoch.toString() +
          '.mp4';
    }
    return path;
  }

  recorder() {
    return AudioRecorder(
      path: path,
      onStop: () {},
    );
  }

  record() async {
    switch (status) {
      case RecordStatus.idle:
        status = RecordStatus.recording;
        return;
      case RecordStatus.recording:
        status = RecordStatus.recording;
        return;
      case RecordStatus.pause:
        return;
      case RecordStatus.stop:
        return;
      default:
        return;
    }
  }

  playRecord() async {
    var result = await audioPlayer.setUrl(path, isLocal: true);
    if (result == 1) {
      try {
        await audioPlayer.play(path, isLocal: true);
      } catch (e) {
        print(e);
      }
    }
  }
}

