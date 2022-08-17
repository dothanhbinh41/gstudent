import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';
import 'package:gstudent/homework/cubit/homework_cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_utils/keyboard_aware/keyboard_aware.dart';

class Writing extends StatefulWidget {
  GroupQuestion question;

  Writing({this.question, Key key}) : super(key: key);

  @override
  WritingState createState() {
    return WritingState(grQuestion: this.question);
  }
}

class WritingState extends State<Writing> {
  GroupQuestion grQuestion;

  WritingState({this.grQuestion});

  TextEditingController textEdit = TextEditingController();
  List<String> img = [];
  int timeStart = 0;
  var getIt = GetIt.instance;
  HomeworkCubit cubit;
  bool isFocus = false;
  FocusNode _focus = new FocusNode();

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<HomeworkCubit>(context);
    setState(() {
      timeStart = DateTime.now().millisecondsSinceEpoch;
      if (grQuestion.questions.isNotEmpty && grQuestion.questions[0].answer == null) {
        grQuestion.questions[0].answer = QuestionAnswer(content: "", images: [], questionId: grQuestion.questions[0].id);
      }
      if (grQuestion.questions.isNotEmpty && grQuestion.questions[0].answer.content.isNotEmpty) {
        textEdit.text = grQuestion.questions[0].answer.content;
      }
    });
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    debugPrint("Focus: ${_focus.hasFocus.toString()}");
    if (_focus.hasFocus) {
      setState(() {
        isFocus = true;
      });
    } else {
      disableFocus();
    }
  }

  disableFocus() {
    SystemChannels.textInput.invokeListMethod("TextInput.hide");
    _focus.unfocus();
    setState(() {
      isFocus = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        grQuestion.image.isNotEmpty
            ? GestureDetector(
          onTap: () => disableFocus(),
              child: Container(
                  child: Image.network(grQuestion.image),
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                ),
            )
            : Container(),
        Container(
          margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: TextField(
            enabled: true,
            focusNode: _focus,
            style: TextStyle(fontSize: 14),
            controller: textEdit,
            onChanged: (value) {
              setState(() {
                grQuestion.questions[0].answer.content = value;
                grQuestion.questions[0].answer.timeAnswer = DateTime.now().millisecondsSinceEpoch - timeStart;
              });
            },
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
                counterText: "",
                border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary), borderRadius: BorderRadius.circular(8)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary), borderRadius: BorderRadius.circular(8)),
                focusedBorder:
                    OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary), borderRadius: BorderRadius.circular(8))),

          ),
        ),
        KeyboardAware(
          builder: (context, configuracaoTeclado) {
            return Container(
              height: configuracaoTeclado.isKeyboardOpen ? configuracaoTeclado.keyboardHeight + 80 : 0,
            );
          },
        )
      ],
    );
  }

  itemImage(int index) {
    return GestureDetector(
      child: Container(
        height: 48,
        width: 48,
        margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: Center(
          child: Image.network(img[index]),
        ),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white, boxShadow: [
          BoxShadow(
            color: Colors.black54,
            offset: Offset(0.0, 1.0),
            blurRadius: 2.0,
          ),
        ]),
      ),
      // onTap: () => showDialogAsync(ShowImageDialog(
      //   file: img[index],
      // )),
    );
  }

  Future<int> imageOptions(context) async {
    var result = await showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 100,
            child: SizedBox.expand(
                child: Container(
              child: Column(
                children: [
                  GestureDetector(
                    child: Container(
                      child: Text(
                        AppLocalizations.of(context).lblCamera,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontFamily: 'SourceSerifPro',
                        ),
                      ),
                      margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                    ),
                    onTap: () => {Navigator.pop(context, 1)},
                  ),
                  Expanded(
                      child: Divider(
                    color: Colors.grey,
                  )),
                  GestureDetector(
                      child: Container(
                        child: Text(
                          AppLocalizations.of(context).lblGallery,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'SourceSerifPro',
                          ),
                        ),
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                      ),
                      onTap: () => {Navigator.pop(context, 2)})
                ],
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
              ),
              alignment: Alignment.bottomCenter,
            )),
            //margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
    return result == null ? 0 : result;
  }

  void showDialogAsync(Widget widget) async {
    var result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return widget;
        });
  }
}
