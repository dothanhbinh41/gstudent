// ignore: must_be_immutable
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';

// ignore: must_be_immutable
class MatchTextAudioView extends StatefulWidget {
  GroupQuestion question;

  MatchTextAudioView({this.question, Key key}) : super(key: key);

  @override
  MatchTextAudioViewState createState() =>
      MatchTextAudioViewState(grQuestion: this.question);
}

class MatchTextAudioViewState extends State<MatchTextAudioView> {
  GroupQuestion grQuestion;

  MatchTextAudioViewState({this.grQuestion});

  Question currentQs;
  int current;
  PageController _pageController = PageController(viewportFraction: 2 / 5);

  @override
  void initState() {
    super.initState();

    setState(() {
      current = 0;
      currentQs = grQuestion.questions[0];
    });
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;

    // /*24 is for notification bar on Android*/
    // final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    // final double itemWidth = size.width / 2;

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
        ],
      ),
    );
  }

  item(index) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
      height: 120,
      decoration: BoxDecoration(),
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(child: Container()),
              Container(
                width: 160,
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(color: Colors.white, offset: Offset(1, 1))
                    ]),
                child: Center(
                  child: Text(grQuestion.questions[index].studentAnswer),
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
