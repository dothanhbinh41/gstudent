import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';
import 'package:gstudent/api/dtos/homework/submit_response.dart';
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
import 'package:gstudent/settings/views/notification_dialog.dart';

class HomeworkPage extends StatefulWidget {
  int lesson;
  int classroomId;
  bool isAdvance;

  HomeworkPage(
      {this.lesson, this.classroomId, this.isAdvance = false});

  @override
  State<StatefulWidget> createState() => HomeworkPageState(
      classroomId: this.classroomId,
      lesson: this.lesson,
      isAdvance: this.isAdvance);
}

class HomeworkPageState extends State<HomeworkPage> {
  int lesson;
  int classroomId;
  bool isAdvance;

  HomeworkPageState(
      {this.lesson, this.classroomId, this.isAdvance});
  HomeworkCubit cubit;
  List<GroupQuestion> gqs;
  int index = 0;
  int timeStart = 0;
  int oldTime;
  int avgTime = 0;
  int currentTime = 0;
  List<int> testGroupId;
  final ScrollController _scrollController = ScrollController();
  bool isShowScript = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of<HomeworkCubit>(context);
    loadData();
  }

  void loadData() async {
    if (isAdvance) {
      var res = await cubit.getHomeworkAdvance(classroomId, lesson);
      if (res == null) {
        Navigator.of(context).pop();
        toast(context, 'Có lỗi xảy ra. xin vui lòng báo cho trung tâm');
        return;
      }
      if (res != null && res.error == true) {
        toast(context, res.message);
        Navigator.of(context).pop();
        return;
      } else {
        setState(() {
          gqs = res.data.question;
          testGroupId = res.data.testGroupId;
          timeStart = DateTime.now().millisecondsSinceEpoch;
        });
      }
    } else {

      var res = await cubit.getHomework(classroomId, lesson,
          type: "homework");
      var oldData = await cubit.getQuestionTodo(classroomId, lesson, false);
      if (res == null) {
        Navigator.of(context).pop();
        toast(context, 'Có lỗi xảy ra. xin vui lòng báo cho trung tâm');
        return;
      }
      if (res != null && res.error == true) {
        toast(context, res.message);
        Navigator.of(context).pop();
        return;
      } else {
        bool isNewData = false;
        if(oldData != null && res.data.length == oldData.data.length){
         for(var i = 0 ; i < res.data.length ; i++){
           if(res.data[i].type != oldData.data[i].type){
             isNewData = true;
             break;
           }
         }
         if(isNewData){
           setState(() {
             gqs = res.data;
             timeStart = DateTime.now().millisecondsSinceEpoch;
           });
         }else{
           setState(() {
             gqs = oldData.data;
             oldTime = oldData.time;
             timeStart = DateTime.now().millisecondsSinceEpoch;
           });
         }
        }else{
          setState(() {
            gqs = res.data;
            timeStart = DateTime.now().millisecondsSinceEpoch;
          });
        }
        }

    }
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
                              child: Container(
                                height: 52,
                                child: Row(children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      child: Image(
                                        image: AssetImage(
                                            'assets/images/game_button_back.png'),
                                        height: 48,
                                        width: 48,
                                      ),
                                      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      width: 160,
                                      child: TextButton(
                                        onPressed: () async {
                                          if(gqs == null || gqs.isEmpty){
                                            return;
                                          }
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
                                          overlayColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                                  (Set<MaterialState> states) {
                                            if (states.contains(
                                                MaterialState.pressed))
                                              return Colors.blue;
                                            return null;
                                          }),
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .lbl_review_question,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'SourceSerifPro',
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => submitQuestion(),
                                    child: Container(
                                      width: 80,
                                      margin: EdgeInsets.fromLTRB(4, 8, 4, 8),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                                offset: Offset(1, 1),
                                                blurRadius: 1)
                                          ]),
                                      child: Center(
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .lbl_submit,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'SourceSerifPro',
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ]),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                            child: GestureDetector(
                              onTap: () => disableFocus() ,
                              child: ListView(
                          controller: _scrollController,
                          children: [
                              gqs != null && gqs[index].description != null
                                  ? Container(
                                      child: Text(
                                        gqs[index].description,
                                        style: ThemeStyles.styleNormal(font: 14),
                                      ),
                                      margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
                                    )
                                  : Container(),
                              gqs != null && gqs[index].script != null
                                  ? Container(
                                      child: Text(
                                        gqs[index].script,
                                        style: ThemeStyles.styleNormal(font: 14),
                                      ),
                                      margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
                                    )
                                  : Container(),
                              gqs != null ? content(context) : Container(),
                          ],
                        ),
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
                                    height: 16,
                                  ),
                                ),
                                height: 24,
                                width: 24,
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            )
                          : Container(),
                      top: 60,
                      right: 8,
                    )
                  ],
                )),
              ),
            ),
          ],
        ));
  }

  disableFocus() {
    SystemChannels.textInput.invokeListMethod("TextInput.hide");
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
      await cubit.saveQuestionTodo(gqs, classroomId, lesson, false, DateTime.now().microsecondsSinceEpoch - timeStart);
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
      await cubit.saveQuestionTodo(gqs, classroomId, lesson, false, DateTime.now().microsecondsSinceEpoch - timeStart);
    }
  }

  submitQuestion() async {
    var time = DateTime.now().millisecondsSinceEpoch - timeStart;
    if(isAdvance == false &&  oldTime != null){
      time =   oldTime + time;
    }
    int length = 0;
    List<QuestionAnswer> qs = [];
    gqs.forEach((e) {
      length += e.questions.length;
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
      if(qs.length < length){
        showDialog(context: context, builder: (context) => NotificationDialogView(message: "Bạn chưa làm xong hết bài tập. Hãy làm hết bài tập rồi nộp bài!",));
        return;
      }
    }
    showLoading();

    // if (qs.isEmpty) {
    //   toast(context, 'Bạn chưa làm bài nào cả');
    //   hideLoading();
    //   return;
    // }
    var avgTime = 0;
    qs.forEach((element) {
      avgTime = avgTime + element.timeAnswer;
    });
    avgTime = (avgTime / qs.length).toInt();
    if (isAdvance) {
      var result = await cubit.submitHomeworkAdvance(
          classroomId, lesson, testGroupId, qs);
      hideLoading();
      if (result.error == false) {
        if (result.data != null) {
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
    } else {
      var result = await cubit.submitHomework(
          classroomId, lesson, gqs[0].testId,"homework", qs);
      hideLoading();
      if (result.error == false) {
        if (result.data != null) {
         await cubit.deleteQuestionTodo( classroomId, lesson, false);
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
}
