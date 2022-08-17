import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gstudent/api/dtos/Training/vocab/result_vocab.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/main.dart';
import 'package:gstudent/result/views/result_vocab.dart';
import 'package:gstudent/training/cubit/vocab_cubit.dart';
import 'package:gstudent/training/services/vocab_services.dart';
import 'package:gstudent/training/views/model/VocabNavigationParams.dart';
import 'package:gstudent/training/views/vocab/first.dart';
import 'package:gstudent/training/views/vocab/second.dart';
import 'package:gstudent/training/views/vocab/third.dart';

import '../../../api/dtos/Training/vocab/vocab.dart';

class VocabularyPracticeView extends StatefulWidget {
  int classroomId;
  int lesson;
  int userClanId;

  VocabularyPracticeView({this.lesson, this.classroomId, this.userClanId});

  @override
  State<StatefulWidget> createState() => VocabularyPracticeViewState(lesson: this.lesson, classroomId: this.classroomId, userClanId: this.userClanId);
}

class VocabularyPracticeViewState extends State<VocabularyPracticeView> {
  int classroomId;
  int lesson;
  int userClanId;

  VocabularyPracticeViewState({this.lesson, this.classroomId, this.userClanId});

  VocabCubit cubit;
  VocabData data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of<VocabCubit>(context);
    loadData();
  }

  loadData() async {
    showLoading();
    var res = await cubit.getQuestionVocab(classroomId, lesson);
    hideLoading();
    if (res != null && res.error == false) {
      setState(() {
        data = res;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
          SafeArea(
            child: Container(
              child: Column(
                children: [
                  Container(
                    height: 56,
                    child: Stack(
                      children: [
                        Positioned(
                          height: 48,
                          bottom: 0,
                          left: 8,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Image(
                              image: AssetImage('assets/images/game_button_back.png'),
                            ),
                          ),
                        ),
                        Container(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              "LUYỆN TỪ VỰNG",
                              style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'SourceSerifPro'),
                            ))
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(24, 0, 24, 0),
                    child: Image(
                      image: AssetImage('assets/images/ellipse.png'),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                      height: 56,
                      child: Center(
                          child: GestureDetector(
                        onTap: () async {
                          if (data == null || data.data.isEmpty) {
                            toast(context, 'không có bài');
                            return;
                          }
                          var service = GetIt.instance.get<VocabService>();
                          var res1 = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider.value(
                                  value: VocabCubit(services: service),
                                  child: VocabFirstChallenge(
                                    listWords: data.data,
                                    testId: data.data[0].testId,
                                    lesson: this.lesson,
                                    folderName: data.folderName,
                                    classroomId: this.classroomId,
                                    userClanId: this.userClanId,
                                  ),
                                ),
                              ));
                          if (res1 == null) {
                            return;
                          }
                          VocabNavigationParams result2 = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider.value(
                                  value: VocabCubit(services: service),
                                  child: VocabSecondChallenge(
                                    listWords: data.data,
                                    testId: data.data[0].testId,
                                    lesson: this.lesson,
                                    folderName: data.folderName,
                                    classroomId: this.classroomId,
                                    userClanId: this.userClanId,
                                  ),
                                ),
                              ));
                          if (result2 != null) {
                            ResultVocab r = await cubit.submit(classroomId, lesson, data.data[0].testId, result2.answers);
                            if (r.error == true) {
                              toast(context, r.message);
                              return;
                            } else {
                              toast(context, r.message);
                              var continueChallenge = await showDialog(
                                useSafeArea: false,
                                context: context,
                                builder: (context) => ResultTrainingVocabView(
                                  isLast: false,
                                  rewards: r.data.data,
                                  param: ParamResultVocab(result2.time, result2.totalQs, result2.answerRight),
                                ),
                              );
                              if (continueChallenge == true) {
                                VocabNavigationParams result3 = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider.value(
                                        value: VocabCubit(services: service),
                                        child: VocabThirdChallenge(
                                          listWords: data.data,
                                          testId: data.data[0].testId,
                                          lesson: this.lesson,
                                          classroomId: this.classroomId,
                                          folderName: data.folderName,
                                          userClanId: this.userClanId,
                                        ),
                                      ),
                                    ));
                                if (result3 != null) {
                                  await showDialog(
                                    context: context,
                                    builder: (context) => ResultTrainingVocabView(
                                      isLast: true,
                                      param: ParamResultVocab(result2.time, result2.totalQs, result2.answerRight),
                                    ),
                                  );
                                }
                              }
                            }
                          }
                        },
                        child: ButtonYellowSmall(
                          'Bắt đầu',
                          textColor: HexColor("#d5e7d5"),
                        ),
                      )))
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
