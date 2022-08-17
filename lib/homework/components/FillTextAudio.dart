// import 'package:edutalkapp/common/components/EAudioPlayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/homework/components/PlayAudioView.dart';
import 'package:keyboard_utils/keyboard_aware/keyboard_aware.dart';

// ignore: must_be_immutable
class FillTextAudio extends StatefulWidget {
  GroupQuestion grQuestions;

  FillTextAudio({this.grQuestions, Key key}) : super(key: key);

  @override
  FillTextAudioState createState() {
    return new FillTextAudioState(grQuestions: this.grQuestions);
  }
}

class FillTextAudioState extends State<FillTextAudio> {
  GroupQuestion grQuestions;

  // List<TextEditingController> _controllers = new List();
  List<Question> questions;
  Question currentQs;
  int timeStart = 0;

  FillTextAudioState({this.grQuestions});

  FocusNode inputNode = FocusNode();

// to open keyboard call this function;
  void openKeyboard() {
    FocusScope.of(context).requestFocus(inputNode);
  }

  bool isFocus = false;

  @override
  void initState() {
    super.initState();
    if (grQuestions == null) {
      return;
    }
    setState(() {
      currentQs = grQuestions.questions[0];
      questions = grQuestions.questions;
      timeStart = DateTime
          .now()
          .millisecondsSinceEpoch;
      for (var i = 0; i < grQuestions.questions.length; i++) {
        if (grQuestions.questions[i].answer == null) {
          grQuestions.questions[i].answer = QuestionAnswer(content: "", questionId: grQuestions.questions[i].id);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        grQuestions.audio.isNotEmpty
            ? PlayAudioView(
          url: grQuestions.audio,
        )
            : Container(),
        Container(
            margin: EdgeInsets.only(left: 8, right: 8),
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) => listItem(questions[index]))),
        KeyboardAware(
          builder: (context, configuracaoTeclado) {
            return Container(
              height: configuracaoTeclado.keyboardHeight > 0 ? configuracaoTeclado.keyboardHeight : 24,
            );
          },
        ),
      ],
    );
  }

  listItem(Question question) =>
      Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Card(
              margin: EdgeInsets.only(top: 24, bottom: 24, right: 8, left: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        question.title,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'SourceSerifPro',
                        ),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                          boxShadow: [],
                          shape: BoxShape.rectangle,
                          color: HexColor("#9c7f6a")),
                    ),
                  ),
                  editTextField(question),
                  SizedBox(
                    height: 20,
                  )
                ],
              )),
          Positioned(
            bottom: 0,
            right: 40,
            child: question.audio.isNotEmpty
                ? PlayAudioView(
              url: question.audio,
            )
                : Container(),
          )
        ],
      );

  editTextField(Question question) {
    return TextFieldAudioController(question: question, onchangeText: (v) {
      setState(() {
        question.answer.content = v;
        question.answer.timeAnswer = DateTime
            .now()
            .millisecondsSinceEpoch - timeStart;
      });
    },);
  }
}

class TextFieldAudioController extends StatefulWidget {
  Question question;
  Function(String) onchangeText;

  TextFieldAudioController({Key key, this.question, this.onchangeText}) : super(key: key);

  @override
  _TextFieldAudioControllerState createState() => _TextFieldAudioControllerState();
}

class _TextFieldAudioControllerState extends State<TextFieldAudioController> {
  TextEditingController textEdit = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    textEdit.text = widget.question.answer.content;
    textEdit.selection = TextSelection.fromPosition(TextPosition(offset: textEdit.text.length));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(20),
        child: TextField(
          controller: textEdit,
          decoration: InputDecoration(),
          onChanged: (text) {
            setState(() {
              widget.onchangeText(text);
            });
          },
          style: TextStyle(fontSize: 14),
        ));
  }
}
