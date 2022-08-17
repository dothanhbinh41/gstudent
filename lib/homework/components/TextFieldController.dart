
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/styles/theme_text.dart';

class TextFieldIndexController extends StatefulWidget{
  String index;
  String answer;
  final Function(String) textChange;

  TextFieldIndexController({this.index, this.answer,this.textChange});

  @override
  State<StatefulWidget> createState()  => TextFieldIndexControllerState(index: this.index,answer: this.answer,textChange: this.textChange);

}

class TextFieldIndexControllerState extends State<TextFieldIndexController> {
  String index;
  String answer;
  final Function(String) textChange;

  TextFieldIndexControllerState({this.index, this.answer,this.textChange});

  TextEditingController textEdit = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textEdit.text = answer;
    textEdit.addListener(() {
      setState(() {
        answer = textEdit.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Container(
          decoration: BoxDecoration(
              color: HexColor("#9c7f6a"),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Color(0x60000000),
                  offset: Offset(0.0, 3.0),
                  blurRadius: 5.0,
                ),
              ]),
          width: 220,
          margin: EdgeInsets.all(24),
          padding: EdgeInsets.all(12),
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(index,style: ThemeStyles.styleNormal(),),
              SizedBox(width: 4),
              Expanded(
                  child: TextField(
                    controller: textEdit,
                    decoration:InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      focusedBorder: UnderlineInputBorder(),
                    ),
                    onChanged: (text) {
                      setState(() {
                        answer = text;
                        textChange(text);
                      });
                    },
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',),
                  )),
            ],
          ))
    ],);
  }
}


class TextFieldTitleController extends StatefulWidget{
  String title;
  String answer;
  final Function(String) textChange;

  TextFieldTitleController({this.title, this.answer,this.textChange});

  @override
  State<StatefulWidget> createState()  => TextFieldTitleControllerState(title: this.title,answer: this.answer,textChange: this.textChange);

}

class TextFieldTitleControllerState extends State<TextFieldTitleController> {
  String title;
  String answer;
  final Function(String) textChange;

  TextFieldTitleControllerState({this.title, this.answer,this.textChange});

  TextEditingController textEdit = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textEdit.text = answer;
    textEdit.addListener(() {
      setState(() {
        answer = textEdit.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [ Container(
        decoration: BoxDecoration(
            color: HexColor("#9c7f6a"),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Color(0x60000000),
                offset: Offset(0.0, 3.0),
                blurRadius: 5.0,
              ),
            ]),
        width: 220,
        margin: EdgeInsets.all(24),
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title,style: ThemeStyles.styleNormal(font: 14),),
            SizedBox(width: 4),
            TextField(
              controller: textEdit,
              decoration:InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                focusedBorder: UnderlineInputBorder(),
              ),
              onChanged: (text) {
                setState(() {
                  answer = text;
                  textChange(text);
                });
              },
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',),
            ),
          ],
        ))],);
  }
}