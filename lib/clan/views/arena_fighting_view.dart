import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gstudent/api/base/ApiBase.dart';
import 'package:gstudent/api/dtos/Arena/arena_detail_response.dart';
import 'package:gstudent/api/dtos/Arena/result_arena.dart';
import 'package:gstudent/api/dtos/Arena/status_arena.dart';
import 'package:gstudent/api/dtos/Authentication/user_info.dart';
import 'package:gstudent/api/dtos/Clan/leaderboard_clan.dart';
import 'package:gstudent/api/dtos/Exam/GroupQuestionExam.dart';
import 'package:gstudent/clan/services/clan_services.dart';
import 'package:gstudent/clan/views/inventory_arena.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/text_painting.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/home/cubit/home_cubit.dart';
import 'package:gstudent/main.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ArenaFightingView extends StatefulWidget {
  int arenaId;
  int clanId;
  int userClanId;
  DataArena data;
  DateTime startTime;

  ArenaFightingView(
      {this.arenaId, this.clanId, this.userClanId, this.data, this.startTime});

  @override
  State<StatefulWidget> createState() => ArenaFightingViewState(
      startTime: this.startTime,
      arenaId: this.arenaId,
      clanId: this.clanId,
      userClanId: this.userClanId,
      data: this.data);
}

class ArenaFightingViewState extends State<ArenaFightingView> {
  int arenaId;
  int clanId;
  int userClanId;
  DataArena data;
  DateTime startTime;

  ArenaFightingViewState(
      {this.arenaId, this.clanId, this.userClanId, this.data, this.startTime});

  HomeCubit cubit;

  bool usingStopTime = false;
  ApplicationSettings settings;
  Socket socket;
  ClanService service;
  List<PracticeQuestion> qs;
  ClanDataArena clanUser;
  ClanDataArena clanAnother;
  List<Student> clanUserData = [];
  List<Student> clanAnotherData = [];

  int indexUser = 0;
  Timer _timer;
  Timer _timerCooldown;
  int _start = 0;
  int coolDown = 0;
  DateTime now;
  int milisec = 0;
  User user;
  int totalQs = 0;
  List<LeaderBoardClan> userClan;
  List<LeaderBoardClan> oldDataUserClan;
  List<LeaderBoardClan> enermyClan;
  List<LeaderBoardClan> oldDataEnermyClan;
  int resultClan = 0;
  int resultClanEnemy = 0;
  bool isFocus = false;
  FocusNode _focus = new FocusNode();
  int isUseLuckyStar = 1;
  bool joinSuccess = false;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<HomeCubit>(context);
    service = GetIt.instance.get<ClanService>();
    settings = GetIt.instance.get<ApplicationSettings>();
    startCooldown();
    loadData();
    _focus.addListener(_onFocusChange);
  }

  startCooldown() {
    var millisInADay =
        Duration(hours: startTime.hour, minutes: startTime.minute)
            .inMilliseconds;
    var now = DateTime.now();
    var millisInANow =
        Duration(hours: now.hour, minutes: now.minute, seconds: now.second)
            .inMilliseconds;
    var c = millisInADay - millisInANow;
    setState(() {
      coolDown = (c ~/ 1000) - 1;
    });
    startTimeCooldown();
  }

  void _onFocusChange() {
    debugPrint("Focus: ${_focus.hasFocus.toString()}");
    if (_focus.hasFocus) {
      setState(() {
        isFocus = true;
      });
    } else {
      disableFocus();
    }
  }

  disableFocus() {
    setState(() {
      isFocus = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer?.cancel();
    _timerCooldown?.cancel();
    socket.disconnect();
    socket.dispose();
  }

  loadData() async {
    var dataLogin = await settings.getCurrentUser();
    this.user = dataLogin.userInfo;
    setupSocket();

    if (data.clan.student
        .where((element) => element.id == dataLogin.userInfo.id)
        .isNotEmpty) {
      var userInList = data.clan.student
          .where((element) => element.id == dataLogin.userInfo.id)
          .first;
      setState(() {
        clanUser = data.clan;
        clanAnother = data.anotherClan;
        indexUser = data.clan.student.indexOf(userInList);

        print('index user' + indexUser.toString());
      });
    }

    if (data.anotherClan.student
        .where((element) => element.id == dataLogin.userInfo.id)
        .isNotEmpty) {
      var userInList = data.anotherClan.student
          .where((element) => element.id == dataLogin.userInfo.id)
          .first;
      setState(() {
        clanUser = data.anotherClan;
        clanAnother = data.clan;
        indexUser = data.anotherClan.student.indexOf(userInList);
        print('index user' + indexUser.toString());
      });
    }

    clanUser.student.forEach((element) {
      element.online = true;
    });
    clanAnother.student.forEach((element) {
      element.online = true;
    });
    var used = await settings.getUsedLuckyStar(this.arenaId, this.user.id);
    if (used != null) {
      setState(() {
        isUseLuckyStar = used == true ? 0 : 1;
      });
    }
  }

  void setupSocket() async {
    print(arenaId);
    socket = io('ws://'+ apiUrl +'/arena/' + arenaId.toString(),
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .build());
    socket.connect();
    socket.onConnectError((data) {
      print('socket connect error');
      print(data);
      toast(context,
          'Đấu trường đã kết thúc hoặc có lỗi xảy ra. Xin vui lòng thử lại.');
      Navigator.of(context).pop();
    });
    socket.onConnect((data) {
      print("socket arena connect : " + socket.connected.toString());
      socket.emit('join-arena', {'user_id': user.id, 'arena_id': arenaId});
    });
    socket.on('leader_board_each_question', (data) {
      print('leader_board_each_question');
      var d = jsonEncode(data);
      print(d);
      Map<String, List<LeaderBoardClanEachQuestion>> ld =
          Map.from(json.decode(jsonEncode(data))).map((k, v) =>
              MapEntry<String, List<LeaderBoardClanEachQuestion>>(
                  k,
                  List<LeaderBoardClanEachQuestion>.from(
                      v.map((x) => LeaderBoardClanEachQuestion.fromJson(x)))));
      // print('leader board');
      print(jsonEncode(ld));
      if (ld != null) {
        var f = ld.values.first;
        var l = ld.values.last;
        setState(() {
          resultClan = 0;
          resultClanEnemy = 0;
          if (f
              .where((element) => element.id == clanUser.student.first.id)
              .isNotEmpty) {
            if (f.where((element) => element.totalNumberTrue >= 1).isNotEmpty) {
              f
                  .where((element) => element.totalNumberTrue >= 1)
                  .toList()
                  .forEach((element) {
                resultClan = resultClan + element.totalNumberTrue;
              });
            } else {
              resultClan = resultClan;
            }
          } else if (f
              .where((element) => element.id == clanAnother.student.first.id)
              .isNotEmpty) {
            if (f.where((element) => element.totalNumberTrue >= 1).isNotEmpty) {
              f
                  .where((element) => element.totalNumberTrue >= 1)
                  .toList()
                  .forEach((element) {
                resultClanEnemy = resultClanEnemy + element.totalNumberTrue;
              });
            } else {
              resultClanEnemy = resultClanEnemy;
            }
          }

          if (l
              .where((element) => element.id == clanUser.student.first.id)
              .isNotEmpty) {
            if (l.where((element) => element.totalNumberTrue >= 1).isNotEmpty) {
              l
                  .where((element) => element.totalNumberTrue >= 1)
                  .toList()
                  .forEach((element) {
                resultClan = resultClan + element.totalNumberTrue;
              });
            } else {
              resultClan = resultClan;
            }
          } else if (l
              .where((element) => element.id == clanAnother.student.first.id)
              .isNotEmpty) {
            if (l.where((element) => element.totalNumberTrue >= 1).isNotEmpty) {
              l
                  .where((element) => element.totalNumberTrue >= 1)
                  .toList()
                  .forEach((element) {
                resultClanEnemy = resultClanEnemy + element.totalNumberTrue;
              });
            } else {
              resultClanEnemy = resultClanEnemy;
            }
          }
        });
      }
    });

    socket.on('arena_question', (data) async {
      String json = jsonEncode(data);
      if (json.isNotEmpty) {
        print(json);
      }
      setState(() {
        usingStopTime = false;
        oldDataUserClan = userClan;
        oldDataEnermyClan = enermyClan;
        userClan = null;
        enermyClan = null;
        totalQs++;
        qs = groupPracticeQuestionFromJson(jsonEncode(data));
      });
      startTimer(21);
      now = DateTime.now();
    });

    socket.on('member_arena', (data) {
      print('member_arena');
      var a = StatusJoinArenaFromJson(jsonEncode(data));
      if (a != null &&
          a.userAnotherClans.isNotEmpty &&
          a.userClans.isNotEmpty) {
        setState(() {
          clanUser.student.forEach((element) {
            element.online = false;
          });
          clanAnother.student.forEach((element) {
            element.online = false;
          });
          var clanOnline =
              a.userClans.where((element) => element.online).isNotEmpty
                  ? a.userClans.where((element) => element.online).toList()
                  : null;
          var clanAnotherOnline = a.userAnotherClans
                  .where((element) => element.online)
                  .isNotEmpty
              ? a.userAnotherClans.where((element) => element.online).toList()
              : null;
          if (clanOnline != null) {
            clanOnline.forEach((element) {
              print(element.studentId);
              if (clanUser.student
                  .where((e) => e.id == element.studentId)
                  .isNotEmpty) {
                clanUser.student
                    .where((e) => e.id == element.studentId)
                    .first
                    .online = true;
              } else {
                clanAnother.student
                    .where((e) => e.id == element.studentId)
                    .first
                    .online = true;
              }
            });
          }

          if (clanAnotherOnline != null) {
            clanAnotherOnline.forEach((element) {
              print(element.studentId);
              if (clanUser.student
                  .where((e) => e.id == element.studentId)
                  .isNotEmpty) {
                clanUser.student
                    .where((e) => e.id == element.studentId)
                    .first
                    .online = true;
              } else {
                clanAnother.student
                    .where((e) => e.id == element.studentId)
                    .first
                    .online = true;
              }
            });
          }
        });
      }

      setState(() {
        clanUserData = clanUser.student
            .where((element) => element.online == true)
            .toList();
        clanAnotherData = clanAnother.student
            .where((element) => element.online == true)
            .toList();
        if (clanUserData.where((element) => element.id == user.id).isNotEmpty) {
          var userInList =
              clanUserData.where((element) => element.id == user.id).first;
          indexUser = clanUserData.indexOf(userInList);
        }

        if (clanAnotherData
            .where((element) => element.id == user.id)
            .isNotEmpty) {
          var userInList =
              clanAnotherData.where((element) => element.id == user.id).first;
          indexUser = clanAnotherData.indexOf(userInList);
        }

        clanUserData = clanUserData.reversed.toList();
        clanAnotherData = clanAnotherData.reversed.toList();
      });
    });

    socket.on('top_leader', (data) {
      print('result.........................................................');
      print(data);
      Map<String, List<LeaderBoardClan>> ld =
          Map.from(json.decode(jsonEncode(data))).map((k, v) =>
              MapEntry<String, List<LeaderBoardClan>>(
                  k,
                  List<LeaderBoardClan>.from(
                      v.map((x) => LeaderBoardClan.fromJson(x)))));
      // print('leader board');
      print(jsonEncode(ld));
      if (ld != null) {
        var f = ld.values.first;
        var l = ld.values.last;
        setState(() {
          if (f.where((element) => element.id == user.id).isNotEmpty) {
            userClan = f;
            enermyClan = l;
          } else {
            userClan = l;
            enermyClan = f;
          }
        });
      }
    });

    socket.on('leader_board', (data) {
      print('data leaderboard');
      print(data);
      var result = resultArenaFromJson(jsonEncode(data));
      if (result != null) {
        var f = result.values.first;
        print(f);
        var l = result.values.last;
        print(l);

        setState(() {
          if (f.where((element) => element.id == user.id).isNotEmpty) {
            DataResultArena r = DataResultArena(
                resultClan: resultClan,
                resultClanEnemy: resultClanEnemy,
                users: f);
            Navigator.of(context).pop(r);
          } else {
            DataResultArena r = DataResultArena(
                resultClan: resultClan,
                resultClanEnemy: resultClanEnemy,
                users: l);
            Navigator.of(context).pop(r);
          }
        });
      }
    });

    socket.on('arena_status', (data) {
      print('arena_status');
      print(data);
      if (data != null) {
        setState(() {
          joinSuccess = true;
        });
      }
      StatusArena status = statusArenaFromJson(jsonEncode(data));
      if (status.type == "ket_thuc_som" ||
          status.type == "dau_truong_da_ket_thuc") {
        toast(context, status.message);
        Navigator.of(context).pop();
      }
    });
  }

  void startTimer(int sec) {
    if (sec == null) {
      _start = 15;
    } else {
      _start = sec;
    }
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          timer.cancel();
          // socket.emit('require-leaderboard', {'arena_id': arenaId});
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void startTimeCooldown() {
    const oneSec = const Duration(seconds: 1);
    _timerCooldown = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (coolDown == 0) {
          timer.cancel();
          if (joinSuccess == false) {
            toast(context,
                'Đấu trường hiện tại đã có lỗi xảy ra. Xin vui lòng thử tạo lại đấu trường khác');
            Navigator.of(context).pop();
          }
        } else {
          if (mounted) {
            setState(() {
              coolDown--;
            });
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: 0,
              right: 0,
              left: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isFocus = false;
                  });
                },
                child: Image(
                  image: AssetImage('assets/game_bg_arena.png'),
                  fit: BoxFit.fill,
                ),
              )),
          Positioned(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isFocus = false;
                });
              },
              child: SafeArea(
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
                              left: 0,
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
                                  "ĐẤU TRƯỜNG",
                                  style: ThemeStyles.styleBold(
                                    font: 24,
                                    textColors: Colors.black,
                                  ),
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
                        margin: EdgeInsets.fromLTRB(24, 0, 24, 0),
                        child: Row(
                          children: [
                            Expanded(
                                child: Center(
                              child: Text(
                                clanUser != null ? clanUser.name : "",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    fontFamily: 'SourceSerifPro'),
                              ),
                            )),
                            Expanded(
                                child: Center(
                              child: Text('$resultClan -  $resultClanEnemy',
                                  style: TextStyle(
                                      color: HexColor("#86684c"),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'SourceSerifPro')),
                            )),
                            Expanded(
                                child: Center(
                              child: Text(
                                clanAnother != null ? clanAnother.name : "",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    fontFamily: 'SourceSerifPro'),
                              ),
                            )),
                          ],
                        ),
                      ),
                      clanUser != null && clanAnother != null
                          ? Container(
                              margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
                              child: Row(
                                children: [
                                  Expanded(child: myclan()),
                                  Container(
                                    width: 2,
                                    color: Colors.black54,
                                    height: clanUserData.length >
                                            clanAnotherData.length
                                        ? 50.0 * clanUserData.length
                                        : 50.0 * clanAnotherData.length,
                                  ),
                                  Expanded(child: otherClan()),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            )
                          : Container(),
                      Container(
                        height: 70,
                        child: Stack(
                          children: [
                            Positioned(
                              right: 16,
                              child: GestureDetector(
                                onTap: () => openInventory(),
                                child: Container(
                                  width: 80,
                                  height: 60,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        right: 8,
                                        top: 0,
                                        bottom: 8,
                                        child: Image(
                                          image: AssetImage(
                                              'assets/images/game_inventory_icon.png'),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        left: 0,
                                        child: Text(
                                          'Vật phẩm',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'SourceSerifPro',
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
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
                      Opacity(
                        opacity: 0.5,
                        child: Container(
                          height: 2,
                          color: Colors.black,
                          margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
                        ),
                      ),
                      indexUser != null && indexUser < 5 && qs != null
                          ? Wrap(
                              // HexColor("#a12525")
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                                  child: textQuestion(
                                      qs[indexUser].title != null &&
                                              qs[indexUser].title.isNotEmpty
                                          ? qs[indexUser].title
                                          : qs[indexUser]
                                              .practiceGroupQuestion
                                              .description),
                                ),
                                qs != null
                                    ? Container(
                                        margin:
                                            EdgeInsets.fromLTRB(16, 0, 16, 8),
                                        child: ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: qs[indexUser]
                                              .practiceAnswers
                                              .length,
                                          itemBuilder: (context, index) {
                                            return Opacity(
                                                opacity: 0.7,
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      answerClicked(index),
                                                  child: Container(
                                                    padding: EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                        color: _start != 0
                                                            ? (qs[indexUser]
                                                                    .practiceAnswers
                                                                    .where((element) =>
                                                                        element.isSelected ==
                                                                        true)
                                                                    .isEmpty
                                                                ? HexColor(
                                                                    "#9c7f6a")
                                                                : qs[indexUser].practiceAnswers.where((element) => element.isSelected == true).isNotEmpty &&
                                                                        qs[indexUser].practiceAnswers.where((element) => element.isSelected == true).first ==
                                                                            qs[indexUser].practiceAnswers[
                                                                                index]
                                                                    ? Theme.of(context)
                                                                        .colorScheme
                                                                        .primary
                                                                    : HexColor(
                                                                        "#9c7f6a"))
                                                            : qs[indexUser]
                                                                    .practiceAnswers[
                                                                        index]
                                                                    .content
                                                                    .contains(
                                                                        '#')
                                                                ? (qs[indexUser].practiceAnswers.where((element) => element.isSelected == true).isNotEmpty && qs[indexUser].practiceAnswers.where((element) => element.isSelected == true).first.content.split('#').join('').trim() == qs[indexUser].correctAnswers.trim() && qs[indexUser].practiceAnswers[index].content.split('#').join('').trim() == qs[indexUser].correctAnswers.trim()
                                                                    ? HexColor(
                                                                        "#00c55a")
                                                                    : (qs[indexUser].practiceAnswers[index].content.split('#').join('').trim() == qs[indexUser].correctAnswers.trim()
                                                                        ? HexColor(
                                                                            "#00c55a")
                                                                        : (qs[indexUser].practiceAnswers[index].isSelected == true
                                                                            ? Colors.red.shade200
                                                                            : HexColor("#9c7f6a"))))
                                                                : (qs[indexUser].practiceAnswers.where((element) => element.isSelected == true).isNotEmpty && qs[indexUser].practiceAnswers.where((element) => element.isSelected == true).first.content == qs[indexUser].correctAnswers.trim() && qs[indexUser].practiceAnswers[index].content.trim() == qs[indexUser].correctAnswers.trim() ? HexColor("#00c55a") : (qs[indexUser].practiceAnswers[index].content.trim() == qs[indexUser].correctAnswers.trim() ? HexColor("#00c55a") : (qs[indexUser].practiceAnswers[index].isSelected == true ? Colors.red.shade200 : HexColor("#9c7f6a")))),
                                                        //HexColor("#00c55a") : HexColor("#9c7f6a"),
                                                        boxShadow: [BoxShadow(offset: Offset(1, 0), blurRadius: 2)],
                                                        borderRadius: BorderRadius.circular(4)),
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          child: textAnswer(qs[
                                                                  indexUser]
                                                              .practiceAnswers[
                                                                  index]
                                                              .content),
                                                          alignment: Alignment
                                                              .centerLeft,
                                                        )
                                                      ],
                                                    ),
                                                    margin: EdgeInsets.fromLTRB(
                                                        8, 0, 8, 8),
                                                  ),
                                                ));
                                          },
                                        ),
                                      )
                                    : Container(),
                              ],
                            )
                          : Container(),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
              ),
            ),
            top: 0,
            right: 0,
            left: 0,
            bottom: 60,
          ),
          // KeyboardAware(
          //   builder: (context, configuracaoTeclado) {
          //     return AnimatedPositioned(
          //       child: Container(
          //         height: 60,
          //         child: Wrap(
          //           children: [
          //             Opacity(
          //                 opacity: 0.5,
          //                 child: Container(
          //                   height: 1,
          //                   margin: EdgeInsets.fromLTRB(16, 0, 16, 4),
          //                   decoration: BoxDecoration(color: Colors.white),
          //                 )),
          //             Container(
          //               height: 56,
          //               child: Row(
          //                 children: [
          //                   Container(
          //                     margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
          //                     child: Image(
          //                       height: 40,
          //                       width: 40,
          //                       image: AssetImage('assets/images/icon_emoji.png'),
          //                     ),
          //                   ),
          //                   Expanded(
          //                       child: Container(
          //                     margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
          //                     decoration: BoxDecoration(
          //                         border: Border.all(color: Colors.transparent),
          //                         borderRadius: BorderRadius.circular(4),
          //                         color: HexColor("#503932"),
          //                         boxShadow: [BoxShadow(offset: Offset(0, -1), color: HexColor("#503932"))]),
          //                     child: TextField(
          //                       focusNode: _focus,
          //                       decoration: new InputDecoration(
          //                           focusedBorder: OutlineInputBorder(
          //                             borderSide: BorderSide(color: Colors.transparent),
          //                           ),
          //                           enabledBorder: OutlineInputBorder(
          //                             borderSide: BorderSide(color: Colors.transparent),
          //                           ),
          //                           hintText: 'Chating .... ',
          //                           hintStyle: TextStyle(color: HexColor("#ffe0b1"), fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w700)),
          //                     ),
          //                   )),
          //                   Container(
          //                     margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
          //                     child: Text(
          //                       'Send',
          //                       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'SourceSerifPro'),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             )
          //           ],
          //         ),
          //       ),
          //       duration: Duration(milliseconds: 50),
          //       right: 0,
          //       left: 0,
          //       bottom: isFocus ? configuracaoTeclado.keyboardHeight : 8,
          //     );
          //   },
          // ),
          qs == null && coolDown >= 0
              ? Positioned(
                  child: Center(
                    child: textpaintingBoldBase(coolDown.toString(), 24,
                        Colors.white, HexColor("#a12525"), 3),
                  ),
                  top: 0,
                  right: 0,
                  left: 0,
                  bottom: 0,
                )
              : Container()
        ],
      ),
    );
  }

  answerClicked(int index) {
    if (_start == 0) {
      toast(context, AppLocalizations.of(context).lbl_timeout);
      return;
    }
    if (qs[indexUser]
        .practiceAnswers
        .where((element) => element.isSelected == true)
        .isNotEmpty) {
      return;
    }
    qs[indexUser].practiceAnswers[index].isSelected = true;
    var ans = qs[indexUser]
        .practiceAnswers
        .where((element) => element.isSelected == true)
        .first;
    milisec = usingStopTime
        ? 100
        : DateTime.now().millisecondsSinceEpoch - now.millisecondsSinceEpoch;
    var isUseStart = isUseLuckyStar == 0 ? true : false;
    print({
      'user': {'id': user.id, 'name': user.name, 'clan_id': clanId},
      'answer': {
        'is_true': ans.content == qs[indexUser].correctAnswers,
        'time': milisec,
        'lucky_star': isUseStart
      },
      'arena_id': arenaId
    });
    String answerSend;
    String answerCorrect;
    if (ans.content.contains('#')) {
      answerSend = ans.content.split('#').join('').trim();
      answerCorrect = qs[indexUser].correctAnswers.split(' ').join('').trim();
    } else {
      answerSend = ans.content.trim();
      answerCorrect = qs[indexUser].correctAnswers.trim();
    }
    socket.emit('sent-answer', {
      'user': {'id': user.id, 'name': user.name, 'clan_id': clanId},
      'answer': {
        'is_true': answerSend == answerCorrect,
        'time': milisec,
        'lucky_star': isUseStart
      },
      'arena_id': arenaId
    });
    Future.delayed(Duration(milliseconds: 1000)).whenComplete(() {
      if (mounted) {
        setState(() {
          if (isUseStart) {
            isUseLuckyStar = -1;
          }
          usingStopTime = false;
        });
      }
    });
  }

  String convertMilisec(int sec) {
    if (sec != null && sec > 0) {
      return (sec ~/ 1000).toString() + 's';
    } else {
      return 0.toString();
    }
  }

  otherClan() {
    return Container(
      child: clanAnotherData != null && clanAnotherData.isNotEmpty
          ? Stack(
              children: [
                for (var i = 0; i < clanAnotherData.length; i++)
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        0, (48.0 * ((clanAnotherData.length - 1) - i)), 0, 4),
                    height: 100,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                ),
                                _start == 0
                                    ? Container(
                                        height: 24,
                                        child: totalQs == 1
                                            ? (enermyClan != null &&
                                                    enermyClan
                                                        .where((element) =>
                                                            element.id ==
                                                            clanAnotherData[i]
                                                                .id)
                                                        .isNotEmpty &&
                                                    enermyClan
                                                            .where((element) =>
                                                                element.id ==
                                                                clanAnotherData[
                                                                        i]
                                                                    .id)
                                                            .first
                                                            .totalNumberTrue >=
                                                        1
                                                ? Image(
                                                    image: AssetImage(
                                                        'assets/images/icon_true.png'),
                                                  )
                                                : Image(
                                                    image: AssetImage(
                                                        'assets/images/icon_wrong.png'),
                                                  ))
                                            : (enermyClan != null &&
                                                    enermyClan
                                                        .where((element) =>
                                                            element.id ==
                                                            clanAnotherData[i]
                                                                .id)
                                                        .isNotEmpty &&
                                                    enermyClan
                                                            .where((element) =>
                                                                element.id ==
                                                                clanAnotherData[
                                                                        i]
                                                                    .id)
                                                            .first
                                                            .totalNumberTrue >=
                                                        1
                                                // oldDataEnermyClan.where((element) => element.id == clanAnotherData[i].id).isNotEmpty
                                                // (  enermyClan.where((element) => element.id == clanAnotherData[i].id).first.totalNumberTrue  !=
                                                //     oldDataEnermyClan.where((element) => element.id == clanAnotherData[i].id).first.totalNumberTrue ||  enermyClan.where((element) => element.id == clanAnotherData[i].id).first.totalNumberTrue > 0)
                                                ? Image(
                                                    image: AssetImage(
                                                        'assets/images/icon_true.png'),
                                                  )
                                                : Image(
                                                    image: AssetImage(
                                                        'assets/images/icon_wrong.png'),
                                                  )),
                                      )
                                    : Container(),
                                Expanded(
                                  child: Container(),
                                ),
                                Center(
                                  child: Text(
                                    clanAnotherData[i].name,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: HexColor("#2e2e2e"),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'SourceSerifPro'),
                                  ),
                                ),
                                Container(
                                  width: 60,
                                  height: 60,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 60,
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
                                      Positioned(
                                        child: _start == 0
                                            ? Stack(
                                                children: [
                                                  Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    bottom: 0,
                                                    left: 0,
                                                    child: Image(
                                                      image: AssetImage(
                                                          'assets/images/retangcle_arena_fight.png'),
                                                    ),
                                                  ),
                                                  enermyClan != null
                                                      ? Center(
                                                          child: Text(
                                                            enermyClan
                                                                    .where((element) =>
                                                                        element
                                                                            .id ==
                                                                        clanAnotherData[i]
                                                                            .id)
                                                                    .isNotEmpty
                                                                ? convertMilisec(enermyClan
                                                                    .where((element) =>
                                                                        element
                                                                            .id ==
                                                                        clanAnotherData[i]
                                                                            .id)
                                                                    .first
                                                                    .totalTime)
                                                                : '0',
                                                            style: TextStyle(
                                                                color: HexColor(
                                                                    "#75c3ff"),
                                                                fontFamily:
                                                                    'SourceSerifPro',
                                                                fontSize: 12),
                                                          ),
                                                        )
                                                      : Container()
                                                ],
                                              )
                                            : Container(),
                                        top: 0,
                                        right: 0,
                                        bottom: 0,
                                        left: 0,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.end,
                            ),
                            height: 60,
                            width: (MediaQuery.of(context).size.width / 2) - 40,
                          ),
                        ),
                        // Positioned(
                        //     top: 56,
                        //     bottom: 8,
                        //     right: 24,
                        //     left: 8,
                        //     child: Visibility(
                        //       visible: i == 3,
                        //       child: Container(
                        //         height: 60,
                        //         decoration:
                        //             BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomRight: Radius.circular(8), bottomLeft: Radius.circular(8))),
                        //         child: Center(
                        //             child: Text(
                        //           "khó vãi cứt",
                        //           style: TextStyle(color: Colors.white, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w500),
                        //         )),
                        //       ),
                        //     ))
                      ],
                    ),
                  )
              ],
            )
          : Container(),
    );
  }

  myclan() {
    return Container(
      child: clanUserData != null && clanUserData.isNotEmpty
          ? Stack(
              children: [
                for (var i = 0; i < clanUserData.length; i++)
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        0, (48.0 * ((clanUserData.length - 1) - i)), 0, 4),
                    height: 100,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 60,
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
                                      Positioned(
                                        child: _start == 0
                                            ? Stack(
                                                children: [
                                                  Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    bottom: 0,
                                                    left: 0,
                                                    child: Image(
                                                      image: AssetImage(
                                                          'assets/images/retangcle_arena_fight.png'),
                                                    ),
                                                  ),
                                                  userClan != null
                                                      ? Center(
                                                          child:
                                                              textTimeClanUser(
                                                                  i),
                                                        )
                                                      : Container()
                                                ],
                                              )
                                            : Container(),
                                        top: 0,
                                        right: 0,
                                        bottom: 0,
                                        left: 0,
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      clanUserData[i].name,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: HexColor("#2e2e2e"),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'SourceSerifPro'),
                                    ),
                                  ),
                                ),
                                _start == 0
                                    ? Container(
                                        height: 24,
                                        child: totalQs == 1
                                            ? (userClan != null &&
                                                    userClan
                                                        .where((element) =>
                                                            element.id ==
                                                            clanUserData[i].id)
                                                        .isNotEmpty &&
                                                    userClan
                                                            .where((element) =>
                                                                element.id ==
                                                                clanUserData[i]
                                                                    .id)
                                                            .first
                                                            .totalNumberTrue >=
                                                        1
                                                ? Image(
                                                    image: AssetImage(
                                                        'assets/images/icon_true.png'),
                                                  )
                                                : Image(
                                                    image: AssetImage(
                                                        'assets/images/icon_wrong.png'),
                                                  ))
                                            : (userClan != null &&
                                                    userClan
                                                        .where((element) =>
                                                            element.id ==
                                                            clanUserData[i].id)
                                                        .isNotEmpty &&
                                                    userClan
                                                            .where((element) =>
                                                                element.id ==
                                                                clanUserData[i]
                                                                    .id)
                                                            .first
                                                            .totalNumberTrue >=
                                                        1
                                                // oldDataUserClan.where((element) => element.id == clanUserData[i].id).isNotEmpty &&
                                                // (userClan.where((element) => element.id == clanUserData[i].id).first.totalNumberTrue !=
                                                //     oldDataUserClan.where((element) => element.id == clanUserData[i].id).first.totalNumberTrue || userClan.where((element) => element.id == clanUserData[i].id).first.totalNumberTrue  > 0)
                                                ? Image(
                                                    image: AssetImage(
                                                        'assets/images/icon_true.png'),
                                                  )
                                                : Image(
                                                    image: AssetImage(
                                                        'assets/images/icon_wrong.png'),
                                                  )),
                                      )
                                    : Container(),
                                Container(
                                  width: 8,
                                )
                              ],
                            ),
                            height: 60,
                            width: (MediaQuery.of(context).size.width / 2) - 40,
                          ),
                        ),
                        // Positioned(
                        //     top: 36,
                        //     bottom: 24,
                        //     right: 8,
                        //     left: 24,
                        //     child: Visibility(
                        //       visible: i == 0,
                        //       child: Container(
                        //         height: 60,
                        //         decoration: BoxDecoration(
                        //             color: Colors.black45,
                        //             border: Border.all(),
                        //             borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8), bottomLeft: Radius.circular(8))),
                        //         child: Center(child: Text("Đáp án là dễ vãi", style: TextStyle(color: Colors.white, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w500))),
                        //       ),
                        //     ))
                      ],
                    ),
                  )
              ],
            )
          : Container(),
    );
  }

  openInventory() async {
    var result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return BlocProvider<HomeCubit>.value(
            value: cubit, //
            child: InventoryArena(
              userClanId: this.userClanId,
              isUseLuckyStar: this.isUseLuckyStar,
            ),
          );
        });
    if (result != null) {
      usingItem(result);
    }
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
      case -1:
        useLuckyStar();
        return;
      default:
        return;
    }
  }

  void use5050() {
    socket.emit('use_item', {'user': user, 'arena_id': arenaId});
    setState(() {
      for (var i = 0; i < 2; i++) {
        qs[indexUser].practiceAnswers.shuffle();
        setState(() {
          qs[indexUser].practiceAnswers.remove(qs[indexUser]
              .practiceAnswers
              .where(
                  (element) => element.content != qs[indexUser].correctAnswers)
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

  textTimeClanUser(int i) {
    if (userClan
            .where((element) => element.id == clanUserData[i].id)
            .isNotEmpty &&
        userClan.where((element) => element.id == clanUserData[i].id).first !=
            null) {
      return Text(
        userClan
                    .where((element) => element.id == clanUserData[i].id)
                    .first
                    .totalTime ==
                0
            ? "0"
            : convertMilisec(userClan
                .where((element) => element.id == clanUserData[i].id)
                .first
                .totalTime),
        style: TextStyle(
            color: HexColor("#75c3ff"),
            fontFamily: 'SourceSerifPro',
            fontSize: 12),
      );
    } else {
      return Text(
        "0",
        style: TextStyle(
            color: HexColor("#75c3ff"),
            fontFamily: 'SourceSerifPro',
            fontSize: 12),
      );
    }
  }

  textTimeClanAnother(int i) {
    if (userClan
            .where((element) => element.id == clanUserData[i].id)
            .isNotEmpty &&
        userClan.where((element) => element.id == clanUserData[i].id).first !=
            null) {
      return Text(
        userClan
                    .where((element) => element.id == clanUserData[i].id)
                    .first
                    .totalTime ==
                0
            ? "0"
            : convertMilisec(userClan
                .where((element) => element.id == clanUserData[i].id)
                .first
                .totalTime),
        style: TextStyle(
            color: HexColor("#75c3ff"),
            fontFamily: 'SourceSerifPro',
            fontSize: 12),
      );
    } else {
      return Text(
        "0",
        style: TextStyle(
            color: HexColor("#75c3ff"),
            fontFamily: 'SourceSerifPro',
            fontSize: 12),
      );
    }
  }

  textAnswer(String text) {
    if (text.contains("#")) {
      var lst = text.split(' ');
      if (lst.length == 1) {
        var splitWord = text.split('#');
        var indexFirst = 1;
        return RichText(
          text: TextSpan(children: [
            if (splitWord.length > 0)
              for (int i = 0; i < splitWord.length; i++)
                if (i > indexFirst && i < indexFirst)
                  TextSpan(text: splitWord[i], style: ThemeStyles.styleBold())
                else if (i == indexFirst)
                  TextSpan(
                    text: splitWord[i],
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'SourceSerifPro',
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        decoration: TextDecoration.underline),
                  )
                else
                  TextSpan(text: splitWord[i], style: ThemeStyles.styleNormal())
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
                    TextSpan(text: lst[i] + ' ', style: ThemeStyles.styleBold())
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
                          color: Colors.black,
                          decoration: TextDecoration.underline),
                    )
                  else
                    TextSpan(
                        text: lst[i] + ' ', style: ThemeStyles.styleNormal())
            ]),
          );
        } else {
          return RichText(
            text: TextSpan(children: [
              if (lst.length > 0)
                for (int i = 0; i < lst.length; i++)
                  if (lst[i].contains('#'))
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
                          color: Colors.black,
                          decoration: TextDecoration.underline),
                    )
                  else
                    TextSpan(
                        text: lst[i] + ' ', style: ThemeStyles.styleNormal())
            ]),
          );
        }
      }
    } else {
      return Text(text,
          textAlign: TextAlign.start,
          style: ThemeStyles.styleNormal(textColors: Colors.white));
    }
  }

  textQuestion(String title) {
    if (title.contains("<b>") || title.contains("</b>")) {
      var lst = title.split(' ');
      var listBold = lst
          .where(
              (element) => element.contains("<b>") || element.contains("</b>"))
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
                        color: HexColor("#a12525"),
                        decoration: TextDecoration.underline))
              else if (i == indexFirst || i == indexLast)
                TextSpan(
                    text: ' ',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'SourceSerifPro',
                        fontWeight: FontWeight.w700,
                        color: HexColor("#a12525"),
                        decoration: TextDecoration.underline))
              else
                TextSpan(
                    text: lst[i] + ' ',
                    style: ThemeStyles.styleNormal(
                        textColors: HexColor("#a12525")))
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
                        color: HexColor("#a12525"),
                        decoration: TextDecoration.underline),
                  )
                else
                  TextSpan(
                      text: splitWord[i],
                      style: ThemeStyles.styleNormal(
                          textColors: HexColor("#a12525")))
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
                            textColors: HexColor("#a12525")))
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
                          color: HexColor("#a12525"),
                          decoration: TextDecoration.underline),
                    )
                  else
                    TextSpan(
                        text: lst[i] + ' ',
                        style: ThemeStyles.styleNormal(
                            textColors: HexColor("#a12525")))
            ]),
          );
        } else {
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
                          color: HexColor("#a12525"),
                          decoration: TextDecoration.underline),
                    )
                  else
                    TextSpan(
                        text: lst[i] + ' ',
                        style: ThemeStyles.styleNormal(
                            textColors: HexColor("#a12525")))
            ]),
          );
        }
      }
    } else {
      return Text(
        title,
        style: TextStyle(
            fontSize: 14,
            fontFamily: 'SourceSerifPro',
            color: HexColor("#a12525"),
            fontWeight: FontWeight.w400),
      );
    }
  }

  void useLuckyStar() async {
    setState(() {
      isUseLuckyStar = 0;
    });
    await settings.saveUsedLuckyStar(this.arenaId, this.user.id);
  }
}

StatusJoinArena StatusJoinArenaFromJson(String str) =>
    StatusJoinArena.fromJson(json.decode(str));

String StatusJoinArenaToJson(StatusArena data) => json.encode(data.toJson());

class StatusJoinArena {
  StatusJoinArena({
    this.userClans,
    this.userAnotherClans,
  });

  List<UserClanArena> userClans;
  List<UserClanArena> userAnotherClans;

  factory StatusJoinArena.fromJson(Map<String, dynamic> json) =>
      StatusJoinArena(
        userClans: List<UserClanArena>.from(
            json["user_clans"].map((x) => UserClanArena.fromJson(x))),
        userAnotherClans: List<UserClanArena>.from(
            json["user_another_clans"].map((x) => UserClanArena.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user_clans": List<dynamic>.from(userClans.map((x) => x.toJson())),
        "user_another_clans":
            List<dynamic>.from(userAnotherClans.map((x) => x.toJson())),
      };
}

class UserClanArena {
  UserClanArena({
    this.id,
    this.courseStudentId,
    this.studentId,
    this.clanId,
    this.characterId,
    this.nickname,
    this.online,
  });

  int id;
  int courseStudentId;
  int studentId;
  int clanId;
  int characterId;
  String nickname;
  bool online;

  factory UserClanArena.fromJson(Map<String, dynamic> json) => UserClanArena(
      id: json["id"],
      courseStudentId: json["course_student_id"],
      studentId: json["student_id"],
      clanId: json["clan_id"],
      characterId: json["character_id"],
      nickname: json["nickname"],
      online: json["online"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_student_id": courseStudentId,
        "student_id": studentId,
        "clan_id": clanId,
        "character_id": characterId,
        "nickname": nickname,
        "online": online,
      };
}
