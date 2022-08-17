import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gstudent/api/dtos/TestInput/answer.dart';
import 'package:gstudent/api/dtos/TestInput/ielts.dart';
import 'package:gstudent/common/controls/dialog_zoom_image.dart';
import 'package:image_picker/image_picker.dart';

class WritingPage extends StatefulWidget {
  QuestionTestInputDto groupQuestionTest;

  WritingPage({this.groupQuestionTest});

  @override
  State<StatefulWidget> createState() => WritingPageState(groupQuestionTest: this.groupQuestionTest);
}

class WritingPageState extends State<WritingPage> {
  QuestionTestInputDto groupQuestionTest;

  WritingPageState({this.groupQuestionTest});

  TextEditingController textEdit = TextEditingController();
  List<String> img = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      if (groupQuestionTest.answerSubmit == null) {
        groupQuestionTest.answerSubmit = AnswerQuestion(id: groupQuestionTest.id, answers: "", answerType: groupQuestionTest.answerType);
      }
      textEdit.text = groupQuestionTest.answerSubmit.answers;

      // if(groupQuestionTest.answerSubmit.images.length > 0){
      //
      //   groupQuestionTest.answer.images.forEach((element) {
      //     img.add(element.path);
      //   });
      // }
    });
  }

  //
  // final picker = ImagePicker();
  // PickedFile pickedFile;
  //
  // Future<String> getImage(int isCamera) async {
  //   if (isCamera == 1) {
  //     pickedFile = await picker.getImage(source: ImageSource.camera);
  //   }
  //   if (isCamera == 2) {
  //     pickedFile = await picker.getImage(source: ImageSource.gallery);
  //   }
  //
  //   if (pickedFile != null) {
  //     var image = File(pickedFile.path);
  //     return image.path;
  //   }
  //
  //   return null;
  // }

  // uploadImage() async {
  //   int isCamera;
  //   await imageOptions(context).then((value) => isCamera = value);
  //   var file = await getImage(isCamera);
  //   if (file == null || file.isEmpty) {
  //     return;
  //   }
  //   setState(() {
  //     img.add(file);
  //   });
  // }

  // Future<int> imageOptions(context) async {
  //   var result = await showGeneralDialog(
  //     barrierLabel: "Label",
  //     barrierDismissible: true,
  //     barrierColor: Colors.black.withOpacity(0.5),
  //     transitionDuration: Duration(milliseconds: 700),
  //     context: context,
  //     pageBuilder: (context, anim1, anim2) {
  //       return Align(
  //         alignment: Alignment.bottomCenter,
  //         child: Container(
  //           height: 100,
  //           child: SizedBox.expand(
  //               child: Container(
  //             child: Column(
  //               children: [
  //                 GestureDetector(
  //                   child: Container(
  //                     child: Text(AppLocalizations.of(context).lblCamera),
  //                     margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
  //                   ),
  //                   onTap: () => {Navigator.pop(context, 1)},
  //                 ),
  //                 Expanded(
  //                     child: Divider(
  //                   color: Colors.grey,
  //                 )),
  //                 GestureDetector(
  //                     child: Container(
  //                       child: Text(AppLocalizations.of(context).lblGallery),
  //                       margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
  //                     ),
  //                     onTap: () => {Navigator.pop(context, 2)})
  //               ],
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //             ),
  //             alignment: Alignment.bottomCenter,
  //           )),
  //           //margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.only(
  //                 topRight: Radius.circular(20), topLeft: Radius.circular(20)),
  //           ),
  //         ),
  //       );
  //     },
  //     transitionBuilder: (context, anim1, anim2, child) {
  //       return SlideTransition(
  //         position:
  //             Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
  //         child: child,
  //       );
  //     },
  //   );
  //   return result == null ? 0 : result;
  // }

  // void showDialogAsync(Widget widget) async {
  //   var result = await showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return widget;
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Text(
              groupQuestionTest.content,
              style: TextStyle(fontWeight: FontWeight.w400, fontFamily: 'SourceSerifPro'),
            ),
          ),
          groupQuestionTest.questionMediaContent.isNotEmpty
              ? Container(
                  child: Image.network(groupQuestionTest.questionMediaContent),
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                )
              : Container(),

          Container(
            margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'SourceSerifPro'),
              controller: textEdit,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary), borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary), borderRadius: BorderRadius.circular(8))),
            ),
          ),
          // Container(
          //   margin: EdgeInsets.fromLTRB(8, 4, 0, 4),
          //   height: 50,
          //   child: Row(
          //     children: [
          //       ListView.builder(
          //         itemBuilder: (context, index) => itemImage(index),
          //         scrollDirection: Axis.horizontal,
          //         itemCount: img.length,
          //         shrinkWrap: true,
          //       )
          //     ],
          //     mainAxisAlignment: MainAxisAlignment.start,
          //   ),
          // )
        ],
      ),
    );
  }

// itemImage(int index) {
//   return Container(
//     height: 48,
//     width: 48,
//     margin: EdgeInsets.all(4),
//     child: index == 0
//         ? GestureDetector(
//             child: Container(
//               child: Center(
//                 child: Icon(Icons.camera_alt),
//               ),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(offset: Offset(1, 1), blurRadius: 0)
//                   ]),
//             ),
//             onTap: () => uploadImage(),
//           )
//         : GestureDetector(
//             child: Container(
//               child: Image.file(File(img[index])),
//             ),
//             onTap: () => showDialogAsync(ShowImageDialog(
//               file: img[index],
//             )),
//           ),
//   );
// }
}
