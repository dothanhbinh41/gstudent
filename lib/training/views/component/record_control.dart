import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class RecordSpeedToText extends StatefulWidget {
  Function(String) callback;

  RecordSpeedToText({this.callback, Key key}) : super(key: key);

  @override
  _RecordSpeedToTextState createState() => _RecordSpeedToTextState(callback: callback);
}

class _RecordSpeedToTextState extends State<RecordSpeedToText> {
  Function(String) callback;

  _RecordSpeedToTextState({this.callback});

  stt.SpeechToText _speech;
  bool isListening = false;
  String textRecord = "";
  String localeId;
  bool isAvailable = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    _speech =   stt.SpeechToText();
    bool available =  await _speech.initialize(
      onStatus: (val) {
        print('status record');
        print(val);
        if(val == "notListening" || val == "done"){
          setState(() {
            isListening = false;
          });
        }
      },
      onError: (val) {
       if(mounted){
         setState(() {
           isListening = false;
         });
       }
      },
    );
    setState(() {
      isAvailable = available;
    });
    // var locale = await _speech.systemLocale();
    // setState(() {
    //   localeId = locale.localeId;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          height: 48,
          child: Text(
            textRecord,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          )),
      backgroundColor: Colors.transparent,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: isListening,
        endRadius: 75,
        showTwoGlows: true,
        glowColor: Theme.of(context).primaryColor,
        child: FloatingActionButton(
          child: Icon(isListening ? Icons.pause : Icons.mic, size: 36),
          onPressed: () => toggleRecording(),
        ),
      ),
    );
  }

  Future toggleRecording() async {
    if (!isListening) {
      if (isAvailable) {
        setState(() => isListening = true);
        _speech.listen(
          onResult: (val) {
            if (mounted) {
              setState(() {
                isListening = false;
                textRecord = val.recognizedWords;
                print(textRecord);
                // _speech.stop();
                // if (val.hasConfidenceRating && val.confidence > 0) {
                //   _confidence = val.confidence;
                // }
              });
            }
          },
          localeId: "en-GB"
        );
      }
    } else {
      setState(() => isListening = false);
      callback(textRecord);
      _speech.stop();
    }
  }
}
