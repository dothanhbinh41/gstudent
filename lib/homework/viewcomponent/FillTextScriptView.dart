import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';

// ignore: must_be_immutable
class FillTextScriptView extends StatefulWidget {
  GroupQuestion grQuestion;

  FillTextScriptView({this.grQuestion, Key key}) : super(key: key);

  @override
  FillTextScriptViewState createState() {
    return FillTextScriptViewState(grQuestion: this.grQuestion);
  }
}

class FillTextScriptViewState extends State<FillTextScriptView> {
  GroupQuestion grQuestion;
  Question currentQs;
  PageController _pageController = PageController(viewportFraction: 2 / 3);

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
    return SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
          Visibility(
            visible: grQuestion.image.isNotEmpty,
            child: GestureDetector(
              // onTap: () => showDialogAsync(ShowImageDialog(
              //   file:  grQuestion.image,
              // )),
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
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x60000000),
                      offset: Offset(0.0, 3.0),
                      blurRadius: 5.0,
                    ),
                  ]),
              margin: EdgeInsets.all(24),
              padding: EdgeInsets.all(12),
              child: Wrap(children: [Text(grQuestion.script)])),
          Container(
            height: 120,
            child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) =>
                    currentQs = grQuestion.questions[value],
                itemCount: grQuestion.questions.length,
                itemBuilder: (BuildContext context, int index) =>
                    _answerFillText(index)),
          ),
        ]));
  }

  _answerFillText(int index) {
    return Container(
        height: 48,
        decoration: BoxDecoration(
            color: Colors.white,
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
            Text((index+1).toString()+"."),
            SizedBox(width: 16),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  grQuestion.questions[index].studentAnswer,
                  style: TextStyle(
                    fontSize: 14,
                    color: grQuestion.questions[index].studentAnswer
                                .toLowerCase()
                                .replaceAll(new RegExp(r'[^\w\s]+'),'') ==
                            grQuestion.questions[index].correctAnswer
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
