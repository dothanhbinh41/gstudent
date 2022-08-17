import 'dart:convert';

import 'package:gstudent/api/dtos/TestInput/answer.dart';
import 'package:gstudent/api/dtos/TestInput/group_question.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/styles/theme_text.dart';

// ignore: must_be_immutable

class SingleChoicePage extends StatefulWidget {
  GroupQuestionTest groupQuestionTest;

  SingleChoicePage({this.groupQuestionTest, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      SingleChoicePageState(groupQuestionTest: this.groupQuestionTest);
}

class SingleChoicePageState extends State<SingleChoicePage> {
  GroupQuestionTest groupQuestionTest;

  SingleChoicePageState({this.groupQuestionTest});

  @override
  void initState() {
    super.initState();
    groupQuestionTest.groupQuestion.forEach((element) {
      if (element.answerSubmit == null) {
        element.answerSubmit = AnswerQuestion(
            id: element.id,
            answers: "",
            type: element.groupQuestionType,
            answerType: element.answerType);
      }

      if (element.answer == null) {
        element.answer = Answer(noiDung: "");
      }
      // try {
      //   List<Answer> l = List<Answer>.from(element.answers.map((x) {
      //     return Answer.fromJson(x);
      //   }));
      //   element.answers = l;
      // } catch (e) {
      //   print(e.toString());
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
     Column(children: [
       Container(
         margin: EdgeInsets.fromLTRB(16, 8, 16, 0),
         child: Text(groupQuestionTest.groupQuestion[0].groupQuestionMediaContent, style: ThemeStyles.styleNormal(font: 14),),
       ),
       ListView.builder(
         itemBuilder: (context, index) => item(context, index),
         itemCount: groupQuestionTest.groupQuestion.length,
         shrinkWrap: true,
         physics: NeverScrollableScrollPhysics(),
       ),
     ],)
    );
  }

  item(BuildContext context, int index) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color:  HexColor("#9c7f6a"),
          borderRadius: BorderRadius.circular(4)
      ),
      height:
      40 + (groupQuestionTest.groupQuestion[index].answers.length * 60.0),
      margin: EdgeInsets.fromLTRB(16, 2, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(child:  Text(groupQuestionTest.groupQuestion[index].content.isNotEmpty ? groupQuestionTest.groupQuestion[index].idQuestionImport
              .toString() +
              ". "+groupQuestionTest.groupQuestion[index].content : groupQuestionTest.groupQuestion[index].idQuestionImport
              .toString() +
              ". "),),
          Expanded(
              child: ListView.builder(
                itemBuilder: (context, indexSelect) {
                  return RadioListTile(
                    activeColor: Color(0xFF6200EE),
                    title: Text(groupQuestionTest
                        .groupQuestion[index].answers[indexSelect].noiDung
                        .toString()),
                    groupValue: groupQuestionTest.groupQuestion[index].answer,
                    value:
                    groupQuestionTest.groupQuestion[index].answers[indexSelect],
                    onChanged: (value) {
                      setState(() {
                        groupQuestionTest.groupQuestion[index].answer = value;
                        groupQuestionTest.groupQuestion[index].answerSubmit
                            .answers = value.noiDung.toString();
                      });
                    },
                  );
                },
                itemCount: groupQuestionTest.groupQuestion[index].answers.length,
                physics: NeverScrollableScrollPhysics(),
              ))
        ],
      ),
    );
  }
}
