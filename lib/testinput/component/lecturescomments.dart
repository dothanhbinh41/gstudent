
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/TestInput/answer.dart';
import 'package:gstudent/api/dtos/TestInput/group_question.dart';

// ignore: must_be_immutable
class LectureCommentPage extends StatefulWidget {
  GroupQuestionTest groupQuestionTest;

  LectureCommentPage({this.groupQuestionTest, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      LectureCommentPageState(groupQuestionTest: this.groupQuestionTest);
}

class LectureCommentPageState extends State<LectureCommentPage> {
  GroupQuestionTest groupQuestionTest;

  LectureCommentPageState({this.groupQuestionTest});

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
      try {
        element.answers =
        List<Answer>.from(jsonDecode(jsonEncode(element.answers)).map((x) => Answer.fromJson(x)));
        element.answers.forEach((e) {
          e.isSelected = false;
        });
      } catch (e) {
        print(e.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: ListView.builder(
                  itemBuilder: (context, index) => itemAnswer(index),
                  itemCount: groupQuestionTest.groupQuestion[0].answers.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics()),
              margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
            ),
            Container(
                child: ListView.builder(
                    itemBuilder: (context, index) => item(index),
                    itemCount: groupQuestionTest.groupQuestion.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics()))
          ],
          crossAxisAlignment: CrossAxisAlignment.stretch,
        ),
      ),
    );
  }

  itemAnswer(int index) {
    return Container(
      child: Text((index + 1).toString() +
          ". " +
          groupQuestionTest.groupQuestion[0].answers[index].noiDung.toString(),style: TextStyle(  fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400,),),
    );
  }

  item(int index) {
    TextEditingController textEdit = TextEditingController();
    textEdit.text = groupQuestionTest.groupQuestion[index].answer.noiDung;
    textEdit.selection =
        TextSelection.fromPosition(TextPosition(offset: textEdit.text.length));

    return Container(
      margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
      height: 40,
      child: Row(
        children: [
          Container(
            child: Text(groupQuestionTest.groupQuestion[index].content,style: TextStyle(  fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400,),),
            alignment: Alignment.centerLeft,
          ),
          Spacer(),
          Container(
            width: 40,
            height: 40,
            child: TextField(
              controller: textEdit,
              decoration: InputDecoration(
                  counterText: "",
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary),
                      borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary),
                      borderRadius: BorderRadius.circular(8))),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              style: TextStyle(  fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              onChanged: (value) {
                setState(() {
                  if (int.parse(value) != null) {
                    var indexData =
                        int.parse(value) > 0 ? int.parse(value) - 1 : 0;
                    groupQuestionTest.groupQuestion[index].answer.noiDung =
                        int.parse(value).toString();
                    Answer data = indexData <
                            groupQuestionTest.groupQuestion[0].answers.length
                        ? groupQuestionTest.groupQuestion[0].answers[indexData]
                        : null;
                    if (data != null) {
                      groupQuestionTest.groupQuestion[index].answerSubmit
                          .answers = data.noiDung;
                    }
                  }
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
