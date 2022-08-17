// import 'package:edutalkapp/common/colors.dart';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';
import 'package:gstudent/common/controls/orderable/orderable.dart';
import 'package:gstudent/common/styles/theme_text.dart';

class ArrangeSentencesView extends StatefulWidget {
  GroupQuestion question;

  ArrangeSentencesView({this.question, Key key}) : super(key: key);

  @override
  ArrangeSentencesViewState createState() => ArrangeSentencesViewState(grQuestion: this.question);
}

class ArrangeSentencesViewState extends State<ArrangeSentencesView> {
  GroupQuestion grQuestion;

  ArrangeSentencesViewState({this.grQuestion});

  List<QuestionAnswer> listAnswers;
  List<QuestionAnswer> listAnswereds;
  int timeStart;

  // Map<QuestionAnswer, QuestionAnswer> choices = {};

  @override
  void dispose() {
    super.dispose();
    listAnswers?.clear();
    listAnswereds?.clear();
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      timeStart = DateTime.now().millisecondsSinceEpoch;
      listAnswers = [];
      listAnswereds = [];
      for (var i = 0; i < grQuestion.questions[0].answers.length; i++) {
        listAnswers.add(grQuestion.questions[0].answers[i]);
      }
      if (grQuestion.questions[0].answer == null) {
        grQuestion.questions[0].answer = QuestionAnswer(content: '', questionId: grQuestion.questions[0].id,timeAnswer:  0);
      } else {
        if (grQuestion.questions[0].answer.content.isNotEmpty) {
          var ans = grQuestion.questions[0].answer.content.split(' ').toList();
          for(var i = 0 ; i < ans.length ; i ++){
            var s =   isStringIndexConstain(ans,i,i+1);
            if(s != null){
              listAnswereds.add(listAnswers.where((e) => e.content== s).first);
              listAnswers.remove(listAnswers.where((e) => e.content== s).first);
            }
          }

          var anss = List<String>();
          listAnswereds.forEach((element) {
            anss.add(element.content);
          });
          grQuestion.questions[0].answer.content = anss.join(' ');

          print(grQuestion.questions[0].answer.content);
        }
      }
    });
  }

  String isStringIndexConstain(List<String> data ,int index1, int index2){
    var item1 = data[index1];
    var item2 = index2 <= data.length-1 ? data[index2] : null;
    var item3 = item2 != null ? item1 + ' ' + item2 : item1;
    if(  listAnswers.where((e) => e.content.contains(item1) && e.content.length == item1.length).isNotEmpty){
      print(item1);
      return item1;
    }
    else if (listAnswers.where((e) => e.content.contains(item3) && e.content.length == item3.length).isNotEmpty){
      print(data[index1]+' '+data[index2]);
      return data[index1]+' '+data[index2];
    }else{
      return null;
    }

  }

  // load() {
  //   if (grQuestion.questions[0].answer == null) {
  //     for (var i = 0; i < grQuestion.questions[0].answers.length; i++) {
  //       listAnswers.add(grQuestion.questions[0].answers[i]);
  //     }
  //     grQuestion.questions[0].answer = QuestionAnswer(content: listAnswers.join(' '), id: grQuestion.questions[0].id);
  //   } else {
  //     if (grQuestion.questions[0].answer.content.isNotEmpty) {
  //       var ans = grQuestion.questions[0].answer.content.split(' ').toList();
  //       print(ans);
  //       ans.forEach((element) {
  //         listAnswers.add(grQuestion.questions[0].answers.where((e) => e.content == element).first);
  //         // listAnswers.remove(listAnswers.where((e) => e.content.contains(element)).first);
  //       });
  //       // var anss = List<String>();
  //       // listAnswereds.forEach((element) {
  //       //   anss.add(element.content);
  //       // });
  //       // grQuestion.questions[0].answer.content = anss.join(' ');
  //       //
  //     }
  //   }
  //   // for (var i = 0; i < listAnswers.length; i++) {
  //   //   listAnswereds.add(QuestionAnswer(content: ''));
  //   //
  //   //   var a = {listAnswers[i]: listAnswereds[i]};
  //   //   choices.addAll(a);
  //   // }
  // }

  String acceptedData = '';

  @override
  Widget build(BuildContext context) {
    // var w = MediaQuery.of(context).size.width;
    // return Column(
    //   children: [
    //
    //     FutureBuilder(
    //       future: _loadList(),
    //       builder: (context, snapshot) {
    //         return Container(
    //           child: listAnswers != null
    //               ? OrderableStack<QuestionAnswer>(
    //                   key: GlobalKey<ScaffoldState>(),
    //                   direction: Direction.Horizontal,
    //                   margin: 0.0,
    //                   shuffle: false,
    //                   items: listAnswers,
    //                   itemBuilder: itemBuilder,
    //                   itemSize: Size.square(w / (listAnswers.length * 1.2)),
    //                   onChange: (List<QuestionAnswer> orderedList) {
    //                     List<String> ans = [];
    //                     orderedList.forEach((element) {
    //                       ans.add(element.content);
    //                     });
    //                     grQuestion.questions[0].answer.content = ans.join(' ');
    //                     print(grQuestion.questions[0].answer.content);
    //                   })
    //               : Container(),
    //           margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
    //         );
    //       },
    //     )
    //   ],
    // );

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.primary),
              borderRadius: BorderRadius.circular(8),
            ),
            height: 120,
            width: double.infinity,
            child: RichText(
              text: TextSpan(children: [
                if (listAnswereds.length > 0)
                  for (int i = 0; i < listAnswereds.length; i++)
                    WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: GestureDetector(
                          onTap: () => setState(() {
                            removeAnswer(i);
                          }),
                          child: Text(listAnswereds[i].content + ' ', style: ThemeStyles.styleNormal(font: 18)),
                        ))
              ]),
            )),
        Container(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Wrap(spacing: 20, direction: Axis.horizontal, alignment: WrapAlignment.start, children: [
                if (listAnswers.length > 0)
                  for (int i = 0; i < listAnswers.length; i++)
                    GestureDetector(
                      onTap: () => setState(() {
                        selectAnswer(i);
                      }),
                      child: Chip(
                        label: Text(
                          listAnswers[i].content,
                          style: ThemeStyles.styleNormal(textColors: Colors.white),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    )
              ]),
            )),
      ],
    );
  }

  // Widget itemBuilder({Orderable<QuestionAnswer> data, Size itemSize}) {
  //   return Container(
  //     width: itemSize.width,
  //     key: Key("orderableDataWidget${data.value.content}"),
  //     color: data != null && !data.selected
  //         ? data.dataIndex == data.visibleIndex
  //             ? Colors.lime
  //             : Colors.cyan
  //         : Colors.orange,
  //     child: Center(
  //         child: Column(children: [
  //       Text(
  //         "${data.value.content}",
  //         style: TextStyle(
  //           fontSize: 12.0,
  //           color: Colors.white,
  //           fontWeight: FontWeight.w400,
  //           fontFamily: 'SourceSerifPro',
  //         ),
  //       )
  //     ])),
  //   );
  // }

  selectAnswer(index) {
    setState(() {
      listAnswereds.add(listAnswers[index]);
      listAnswers.removeAt(index);
      var ans = List<String>();
      listAnswereds.forEach((element) {
        ans.add(element.content);
      });
      grQuestion.questions[0].answer.content = ans.join(' ');
      grQuestion.questions[0].answer.timeAnswer = DateTime.now().millisecondsSinceEpoch - timeStart;
    });
  }

  removeAnswer(index) {
    setState(() {
      listAnswers.add(listAnswereds[index]);
      listAnswereds.removeAt(index);
      var ans = List<String>();
      if (listAnswereds.length > 0) {
        listAnswereds.forEach((element) {
          ans.add(element.content);
        });
        grQuestion.questions[0].answer.content = ans.join(' ');
      } else {
        grQuestion.questions[0].answer.content = "";
      }
    });
  }

  Future<List<QuestionAnswer>> _loadList() async {
    return listAnswers;
  }
}
