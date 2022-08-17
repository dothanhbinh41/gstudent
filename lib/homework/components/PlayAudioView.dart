
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';


class PlayAudioView extends StatefulWidget {
  String url;

  PlayAudioView({this.url});

  @override
  _PlayAudioViewState createState() => _PlayAudioViewState(url: this.url);
}

class _PlayAudioViewState extends State<PlayAudioView> with SingleTickerProviderStateMixin {
  AudioPlayer audioPlayer;
  String url;
  Duration duration =  Duration();
  double durationvalue;
  Duration position =  Duration();
  AnimationController _animationController;
  bool isPlay = false;
  _PlayAudioViewState({this.url});

  @override
  void dispose() async {

    // TODO: implement dispose
    super.dispose();
    await audioPlayer.release();
    audioPlayer.dispose();
  }

  @override
  void initState() {
    super.initState();
    audioPlayer =  AudioPlayer();
    audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.STOPPED || event == PlayerState.PAUSED) {
        if(mounted){
          setState(() {
            isPlay = false;
          });
          _animationController.reverse();
        }
      }
      if(event == PlayerState.COMPLETED){
        setState(() {
          isPlay = false;
        });
        _animationController.reverse();
      }
    });
    audioPlayer.onPlayerError.listen((event) {
      print('error playing');
      print(event);
      setState(() {
        isPlay = false;
      });
      _animationController.reverse();
    });
    audioPlayer.onDurationChanged.listen((Duration d) {
      print('Max duration: '+d.inMilliseconds.toString());
      setState(() => duration = d);
    });

    audioPlayer.onAudioPositionChanged.listen((Duration p) {
      print('Current position: '+p.inMilliseconds.toString());
      if(mounted){
        setState(() => position = p);
        if(duration.inMilliseconds - 400 < p.inMilliseconds){
          setState(() {
            audioPlayer.stop();
            isPlay = false;
            position = Duration(milliseconds: 0);
            _animationController.reverse();
          });
        }
      }
    });

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    super.initState();
  }



  void handleTapVolumn() {
    setState(() {
      isPlay = !isPlay;
    });
    isPlay ? _animationController.forward() : _animationController.reverse();
    isPlay == true ? playAudio() : stopAudio();
  }

  stopAudio() async {
    //   await audioPlayer.stop();
    await audioPlayer.stop();
  }

  playAudio() async {
    try {
      await audioPlayer.play(url,isLocal: false,position: position);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16),
      width: 50,
      height: 50,
      child: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.surface,
        onPressed: handleTapVolumn,
        child: AnimatedIcon(
          icon: AnimatedIcons.play_pause,
          progress: _animationController,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
