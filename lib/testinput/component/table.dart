import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/TestInput/answer.dart';
import 'package:gstudent/api/dtos/TestInput/group_question.dart';

// ignore: must_be_immutable
class TablePage extends StatefulWidget {
  GroupQuestionTest groupQuestionTest;

  TablePage({this.groupQuestionTest, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      TablePageState(groupQuestionTest: this.groupQuestionTest);
}

class TablePageState extends State<TablePage> {
  GroupQuestionTest groupQuestionTest;

  TablePageState({this.groupQuestionTest});

  dynamic data = [];

  @override
  void initState() {
    super.initState();
    groupQuestionTest.groupQuestion.forEach((element) {
      if (element.idQuestionImport != null && element.answerSubmit == null) {
        element.answerSubmit = AnswerQuestion(
            id: element.id,
            answers: "",
            type: element.groupQuestionType,
            answerType: element.answerType);
      }
      data.add(element);
    });

    data = groupBy(groupQuestionTest.groupQuestion, (obj) => obj.rowTable);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: Text(groupQuestionTest.groupQuestion[0].sectionMediaContent),
            margin: EdgeInsets.fromLTRB(16, 0, 16, 4),
          ),
          ListView.builder(
            itemBuilder: (context, index) => item(index),
            itemCount: data.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
          )
        ],
      ),
    );
  }

  item(int index) {
    return Container(
      height: index == 0 || index == 1 ? 60 : 240,
      child: Row(
        children: [
          for (var i = 0;
              i <
                  (data[index].length > 3
                      ? data[index].length - 1
                      : data[index].length);
              i++)
            if (!data[index][i].content.contains('......'))
              i == 0
                  ? Container(
                      child: Text(
                        data[index][i].content.toString(),
                        style: TextStyle(
                            fontWeight: index == 0
                                ? FontWeight.bold
                                : FontWeight.w400,  fontFamily: 'SourceSerifPro',),
                      ),
                      width: 80,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: index == 0
                                  ? Colors.transparent
                                  : Colors.black)),
                    )
                  : Expanded(
                      child: Container(
                      child: Text(data[index][i].content.toString(),
                          style: TextStyle(
                              fontWeight: index == 0
                                  ? FontWeight.bold
                                  :  FontWeight.w400,  fontFamily: 'SourceSerifPro',)),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: index == 0
                                  ? Colors.transparent
                                  : Colors.black)),
                      padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                    ))
            else
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: RichText(
                    text: TextSpan(children: [
                      if (data[index][i].content.split(' ').toList().length ==
                          1)
                        WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Container(
                              child: Container(
                                height: 40,
                                child: entryItem(index, i),
                                alignment: Alignment.bottomCenter,
                              ),
                            ))
                      else if (data[index][i]
                              .content
                              .split(' ')
                              .toList()
                              .length >
                          1)
                        for (var j = 0;
                            j <
                                data[index][i]
                                    .content
                                    .split(' ')
                                    .toList()
                                    .length;
                            j++)
                          if (!data[index][i]
                              .content
                              .split(' ')
                              .toList()[j]
                              .contains("...."))
                            TextSpan(
                              text: data[index][i]
                                      .content
                                      .split(' ')
                                      .toList()[j] +
                                  " ",
                              style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',),
                            )
                          else
                            WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Container(
                                  child: Container(
                                    height: 42,
                                    width: 100,
                                    child: textfieldItem(index, i, j),
                                    alignment: Alignment.bottomCenter,
                                  ),
                                ))
                    ]),
                  ),
                ),
              )
        ],
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ),
    );
  }

  bool check(index, i, j) {
    var a = data[index][i]
            .content
            .split(' ')
            .toList()
            .where((String c) => c.contains("..................."))
            .toList() !=
        null;
    var b = data[index][i]
            .content
            .split(' ')
            .toList()
            .where((String c) => c.contains("...."))
            .toList()
            .length >
        1;
    var lastitem = data[index][i]
        .content
        .split(' ')
        .toList()
        .where((String element) => element.contains('...................'))
        .toList()
        .first;
    var d = j > data[index][i].content.split(' ').toList().indexOf(lastitem);

    return (a == true && b == true && d == true);
  }

  // TextEditingController setTextEdit(TextEditingController textEdit, first) {
  //   textEdit.text = first.answerSubmit.answers;
  //   textEdit.selection =
  //       TextSelection.fromPosition(TextPosition(offset: textEdit.text.length));
  //   return textEdit;
  // }

  entryItem(int index, int i) {
    // TextEditingController textEdit = TextEditingController();
    // textEdit.text = (groupQuestionTest.groupQuestion
    //         .where((c) => c.idQuestionImport == data[index][i].idQuestionImport)
    //         .first)
    //     .answerSubmit
    //     .answers;
    // textEdit.selection =
    //     TextSelection.fromPosition(TextPosition(offset: textEdit.text.length));

    return TextField(
      maxLines: 1,
      textAlignVertical: TextAlignVertical.bottom,
      decoration: InputDecoration(
          hintText:
          groupQuestionTest.groupQuestion.where((c) => c.idQuestionImport == data[index][i].idQuestionImport).first.answerSubmit.answers.isNotEmpty ? groupQuestionTest.groupQuestion.where((c) => c.idQuestionImport == data[index][i].idQuestionImport).first.answerSubmit.answers :  data[index][i].idQuestionImport.toString() + "................",
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.primary))),
      onChanged: (text) {
        setState(() {
          var qs = groupQuestionTest.groupQuestion.where((c) => c.idQuestionImport == data[index][i].idQuestionImport).first;
          if (qs != null) {
            qs.answerSubmit.answers = text;
          }
        });
      },
      style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro'),
    );
  }

  textfieldItem(int index, int i, int j) {
    int id;
    if (check(index, i, j)) {
      id = data[index][i].idQuestionImport + 1;
    } else {
      id = data[index][i].idQuestionImport;
    }
    // TextEditingController textEdit = TextEditingController();
    // textEdit.text = groupQuestionTest.groupQuestion
    //         .where((c) => c.idQuestionImport == id)
    //         .first
    //     .answerSubmit
    //     .answers;
    // textEdit.selection =
    //     TextSelection.fromPosition(TextPosition(offset: textEdit.text.length));
    // groupQuestionTest.groupQuestion.where((c) => c.idQuestionImport == id).first.answerSubmit

    return TextField(
      maxLines: 1,
      textAlignVertical: TextAlignVertical.bottom,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(8),
          isDense: true,
          hintText:
          check(index, i, j)
              ?( groupQuestionTest.groupQuestion.where((c) => c.idQuestionImport == data[index][i].idQuestionImport + 1).first.answerSubmit.answers.isNotEmpty ?(data[index][i].idQuestionImport + 1).toString() +'. '+ groupQuestionTest.groupQuestion.where((c) => c.idQuestionImport == data[index][i].idQuestionImport + 1).first.answerSubmit.answers : (data[index][i].idQuestionImport + 1).toString() + "...................")
              :  ( groupQuestionTest.groupQuestion.where((c) => c.idQuestionImport == data[index][i].idQuestionImport).first.answerSubmit.answers.isNotEmpty ? data[index][i].idQuestionImport.toString() +'. '+ groupQuestionTest.groupQuestion.where((c) => c.idQuestionImport == data[index][i].idQuestionImport).first.answerSubmit.answers : data[index][i].idQuestionImport.toString() + "..................."),
          hintStyle: TextStyle(fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro'),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.primary))),
      onChanged: (text) {
        setState(() {
          int id;
          if (check(index, i, j)) {
            id = data[index][i].idQuestionImport + 1;
          } else {
            id = data[index][i].idQuestionImport;
          }
          var qs = groupQuestionTest.groupQuestion
              .where((c) => c.idQuestionImport == id)
              .first;
          if (qs != null) {
            qs.answerSubmit.answers = text;
          }
        });
      },
      style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro'),
    );
  }
}
