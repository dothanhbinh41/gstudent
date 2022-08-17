import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';
import 'package:gstudent/common/controls/dialog_zoom_image.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/homework/components/PlayAudioView.dart';
import 'package:gstudent/homework/components/TextFieldController.dart';
import 'package:keyboard_utils/keyboard_aware/keyboard_aware.dart';

// ignore: must_be_immutable
class FillTextScript extends StatefulWidget {
  GroupQuestion grQuestion;

  FillTextScript({this.grQuestion, Key key}) : super(key: key);

  @override
  FillTextScriptState createState() {
    return FillTextScriptState(grQuestion: this.grQuestion);
  }
}

class FillTextScriptState extends State<FillTextScript> {
  GroupQuestion grQuestion;
  List<String> listAnswers;
  Question currentQs;
  PageController _pageController = PageController(viewportFraction: 2 / 3);

  FillTextScriptState({this.grQuestion});
 int timeStart = 0;
  List<String> scripts;

  @override
  void dispose() {
    super.dispose();
    grQuestion = null;
    listAnswers?.clear();
    scripts?.clear();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      timeStart = DateTime.now().millisecondsSinceEpoch;
      if(grQuestion.questions != null && grQuestion.questions.isNotEmpty){
        for (var i = 0; i < grQuestion.questions.length; i++) {
          if (grQuestion.questions[i].answer == null) {
            grQuestion.questions[i].answer =
                QuestionAnswer(content: "", questionId: grQuestion.questions[i].id);
          }
        }
        currentQs = grQuestion.questions[0];
      }
    });
  }


  int index;

  void showDialogAsync(Widget widget) async {
    var result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return widget;
        });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        Visibility(
          visible: grQuestion.audio.isNotEmpty,
          child: PlayAudioView(
            url:grQuestion.audio,
          ),
        ),
          Visibility(
            visible: grQuestion.image.isNotEmpty,
            child: GestureDetector(
              onTap: () => showDialogAsync(ShowImageDialog(
                file: grQuestion.image,
              )),
              child: Container(
                margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Image.network(
                  grQuestion.image,
                ),
              ),
            ),
          ),
          currentQs != null   && currentQs.title != null
              ? Container(
            margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
            padding: EdgeInsets.all(4),
                  child: Text(
                    currentQs.title,
                    style: ThemeStyles.styleBold(font: 14),
                  ),
                )
              : Container(),

              ConstrainedBox(
                constraints:  BoxConstraints(
                  minHeight: 120,
                  maxHeight:360,
                  maxWidth: MediaQuery.of(context).size.width,
                ),
            child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    currentQs = grQuestion.questions[value];
                  });
                },
                itemCount: grQuestion.questions.length,
                itemBuilder: (BuildContext context, int index) =>
                    _answerFillText(index)),
          ),

        ]));
  }

  _answerFillText(int index) {
    return TextFieldIndexController(
      index: (index+1).toString(),
      answer: grQuestion.questions[index].answer.content,
      textChange: (value) {
        setState(() {
          grQuestion.questions[index].answer.content = value;
          grQuestion.questions[index].answer.timeAnswer = DateTime.now().millisecondsSinceEpoch - timeStart;
        });
      },
    );
  }
}
