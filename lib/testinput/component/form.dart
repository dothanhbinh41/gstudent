
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/TestInput/answer.dart';
import 'package:gstudent/api/dtos/TestInput/group_question.dart';

// ignore: must_be_immutable
class FormPage extends StatefulWidget {
  GroupQuestionTest groupQuestionTest;

  FormPage({this.groupQuestionTest, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      FormPageState(groupQuestionTest: this.groupQuestionTest);
}

class FormPageState extends State<FormPage> {
  GroupQuestionTest groupQuestionTest;

  FormPageState({this.groupQuestionTest});

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemBuilder: (context, index) => item(context, index),
        itemCount: groupQuestionTest.groupQuestion.length,
        shrinkWrap: true,
      ),
    );
  }

  item(BuildContext context, int index) {
    String content = groupQuestionTest.groupQuestion[index].content;

    return Container(
      margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: RichText(
        text: TextSpan(children: [
          for (var i = 0; i < content.split(' ').toList().length; i++)
            if (!(content.split(' ').toList()[i].contains("....") ||
                content.split(' ').toList()[i].contains("_____")))
              TextSpan(
                  text: i == 0 &&
                          groupQuestionTest
                                  .groupQuestion[index].idQuestionImport !=
                              null
                      ? groupQuestionTest.groupQuestion[index].idQuestionImport
                              .toString() +
                          ". " +
                          content.split(' ').toList()[i] +
                          " "
                      : content.split(' ').toList()[i] + " ",
                  style: TextStyle(color: Colors.black,  fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400,),
                  recognizer: TapGestureRecognizer()..onTap = () {})
            else
              WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Container(
                    width: 160,
                    child: Container(
                      margin: EdgeInsets.only(left: 8, right: 8),
                      height: 40,
                      child: TextField(
                        maxLines: 1,
                        textAlignVertical: TextAlignVertical.bottom,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8),
                            isDense: true,
                            hintText: groupQuestionTest.groupQuestion[index].answerSubmit.answers.isNotEmpty ? groupQuestionTest.groupQuestion[index].answerSubmit.answers : "................",
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary))),
                        onChanged: (text) {
                          setState(() {
                            groupQuestionTest.groupQuestion[index].answerSubmit.answers = text;
                          });
                        },
                        style: TextStyle(fontSize: 14,  fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400,),
                      ),
                      alignment: Alignment.bottomCenter,
                    ),
                  ))
        ]),
      ),
    );
  }
}
