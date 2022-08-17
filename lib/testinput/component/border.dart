import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/TestInput/answer.dart';
import 'package:gstudent/api/dtos/TestInput/group_question.dart';
import 'package:gstudent/common/colors/HexColor.dart';

// ignore: must_be_immutable
class BorderPage extends StatefulWidget {
  GroupQuestionTest groupQuestionTest;

  BorderPage({this.groupQuestionTest, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      BorderPageState(groupQuestionTest: this.groupQuestionTest);
}

class BorderPageState extends State<BorderPage> {
  GroupQuestionTest groupQuestionTest;

  BorderPageState({this.groupQuestionTest, Key key});

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
      //     print(x);
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
      child: ListView.builder(
        itemBuilder: (context, index) => item(context, index),
        itemCount: groupQuestionTest.groupQuestion.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }

  item(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
      decoration: BoxDecoration(
        color:  HexColor("#9c7f6a"),
        borderRadius: BorderRadius.circular(4)
      ),
      child: Column(
        children: [
          groupQuestionTest.groupQuestion[index].questionMediaContent != null && groupQuestionTest.groupQuestion[index].questionMediaContent != "" ?  Container(
            child: Image.network(groupQuestionTest.groupQuestion[index].questionMediaContent),
            height: 120,
          ) : Container(),
          Container(
            height: 40 +
                (groupQuestionTest.groupQuestion[index].answers.length * 60.0),
            margin: EdgeInsets.fromLTRB(16, 2, 16, 2),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(groupQuestionTest.groupQuestion[index].idQuestionImport
                        .toString() +
                        ". "),
                    Expanded(
                      child: Container(
                        child: Text(
                            groupQuestionTest.groupQuestion[index].content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, indexSelect) {
                        return RadioListTile(
                          activeColor: Color(0xFF6200EE),
                          title: Text(groupQuestionTest
                              .groupQuestion[index].answers[indexSelect].noiDung
                              .toString()),
                          groupValue: groupQuestionTest.groupQuestion[index].answer,
                          value: groupQuestionTest
                              .groupQuestion[index].answers[indexSelect],
                          onChanged: (value) {
                            setState(() {
                              groupQuestionTest.groupQuestion[index].answer = value;
                              groupQuestionTest.groupQuestion[index].answerSubmit
                                  .answers = value.noiDung.toString();
                            });
                          },
                        );
                      },
                      itemCount:
                      groupQuestionTest.groupQuestion[index].answers.length,
                      physics: NeverScrollableScrollPhysics(),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
