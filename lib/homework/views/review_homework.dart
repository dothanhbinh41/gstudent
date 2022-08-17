import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/homework/cubit/homework_cubit.dart';
import 'package:gstudent/homework/viewcomponent/FillTextAudioView.dart';
import 'package:gstudent/homework/viewcomponent/FillTextImageView.dart';
import 'package:gstudent/homework/viewcomponent/FillTextScriptView.dart';
import 'package:gstudent/homework/viewcomponent/MatchImageAudioView.dart';
import 'package:gstudent/homework/viewcomponent/MatchTextAudioView.dart';
import 'package:gstudent/homework/viewcomponent/MatchTextImageView.dart';
import 'package:gstudent/homework/viewcomponent/ViewArrangeSentences.dart';
import 'package:gstudent/homework/viewcomponent/ViewRecordAudio.dart';
import 'package:gstudent/homework/viewcomponent/ViewSingleSelection.dart';
import 'package:gstudent/homework/viewcomponent/ViewWriting.dart';
import 'package:gstudent/homework/views/homework_dialog_list_question.dart';

import '../../main.dart';

class ReviewHomeworkPage extends StatefulWidget {

  List<GroupQuestion> gqs;

  ReviewHomeworkPage({ this.gqs});

  @override
  State<StatefulWidget> createState() =>
      ReviewHomeworkPageState(    gqs:this.gqs);
}

class ReviewHomeworkPageState extends State<ReviewHomeworkPage> {

  List<GroupQuestion> gqs;

  ReviewHomeworkPageState({  this.gqs});

  int index = 0;
  int timeStart = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      if(gqs.isEmpty){
        toast(context, "Bài tập rỗng, xin vui lòng thử lại và báo cho Trung tâm hỗ trợ");
      }
    });
  }

@override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                top: true,
                left: false,
                bottom: false,
                right: false,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 60,
                                child: Row(children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      child: Image(
                                        image: AssetImage('assets/images/game_button_back.png'),
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
                                          var currentIndex = await   showDialog(context: context, builder: (context) => HomeworkDialogListQuestion(current: index,qs: gqs,),);
                                          if(currentIndex != null){
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
                                              return Colors.blue;
                                            return null;
                                          }),
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .lbl_review_question,
                                          style: TextStyle( fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                      ),
                                    ),
                                  ),

                                ]),
                              ),
                            ),
                          ],
                        ),
                         gqs != null  && gqs.isNotEmpty? Container(child: Text(gqs[index].description,style: ThemeStyles.styleNormal(font: 14),),margin: EdgeInsets
                            .fromLTRB(16, 4, 16, 4),): Container(),
                        Expanded(
                            child: SingleChildScrollView(
                              child:  gqs != null  && gqs.isNotEmpty?  content(context) : Container(),
                            )),
                        Row(
                          children: [
                            Visibility(
                              visible: index == 0? false : true,
                              child: GestureDetector(
                                  onTap: () => prevQuestion(),
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(16, 4, 8, 8),
                                    child: Image(
                                      image: AssetImage('assets/images/game_select_character_left.png'),
                                      height: 28,
                                    ),
                                  )),
                            ),
                            Expanded(
                                child:Container()),
                            Visibility(
                              visible: gqs != null && index == gqs.length-1 ? false : true,
                              child: GestureDetector(
                                  onTap: () => nextQuestion(),
                                  child:  Container(
                                    margin: EdgeInsets.fromLTRB(16, 4, 8, 8),
                                    child: Image(
                                      image: AssetImage('assets/images/game_select_character_right.png'),
                                      height: 28,
                                    ),
                                  )),
                            )
                          ],
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }

  content(BuildContext context) {
    if (gqs[index] != null) {
      switch (gqs[index].type) {
        case QuestionType.FILL_TEXT_SCRIPT:
          return FillTextScriptView(
            grQuestion: gqs[index],
            key: GlobalKey<ScaffoldState>(),
          );
        case QuestionType.MATCH_TEXT_IMAGE:
          return MatchTextImageView(
            question: gqs[index],
            key: GlobalKey<ScaffoldState>(),
          );
        case QuestionType.FILL_TEXT_AUDIO:
          return FillTextAudioView(
            grQuestions: gqs[index],
            key: GlobalKey<ScaffoldState>(),
          );
        case QuestionType.ARRANGE_SENTENCES:
          return ViewArrangeSentencesView(
            question: gqs[index],
            key: GlobalKey<ScaffoldState>(),
          );
        case QuestionType.FILL_TEXT_IMAGE:
          return FillTextImageView(
            groupQuestion: gqs[index],
            key: GlobalKey<ScaffoldState>(),
          );
        case QuestionType.SINGLE_CHOICE:
          return ViewSingleSelection(
              grQuestions: gqs[index], key: GlobalKey<ScaffoldState>());
        case QuestionType.RECORD_AUDIO:
          return ViewRecordAudioView(
              grQuestions: gqs[index], key: GlobalKey<ScaffoldState>());
        case QuestionType.MATCH_TEXT_AUDIO:
          return MatchTextAudioView(
              question: gqs[index], key: GlobalKey<ScaffoldState>());
        case QuestionType.MATCH_IMAGE_AUDIO:
          return MatchImageAudioView(
              question: gqs[index], key: GlobalKey<ScaffoldState>());
        // case QuestionType.MULTI_SELECTION:
        //   return MultiSelectionView(
        //       grQuestion: gqs[index], key: GlobalKey<ScaffoldState>());
        // case QuestionType.FILL_SCRIPT:
        //   return FillScriptView(
        //       question: gqs[index], key: GlobalKey<ScaffoldState>());
        case QuestionType.WRITING:
          return ViewWritting(
            question: gqs[index],
            key: GlobalKey<ScaffoldState>(),
          );
        default:
          return ViewSingleSelection(
              grQuestions: gqs[index], key: GlobalKey<ScaffoldState>());
      }
    }
    return Container();
  }

  nextQuestion() {
    if (index < gqs.length - 1) {
      setState(() {
        index++;
      });
    }
  }

  prevQuestion() {
    if (index > 0) {
      setState(() {
        index--;
      });
    }
  }

}
