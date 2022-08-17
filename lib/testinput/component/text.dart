
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/TestInput/answer.dart';
import 'package:gstudent/api/dtos/TestInput/group_question.dart';

// ignore: must_be_immutable
class TextPage extends StatefulWidget {
  GroupQuestionTest groupQuestionTest;

  TextPage({this.groupQuestionTest, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      TextPageState(groupQuestionTest: this.groupQuestionTest);
}

class TextPageState extends State<TextPage> {
  GroupQuestionTest groupQuestionTest;

  TextPageState({this.groupQuestionTest});

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
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
              child:
                  Text(groupQuestionTest.groupQuestion[0].sectionMediaContent,style: TextStyle(fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro'),)),
          Container(
              margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: Text(groupQuestionTest.groupQuestion[0].groupQuestion,style: TextStyle(fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro'),)),
          Container(
              margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(4),
              child: Text(groupQuestionTest
                  .groupQuestion[0].groupQuestionMediaContent,style: TextStyle(fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro'),)),
          Container(
            margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: ListView.builder(
              itemBuilder: (context, index) => itemList(index),
              itemCount: groupQuestionTest.groupQuestion.length,
              shrinkWrap: true,
            ),
          )
        ],
      ),
    );
  }

  itemList(int index) {
    String content = groupQuestionTest.groupQuestion[index].content;
    // TextEditingController textEdit = TextEditingController();
    // textEdit.text = groupQuestionTest.groupQuestion[index].answerSubmit.answers;
    // textEdit.selection =
    //     TextSelection.fromPosition(TextPosition(offset: textEdit.text.length));
    return Container(
      child: RichText(
        text: TextSpan(children: [
          for (var i = 0; i < content.split(' ').toList().length; i++)
            if (!content.split(' ').toList()[i].contains("...."))
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
                style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro'),
              )
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
                            hintText:  groupQuestionTest.groupQuestion[index].answerSubmit.answers.isNotEmpty ?  groupQuestionTest.groupQuestion[index].answerSubmit.answers : "................",
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
                        style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro'),
                      ),
                      alignment: Alignment.bottomCenter,
                    ),
                  ))
        ]),
      ),
    );
  }
}
