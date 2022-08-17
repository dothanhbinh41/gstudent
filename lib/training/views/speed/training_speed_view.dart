import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gstudent/api/dtos/Authentication/user_info.dart';
import 'package:gstudent/api/dtos/Exam/GroupQuestionExam.dart';
import 'package:gstudent/api/dtos/Training/speed/message.dart';
import 'package:gstudent/api/dtos/Training/speed/user_leader_board.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/running_text.dart';
import 'package:gstudent/common/controls/text_outline.dart';
import 'package:gstudent/common/controls/text_painting.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/common/utils.dart';
import 'package:gstudent/main.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../inventory_training_speed.dart';

class ParamResultSpeed {
  int time;
  int total;
  int top;
  int correct;
  double average;

  ParamResultSpeed(
      {this.time, this.total, this.correct, this.top, this.average});
}

class TrainingSpeedView extends StatefulWidget {
  int courseStudentId;
  int userClanId;
  int classroomId;
  int exp;

  TrainingSpeedView(
      {this.courseStudentId, this.classroomId, this.userClanId, this.exp});

  @override
  State<StatefulWidget> createState() => TrainingSpeedViewState(
      exp: this.exp,
      courseStudentId: this.courseStudentId,
      classroomId: this.classroomId,
      userClanId: this.userClanId);
}

class TrainingSpeedViewState extends State<TrainingSpeedView> {
  int courseStudentId;
  int classroomId;
  int userClanId;
  int exp;

  TrainingSpeedViewState(
      {this.courseStudentId, this.classroomId, this.userClanId, this.exp});

  ApplicationSettings settings;
  User user;
  List<UserLeaderBoard> leaderBoards = List<UserLeaderBoard>();
  PracticeQuestion qs;
  PracticeAnswer qsAnswer;
  PracticeGroupQuestion currentGqs;
  TextEditingController textEditingController;
  Socket socket;
  int correct = 0;
  int wrong = 0;
  int milisec = 0;
  int top = 0;
  Timer _timer;
  Timer _timerCooldown;
  int _start = 0;
  DateTime now;
  DateTime timeStart;
  List<int> listAnswerTime = [];
  bool usingStopTime = false;
  int timeCooldown = 0;
  bool isWaiting = true;
  int totalQs = 0;
  bool isSayHello = false;
  bool isTextRunningPerQuestionDone = false;

  List<String> messHello = [
    "Chào người anh em thiện lành",
    "Ơn giời cậu đây rồi",
    "Người lạ ơi",
    "Chào nhau một tiếng vội gì bạn ơi",
    "Alo! Alo"
  ];

  List<String> messHello2 = [
    "Khỏe khum bạn?",
    "Hôm nay bạn có mục tiêu gì khum? ",
    "Mục tiêu là chinh phục câu đặc biệt nhaaaa",
    "Cho mình xin in4 bạn ơi",
    "Không chơi hay chơi chơi hay không chơi nói một lời"
  ];

  List<String> messStartQs = [
    "Bắt đầu rồi kìa",
    "Đến đây",
    "Ây, câu đầu tiên thôi mà",
    "Tới công chiện rồi",
    "Tấm chiếu mới à bạn"
  ];

  List<String> messQs3 = [
    "Câu này hay đấy",
    "Nhanh lên chút bạn ơi",
    "Mình sắp tới câu đặc biệt rồi nè",
    "Cố lên người anh em",
    "Yaas, đơn giản",
    "Được 20 câu chưa bạn ơiii",
    "Đừng bỏ cuộc nha bạn mình",
    "Khá đấy",
    "Xu cà na quá",
    "Good job, amazing em",
    "Ủa? Câu này là sao?"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textEditingController = TextEditingController();
    settings = GetIt.instance.get<ApplicationSettings>();
    timeStart = DateTime.now();
    setState(() {
      var nowSecond = DateTime.now().second;
      if (nowSecond <= 30) {
        timeCooldown = 30 - (nowSecond + 1);
      } else {
        timeCooldown = 60 - (nowSecond + 1);
      }
    });
    startTimeCooldown();
    setupSocket();
  }

  @override
  void dispose() {
    _timer?.cancel();
    socket?.disconnect();
    socket?.dispose();
    // TODO: implement dispose
    super.dispose();
    // _timer?.cancel();
    // socket?.disconnect();
    // socket?.dispose();
  }

  void startTimeCooldown() {
    const oneSec = const Duration(seconds: 1);
    _timerCooldown = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (timeCooldown == 0) {
          timer.cancel();
        } else {
          if (mounted) {
            setState(() {
              timeCooldown--;
            });
          }
        }
      },
    );
  }

  void setupSocket() async {
    var data = await settings.getCurrentUser();
    setState(() {
      user = data.userInfo;
    });

    socket = io(
        'ws://socket.edutalk.edu.vn',
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .build());
    socket.connect();
    socket.onConnectError((data) {
      toast(context, 'Đã có lỗi xảy ra!');
      Navigator.of(context).pop();
      return;
    });
    socket.emit('join-speech-room', [
      {
        'user': {
          "id": user.id,
          "name": user.name,
          "email": user.email,
          "access_token": user.accessToken,
          "course_student_id": this.courseStudentId,
          "classroom_id": this.classroomId,
          "exp": this.exp
        },
      }
    ]);
    socket.on('join-speech-room-response', (data) {
      print(data);
      toast(context, data['message'] + '. Xin hãy chờ đến câu hỏi tiếp theo!');
    });
    socket.on('get-question-response', (data) {
      var a = jsonEncode(data['quesion']);
      print(a);
      setState(() {
        totalQs++;
        isWaiting = false;
        usingStopTime = false;
        qsAnswer = null;
        leaderBoards = null;
        now = DateTime.now();
        currentGqs = PracticeGroupQuestion.fromJson(
            jsonDecode(jsonEncode(data['quesion']['practice_group_question'])));
        qs = PracticeQuestion.fromJson(jsonDecode(a));
        print('qs practiceId : ' +currentGqs.practiceId.toString());
        print('qs id : ' +currentGqs.id.toString());
        print('groupQuestionId : '+qs.groupQuestionId.toString());
        print('id group Question  : '+qs.id.toString());
      });
      startTimer(25);
    });
    socket.on('sent-top-leader', (data) {
      var users = topLeaderFromJson(jsonEncode(data));
      var ld = users.topLeader.length > 5
          ? users.topLeader.take(5).toList()
          : users.topLeader;
      setState(() {
        leaderBoards = ld;
      });
      if (leaderBoards.isNotEmpty && leaderBoards.first.id == user.id) {
        top++;
      }
    });

    socket.on('sent-top-quick', (data) {
      var a = jsonEncode(data);
      if (leaderBoards == null) {
        leaderBoards = List<UserLeaderBoard>();
      }
      var users = topQuickFromJson(jsonEncode(data));
      var ld = users.topquick.length > 5
          ? users.topquick.take(5).toList()
          : users.topquick;
      // ld.sort((a, b) => b.time.compareTo(a.time));
      setState(() {
        leaderBoards.add(ld.last);
      });
      if (leaderBoards
          .where((element) => element.courseStudentId < 100)
          .isNotEmpty) {
        if (totalQs <= 1) {
          if (totalQs == 1 && isSayHello == true) {
            if (leaderBoards
                .where((element) =>
                    element.courseStudentId < 100 && element.mess == null)
                .isNotEmpty) {
              setState(() {
                leaderBoards
                        .where(
                            (element) =>
                                element.courseStudentId < 100 &&
                                element.mess == null)
                        .first
                        .mess =
                    messStartQs[Random().nextInt(messStartQs.length - 1)];
              });
            }
          }
          if (leaderBoards
              .where((element) =>
                  element.courseStudentId < 100 && element.mess == null)
              .isNotEmpty) {
            setState(() {
              leaderBoards
                  .where((element) =>
                      element.courseStudentId < 100 && element.mess == null)
                  .first
                  .mess = messHello[Random().nextInt(messHello.length - 1)];
            });
          }
        }
        if (totalQs >= 3) {
          if (leaderBoards
              .where((element) =>
                  element.courseStudentId < 100 && element.mess == null)
              .isNotEmpty) {
            setState(() {
              leaderBoards
                  .where((element) =>
                      element.courseStudentId < 100 && element.mess == null)
                  .first
                  .mess = messQs3[Random().nextInt(messQs3.length - 1)];
            });
          }
        }
      }
    });

    socket.on('sent-message-response', (data) {
      var message = messageFromJson(jsonEncode(data));
    });
  }

  void startTimer(int sec) {
    if (sec == null) {
      _start = 25;
    } else {
      _start = sec;
    }
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          timer.cancel();
          if (qsAnswer == null) {
            wrong++;
          }
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
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
            child:  SafeArea(
                top: true,
                bottom: false,
                right: false,
                left: false,
                child: Column(
                  children: [
                    Expanded(
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
                                          if (wrong > 0 || correct > 0) {
                                            var totalTime = DateTime.now()
                                                .millisecondsSinceEpoch -
                                                timeStart.millisecondsSinceEpoch;
                                            var averageTime = 0;
                                            listAnswerTime.forEach((element) {
                                              averageTime = averageTime + element;
                                            });
                                            var totalAverage = averageTime /
                                                listAnswerTime.length;
                                            var param = ParamResultSpeed(
                                                time: totalTime,
                                                total: wrong + correct,
                                                correct: correct,
                                                top: top,
                                                average: totalAverage);
                                            Navigator.of(context).pop(param);
                                          } else {
                                            Navigator.of(context).pop();
                                          }
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
                                          "LUYỆN TỐC ĐỘ",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'SourceSerifPro'),
                                        ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(36, 0, 36, 0),
                                child: Image(
                                  image: AssetImage('assets/images/ellipse.png'),
                                ),
                              ),
                              Container(
                                height: 60,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: () async {
                                          var item = await showDialog(
                                            context: context,
                                            builder: (context) =>
                                                InventoryTraining(
                                                  userClanId: userClanId,
                                                  type: InvenTraining.speed,
                                                ),
                                          );
                                          if (_start > 0) {
                                            if (item != null) {
                                              usingItem(item);
                                            }
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
                                                    child:
                                                    textpainting('Vật phẩm'),
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        _start.toString(),
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontFamily: 'SourceSerifPro',
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              leaderBoard(),
                              Opacity(
                                opacity: 0.5,
                                child: Container(
                                  height: 2,
                                  color: Colors.black,
                                  margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
                                ),
                              ),
                              Container(
                                  child: Column(
                                    children: [
                                      currentGqs != null
                                          ? Container(
                                        margin:
                                        EdgeInsets.fromLTRB(16, 4, 16, 4),
                                        child: Text(
                                          currentGqs.description != null
                                              ? currentGqs.description
                                              : '',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'SourceSerifPro',
                                              color: HexColor("#a12525"),
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.left,
                                        ),
                                      )
                                          : Container(),
                                      qs != null
                                          ? Container(
                                        margin:
                                        EdgeInsets.fromLTRB(16, 4, 16, 4),
                                        child: qs.title != null &&
                                            qs.title.isNotEmpty
                                            ? textQuestion(qs.title)
                                            : Text(''),
                                      )
                                          : Container(),
                                      qs != null
                                          ? ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        padding:
                                        EdgeInsets.fromLTRB(16, 0, 16, 8),
                                        shrinkWrap: true,
                                        itemCount: qs.practiceAnswers.length,
                                        itemBuilder: (context, index) {
                                          return Opacity(
                                            opacity: 0.7,
                                            child: GestureDetector(
                                              onTap: () => answerClicked(index),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: _start != 0
                                                        ? (qs.practiceAnswers
                                                        .where((element) =>
                                                    element.isSelected ==
                                                        true)
                                                        .isEmpty
                                                        ? HexColor(
                                                        "#9c7f6a")
                                                        : qs.practiceAnswers.where((element) => element.isSelected == true).isNotEmpty &&
                                                        qs.practiceAnswers.where((element) => element.isSelected == true).first ==
                                                            qs.practiceAnswers[
                                                            index]
                                                        ? Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                        : HexColor(
                                                        "#9c7f6a"))
                                                        : qs.practiceAnswers[index].content
                                                        .contains('#')
                                                        ? (qs.practiceAnswers
                                                        .where((element) =>
                                                    element.isSelected ==
                                                        true)
                                                        .isNotEmpty &&
                                                        qs.practiceAnswers
                                                            .where((element) => element.isSelected == true)
                                                            .first
                                                            .content
                                                            .split('#')
                                                            .join('')
                                                            .trim() ==
                                                            qs.correctAnswers.trim() &&
                                                        qs.practiceAnswers[index].content.split('#').join('').trim() == qs.correctAnswers.trim()
                                                        ? HexColor("#00c55a")
                                                        : (qs.practiceAnswers[index].content.split('#').join('').trim() == qs.correctAnswers.trim() ? HexColor("#00c55a") : (qs.practiceAnswers[index].isSelected == true ? Colors.red.shade200 : HexColor("#9c7f6a"))))
                                                        : (qs.practiceAnswers.where((element) => element.isSelected == true).isNotEmpty && qs.practiceAnswers.where((element) => element.isSelected == true).first.content.trim() == qs.correctAnswers.trim() && qs.practiceAnswers[index].content.trim() == qs.correctAnswers.trim() ? HexColor("#00c55a") : (qs.practiceAnswers[index].content.trim() == qs.correctAnswers.trim() ? HexColor("#00c55a") : (qs.practiceAnswers[index].isSelected == true ? Colors.red.shade200 : HexColor("#9c7f6a")))),
                                                    //HexColor("#00c55a") : HexColor("#9c7f6a"),
                                                    boxShadow: [BoxShadow(offset: Offset(1, 0), blurRadius: 2)],
                                                    borderRadius: BorderRadius.circular(4)),
                                                padding: EdgeInsets.all(8),
                                                margin: EdgeInsets.fromLTRB(
                                                    16, 8, 16, 8),
                                                child: textAnswer(
                                                    qs.practiceAnswers[index]),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                          : Container(),
                                    ],
                                  )),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
            ),
            top: 0,
            right: 0,
            bottom: 0,
            left: 0,
          ),

          isWaiting
              ? Positioned(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.fromLTRB(24, 0, 24, 0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black, width: 1)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          textpaintingBoldBase(
                              'Xin vui lòng chờ đến câu hỏi tiếp theo!',
                              16,
                              Colors.white,
                              Colors.black,
                              3),
                          textpaintingBoldBase(timeCooldown.toString(), 24,
                              Colors.white, Colors.black, 3)
                        ],
                      ),
                      height: 100,
                    ),
                  ),
                  top: 0,
                  right: 0,
                  left: 0,
                  bottom: 0,
                )
              : Container(),
        ],
      ),
    );
  }

  textpainting(String s) {
    return OutlinedText(
      text: Text(s,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 14,
              fontFamily: 'SourceSerifPro',
              fontWeight: FontWeight.bold,
              color: Colors.white)),
      strokes: [
        OutlinedTextStroke(color: Colors.black87, width: 3),
      ],
    );
  }

  answerClicked(int index) {
    if (_start == 0) {
      toast(context, AppLocalizations.of(context).lbl_timeout);
      return;
    }
    if (qs.practiceAnswers
        .where((element) => element.isSelected == true)
        .isNotEmpty) {
      return;
    }
    setState(() {
      qsAnswer = qs.practiceAnswers[index];
    });
    qs.practiceAnswers[index].isSelected = true;
    var ans =
        qs.practiceAnswers.where((element) => element.isSelected == true).first;
    milisec = usingStopTime
        ? 100
        : DateTime.now().millisecondsSinceEpoch - now.millisecondsSinceEpoch;
    listAnswerTime.add(milisec);
    String answerSend;
    String answerCorrect;
    if (ans.content.contains('#')) {
      answerSend = ans.content.split('#').join('').trim();
      answerCorrect = qs.correctAnswers.split(' ').join('').trim();
    } else {
      answerSend = ans.content.trim();
      answerCorrect = qs.correctAnswers.trim();
    }
    print({
      'user': {
        'id':user.id,
        'name':user.name,
        'email':user.email,
        'course_student_id':this.courseStudentId,
        'classroom_id':this.classroomId,
        'exp':user.exp
      },
      'answer': {'is_true': answerSend == answerCorrect, 'time': milisec},
    });
    socket.emit('sent-answer', [
      {
        'user': {
          'id':user.id,
          'name':user.name,
          'email':user.email,
          'course_student_id':this.courseStudentId,
          'classroom_id':this.classroomId,
          'exp':user.exp
        },
        'answer': {'is_true': answerSend == answerCorrect, 'time': milisec},
      }
    ]);

    ans.content == qs.correctAnswers ? correct++ : wrong++;
  }

  sendMessage() {
    var text = textEditingController.text;
    socket.emit('sent-message', [
      {
        'user': user,
        'message': text,
      }
    ]);
    textEditingController.clear();
  }

  leaderBoard() {
    return Container(
      height: 56.0 * 5,
      child: leaderBoards != null
          ? ListView.builder(
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.brown),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Stack(
                    children: [
                      Positioned(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                              width: 56,
                              height: 56,
                              child: Stack(
                                children: [
                                  Positioned(
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 48,
                                          child: Image(
                                            image: AssetImage(
                                                'assets/images/game_bg_rank.png'),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 4,
                                          top: 4,
                                          right: 0,
                                          left: 0,
                                          child: Image(
                                            image: AssetImage(
                                                'assets/images/ic_grandmaster.png'),
                                          ),
                                        )
                                      ],
                                    ),
                                    top: 0,
                                    bottom: 0,
                                    right: 10,
                                    left: 10,
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: Text(
                                leaderBoards[index].name,
                                style: TextStyle(
                                    color: HexColor("#2e2e2e"),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SourceSerifPro'),
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Center(
                              child: Text(
                                convertMilisec(leaderBoards[index].time),
                                style: TextStyle(
                                    fontFamily: 'SourceSerifPro',
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            Container(
                              width: 8,
                            )
                          ],
                        ),
                        top: 0,
                        right: 0,
                        left: 0,
                        bottom: 0,
                      ),
                      leaderBoards[index].courseStudentId < 100 &&
                              leaderBoards[index].mess != null
                          ? Positioned(
                              child: Container(
                                margin: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      topLeft: Radius.circular(8),
                                      bottomRight: Radius.circular(8),
                                    )),
                                child: Center(
                                    child: RunningText(
                                  text: leaderBoards[index].mess,
                                  speed: leaderBoards[index].mess.length < 10
                                      ? 15
                                      : 25,
                                  alwaysScroll: true,
                                  style: ThemeStyles.styleBold(
                                      textColors: Colors.white),
                                  onEnd: (p) => onEndRunningText(index),
                                )),
                              ),
                              top: 0,
                              right: 0,
                              bottom: 0,
                              left: 68,
                            )
                          : Container()
                    ],
                  ),
                  height: 48,
                  width: (MediaQuery.of(context).size.width / 2) - 40,
                );
              },
              shrinkWrap: true,
              itemCount: leaderBoards.length,
            )
          : Container(),
      margin: EdgeInsets.fromLTRB(16, 0, 16, 4),
    );
  }

  usingItem(int id) {
    switch (id) {
      case 6:
        //50 50
        use5050();
        return;
      case 7:
        //dong ho ngung dong
        useStopTime();
        return;
      default:
        return;
    }
  }

  void use5050() {
    // socket.emit('use_item', {'user': user, 'arena_id': arenaId});
    setState(() {
      for (var i = 0; i < 2; i++) {
        qs.practiceAnswers.shuffle();
        setState(() {
          qs.practiceAnswers.remove(qs.practiceAnswers
              .where((element) => element.content != qs.correctAnswers)
              .first);
        });
      }
    });
  }

  void useStopTime() {
    setState(() {
      usingStopTime = true;
    });
  }

  textAnswer(PracticeAnswer ans) {
    var text = ans.content;
    if (text.contains("#")) {
      var lst = text.split(' ');
      return RichText(
        text: TextSpan(children: [
          for (int i = 0; i < lst.length; i++)
            if (lst[i].contains("#"))
              if (lst[i].split('#').toList().length > 2)
                for (int j = 0; j < lst[i].split('#').toList().length; j++)
                  if (j % 2 == 1)
                    TextSpan(
                        text: lst[i].split('#').toList()[j],
                        style: ThemeStyles.styleBold(textColors: Colors.black))
                  else
                    TextSpan(
                        text: lst[i].split('#').toList()[j],
                        style: ThemeStyles.styleNormal(textColors: Colors.black))
              else
                TextSpan(
                    text: lst[i].replaceAll('#', '')+' ',
                    style: ThemeStyles.styleBold(textColors: Colors.black))
            else
              TextSpan(
                  text: lst[i]+' ',
                  style: ThemeStyles.styleNormal(textColors: Colors.black))
        ]),
      );
    } else {
      return Text(text,
          textAlign: TextAlign.start,
          style: ThemeStyles.styleNormal(textColors: Colors.black));
    }
  }


  textQuestion(String title) {
    if (title.contains("<b>") ) {
      var lst = title.split(' ');
      var listBold = lst
          .where(
              (element) => element.contains("<b>"))
          .toList();
      var indexFirst = lst.indexOf(listBold.first);
      var indexLast = lst.indexOf(listBold.last);
      return RichText(
        text: TextSpan(children: [
          if (lst.length > 0)
            for (int i = 0; i < lst.length; i++)
              if (i > indexFirst && i < indexLast)
                TextSpan(
                    text: lst[i] + ' ',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'SourceSerifPro',
                        fontWeight: FontWeight.w700,
                        color:  HexColor("#a12525"),
                        decoration: TextDecoration.underline))
              else if (i == indexFirst || i == indexLast)
                TextSpan(
                    text: ' ',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'SourceSerifPro',
                        fontWeight: FontWeight.w700,
                        color:  HexColor("#a12525"),
                        decoration: TextDecoration.underline))
              else
                TextSpan(
                    text: lst[i] + ' ',
                    style: ThemeStyles.styleNormal(textColors:  HexColor("#a12525")))
        ]),
      );
    } else if (title.contains("#")) {
      var lst = title.split(' ');
      if (lst.length == 1) {
        var splitWord = title.split('#');
        return RichText(
          text: TextSpan(children: [
            if (splitWord.length > 0)
              for (int i = 0; i < splitWord.length; i++)
                if (splitWord[i].contains("#"))
                  TextSpan(
                    text: splitWord[i]
                        .split("#")
                        .where((element) => element.isNotEmpty)
                        .first,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'SourceSerifPro',
                        fontWeight: FontWeight.w700,
                        color:  HexColor("#a12525"),
                        decoration: TextDecoration.underline),
                  )
                else
                  TextSpan(
                      text: splitWord[i],
                      style: ThemeStyles.styleNormal(
                          textColors:  HexColor("#a12525"), font: 16))
          ]),
        );
      } else {
        var listBold = lst.where((element) => element.contains("#")).toList();
        if (listBold.length == 2) {
          var indexFirst = lst.indexOf(listBold.first);
          var indexLast = lst.indexOf(listBold.last);
          return RichText(
            text: TextSpan(children: [
              if (lst.length > 0)
                for (int i = 0; i < lst.length; i++)
                  if (i > indexFirst && i < indexLast)
                    TextSpan(
                        text: lst[i] + ' ',
                        style: ThemeStyles.styleBold(
                            textColors: HexColor("#a12525"), font: 16))
                  else if (i == indexFirst || i == indexLast)
                    TextSpan(
                      text: lst[i]
                              .split('#')
                              .where((element) => element.isNotEmpty)
                              .first +
                          ' ',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'SourceSerifPro',
                          fontWeight: FontWeight.w700,
                          color:  HexColor("#a12525"),
                          decoration: TextDecoration.underline),
                    )
                  else
                    TextSpan(
                        text: lst[i] + ' ',
                        style: ThemeStyles.styleNormal(
                            textColors:  HexColor("#a12525"), font: 16))
            ]),
          );
        }
        else {
          return RichText(
            text: TextSpan(children: [
              if (lst.length > 0)
                for (int i = 0; i < lst.length; i++)
                  if (lst[i].contains("#"))
                    TextSpan(
                      text: lst[i]
                              .split('#')
                              .where((element) => element.isNotEmpty)
                              .first +
                          ' ',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'SourceSerifPro',
                          fontWeight: FontWeight.w700,
                          color:  HexColor("#a12525"),
                          decoration: TextDecoration.underline),
                    )
                  else
                    TextSpan(
                        text: lst[i] + ' ',
                        style: ThemeStyles.styleNormal(
                            textColors:  HexColor("#a12525"), font: 16))
            ]),
          );
        }
      }
    } else {
      return Text(
        title,
        style: TextStyle(
            fontSize: 16,
            fontFamily: 'SourceSerifPro',
            color: HexColor("#a12525"),
            fontWeight: FontWeight.w400),
      );
    }
  }

  onEndRunningText(int index) {
    if (leaderBoards != null) {
      setState(() {
        leaderBoards[index].mess = null;
      });

      if (totalQs <= 1) {
        if (totalQs <= 1 && isSayHello == false) {
          Future.delayed(Duration(milliseconds: 1000)).whenComplete(() {
            setState(() {
              isSayHello = true;
              leaderBoards[index].mess =
                  messHello2[Random().nextInt(messHello2.length - 1)];
            });
          });
        }

        if (totalQs == 1 &&
            isSayHello == true &&
            isTextRunningPerQuestionDone == false) {
          Future.delayed(Duration(milliseconds: 1000)).whenComplete(() {
            setState(() {
              isTextRunningPerQuestionDone = true;
              leaderBoards[index].mess =
                  messStartQs[Random().nextInt(messStartQs.length - 1)];
              ;
            });
          });
        }
      }
    }
  }
}
