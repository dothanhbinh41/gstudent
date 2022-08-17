import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';
import 'package:gstudent/common/colors/HexColor.dart';

// ignore: must_be_immutable
class MatchImageAudioView extends StatefulWidget {
  GroupQuestion question;

  MatchImageAudioView({this.question, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      MatchImageAudioViewState(grQuestion: this.question);
}

class MatchImageAudioViewState extends State<MatchImageAudioView> {
  GroupQuestion grQuestion;

  MatchImageAudioViewState({this.grQuestion});

  Question currentQs;
  int current;
  PageController _pageController = PageController(viewportFraction: 2 / 4);

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
            height: 120,
          ),
        ],
      ),
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
              Container(
                width: 200,
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(color: Theme.of(context).colorScheme.surface, offset: Offset(1, 1))
                    ]),
                child: Image.network(
                  grQuestion.questions[index].studentAnswer,
                  fit: BoxFit.fill,
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
          color: HexColor("#CCFFFFFF"),
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
