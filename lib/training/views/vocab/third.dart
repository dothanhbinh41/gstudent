import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/common/controls/text_painting.dart';
import 'package:gstudent/training/cubit/vocab_cubit.dart';
import 'package:gstudent/training/views/inventory_training_speed.dart';
import 'package:gstudent/training/views/model/VocabNavigationParams.dart';
import 'package:gstudent/training/views/vocab/introduce_word.dart';
import 'package:gstudent/training/views/vocab/record_view.dart';
import 'package:http/http.dart';
import 'package:video_player/video_player.dart';

import '../../../api/dtos/Training/vocab/subtitle.dart';
import '../../../api/dtos/Training/vocab/vocab.dart';

class VocabThirdChallenge extends StatefulWidget {
  int page;
  int classroomId;
  int lesson;
  int testId;
  int userClanId;
  List<Vocab> listWords;
  String folderName;

  VocabThirdChallenge(
      {this.listWords,
      this.page,
      this.lesson,
      this.folderName,
      this.classroomId,
      this.userClanId,
      this.testId});

  @override
  State<StatefulWidget> createState() => VocabThirdChallengeState(
        classroomId: this.classroomId,
        lesson: this.lesson,
        testId: this.testId,
        page: 3,
        listWords: this.listWords,
        folderName: this.folderName,
        userClanId: this.userClanId,
      );
}

class VocabThirdChallengeState extends State<VocabThirdChallenge> {
  List<Vocab> listWords;
  int classroomId;
  int lesson;
  int testId;
  int page;
  int userClanId;
  String folderName;

  VocabThirdChallengeState(
      {this.listWords,
      this.page,
      this.lesson,
      this.classroomId,
      this.folderName,
      this.userClanId,
      this.testId});

  List<AnswerVocab> answers = [];
  VideoPlayerController _videoPlayerController;

  bool isSubmit = false;
  bool isFinish = false;

  AnswerVocab answer = AnswerVocab();
  AnswerVocab answer1 = AnswerVocab();
  Vocab word = Vocab();
  List<Subtitle> subtitlesEng;
  List<Subtitle> subtitlesViet;

  String subeng = "";
  String subviet = "";
  int step = 0;
  bool isFinishIntroduce = false;
  int index = 0;
  bool isRecord = false;
  int indexWord = 0;
  TextEditingController answerController = TextEditingController();
  List<QuestionVocab> maps = [];

  // SubmitVocabResultDto result = SubmitVocabResultDto();
  int timeStart = 0;
  List<Vocab> words = [];
  int answerRight = 0;
  int totalQs = 0;
  VocabCubit cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of<VocabCubit>(context);
    timeStart = DateTime.now().millisecondsSinceEpoch;
    loadData();
  }

  loadData() async {
    Future.delayed(Duration.zero, () async {
      totalQs = listWords.length;
      listWords.shuffle();
      for (var i = 0; i < listWords.length; i++) {
        setState(() {
          maps.add(QuestionVocab(question: [listWords[i]]));
        });
      }

      if (maps.length > 0) {
        await reloadVideo();
      }
    });
  }

  Future reloadVideo() async {
    if (maps[index] != null) {
      setState(() {
        words = maps[index].question;
      });
      await loadDataForWord(words[indexWord], true);
    }
  }

  Future loadDataForWord(Vocab newWord, bool autoPlay) async {
    if (newWord == null) {
      return;
    }
    if (!mounted) return;
    setState(() {
      word = newWord;
    });
    var se = await loadSubtitle("E_Sub/" + newWord.engsub);
    var sv = await loadSubtitle("V_Sub/" + newWord.vietsub);
    if (!mounted) return;
    setState(() {
      subtitlesEng = se;
      subtitlesViet = sv;
    });
    await setControllerPlayer(newWord.video, autoPlay);
  }

  void finishTime() {
    var time = DateTime.now().millisecondsSinceEpoch - timeStart;
  }

  Future setControllerPlayer(String url, bool autoPlay) async {
    _onControllerChange(url, autoPlay);
  }

  void onErrorLoading() async {
    if (indexWord == words.length - 1) {
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        isFinishIntroduce = true;
        indexWord = -1;
      });
    } else {
      setState(() {
        indexWord++;
        isFinishIntroduce = false;
      });

      await loadDataForWord(words[indexWord], true);
    }
  }

  void _initController(String link, bool autoPlay) {
    print(link);
    _videoPlayerController = VideoPlayerController.network(link)
      ..initialize().then((_) {
        _videoPlayerController.setVolume(1.0);
        _videoPlayerController.addListener(onVideoPlay);
        _videoPlayerController.addListener(() {
          if (_videoPlayerController.value.hasError) {
            print(
                "------------------------ ERROR -----------------------------");
            print(_videoPlayerController.value.errorDescription);
            onErrorLoading();
            // setState(() {
            //   isFinishIntroduce = true;
            //   indexWord = -1;
            // });
          }
          if (_videoPlayerController.value.isInitialized) {
            print('init');
          }
          if (_videoPlayerController.value.isBuffering) {
            print('buffering');
          }
        });
        _videoPlayerController.setLooping(false);
        if (_videoPlayerController.value != null) {
          setSubtitle(_videoPlayerController.value.position);
          if (autoPlay == true) {
            _videoPlayerController.play();
          }
        }
      });
  }

  Future<void> _onControllerChange(String link, bool autoPlay) async {
    if (_videoPlayerController == null) {
      _initController(link, autoPlay);
    } else {
      final oldController = _videoPlayerController;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        oldController.removeListener(onVideoPlay);
        await oldController.dispose();

        _initController(link, autoPlay);
      });

      setState(() {
        _videoPlayerController = null;
      });
    }
  }

  Future submit() async {
    answerRight =
        answers.where((element) => element.istrue == true).toList().length;
    var time = DateTime.now().millisecondsSinceEpoch - timeStart;

    VocabNavigationParams params = VocabNavigationParams(
        answers: this.answers,
        answerRight: this.answerRight,
        time: time,
        totalQs: this.totalQs);
    Navigator.of(context).pop(params);
  }

  void setSubtitle(Duration time) async {
    if (subtitlesEng != null) {
      var currentSubtitleEng = subtitlesEng.where(
          (e) => e.startTime <= time.inSeconds && time.inSeconds <= e.endTime);

      if (currentSubtitleEng.length == 0) {
        setState(() {
          subeng = "";
        });
      } else {
        setState(() {
          subeng = currentSubtitleEng.first.sub;
        });
      }
    }

    if (subtitlesViet != null) {
      var currentSubtitleViet = subtitlesViet.where(
          (e) => e.startTime <= time.inSeconds && time.inSeconds <= e.endTime);
      if (currentSubtitleViet.length == 0) {
        setState(() {
          subviet = "";
        });
      } else {
        setState(() {
          subviet = currentSubtitleViet.first.sub;
        });
      }
    }
  }

  void onVideoPlay() async {
    if (_videoPlayerController?.value == null) {
      return;
    }

    if (_videoPlayerController == null ||
        !_videoPlayerController.value.isInitialized ||
        _videoPlayerController.value.isBuffering ||
        _videoPlayerController.value.position.inSeconds == 0) {
      return;
    }

    if (_videoPlayerController.value.position ==
        _videoPlayerController.value.duration) {
      setState(() {
        isFinishIntroduce = true;
      });

      // if (indexWord == words.length - 1) {
      //   await Future.delayed(Duration(seconds: 2));
      //   if (!isNext) {
      //     setState(() {
      //       isFinishIntroduce = true;
      //       indexWord = -1;
      //     });
      //   }
      // }
      // else {
      //   if (!isNext) {
      //     setState(() {
      //       indexWord++;
      //       isFinishIntroduce = false;
      //     });
      //
      //     await loadDataForWord(words[indexWord], true);
      //   }
      // }
    }
  }

  Future<List<Subtitle>> loadSubtitle(String name) async {
    String s;
    try {
      var uri = Uri.parse(
          'https://edutalk-cdn.sgp1.digitaloceanspaces.com/Edutalk/basic/$name');

      var res = await get(uri, headers: <String, String>{
        'Content-Type': 'text/html; charset=utf-8'
      });
      if (res.statusCode == 200) {
        s = utf8.decode(res.bodyBytes)?.trim();

        final regex = RegExp(
          "(([0-9]+)[\r\n]+([0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3}) --> ([0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3})[\r\n]+(.+))",
          caseSensitive: true,
          multiLine: true,
        );
        var m = regex.allMatches(s);
        if (m.length > 0) {
          var list = m
              .map((e) =>
                  Subtitle.fromString(e.group(3), e.group(4), e.group(5)))
              .toList();
          return list;
        }
      }
    } catch (e) {
      print(e);
    }

    return [];
  }

  @override
  void dispose() async {
    // TODO: implement dispose
    super.dispose();
    answerController.dispose();
    if (_videoPlayerController != null) {
      _videoPlayerController.removeListener(onVideoPlay);
      await _videoPlayerController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
              top: 0,
              right: 0,
              left: 0,
              bottom: 0,
              child: Image(
                image: AssetImage('assets/game_bg_arena.png'),
                fit: BoxFit.fill,
              )),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
            child: SafeArea(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 56,
                        child: Stack(
                          children: [
                            Positioned(
                              height: 48,
                              bottom: 0,
                              left: 8,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Image(
                                  image: AssetImage(
                                      'assets/images/game_button_back.png'),
                                ),
                              ),
                            ),
                            Container(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  "LUYỆN TỪ VỰNG",
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'SourceSerifPro'),
                                ))
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(24, 0, 24, 0),
                        child: Image(
                          image: AssetImage('assets/images/ellipse.png'),
                        ),
                      ),
                      (_videoPlayerController == null)
                          ? Container()
                          : playVideo(),
                      SizedBox(height: 16),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.fromLTRB(24, 8, 24, 8),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: HexColor("#fdf8f0"),
                            border: Border.all(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(-1, -1),
                                  color: Colors.grey.shade400)
                            ]),
                        child:
                            (word != null && word.meaning != null) && step == 0
                                ? TranningIntroducePage(
                                    word: word,
                                    key: GlobalKey<ScaffoldState>(),
                                    subeng: subeng,
                                    subviet: subviet,
                                  )
                                : content(context),
                      ),
                      Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: [
                            Positioned(
                              child: GestureDetector(
                                onTap: () async {
                                  var item = await showDialog(
                                    context: context,
                                    builder: (context) => InventoryTraining(
                                      userClanId: userClanId,
                                      type: InvenTraining.vocab,
                                    ),
                                  );
                                  if (item != null && item == true) {
                                    var text = word.vocabOrWord.substring(0, 3);

                                    answerController.text = text;
                                  }
                                },
                                child: Container(
                                  width: 100,
                                  height: 60,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        right: 0,
                                        left: 0,
                                        top: 0,
                                        bottom: 16,
                                        child: Image(
                                          image: AssetImage(
                                              'assets/images/game_inventory_icon.png'),
                                        ),
                                      ),
                                      Positioned(
                                          bottom: 8,
                                          right: 0,
                                          left: 0,
                                          child: Center(
                                            child: textpaintingBoldBase(
                                                'Vật phẩm',
                                                16,
                                                Colors.white,
                                                Colors.black,
                                                2),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                              top: 8,
                              right: 0,
                              bottom: 8,
                            )
                          ],
                        ),
                      ),
                      isFinishIntroduce
                          ? GestureDetector(
                              onTap: () => nextQuestion(),
                              child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                                  height: 56,
                                  child: Center(
                                    child: GestureDetector(
                                        child: ButtonYellowSmall(isFinish == true
                                            ? 'Kết quả'
                                            : (isSubmit == true
                                                ? 'Nộp bài'
                                                : 'Tiếp tục'))),
                                  )),
                            )
                          : Container()
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  playVideo() => GestureDetector(
        onTap: () {
          if (isFinishIntroduce == false) {
            return;
          }

          if (_videoPlayerController.value.position ==
              _videoPlayerController.value.duration) {
            reloadVideo();
          } else {
            setState(() {
              if (_videoPlayerController.value.isPlaying) {
                _videoPlayerController.pause();
              } else {
                _videoPlayerController.play();
              }
            });
          }
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(24, 8, 24, 8),
          height: 160,
          child: _videoPlayerController.value == null
              ? Container()
              : Center(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: VideoPlayer(_videoPlayerController))),
        ),
      );

  content(BuildContext context) {
    return ((step + 1) % 3) == 0
        ? TranningRecordPage(
            complete: (a) => setState(() {
              answer = a;
              answers.add(answer);

              isRecord = true;
            }),
            word: word,
            answer: answer1,
            key: GlobalKey<ScaffoldState>(),
            subeng: subeng,
            subviet: subviet,
          )
        : contentTypeWord();
  }

  contentTypeWord() {
    var arrs = subeng.isNotEmpty
        ? subeng.toLowerCase().split(word.vocabOrWord.trim().toLowerCase())
        : ["a", "b", "c"];
    var lst = List<String>();
    for (int i = 0; i < arrs.length; i++) {
      if (i == arrs.length - 1) {
        lst.add(arrs[i]);
        continue;
      }
      lst.add(arrs[i]);
      lst.add(word.vocabOrWord);
    }
    var index = lst.indexOf(word.vocabOrWord);
    return Container(
      child: ListView(shrinkWrap: true, children: [
        RichText(
          text: TextSpan(children: [
            if (lst.length > 0)
              for (int i = 0; i < lst.length; i++)
                if (i == index)
                  WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Container(
                        child: Container(
                            margin: EdgeInsets.only(left: 8, right: 8),
                            height: 24,
                            width: word.vocabOrWord != null
                                ? word.vocabOrWord.length * 10.0
                                : 100,
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: answerController,
                              onChanged: (text) {
                                setState(() {
                                  answer.answer = text;
                                  answer.vocabOrWord = word.vocabOrWord;
                                  answer.questionId = word.id;
                                  if (text.trim() == word.vocabOrWord.trim()) {
                                    answer.istrue = true;
                                  } else {
                                    answer.istrue = false;
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                              ),
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: 'SourceSerifPro',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14),
                            )),
                      ))
                else
                  TextSpan(
                      text: lst[i],
                      style: TextStyle(
                          color: Colors.black54,
                          fontFamily: 'SourceSerifPro',
                          fontWeight: FontWeight.w400))
          ]),
        ),
        SizedBox(height: 8),
        Text(subviet,
            style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontFamily: 'SourceSerifPro',
                fontWeight: FontWeight.w400)),
      ]),
    );
  }

  nextQuestion() async {
    if (step == 0) {
      setState(() {
        step++;
      });
      reloadVideo();
    } else {
      if (step == 2) {
        if (answer.answer != null) {
          answers.add(answer);
          answer = AnswerVocab();
          answerController.clear();
        }
        if (maps.length == 1) {
          submit();
          return;
        } else {
          if (index == maps.length - 1) {
            submit();
            return;
          }
        }
        setState(() {
          step = 0;
          isFinishIntroduce = false;
          index++;
        });
        reloadVideo();
      } else {
        if (answer.answer != null) {
          answers.add(answer);
          answer = AnswerVocab();
          answerController.clear();
        }
        setState(() {
          step++;
        });
        reloadVideo();
      }
    }
  }
}
