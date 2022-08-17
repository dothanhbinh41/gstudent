// import 'package:edutalkapp/common/colors.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';

// ignore: must_be_immutable
class MatchTextAudio extends StatefulWidget {
  GroupQuestion question;

  MatchTextAudio({this.question,Key key}) : super(key: key);

  @override
  MatchTextAudioState createState() =>
      MatchTextAudioState(grQuestion: this.question);
}

class MatchTextAudioState extends State<MatchTextAudio> {
  GroupQuestion grQuestion;

  MatchTextAudioState({this.grQuestion});

  List<String> listAnswers;
  Question currentQs;
  int current;
  int timeStart = 0;
  PageController _pageController = PageController(viewportFraction: 2 / 5);

  @override
  void initState() {
    super.initState();
    listAnswers = [];
    setState(() {
      current = 0;
      timeStart = 0;
      currentQs = grQuestion.questions[0];
      for (var i = 0; i < grQuestion.questions[0].answers.length; i++) {
        listAnswers.add(grQuestion.questions[0].answers[i].content);
      }
      for (var i = 0; i < grQuestion.questions.length; i++) {
        if (grQuestion.questions[i].answer == null) {
          grQuestion.questions[i].answer = QuestionAnswer(content: "", image: "", questionId: grQuestion.questions[i].id);
        }
        if (grQuestion.questions[i].answer.content != "") {
          listAnswers.remove(grQuestion.questions[i].answer.content);
        }
      }
    });
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) => current = value,
                itemCount: grQuestion.questions.length,
                itemBuilder: (BuildContext context, int index) => item(index)),
            height: 100,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                crossAxisCount: 3,
                childAspectRatio: (itemWidth / itemHeight) * 3,
              ),
              itemBuilder: (context, index) => itemGrid(context, index),
              itemCount: listAnswers.length,
              primary: false,
              shrinkWrap: true,
            ),
          )
        ],
      ),
    );
  }

  selectAnswer(index) {
    setState(() {
      currentQs.answer.content = listAnswers[index];
      grQuestion.questions
          .where((element) => element.id == currentQs.id)
          .first
          .answer = currentQs.answer;
    });
  }

  item(index) {
    // bool isPlay;
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
      height: 120,
      decoration: BoxDecoration(),
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(child: Container()),
              GestureDetector(
                onTap: () => removeItem(index),
                child: Container(
                  width: 160,
                  height: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(color: Colors.white, offset: Offset(1, 1))
                      ]),
                  child: Center(
                    child: Text(grQuestion.questions[index].answer.content, style: TextStyle(fontWeight: FontWeight.w400, fontFamily: 'SourceSerifPro',),),
                  ),
                ),
              )
            ],
          ),
          IconPlay(
            path: grQuestion.questions[index].audio,
          )
        ],
      ),
    );
  }

  itemGrid(BuildContext context, int index) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Theme
                .of(context)
                .colorScheme
                .surface, borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(listAnswers[index], style: TextStyle(fontWeight: FontWeight.w400, fontFamily: 'SourceSerifPro',),),
        ),
      ),
      onTap: () {
        setState(() {
          if (grQuestion.questions[current].answer.content.isEmpty) {
            grQuestion.questions[current].answer.content = listAnswers[index];
            grQuestion.questions[current].answer.timeAnswer = DateTime
                .now()
                .millisecondsSinceEpoch - timeStart;
            timeStart = DateTime
                .now()
                .millisecondsSinceEpoch;
            listAnswers.remove(listAnswers[index]);
          } else {
            listAnswers.add(grQuestion.questions[current].answer.content);
            grQuestion.questions[current].answer.content = listAnswers[index];
            listAnswers.remove(listAnswers[index]);
          }
        });
      },
    );
  }

  removeItem(index) {
    if (grQuestion.questions[index].answer.content.isNotEmpty) {
      setState(() {
        listAnswers.add(grQuestion.questions[index].answer.content);
        grQuestion.questions[index].answer.content = "";
      });
    }
  }

}
// ignore: must_be_immutable
class IconPlay extends StatefulWidget {
  String path;

  IconPlay({this.path});

  @override
  State<StatefulWidget> createState() => IconPlayState(path: this.path);
}

class IconPlayState extends State<IconPlay>
    with SingleTickerProviderStateMixin {
  String path;

  IconPlayState({this.path});

  bool isPlay;
  AudioPlayer audioPlayer;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    setState(() {
      isPlay = false;
      audioPlayer = AudioPlayer();
      _animationController = AnimationController(
          vsync: this, duration: Duration(milliseconds: 400));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.play_pause,
          progress: _animationController,
          color: Theme.of(context).colorScheme.primary,
        ),
        splashRadius: 20,
        splashColor: Colors.transparent,
        onPressed: () => buttonAudioClick(),
      )),
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(20)),
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
    );
  }

  buttonAudioClick() {
    setState(() {
      isPlay = !isPlay;
    });
    isPlay ? _animationController.forward() : _animationController.reverse();
    isPlay == true ? playAudio() : stopAudio();
  }

  stopAudio() async {
    //   await audioPlayer.stop();
    await audioPlayer.pause();
  }

  playAudio() async {
    await audioPlayer.play(path);
  }
}
