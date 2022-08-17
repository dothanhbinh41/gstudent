// import 'package:edutalkapp/common/colors.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/styles/theme_text.dart';

// ignore: must_be_immutable
class MatchImageAudio extends StatefulWidget {
  GroupQuestion question;

  MatchImageAudio({this.question, Key key}) : super(key: key);

  @override
  MatchImageAudioState createState() => MatchImageAudioState(grQuestion: this.question);
}

class MatchImageAudioState extends State<MatchImageAudio> {
  GroupQuestion grQuestion;

  MatchImageAudioState({this.grQuestion});

  List<QuestionAnswer> listAnswers;
  Question currentQs;
  int current;
  PageController _pageController = PageController(viewportFraction: 2 / 4);
  int timeStart = 0;

  @override
  void initState() {
    super.initState();
    listAnswers = [];
    setState(() {
      timeStart = DateTime.now().millisecondsSinceEpoch;
      current = 0;
      currentQs = grQuestion.questions[0];
      for (var i = 0; i < grQuestion.questions[0].answers.length; i++) {
        listAnswers.add(grQuestion.questions[0].answers[i]);
      }
      for (var i = 0; i < grQuestion.questions.length; i++) {
        if (grQuestion.questions[i].answer == null) {
          grQuestion.questions[i].answer = QuestionAnswer(content: "", image: "", questionId: grQuestion.questions[i].id);
        }
        if (grQuestion.questions[i].answer.image != "") {
          listAnswers.remove(grQuestion.questions[i].answer);
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
    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return ListView(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            grQuestion != null
                ? Container(
                    child: Text(
                      grQuestion.description,
                      style: ThemeStyles.styleNormal(font: 14),
                    ),
                    margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
                  )
                : Container(),
            Container(
              child: PageView.builder(
                  controller: _pageController, onPageChanged: (value) => current = value, itemCount: grQuestion.questions.length, itemBuilder: (BuildContext context, int index) => item(index)),
              height: 120,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  crossAxisCount: 2,
                  childAspectRatio: (itemWidth / itemHeight) * 2,
                ),
                itemBuilder: (context, index) => itemGrid(context, index),
                itemCount: listAnswers.length,
                primary: false,
                shrinkWrap: true,
              ),
            )
          ],
        ),
      ],
    );
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
                  width: 200,
                  height: 100,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: HexColor("#9c7f6a"), offset: Offset(1, 1))]),
                  child: Image.network(
                    grQuestion.questions[index].answer.image,
                    fit: BoxFit.fill,
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
        decoration: BoxDecoration(color: HexColor("#9c7f6a"), borderRadius: BorderRadius.circular(8)),
        child: Image.network(
          listAnswers[index].image,
          fit: BoxFit.fill,
        ),
      ),
      onTap: () {
        setState(() {
          if (grQuestion.questions[current].answer.image.isEmpty) {
            grQuestion.questions[current].answer.image = listAnswers[index].image;
            grQuestion.questions[current].answer.content = listAnswers[index].position.toString();
            grQuestion.questions[current].answer.position = listAnswers[index].position;
            grQuestion.questions[current].answer.timeAnswer = DateTime.now().millisecondsSinceEpoch - timeStart;
            timeStart = DateTime.now().millisecondsSinceEpoch;
            listAnswers.remove(listAnswers[index]);
          } else {
            listAnswers.add(grQuestion.questions[current].answer);
            grQuestion.questions[current].answer.image = listAnswers[index].image;
            grQuestion.questions[current].answer.content = listAnswers[index].position.toString();
            grQuestion.questions[current].answer.position = listAnswers[index].position;
            listAnswers.remove(listAnswers[index]);
          }
        });
      },
    );
  }

  removeItem(index) {
    setState(() {
      listAnswers.add(grQuestion.questions[index].answer);
      grQuestion.questions[index].answer.image = "";
      grQuestion.questions[index].answer.position = null;
      grQuestion.questions[index].answer.content = "";
    });
  }
}

// ignore: must_be_immutable
class IconPlay extends StatefulWidget {
  String path;

  IconPlay({this.path});

  @override
  State<StatefulWidget> createState() => IconPlayState(path: this.path);
}

class IconPlayState extends State<IconPlay> with SingleTickerProviderStateMixin {
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
      _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
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
      decoration: BoxDecoration(color: HexColor("#CCFFFFFF"), border: Border.all(color: Theme.of(context).colorScheme.primary), borderRadius: BorderRadius.circular(20)),
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
