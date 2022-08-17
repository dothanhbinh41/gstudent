
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AudioRecorder extends StatefulWidget {
  final String path;
  final VoidCallback onStop;
  final Function(String) completeRecord;

  const AudioRecorder({this.path, this.onStop, this.completeRecord});

  @override
  AudioRecorderState createState() => AudioRecorderState();
}

class AudioRecorderState extends State<AudioRecorder> {
  bool isRecordingAudio = false;
  bool isPaused = false;
  String textRecord;
  bool isListening = false;
  stt.SpeechToText _speech;
  int recordDuration = 0;
  Timer timer;

  @override
  void initState() {
    isRecordingAudio = false;
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildRecordStopControl(),
            if (isRecordingAudio) const SizedBox(width: 20),
            buildPauseResumeControl(),
            if (isRecordingAudio) const SizedBox(width: 20),
            buildText(),
          ],
        ),
      ),
    );
  }

  Widget buildRecordStopControl() {
    Icon icon;

    if (isRecordingAudio || isPaused) {
      icon = Icon(Icons.stop, color: Colors.red, size: 30);
    } else {
      icon = Icon(Icons.mic, color: Colors.deepPurple, size: 30);
    }

    return FloatingActionButton(
      heroTag: "btn2",
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: icon,
      onPressed: () {
        isRecordingAudio ? stop() : start();
      },
    );
  }

  Widget buildPauseResumeControl() {
    if (!isRecordingAudio && !isPaused) {
      return const SizedBox.shrink();
    }

    Icon icon;

    if (!isPaused) {
      icon = Icon(Icons.pause, color: Colors.red, size: 30);
    } else {
      icon = Icon(Icons.play_arrow, color: Colors.red, size: 30);
    }

    return FloatingActionButton(
      heroTag: "btn3",
      child: icon,
      onPressed: () {
        isPaused ? resume() : pause();
      },
    );
  }

  Widget buildText() {
    if (isRecordingAudio || isPaused) {
      return buildTimer();
    }

    return Text("");
  }

  Widget buildTimer() {
    final String minutes = formatNumber(recordDuration ~/ 60);
    final String seconds = formatNumber(recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: TextStyle(color: Colors.red),
    );
  }

  String formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0' + numberStr;
    }

    return numberStr;
  }

  Future<void> start() async {
    try {
      if (await Record.hasPermission()) {
        await Record.start(path: widget.path);
        await _listen();
        // await toggleRecording();
        bool isRecording = await Record.isRecording();
        setState(() {
          isRecordingAudio = isRecording;
          recordDuration = 0;
        });

        startTimer();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> stop() async {
    timer?.cancel();
    await _listen();
    // await toggleRecording();

    setState(() => isRecordingAudio = false);

    widget.onStop();
  }

  Future<void> pause() async {
    timer?.cancel();
    await Record.pause();

    setState(() => isPaused = true);
  }

  Future<void> resume() async {
    startTimer();
    await Record.resume();

    setState(() => isPaused = false);
  }

  void startTimer() {
    const tick = const Duration(seconds: 1);

    timer?.cancel();

    timer = Timer.periodic(tick, (Timer t) {
      setState(() => recordDuration++);
    });
  }

  Future _listen() async {
    if (!isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            textRecord = val.recognizedWords;
            print(textRecord);
            widget.completeRecord(textRecord);
          }),
        );
      }
    } else {
      setState(() => isListening = false);
      _speech.stop();
    }
  }

// Future toggleRecording() async => await SpeechApi.toggleRecording(
//     onResult: (text) => setState(() => this.textRecord = text),
//     onListening: (isListening) {
//       setState(() => this.isListening = isListening);
//       Future.delayed(Duration(seconds: 1), () async {
//         // Helpers.scanText(textRecord);
//         print(textRecord);
//       });
//       // callback(textRecord);
//     });
}
