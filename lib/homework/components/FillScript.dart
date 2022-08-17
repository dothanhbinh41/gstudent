import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';

class FillScript extends StatefulWidget {
  GroupQuestion question;

  FillScript({this.question,Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() =>
      FillScriptState(question: this.question);
}

class FillScriptState extends State<FillScript> {
  GroupQuestion question;
  String content = "";

  FillScriptState({this.question});

  List<QuestionAnswer> ans = [];

  @override
  void initState() {
    super.initState();
    content = question.description;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: RichText(
        text: TextSpan(children: [
          for (var i = 0; i < content
              .split(' ')
              .toList()
              .length; i++)
            if (!content.split(' ').toList()[i].contains("..."))
              TextSpan(
                text: content.split(' ').toList()[i] + " ",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',),
              )
            else
              textfield(context, i)
        ]),
      ),
    );
  }

  textfield(context, index) {
    setState(() {
      ans.add(QuestionAnswer(position: index, content: ""));
    });
    TextEditingController textEdit = TextEditingController();
    textEdit.text = ans
        .where((element) => element.position == index)
        .isNotEmpty ? ans
        .where((element) => element.position == index)
        .first
        .content : "";
    textEdit.selection =
        TextSelection.fromPosition(TextPosition(offset: textEdit.text.length));

    return WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Container(
          width: 100,
          child: Container(
            margin: EdgeInsets.only(left: 8, right: 8),
            height: 40,
            child: TextField(
              controller: textEdit,
              maxLines: 1,
              textAlignVertical: TextAlignVertical.bottom,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  isDense: true,
                  hintText: "................",
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme
                              .of(context)
                              .colorScheme
                              .primary))),
              onChanged: (text) {
                setState(() {
                  if (ans
                      .where((element) => element.position == index)
                      .isNotEmpty)
                    ans
                        .where((element) => element.position == index)
                        .first
                        .content = text;
                });
                question.questions[0].answers = ans;
              },
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',),
            ),
            alignment: Alignment.bottomCenter,
          ),
        ));
  }
}
