import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gstudent/api/dtos/TestInput/answer.dart';
import 'package:gstudent/api/dtos/TestInput/answer_submit.dart';
import 'package:gstudent/api/dtos/TestInput/enum.dart';
import 'package:gstudent/api/dtos/TestInput/group_question.dart';
import 'package:gstudent/api/dtos/TestInput/ielts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gstudent/common/controls/dialog_zoom_image.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/testinput/cubit/testinput_cubit.dart';
import 'package:gstudent/testinput/views/do_test_view/list_question_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WritingSkillPage extends StatefulWidget {
  String type;
  List<QuestionTestInputDto> data;
  int idImport;
  int idStudent;
  bool isLast;

  WritingSkillPage({this.type, this.data, this.idImport, this.isLast,this.idStudent});

  @override
  State<StatefulWidget> createState() => WritingSkillPageState(
      type: this.type,
      data: this.data,
      idImport: this.idImport,
      idStudent: this.idStudent,
      isLast: this.isLast);
}

class WritingSkillPageState extends State<WritingSkillPage> {
  String type;
  List<QuestionTestInputDto> data;
  bool isLast;
  int idStudent;

  WritingSkillPageState({this.type, this.data, this.idImport, this.isLast,this.idStudent});

  final String skill = "writing";
  int idImport;
  int current;
  QuestionTestInputDto currentQs;
TestInputCubit cubit;
  //List<QuestionIelts> qs = [];
  FocusNode _focus = new FocusNode();

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of(context);
    setState(() {
      data.forEach((element) {
        if (element.answerSubmit == null) {
          element.answerSubmit = AnswerQuestion(
              id: element.id,
              answers: "",
              answerType: element.answerType,
              type: element.groupQuestionType);
        }
        if (element.answer == null) {
          element.answer = Answer(images: []);
        }
      });
      current = 0;
      currentQs = data[0];
      initListImage();
      initText();
    });
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    debugPrint("Focus: ${_focus.hasFocus.toString()}");
    if (_focus.hasFocus) {

    } else {
      disableFocus();
    }
  }

  disableFocus() {
    SystemChannels.textInput.invokeListMethod("TextInput.hide");
    _focus.unfocus();
  }


  void submitQs() async {
    List<QuestionTestInputDto> listSave = [];
    data.forEach((element) {
      if(element.answerSubmit != null && element.answerSubmit.answers.isNotEmpty){
        listSave.add(element);
      }
    });

    var res = await   cubit.saveTestInput(skill, listSave, idStudent);
    if(res){
      Navigator.of(context).pop(res);
    }
  }

  // void submitQs() async {
  //   List<AnswerQuestion> ans = [];
  //   data.forEach((element) {
  //     if (element.answer.images.length > 0) {
  //       for (var i = 0; i < element.answer.images.length; i++) {
  //
  //       }
  //     }
  //     if (element.answerSubmit.answers != "" ||
  //         element.answerSubmit.image != "") {
  //       ans.add(element.answerSubmit);
  //     }
  //   });
  //
  //   List<AnswerSubmit> answers = [];
  //   ans.forEach((element) {
  //     var a = AnswerSubmit(
  //         id: element.id,
  //         answers: element.answers,
  //         images: element.image,
  //         type: "textarea");
  //     answers.add(a);
  //   });
  //
  //   var result = await cubit.submitQuestion(type, skill, answers, idImport, false,idStudent);
  //
  //   if (result) {
  //     Navigator.of(context).pop(true);
  //   }
  // }

  navigationBack() {
    Navigator.of(context).pop(isLast);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      GestureDetector(
        onTap: () =>  disableFocus(),
       child: Stack(
         children: [
           Positioned(
               top: 0,
               right: 0,
               left: 0,
               bottom: 0,
               child: Image(
                 image: AssetImage('assets/game_bg_arena_light.png'),
                 fit: BoxFit.fill,
               )),
           Positioned(
             top: 0,
             right: 0,
             left: 0,
             bottom: 0,
             child: GestureDetector(
               onTap: () =>  disableFocus(),
               child: Column(
                 children: [
                 SafeArea(child:   Row(
                   children: [
                     Expanded(
                       child: Container(
                         height: 60,
                         child: Row(children: [
                           GestureDetector(
                             onTap: () => navigationBack(),
                             child: Container(
                               child: Icon(
                                 Icons.chevron_left,
                                 size: 24,
                               ),
                               margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                             ),
                           ),
                           Expanded(
                             child: Container(
                               alignment: Alignment.centerLeft,
                               child: TextButton(
                                 style: ButtonStyle(
                                   overlayColor:
                                   MaterialStateProperty.resolveWith<Color>(
                                           (Set<MaterialState> states) {
                                         if (states.contains(MaterialState.pressed))
                                           return Colors.blue;
                                         return null;
                                       }),
                                 ),
                                 onPressed: () => showDialogAsync(),
                                 child: Text(
                                   AppLocalizations.of(context).lbl_review_question,
                                   style: ThemeStyles.styleNormal(),
                                 ),
                               ),
                             ),
                           ),
                           GestureDetector(
                             child: Container(
                               width: 100,
                               margin: EdgeInsets.fromLTRB(4, 8, 4, 8),
                               decoration: BoxDecoration(
                                   color: Theme.of(context).colorScheme.surface,
                                   borderRadius: BorderRadius.circular(8),
                                   boxShadow: [
                                     BoxShadow(offset: Offset(1, 1), blurRadius: 1)
                                   ]),
                               child: Center(
                                 child:
                                 Text("Lưu kết quả",style: ThemeStyles.styleNormal(),),
                               ),
                             ),
                             onTap: () => submitQs(),
                           )
                         ]),
                       ),
                     ),
                   ],
                 )),
                   Expanded(child: content(context, currentQs)),
                   Row(
                     children: [
                       Expanded(
                           child: Visibility(
                             visible: current == 0 ? false : true,
                             child: GestureDetector(
                                 onTap: () => prevQuestion(context),
                                 child: Container(
                                   margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
                                   child: Center(
                                       child: Text(
                                         AppLocalizations.of(context).lbl_pre,
                                         style: TextStyle(color: Colors.white),
                                       )),
                                   decoration: BoxDecoration(
                                       color: Theme.of(context).colorScheme.primary,
                                       borderRadius: BorderRadius.circular(24)),
                                   height: 40,
                                 )),
                           )),
                       Expanded(
                           child: Visibility(
                             visible: current == data.length - 1 ? false : true,
                             child: GestureDetector(
                                 onTap: () => nextQuestion(context),
                                 child: Container(
                                   margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
                                   child: Center(
                                       child: Text(
                                         AppLocalizations.of(context).lbl_next,
                                         style: TextStyle(color: Colors.white),
                                       )),
                                   decoration: BoxDecoration(
                                       color: Theme.of(context).colorScheme.primary,
                                       borderRadius: BorderRadius.circular(24)),
                                   height: 40,
                                 )),
                           ))
                     ],
                   )
                 ],
               ),
             ),
           ),
         ],
       ),
     )
    );
  }

  List<String> img;
  TextEditingController textEdit = TextEditingController();

  initText() {
    textEdit.text = currentQs.answerSubmit.answers;
    textEdit.selection =
        TextSelection.fromPosition(TextPosition(offset: textEdit.text.length));
  }

  content(context, QuestionTestInputDto qs) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Text(qs.content),
          ),
          Container(
            child: Image.network(qs.questionMediaContent),
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              style: TextStyle(fontSize: 14),
              controller: textEdit,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (value) {
                currentQs.answerSubmit.answers = value;
              },
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
          Container(
            margin: EdgeInsets.fromLTRB(8, 4, 0, 4),
            height: 50,
            child: Row(
              children: [
                ListView.builder(
                  itemBuilder: (context, index) => itemImage(index),
                  scrollDirection: Axis.horizontal,
                  itemCount: img.length,
                  shrinkWrap: true,
                )
              ],
              mainAxisAlignment: MainAxisAlignment.start,
            ),
          )
        ],
      ),
    );
  }

  itemImage(int index) {
    return Container(
      height: 48,
      width: 48,
      margin: EdgeInsets.all(4),
      child: index == 0
          ? GestureDetector(
              child: Container(
                child: Center(
                  child: Icon(Icons.camera_alt),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(offset: Offset(1, 1), blurRadius: 0)
                    ]),
              ),
              onTap: () => uploadImage(),
            )
          : GestureDetector(
              child: Container(
                child: Image.network(img[index]),
              ),
              onTap: () => showDialogPickImageAsync(ShowImageDialog(
                file: img[index],
              )),
            ),
    );
  }

  final picker = ImagePicker();
  PickedFile pickedFile;

  Future<String> getImage(int isCamera) async {
    if (isCamera == 1) {
      pickedFile = await picker.getImage(source: ImageSource.camera);
    }
    if (isCamera == 2) {
      pickedFile = await picker.getImage(source: ImageSource.gallery);
    }

    if (pickedFile != null) {
      var image = File(pickedFile.path);
      return image.path;
    }

    return null;
  }

  uploadImage() async {
    int isCamera;
    await imageOptions(context).then((value) => isCamera = value);
    var file = await getImage(isCamera);
    if (file == null || file.isEmpty) {
      return;
    }
    // var result = await testHelper.uploadFile("testid" + currentQs.id.toString(), file);
    //
    // if (result != null) {
    //   setState(() {
    //     img.add(result.path);
    //     currentQs.answer.images.add(result);
    //   });
    // }
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
                      child: Text(AppLocalizations.of(context).lblCamera),
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
                        child: Text(AppLocalizations.of(context).lblGallery),
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
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
    return result == null ? 0 : result;
  }

  void showDialogPickImageAsync(Widget widget) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return widget;
        });
  }

  nextQuestion(context) {
    setState(() {
      if (current < data.length - 1) {
        data[current] = currentQs;
        current++;
        currentQs = data[current];
        initListImage();
        initText();
      }
    });
  }

  initListImage() {
    img = [];
    img.add("");
    if (currentQs.answer.images.length > 0) {
      currentQs.answer.images.forEach((element) {
        img.add(element.path);
      });
    }
  }

  prevQuestion(context) {
    setState(() {
      if (current > 0) {
        data[current] = currentQs;
        current--;
        currentQs = data[current];
        initListImage();
        initText();
      }
    });
  }

  void showDialogAsync() async {
    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    var tests = groupBy(data, (object) => object.groupQuestion).values.toList();
    List<GroupQuestionTest> list =
        tests.map((e) => GroupQuestionTest(groupQuestion: e)).toList();

    var result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return TestInputQuestionDialog(
              itemHeight: itemHeight,
              itemWidth: itemWidth,
              qs: list,
              current: current,
              type: type);
        });
    setState(() {
      current = result != null ? result : current;
    });
  }
}

