import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:gstudent/training/views/component/record_control.dart';

import '../../../api/dtos/Training/vocab/vocab.dart';

class TranningRecordPage extends StatefulWidget {
  Function(AnswerVocab answerVocab) complete;
  String subeng = "";
  String subviet = "";
  AnswerVocab answer = AnswerVocab();
  Vocab word = Vocab();
  TranningRecordPage(
      {Key key,
        this.subeng,
        this.subviet,
        this.word,
        this.answer,
        this.complete})
      : super(key: key);
  @override
  _TranningRecordPageState createState() => _TranningRecordPageState(
      subeng: subeng,
      subviet: subviet,
      word: word,
      answer: answer,
      complete: complete);
}

class _TranningRecordPageState extends State<TranningRecordPage> {
  Function(AnswerVocab answerVocab) complete;
  String subeng = "";
  String subviet = "";
  String path = "";
  String wordStart;
  String wordEnd;
  bool isPlaying = false;
  bool isRecord = false;
  FlutterTts flutterTts = FlutterTts();
  AnswerVocab answer = AnswerVocab();
  TextEditingController textMesaage = TextEditingController();
  Vocab word = Vocab();
  _TranningRecordPageState(
      {this.subeng, this.subviet, this.word, this.answer, this.complete});

  Future _speak() async {
    await flutterTts.setSharedInstance(true);
    await flutterTts
        .setIosAudioCategory(IosTextToSpeechAudioCategory.playAndRecord, [
      IosTextToSpeechAudioCategoryOptions.allowBluetooth,
      IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
      IosTextToSpeechAudioCategoryOptions.mixWithOthers
    ]);
    await flutterTts.setLanguage("en-US");
    await flutterTts.setVolume(1.0);

    await flutterTts.setPitch(1.0);

    await flutterTts.isLanguageAvailable("en-US");

    try {
      var result = await flutterTts.speak(word.vocabOrWord);
      if (result == 1)
        setState(() {
          isPlaying = true;
        });
    } catch (e) {
      print(e);
    }
  }

  void typeWord() {
    if (word != null && word.vocabOrWord != null) {
      var str = subeng.toLowerCase();
      var wordtype = str.split(word.vocabOrWord.toLowerCase().trim());
      if (wordtype[0] != null && wordtype[0].isNotEmpty) {
        wordStart = wordtype[0].capitalize();
      }

      wordEnd = wordtype.skip(1).join(' ');
    }
  }

  @override
  void initState() {
    super.initState();

    flutterTts.setStartHandler(() {
      setState(() {
        isPlaying = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
      });
    });

    flutterTts.setErrorHandler((err) {
      setState(() {
        print("error occurred: " + err);
        isPlaying = false;
      });
    });
    typeWord();
  }

  @override
  Widget build(BuildContext context) {
    return word != null
        ? Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.subtitle1,
                children: [
                  if (word != null)
                    if (wordStart != null)
                      TextSpan(
                          text: wordStart,
                          style: TextStyle(color: Colors.black54,fontSize: 16)),
                  TextSpan(
                    text: " ${word.vocabOrWord.toLowerCase()}",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                        color: Colors.blue,fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400),
                  ),
                  WidgetSpan(
                    child: Padding(
                      padding:
                     EdgeInsets.zero,
                      child: IconButton(
                        icon: Icon(Icons.volume_up_outlined),
                        color: Colors.deepPurple,
                        onPressed: () => _speak(),
                      ),
                    ),
                  ),
                  if (wordEnd != null)
                    TextSpan(
                        text: wordEnd,
                        style: TextStyle(color: Colors.black54, fontSize: 16,fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400))
                ],
              ),
            ),
            SizedBox(height: 12),
            Text(subviet,
                style:
                TextStyle(fontSize: 14, color: Colors.black54,fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400)),
            SizedBox(height: 12),
            playRecord()
          ]),
    )
        : Container();
  }

  playRecord() => Wrap(
    children: [
      Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/4,
            child: RecordSpeedToText(
              callback: (val) => setState(
                    () {
                      isRecord = !isRecord;
                  answer.vocabOrWord = word.vocabOrWord;
                  answer.answer = val;
                  answer.questionId = word.id;
                  if (val.trim() == word.vocabOrWord.trim()) {
                    answer.istrue = true;
                  } else {
                    answer.istrue = false;
                  }
                  complete(answer);
                },
              ),
            ),
          )),
      Center(
        child: Text(
         isRecord ? 'Press again to finish answer'  : 'Press to record',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400),
        ),
      ),
    ],
  );
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}