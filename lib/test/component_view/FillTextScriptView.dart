import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/Exam/GroupQuestionExam.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/dialog_zoom_image.dart';
import 'package:gstudent/homework/components/PlayAudioView.dart';

// ignore: must_be_immutable
class FillTextScriptView extends StatefulWidget {
  PracticeGroupQuestion grQuestion;

  FillTextScriptView({this.grQuestion, Key key}) : super(key: key);

  @override
  FillTextScriptViewState createState() {
    return FillTextScriptViewState(grQuestion: this.grQuestion);
  }
}

class FillTextScriptViewState extends State<FillTextScriptView> {
  PageController _pageController = PageController(viewportFraction: 2 / 3);
  PracticeQuestion currentQs;
  PracticeGroupQuestion grQuestion;

  FillTextScriptViewState({this.grQuestion});

  List<String> scripts;

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  FocusNode inputNode = FocusNode();

// to open keyboard call this function;
  void openKeyboard() {
    FocusScope.of(context).requestFocus(inputNode);
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
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                file:  grQuestion.image,
              )),
              child: Container(
                height: 160,
                margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Image.network(
                  grQuestion.image,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Container(
            height: 120,
            child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) =>
                currentQs = grQuestion.practiceQuestions[value],
                itemCount: grQuestion.practiceQuestions.length,
                itemBuilder: (BuildContext context, int index) =>
                    _answerFillText(index)),
          ),

        ]);
  }

  _answerFillText(int index) {
    return Container(
        height: 48,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('$index.'),
            SizedBox(width: 16),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  grQuestion.practiceQuestions[index].studentAnswer,
                  style: TextStyle(
                    fontSize: 14,
                    color: grQuestion.practiceQuestions[index].studentAnswer
                                .toLowerCase()
                                .replaceAll(new RegExp(r'[^\w\s]+'),'') ==
                            grQuestion.practiceQuestions[index].correctAnswers
                                .toLowerCase()
                                .replaceAll(new RegExp(r'[^\w\s]+'),'')
                        ? Colors.green
                        : Colors.red.shade400,
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                )
              ],
            )),
          ],
        ));
  }
}
