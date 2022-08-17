import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/dialog_zoom_image.dart';
import 'package:gstudent/homework/components/PlayAudioView.dart';

// ignore: must_be_immutable
class SingleChoice extends StatefulWidget {
  GroupQuestion grQuestions;

  SingleChoice({this.grQuestions, Key key}) : super(key: key);

  @override
  SingleChoiceState createState() {
    return new SingleChoiceState(grQuestions: this.grQuestions);
  }
}

class SingleChoiceState extends State<SingleChoice> {
  GroupQuestion grQuestions;
  List<Question> questions;

  SingleChoiceState({this.grQuestions});

  List<String> listAnswers;
  Question currentQs;
  int timeStart = 0;

  @override
  void initState() {
    super.initState();
    listAnswers = [];
    setState(() {
      timeStart = DateTime.now().millisecondsSinceEpoch;
      if(grQuestions.questions != null && grQuestions.questions.isNotEmpty){
        currentQs = grQuestions.questions[0];
        questions = grQuestions.questions;
        for (var i = 0; i < grQuestions.questions[0].answers.length; i++) {
          listAnswers.add(grQuestions.questions[0].answers[i].content);
        }
        for (var i = 0; i < grQuestions.questions.length; i++) {
          if (grQuestions.questions[i].answer == null) {
            grQuestions.questions[i].answer =
                QuestionAnswer(content: "", questionId: grQuestions.questions[i].id);
          }
        }
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (grQuestions.audio.isNotEmpty)
        PlayAudioView(
          url: grQuestions.audio,
        ),
      grQuestions.image.isNotEmpty
          ? GestureDetector(
        onTap: () {
          showDialog(context: context, builder: (context) => ShowImageDialog(file: grQuestions.image,),);
        },
            child: Container(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Image.network(grQuestions.image),
              ),
          )
          : Container(),
      questions!= null && questions.isNotEmpty ?  Container(
        margin: EdgeInsets.only(left: 8, right: 8),
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: questions.length,
            itemBuilder: (context, index) => listItem(questions[index])),
      ) : Container()
    ]);
  }

  listItem(Question question) => Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Card(
            color: HexColor("#9c7f6a"),
              margin: EdgeInsets.only(top: 24, bottom: 24, right: 8, left: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Container(

                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          question.image != null &&  question.image.isNotEmpty
                              ? Container(
                                  child: Image.network(question.image),
                                )
                              : Container(),
                          Text(
                            question.title != null ? question.title : "",
                            style: TextStyle(
                                color: HexColor("#a12525"),
                                fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',
                                fontSize: 14),
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4)),
                          boxShadow: [],
                          shape: BoxShape.rectangle,
                          color: HexColor(
                              "#9c7f6a")),
                    ),
                  ),
                  for (var a in question.answers)
                    RadioListTile(
                        activeColor: Colors.white,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        value: a.content ,
                        title: Text(
                          a.content != null ? a.content : "",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro', color: Colors.white),
                        ),
                        groupValue: question.answer.content ,
                        onChanged: (value) => setState(() {
                              question.answer.content = value;
                              question.answer.timeAnswer = DateTime.now().millisecondsSinceEpoch - timeStart;
                            })),
                ],
              )),
          if (question.audio.isNotEmpty)
            Positioned(
              bottom: 0,
              right: 40,
              child: PlayAudioView(
                url: question.audio,
              ),
            )
        ],
      );
}
