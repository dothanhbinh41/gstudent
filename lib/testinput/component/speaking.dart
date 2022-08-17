//
// class SpeakingSkillPage extends StatefulWidget {
//   String type;
//   List<QuestionIelts> data;
//   int idImport;
//   bool isLast;
//   SpeakingSkillPage({this.type, this.data, this.idImport, this.isLast});
//
//   @override
//   State<StatefulWidget> createState() => SpeakingSkillPageState(
//       type: this.type,
//       data: this.data,
//       idImport: this.idImport,
//       isLast: this.isLast);
// }
//
// class SpeakingSkillPageState extends State<SpeakingSkillPage> {
//   String type;
//   List<QuestionIelts> data;
//   bool isLast;
//   SpeakingSkillPageState({this.type, this.data, this.idImport, this.isLast});
//
//   RecordStatus status = RecordStatus.idle;
//
//   final String skill = "speaking";
//   int idImport;
//   final getIt = GetIt.instance;
//   TestInputServices api;
//   int current;
//   QuestionIelts currentQs;
//   AudioPlayer audioPlayer;
//
//   @override
//   void initState() {
//     super.initState();
//     api = getIt.get<TestInputServices>();
//     setState(() {
//       audioPlayer = AudioPlayer();
//       data.forEach((element) {
//         if (element.answerSubmit == null) {
//           element.answerSubmit = AnswerQuestion(id: element.id, answers: "");
//         }
//       });
//       current = 0;
//       currentQs = data[0];
//     });
//     getPath();
//   }
//
//   void submitQs() async {
//     List<AnswerQuestion> ans = [];
//     // data.forEach((element) {
//     //   element.groupQuestion.forEach((c) {
//     //     if (c.answer != null && c.answer.answers != "") {
//     //       ans.add(c.answer);
//     //     }
//     //   });
//     // });
//
//     List<AnswerSubmit> answers = [];
//     ans.forEach((element) {
//       var a = AnswerSubmit(id: element.id);
//       if (element.type == GroupQuestionType.YES_NO_NOTGIVEN ||
//           element.type == GroupQuestionType.TRUE_FALSE_NOTGIVEN) {
//         a.answers = element.answers;
//       } else if (element.type == GroupQuestionType.TABLE ||
//           element.type == GroupQuestionType.TEXT) {
//         if (element.answerType == AnswerType.MULTIPLE_CHOICE) {
//           a.answers = List<String>.empty(growable: true);
//           a.answers.add(element.answers);
//         } else {
//           a.answers = element.answers;
//           a.type = "text";
//         }
//       } else if (element.type == GroupQuestionType.SELECT_MULTIPLE) {
//         a.answers = List<String>.empty(growable: true);
//         a.answers.addAll(element.answers);
//       } else {
//         a.answers = List<String>.empty(growable: true);
//         a.answers.add(element.answers);
//       }
//       answers.add(a);
//     });
//
//     var result =
//     await api.submitQuestion(type, skill, answers, idImport, isLast);
//     if (result) {
//       Navigator.of(context).pop(true);
//     }
//   }
//
//   navigationBack() {
//     Navigator.of(context).pop(false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     height: 60,
//                     child: Row(children: [
//                       GestureDetector(
//                         onTap: () => navigationBack(),
//                         child: Container(
//                           child: Icon(
//                             Icons.chevron_left,
//                             size: 24,
//                           ),
//                           margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
//                         ),
//                       ),
//                       Expanded(
//                         child: Container(
//                           alignment: Alignment.centerLeft,
//                           width: 160,
//                           child: TextButton(
//                             style: ButtonStyle(
//                               overlayColor:
//                               MaterialStateProperty.resolveWith<Color>(
//                                       (Set<MaterialState> states) {
//                                     if (states.contains(MaterialState.pressed))
//                                       return Colors.blue;
//                                     return null;
//                                   }),
//                             ),
//                             onPressed: () => showDialogAsync(),
//                             child: Text(
//                               AppLocalizations.of(context).lbl_review_question,
//                               style: TextStyle(
//                                   color: Theme.of(context).colorScheme.primary),
//                             ),
//                           ),
//                         ),
//                       ),
//                       GestureDetector(
//                         child: Container(
//                           width: 80,
//                           margin: EdgeInsets.fromLTRB(4, 8, 4, 8),
//                           decoration: BoxDecoration(
//                               color: Theme.of(context).colorScheme.surface,
//                               borderRadius: BorderRadius.circular(8),
//                               boxShadow: [
//                                 BoxShadow(offset: Offset(1, 1), blurRadius: 1)
//                               ]),
//                           child: Center(
//                             child:
//                             Text(AppLocalizations.of(context).lbl_submit),
//                           ),
//                         ),
//                         onTap: () => submitQs(),
//                       )
//                     ]),
//                   ),
//                 ),
//               ],
//             ),
//             Expanded(child: content(context, currentQs)),
//             Row(
//               children: [
//                 Expanded(
//                     child: Visibility(
//                       visible: current == 0 ? false : true,
//                       child: GestureDetector(
//                           onTap: () => prevQuestion(context),
//                           child: Container(
//                             margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
//                             child: Center(
//                                 child: Text(
//                                   AppLocalizations.of(context).lbl_pre,
//                                   style: TextStyle(color: Colors.white),
//                                 )),
//                             decoration: BoxDecoration(
//                                 color: Theme.of(context).colorScheme.primary,
//                                 borderRadius: BorderRadius.circular(24)),
//                             height: 40,
//                           )),
//                     )),
//                 Expanded(
//                     child: Visibility(
//                       visible: current == data.length - 1 ? false : true,
//                       child: GestureDetector(
//                           onTap: () => nextQuestion(context),
//                           child: Container(
//                             margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
//                             child: Center(
//                                 child: Text(
//                                   AppLocalizations.of(context).lbl_next,
//                                   style: TextStyle(color: Colors.white),
//                                 )),
//                             decoration: BoxDecoration(
//                                 color: Theme.of(context).colorScheme.primary,
//                                 borderRadius: BorderRadius.circular(24)),
//                             height: 40,
//                           )),
//                     ))
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   List<String> img;
//
//   content(context, QuestionIelts qs) {
//     return Container(
//       child: Stack(
//         children: [
//           recorder(),
//           IconButton(
//               icon: Icon(
//                 Icons.play_arrow,
//                 size: 24,
//               ),
//               onPressed: () => playRecord())
//         ],
//       ),
//     );
//   }
//
//   nextQuestion(context) {
//     setState(() {
//       if (current < data.length - 1) {
//         data[current] = currentQs;
//         current++;
//         currentQs = data[current];
//       }
//     });
//   }
//
//   prevQuestion(context) {
//     setState(() {
//       if (current > 0) {
//         data[current] = currentQs;
//         current--;
//         currentQs = data[current];
//       }
//     });
//   }
//
//   void showDialogAsync() async {
//     var size = MediaQuery.of(context).size;
//
//     final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
//     final double itemWidth = size.width / 2;
//
//     var result = await showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return TestInputQuestionDialog(
//               itemHeight: itemHeight,
//               itemWidth: itemWidth,
//               qs: data,
//               current: current,
//               type: type);
//         });
//     setState(() {
//       current = result != null ? result : current;
//     });
//   }
//
//   String path;
//
//   Future<String> getPath() async {
//     if (path == null) {
//       final dir = await getExternalStorageDirectory();
//       path = dir.path +
//           '/' +
//           DateTime.now().millisecondsSinceEpoch.toString() +
//           '.mp4';
//     }
//     return path;
//   }
//
//   recorder() {
//     return AudioRecorder(
//       path: path,
//       onStop: () {},
//     );
//   }
//
//   record() async {
//     switch (status) {
//       case RecordStatus.idle:
//         status = RecordStatus.recording;
//         return;
//       case RecordStatus.recording:
//         status = RecordStatus.recording;
//         return;
//       case RecordStatus.pause:
//         return;
//       case RecordStatus.stop:
//         return;
//       default:
//         return;
//     }
//   }
//
//   playRecord() async {
//     var result = await audioPlayer.setUrl(path, isLocal: true);
//     if (result == 1) {
//       try {
//         await audioPlayer.play(path, isLocal: true);
//       } catch (e) {
//         print(e);
//       }
//     }
//   }
// }
//
