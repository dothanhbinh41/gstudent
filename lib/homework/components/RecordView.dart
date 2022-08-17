import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/homework/cubit/homework_cubit.dart';
import 'package:gstudent/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';

// ignore: must_be_immutable
class RecordView extends StatefulWidget {
  GroupQuestion grQuestions;

  RecordView({this.grQuestions, Key key}) : super(key: key);

  @override
  _RecordViewState createState() => _RecordViewState(grQuestions: grQuestions);
}

class _RecordViewState extends State<RecordView> {
  GroupQuestion grQuestions;

  _RecordViewState({this.grQuestions});

  AudioPlayer audioPlayer;
  HomeworkCubit homeworkCubit;
  bool isComplete = false;
  bool isRecording = false;
  bool isPlaying = false;
  String recordFilePath;
  Duration duration;

  Duration durationRecord;

  Timer _timer;
  int _start = 0;

  @override
  void initState() {
    super.initState();
    homeworkCubit = BlocProvider.of<HomeworkCubit>(context);
    duration = Duration();
    durationRecord = Duration();
    audioPlayer = AudioPlayer();
    if (grQuestions.questions[0].answer == null) {
      grQuestions.questions[0].answer = QuestionAnswer(
        questionId: grQuestions.questions[0].id ?? grQuestions.id,
      );
    } else {
      if (grQuestions.questions[0].answer.record != null) {
        recordFilePath = grQuestions.questions[0].answer.record;
      }
    }
    audioListener();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (isComplete) {
          timer.cancel();
          // socket.emit('require-leaderboard', {'arena_id': arenaId});
        } else {
          setState(() {
            _start++;
            durationRecord = Duration(seconds: _start);
          });
        }
      },
    );
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

  @override
  void dispose() async {
    // TODO: implement dispose
    super.dispose();
    if (isRecording) {
      await audioPlayer.stop();
    }
    audioPlayer.dispose();
    if(_timer != null){
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      isRecording ? time() : Container(),
      SizedBox(
        height: 16,
      ),
      grQuestions.questions[0].answer.content != null && grQuestions.questions[0].answer.content.isNotEmpty
          ? Container(
              margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Row(
                children: [
                  Expanded(child: buttonDelete()),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(child: buttonPlayback())
                ],
              ))
          : buttonRecord(),
    ]);
  }

  time() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final min = twoDigits(durationRecord.inMinutes.remainder(60));
    final sec = twoDigits(durationRecord.inSeconds.remainder(60));
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

  buttonRecord() {
    return ElevatedButton.icon(
      onPressed: () => onRecord(),
      icon: isRecording ? Icon(Icons.stop) : Icon(Icons.mic),
      label: isRecording
          ? Text(
              'Dừng',
              style: ThemeStyles.styleBold(textColors: Colors.white),
            )
          : Text(
              'Bắt đầu',
              style: ThemeStyles.styleBold(),
            ),
      style: ElevatedButton.styleFrom(minimumSize: Size(175, 48), primary: isRecording ? Colors.red : Colors.white, onPrimary: isRecording ? Colors.white : Colors.black),
    );
  }

  buttonPlayback() {
    return ElevatedButton.icon(
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
              style: ThemeStyles.styleBold(),
            )
          : Text(
              'Nghe lại',
              style: ThemeStyles.styleBold(),
            ),
      style: ElevatedButton.styleFrom(minimumSize: Size(175, 48), primary: isRecording ? Colors.red : Colors.white, onPrimary: isRecording ? Colors.white : Colors.black),
    );
  }

  buttonDelete() {
    return ElevatedButton.icon(
      onPressed: () => deleteFile(),
      icon: Icon(
        Icons.delete_forever,
        color: Colors.red,
      ),
      label: Text(
        'Xóa',
        style: ThemeStyles.styleBold(),
      ),
      style: ElevatedButton.styleFrom(minimumSize: Size(175, 48), primary: Colors.white, onPrimary: Colors.white),
    );
  }

  Future<bool> checkPermission() async {

    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.storage,
    ].request();
    var check = statuses.values.where((element) => element != PermissionStatus.granted).isNotEmpty;
    return !check;
  }



  void startRecord() async {
    bool hasPermission = await checkPermission() ;
    if (hasPermission) {
      recordFilePath = await getFilePath();
      isComplete = false;
      setState(() {
        isRecording = true;
      });
      startTimer();
      RecordMp3.instance.start(recordFilePath, (type) {
        setState(() {});
      });
    } else {}
    setState(() {});
  }

  void pauseRecord() {
    if (RecordMp3.instance.status == RecordStatus.PAUSE) {
      bool s = RecordMp3.instance.resume();
      if (s) {
        setState(() {});
      }
    } else {
      bool s = RecordMp3.instance.pause();
      if (s) {
        setState(() {});
      }
    }
  }

  void stopRecord() async {
    bool s = RecordMp3.instance.stop();
    if (s) {
      setState(() {
        isComplete = true;
        isRecording = false;
      });
      showLoading();
      var res = await homeworkCubit.uploadRecord('records_' + DateTime.now().toString()+'.mp3', recordFilePath);
      hideLoading();
      if (res != null) {
        setState(() {
          grQuestions.questions[0].answer.content = res.path;
          grQuestions.questions[0].answer.record = recordFilePath;
        });
      }
    }
  }

  void resumeRecord() {
    bool s = RecordMp3.instance.resume();
    if (s) {
      setState(() {});
    }
  }

  void play() async {
    if(grQuestions.questions[0].answer.content != null && grQuestions.questions[0].answer.content.isNotEmpty){
      setState(() {
        isPlaying = true;
      });
      await  audioPlayer.play(grQuestions.questions[0].answer.content, isLocal: false);
    }
  }

  void stopPlayback() async {
    if (recordFilePath != null && File(recordFilePath).existsSync()) {
      await audioPlayer.stop();
      setState(() {
        isPlaying = false;
      });
    }
  }

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    var now = DateTime.now().toString();
    return sdPath + "/audio_$now.mp3";
  }

  onRecord() {
    if (isRecording) {
      stopRecord();
    } else {
      startRecord();
    }
  }

  onPlayback() {
    if (isPlaying) {
      stopPlayback();
    } else {
      play();
    }
  }

  deleteFile() async {
    if (isPlaying) {
      await audioPlayer.stop();
    }
   try{
     var file = File(recordFilePath);
     if(file != null  && await  file.exists()){
       await file.delete();
     }
   }catch(e){

   }
    setState(() {
      grQuestions.questions[0].answer.record = null;
      grQuestions.questions[0].answer.content = null;
      isPlaying = false;
      isComplete = false;
      recordFilePath = null;
      _start = 0;
      duration = Duration();
      durationRecord = Duration();
    });
  }
}
