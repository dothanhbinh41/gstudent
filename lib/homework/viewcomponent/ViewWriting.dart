
import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';

class ViewWritting extends StatefulWidget {
  GroupQuestion question;

  ViewWritting({this.question, Key key}) : super(key: key);

  @override
  ViewWritingViewState createState() {
    return ViewWritingViewState(grQuestion: this.question);
  }
}

class ViewWritingViewState extends State<ViewWritting> {
  GroupQuestion grQuestion;

  ViewWritingViewState({this.grQuestion});

  TextEditingController textEdit = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (grQuestion == null) {
      return;
    }
    textEdit.text = grQuestion.questions[0].studentAnswer;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Text(grQuestion.script != null ? grQuestion.script  : "null"),
          ),
          grQuestion.image.isNotEmpty
              ? Container(
                  child: Image.network(grQuestion.image),
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                )
              : Container(),
          Container(
            margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              style: TextStyle(fontSize: 14),
              controller: textEdit,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              enabled: false,
              decoration: InputDecoration(
                  counterText: "",
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary),
                      borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary),
                      borderRadius: BorderRadius.circular(8))),
            ),
          ),
          // Container(
          //   margin: EdgeInsets.fromLTRB(8, 4, 0, 4),
          //   height: 50,
          //   child:ListView.builder(
          //     itemBuilder: (context, index) => itemImage(index),
          //     scrollDirection: Axis.horizontal,
          //     itemCount: grQuestion.questions[0].studentAnswerImage.length,
          //     shrinkWrap: true,
          //   ),
          // )
        ],
      ),
    );
  }

  itemImage(int index) {
    return GestureDetector(
      child: Container(
        height: 48,
        width: 48,
        margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
        // child: Center(
        //   child: Image.network(grQuestion.questions[0].studentAnswerImage[index]['path_string']),
        // ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                offset: Offset(0.0, 1.0),
                blurRadius: 2.0,
              ),
            ]),
      ),
      // onTap: () => showDialogAsync(ShowImageDialog(
      //   file: grQuestion.questions[0].studentAnswerImage[index]['path_string'],
      // )),
    );
  }


  void showDialogAsync(Widget widget) async {
    var result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return widget;
        });
  }
}
