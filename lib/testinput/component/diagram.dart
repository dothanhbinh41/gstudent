
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/TestInput/answer.dart';
import 'package:gstudent/api/dtos/TestInput/group_question.dart';

// ignore: must_be_immutable
class DiagramPage extends StatefulWidget {
  GroupQuestionTest groupQuestionTest;

  DiagramPage({this.groupQuestionTest, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      DiagramPageState(groupQuestionTest: this.groupQuestionTest);
}

class DiagramPageState extends State<DiagramPage> {
  GroupQuestionTest groupQuestionTest;

  DiagramPageState({this.groupQuestionTest});

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
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: ListView.builder(
                itemBuilder: (context, index) => item(index),
                itemCount: groupQuestionTest.groupQuestion.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              ),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.stretch,
        ),
      ),
    );
  }

  item(index) {
    TextEditingController textEdit = TextEditingController();
    textEdit.text = groupQuestionTest.groupQuestion[index].answerSubmit.answers;
    // textEdit.selection =
    //     TextSelection.fromPosition(TextPosition(offset: textEdit.text.length));

    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
          padding: EdgeInsets.fromLTRB(4, 8, 4, 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black54)),
          child: RichText(
            text: TextSpan(children: [
              for (var i = 0;
                  i <
                      groupQuestionTest.groupQuestion[index].content
                          .split(' ')
                          .toList()
                          .length;
                  i++)
                if (!groupQuestionTest.groupQuestion[index].content
                    .split(' ')
                    .toList()[i]
                    .contains("...."))
                  TextSpan(
                      text: i == 0 &&
                              groupQuestionTest
                                      .groupQuestion[index].idQuestionImport !=
                                  null
                          ? groupQuestionTest
                                  .groupQuestion[index].idQuestionImport
                                  .toString() +
                              ". " +
                              groupQuestionTest.groupQuestion[index].content
                                  .split(' ')
                                  .toList()[i] +
                              " "
                          : groupQuestionTest.groupQuestion[index].content
                                  .split(' ')
                                  .toList()[i] +
                              " ",
                      style: TextStyle(color: Colors.black,  fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400,),
                      recognizer: TapGestureRecognizer()..onTap = () {})
                else
                  WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Container(
                        width: 80,
                        child: Container(
                          margin: EdgeInsets.only(left: 4, right: 4),
                          height: 32,
                          child: TextField(
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8),
                              isDense: true,
                              hintText:groupQuestionTest.groupQuestion[index].answerSubmit.answers.isNotEmpty ? groupQuestionTest.groupQuestion[index].answerSubmit.answers :"................",
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  borderRadius: BorderRadius.circular(8)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onChanged: (text) {
                              setState(() {
                                groupQuestionTest.groupQuestion[index]
                                    .answerSubmit.answers = text;
                              });
                            },
                            style: TextStyle(fontSize: 14,  fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400,),
                          ),
                          alignment: Alignment.bottomCenter,
                        ),
                      ))
            ]),
          ),
        ),
        Visibility(
          child: Icon(Icons.arrow_downward,size: 24,),
          visible: !(index == groupQuestionTest.groupQuestion.length - 1),
        )
      ],
      crossAxisAlignment: CrossAxisAlignment.stretch,
    );
  }
}
