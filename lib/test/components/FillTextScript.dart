import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/Exam/GroupQuestionExam.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/dialog_zoom_image.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/common/utils.dart';
import 'package:gstudent/homework/components/PlayAudioView.dart';
import 'package:gstudent/homework/components/TextFieldController.dart';
import 'package:keyboard_utils/keyboard_aware/keyboard_aware.dart';

// ignore: must_be_immutable
class FillTextScript extends StatefulWidget {
  PracticeGroupQuestion grQuestion;

  FillTextScript({this.grQuestion, Key key}) : super(key: key);

  @override
  FillTextScriptState createState() {
    return FillTextScriptState(grQuestion: this.grQuestion);
  }
}

class FillTextScriptState extends State<FillTextScript> {
  PracticeGroupQuestion grQuestion;
  List<String> listAnswers;
  PracticeQuestion currentQs;
  PageController _pageController = PageController(viewportFraction: 2 / 3);

  FillTextScriptState({this.grQuestion});

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
      for (var i = 0; i < grQuestion.practiceQuestions.length; i++) {
        if (grQuestion.practiceQuestions[i].answer == null) {
          grQuestion.practiceQuestions[i].answer = PracticeAnswer(content: "",questionId:  grQuestion.practiceQuestions[i].id);
        }
      }
    });
  }

// to open keyboard call this function;

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
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          grQuestion.audio.isNotEmpty ?
            PlayAudioView(
              url: grQuestion.audio,
            ) : Container(),
          Visibility(
            visible: grQuestion.image.isNotEmpty,
            child: GestureDetector(
              onTap: () => showDialogAsync(ShowImageDialog(
                file: grQuestion.image,
              )),
              child: Container(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                height: 160,
                child: Image.network(
                  grQuestion.image,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          ConstrainedBox(
            constraints:  BoxConstraints(
              minHeight: 120,
              maxHeight:360,
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) =>
                currentQs = grQuestion.practiceQuestions[value],
                itemCount: grQuestion.practiceQuestions.length,
                itemBuilder: (BuildContext context, int index) =>
                    _answerFillText(index)),
          ),
          KeyboardAware(
            builder: (context, configuracaoTeclado) {
              return Container(
                height: configuracaoTeclado.keyboardHeight > 0
                    ? configuracaoTeclado.keyboardHeight
                    : 24,
              );
            },
          ),
        ]);
  }

  _answerFillText(int index) {
    if (isNumeric(grQuestion.practiceQuestions[index].title) == true) {
      return TextFieldIndexController(
        index: grQuestion.practiceQuestions[index].title,
        answer: grQuestion.practiceQuestions[index].answer.content,
        textChange: (value) {
          setState(() {
            grQuestion.practiceQuestions[index].answer.content = value;
          });
        },
      );
    } else {
      return TextFieldTitleController(
        title: grQuestion.practiceQuestions[index].title != null && grQuestion.practiceQuestions[index].title.isNotEmpty
            ? grQuestion.practiceQuestions[index].title
            : "",
        answer: grQuestion.practiceQuestions[index].answer.content,
        textChange: (value) {
          setState(() {
            grQuestion.practiceQuestions[index].answer.content = value;
          });
        },
      );
    }
  }


}
