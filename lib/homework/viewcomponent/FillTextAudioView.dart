// import 'package:edutalkapp/common/components/EAudioPlayer.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';
import 'package:gstudent/homework/components/PlayAudioView.dart';

// ignore: must_be_immutable
class FillTextAudioView extends StatefulWidget {
  GroupQuestion grQuestions;
  FillTextAudioView({this.grQuestions, Key key}) : super(key: key);
  @override
  FillTextAudioViewState createState() {
    return new FillTextAudioViewState(grQuestions: this.grQuestions);
  }
}

class FillTextAudioViewState extends State<FillTextAudioView> {
  GroupQuestion grQuestions;
  // List<TextEditingController> _controllers = new List();
  List<Question> questions;
  Question currentQs;
  List<String> listAnswers;
  FillTextAudioViewState({this.grQuestions});

  FocusNode inputNode = FocusNode();

// to open keyboard call this function;
  void openKeyboard() {
    FocusScope.of(context).requestFocus(inputNode);
  }

  @override
  void initState() {
    super.initState();
    listAnswers = [];
    if (grQuestions == null) {
      return;
    }
    setState(() {
      currentQs = grQuestions.questions[0];
      questions = grQuestions.questions;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 8, right: 8),
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (BuildContext context, int index) =>
                listItem(questions[index])));
  }

  listItem(Question question) => Stack(
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
                        color: Theme.of(context).colorScheme.background,
                        fontSize: 14),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8)),
                      boxShadow: [],
                      shape: BoxShape.rectangle,
                      color: Colors.green),
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
        child: PlayAudioView(
          url: question.audio,
        ),
      )
    ],
  );

  editTextField(Question question) {
    TextEditingController textEdit = TextEditingController();
    textEdit.text = question.studentAnswer;
    textEdit.selection =
        TextSelection.fromPosition(TextPosition(offset: textEdit.text.length));
    return Container(
        decoration: BoxDecoration(
          color: question.studentAnswer.toLowerCase().replaceAll(new RegExp(r'[^\w\s]+'),'') == question.correctAnswer.toLowerCase().replaceAll(new RegExp(r'[^\w\s]+'),'')? Colors.white : Colors.red.shade400,
        ),
        margin: EdgeInsets.all(20),
        child: Text(
          question.studentAnswer,
          style: TextStyle(fontSize: 14, color: question.studentAnswer.toLowerCase().replaceAll(new RegExp(r'[^\w\s]+'),'') == question.correctAnswer.toLowerCase().replaceAll(new RegExp(r'[^\w\s]+'),'') ? Colors.green : Colors.red,),
        ));
  }
}
