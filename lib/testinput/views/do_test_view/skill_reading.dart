
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gstudent/api/dtos/TestInput/answer.dart';
import 'package:gstudent/api/dtos/TestInput/answer_submit.dart';
import 'package:gstudent/api/dtos/TestInput/enum.dart';
import 'package:gstudent/api/dtos/TestInput/group_question.dart';
import 'package:gstudent/api/dtos/TestInput/ielts.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/testinput/component/completesummary.dart';
import 'package:gstudent/testinput/component/multiselection.dart';
import 'package:gstudent/testinput/component/singlechoice.dart';
import 'package:gstudent/testinput/component/table.dart';
import 'package:gstudent/testinput/component/text.dart';
import 'package:gstudent/testinput/component/truefalsenotgiven.dart';
import 'package:gstudent/testinput/cubit/testinput_cubit.dart';
import 'package:gstudent/testinput/views/do_test_view/list_question_dialog.dart';

class ReadingSkillPage extends StatefulWidget {
  String type;
  List<GroupQuestionTest> data;
  int idImport;
  int idStudent;
  bool isLast;
  ReadingSkillPage({this.type, this.data, this.idImport, this.isLast,this.idStudent});

  @override
  State<StatefulWidget> createState() => ReadingSkillPageState(
      type: this.type,
      data: this.data,
      idImport: this.idImport,
      idStudent: this.idStudent,
      isLast: this.isLast);
}

class ReadingSkillPageState extends State<ReadingSkillPage> {
  String type;
  List<GroupQuestionTest> data;
  bool isLast;
  ReadingSkillPageState({this.type, this.data, this.idImport, this.isLast,this.idStudent});

  final String skill = "reading";
  int idImport;
  int idStudent;
  final getIt = GetIt.instance;
  int current;
  GroupQuestionTest currentQs;
  TestInputCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of(context);
    setState(() {
      current = 0;
      currentQs = data[current];
    });
  }

  void submitQs() async {
    List<QuestionTestInputDto> listSave = [];
    data.forEach((element) {
      listSave.addAll(element.groupQuestion.where((e) => (e.answerSubmit != null && e.answerSubmit.answers.isNotEmpty) || e.answersSubmit != null && e.answersSubmit.isNotEmpty));
    });

    var res = await   cubit.saveTestInput(skill, listSave, idStudent);
    if(res){
      Navigator.of(context).pop(res);
    }
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
      body:
      GestureDetector(
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
              child:    Container(
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
                                        style: TextStyle(  fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400,
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
                                      Text("Lưu kết quả",style: TextStyle(  fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400,),),
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
                                child: Text(currentQs.groupQuestion[0].section.toString()+
                                    " : " +
                                    currentQs.groupQuestion[0].groupQuestion,style: ThemeStyles.styleNormal(), ) ,
                                margin: EdgeInsets.fromLTRB(16, 0, 16, 4),
                              ),
                              content(context)
                            ],
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
                                          style: TextStyle(color: Colors.white,  fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400,),
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
                                          style: TextStyle(color: Colors.white,  fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400,),
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
            )
          ],
        ),
      )

    );
  }

  content(context) {
    switch (currentQs.groupQuestion[0].groupQuestionType) {
      case GroupQuestionType.TRUE_FALSE_NOTGIVEN:
        return TrueFalseNotGivenPage(
          groupQuestionTest: currentQs,
          key: GlobalKey<ScaffoldState>(),
        );
        break;
      case GroupQuestionType.TABLE:
        return TablePage(
          groupQuestionTest: currentQs,
          key: GlobalKey<ScaffoldState>(),
        );
        break;
      case GroupQuestionType.TEXT:
        if (currentQs.groupQuestion[0].answerType ==
            AnswerType.MULTIPLE_CHOICE) {
          return new SingleChoicePage(
            groupQuestionTest: currentQs,
            key: GlobalKey<ScaffoldState>(),
          );
        } else {
          return TextPage(
            groupQuestionTest: currentQs,
            key: GlobalKey<ScaffoldState>(),
          );
        }
        break;
      case GroupQuestionType.SELECT_MULTIPLE:
        return MultiSelectionPage(
          groupQuestionTest: currentQs,
          key: GlobalKey<ScaffoldState>(),
        );
        break;
      case GroupQuestionType.COMPLETE_SUMMARY:
        return CompleteSummaryPage(
          groupQuestionTest: currentQs,
          key: GlobalKey<ScaffoldState>(),
        );
        break;
      default:
        return TrueFalseNotGivenPage(
          groupQuestionTest: currentQs,
          key: GlobalKey<ScaffoldState>(),
        );
        break;
    // return FillTextAudio();
    }
  }

  nextQuestion() {
    setState(() {
      if (current < data.length - 1) {
        data[current] = currentQs;
        current++;
        currentQs = data[current];
      }
    });
  }

  prevQuestion() {
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
      current = result;
      currentQs = data[current];
    });
  }
}
