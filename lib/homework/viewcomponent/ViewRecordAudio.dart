import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';
import 'package:gstudent/common/styles/theme_text.dart';

// ignore: must_be_immutable
class ViewRecordAudioView extends StatefulWidget {
  GroupQuestion grQuestions;
  ViewRecordAudioView({this.grQuestions, Key key}) : super(key: key);
  @override
  _ViewRecordAudioViewState createState() =>
      _ViewRecordAudioViewState(grQuestions: this.grQuestions);
}

class _ViewRecordAudioViewState extends State<ViewRecordAudioView> {
  GroupQuestion grQuestions;
  List<Question> questions;
  _ViewRecordAudioViewState({this.grQuestions});
  AudioPlayer audioPlayer;
  Duration duration;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    duration = Duration();
    audioPlayer = AudioPlayer();
    setState(() {
      questions = grQuestions.questions;
    });
  }

  audioListener() {
    audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.STOPPED || event == PlayerState.PAUSED) {
        if (mounted) {
          setState(() {
            isPlaying = false;
          });
        }
      }
      if (event == PlayerState.COMPLETED) {
        if (mounted) {
          setState(() {
            isPlaying = false;
          });
        }
      }
    });
    audioPlayer.onPlayerError.listen((event) {
      print('error playing');
      print(event);
      setState(() {
        isPlaying = false;
      });
    });
    audioPlayer.onDurationChanged.listen((Duration d) {
      print('Max duration: ' + d.inMilliseconds.toString());
      setState(() => duration = d);
    });
    audioPlayer.onAudioPositionChanged.listen((Duration p) {
      print('Current position: ' + p.inMilliseconds.toString());
      if (mounted) {
        if (duration.inMilliseconds - 100 < p.inMilliseconds) {
          setState(() {
            isPlaying = false;
          });
        }
      }
    });
  }

  onPlayback() {
    if (isPlaying) {
      stopPlayback();
    } else {
      play();
    }
  }


  void play() async {
    setState(() {
      isPlaying = true;
    });

    await  audioPlayer.play(grQuestions.questions[0].studentAnswer, isLocal: false);
  }

  void stopPlayback() async {
    await audioPlayer.stop();
    setState(() {
      isPlaying = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        grQuestions.script != null ?  Card(
            margin: EdgeInsets.all(16),
            child: Padding(
                padding: EdgeInsets.all(16), child: Text(grQuestions.script != null ? grQuestions.script  : ""))) : Container(),
        grQuestions.image != null && grQuestions.image.isNotEmpty ? Container(
            margin: EdgeInsets.all(16),
            height: 200,
            child: Image.network(grQuestions.image, fit: BoxFit.fill)) : Container(),
        questions.first.studentAnswer != null && questions.first.studentAnswer.isNotEmpty ?  buttonPlayback() : _emptyRecord(),
        // PlayAudioView(
        //   url: questions
        //       .map((e) => e.studentAnswerRecord.map((e) => e.pathString).first)
        //       .first,
        // ),
        SizedBox(
          height: 24,
        )
      ],
    );
  }

  _emptyRecord() {
    return Center(child: Text("The student doesn't answer this question",style: ThemeStyles.styleBold(font: 18),),);
  }


  buttonPlayback() {
    return Center(child: ElevatedButton.icon(
      onPressed: () => onPlayback(),
      icon: isPlaying
          ? Icon(
        Icons.stop,
        color: Colors.red,
      )
          : Icon(Icons.play_arrow),
      label: isPlaying
          ? Text(
        'Dừng',
        style: ThemeStyles.styleBold( textColors:  isPlaying ?  Colors.white : Colors.black),
      )
          : Text(
        'Nghe',
        style: ThemeStyles.styleBold(textColors:  isPlaying ?  Colors.white : Colors.black),
      ),
      style: ElevatedButton.styleFrom(minimumSize: Size(175, 48), primary: isPlaying ? Colors.black : Colors.white, onPrimary: isPlaying ? Colors.white : Colors.black),
    ),);
  }

  time(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final min = twoDigits(duration.inMinutes.remainder(60));
    final sec = twoDigits(duration.inSeconds.remainder(60));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        timeCard(min),
        SizedBox(
          width: 8,
        ),
        timeCard(sec)
      ],
    );
  }

  timeCard(String time) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Text(
        time,
        style: ThemeStyles.styleBold(font: 56),
      ),
    );
  }
}
