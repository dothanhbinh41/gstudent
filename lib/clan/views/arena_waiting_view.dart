import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/Arena/arena_detail_response.dart';
import 'package:gstudent/common/define_item/avatar_character.dart';
import 'package:gstudent/common/styles/theme_text.dart';

class WaitForTheMatchView extends StatefulWidget {
  String nameClan;
  String nameFromClan;
  DateTime time;
  int rankClan;
  int rankOtherClan;
  String winRateClan;
  String winRateOtherClan;
  Student generalClan;
  Student generalOtherClan;
  Student mvpClan;
  Student mvpOtherClan;

  WaitForTheMatchView({this.time, this.nameClan, this.nameFromClan, this.rankClan, this.rankOtherClan, this.winRateClan, this.winRateOtherClan,this.generalClan,this.generalOtherClan,this.mvpClan,this.mvpOtherClan});

  @override
  State<StatefulWidget> createState() => WaitForTheMatchViewState(
      nameFromClan: this.nameFromClan,
      nameClan: this.nameClan,
      time: this.time,
      rankClan: this.rankClan,
      rankOtherClan: this.rankOtherClan,
      winRateClan: this.winRateClan,
      winRateOtherClan: this.winRateOtherClan,
      generalClan:this.generalClan,
      generalOtherClan:this.generalOtherClan,
      mvpClan:this.mvpClan,
      mvpOtherClan:this.mvpOtherClan
  );
}

class WaitForTheMatchViewState extends State<WaitForTheMatchView> with TickerProviderStateMixin {
  String nameClan;
  String nameFromClan;
  DateTime time;
  int rankClan;
  int rankOtherClan;
  String winRateClan;
  String winRateOtherClan;
  Student generalClan;
  Student generalOtherClan;
  Student mvpClan;
  Student mvpOtherClan;
  WaitForTheMatchViewState({this.generalClan,this.generalOtherClan,this.mvpClan,this.mvpOtherClan,this.time, this.nameClan, this.nameFromClan, this.rankClan, this.rankOtherClan, this.winRateClan, this.winRateOtherClan});

  int timecd;
  AnimationController _controller;
  int step = 0;

  @override
  void initState() {
    super.initState();
    var millisInADay = Duration(hours: time.hour, minutes: time.minute).inMilliseconds;
    print(Duration(hours: time.hour, minutes: time.minute));
    var now = DateTime.now();
    print(now);
    var millisInANow = Duration(hours: now.hour, minutes: now.minute, seconds: now.second).inMilliseconds;
    var c = millisInADay - millisInANow;
    timecd = c ~/ 1000;
    timecd = timecd > 30 ? timecd - 19 : (timecd >10 && timecd <= 15 ? 5 : 3 );

    _controller = AnimationController(vsync: this, duration: Duration(seconds: timecd) // gameData.levelClock is a user entered number elsewhere in the applciation
        )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _timer.cancel();
          Navigator.of(context).pop(true);
        }
      });
    startTimer();
    startAnimation();
  }

  Timer _timer;
  var count = 0;

  void startTimer() {
    const oneSec = const Duration(milliseconds: 1000);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
              count = count +1;
              if(count == 3){
               setState(() {
                 count = 0;
                 step ==2 ? step = 0 : step ++;
               });
              }
        },
      ),
    );
  }

  startAnimation() async {
    try {
      await _controller.forward().orCancel;
    } on TickerCanceled {
      print(' animation canceled');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
    _timer.cancel();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
            color: Colors.transparent,
            child: Stack(
              children: [
                Positioned(
                  top: -8,
                  bottom: -8,
                  right: 0,
                  left: 0,
                  child: Image(
                    image: AssetImage('assets/bg_waiting_arena.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                Column(
                  children: [
                    Expanded(
                      child: Container(),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(
                          child: Stack(
                        children: [
                          AnimatedPositioned(
                            top: step == 0 ? 80 :MediaQuery.of(context).size.height/2,
                            bottom: step == 0 ? 80 :MediaQuery.of(context).size.height/2,
                            right: 0,
                            left: 0,
                            duration : Duration(milliseconds: 500),
                            child: Image(
                              image: AssetImage('assets/wait_for_the_match.png'),
                            ),
                          ),
                          Positioned(
                            child: AnimatedOpacity(
                              duration:Duration(milliseconds: 500) ,opacity: step == 0 ? 1.0 : 0.0,
                              child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 100,
                                    width: MediaQuery.of(context).size.width,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 0,
                                          right: 40,
                                          bottom: 0,
                                          left: 40,
                                          child: Image(
                                            image: AssetImage('assets/images/bg_guild_arena.png'),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          bottom: 0,
                                          left: 80,
                                          right: 80,
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context).size.width,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  nameClan,
                                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'SourceSerifPro', fontSize: 18),
                                                ),
                                                Container(
                                                  height: 4,
                                                ),
                                                Image(
                                                  image: AssetImage('assets/images/eclipse_login.png'),
                                                  fit: BoxFit.fill,
                                                ),
                                                RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(
                                                    children: <TextSpan>[
                                                      TextSpan(text: 'Phong độ gần nhất : ', style: ThemeStyles.styleNormal()),
                                                      TextSpan(text: winRateClan + '\n', style: ThemeStyles.styleBold(textColors: Colors.blue)),
                                                      TextSpan(text: 'Rank: ', style: ThemeStyles.styleNormal()),
                                                      TextSpan(text: rankClan.toString(), style: ThemeStyles.styleBold(textColors: Colors.red)),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  flex: 2,
                                ),
                                Expanded(
                                  child: Container(),
                                  flex: 3,
                                ),
                                Expanded(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 0,
                                          right: 40,
                                          bottom: 0,
                                          left: 40,
                                          child: Image(
                                            image: AssetImage('assets/images/bg_guild_arena.png'),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          bottom: 0,
                                          left: 80,
                                          right: 80,
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context).size.width,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  nameFromClan,
                                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'SourceSerifPro', fontSize: 20),
                                                ),
                                                Container(
                                                  height: 8,
                                                ),
                                                Image(
                                                  image: AssetImage('assets/images/eclipse_login.png'),
                                                  fit: BoxFit.fill,
                                                ),
                                                RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(
                                                    children: <TextSpan>[
                                                      TextSpan(text: 'Phong độ gần nhất : ', style: ThemeStyles.styleNormal()),
                                                      TextSpan(text: winRateOtherClan + '\n', style: ThemeStyles.styleBold(textColors: Colors.blue)),
                                                      TextSpan(text: 'Rank: ', style: ThemeStyles.styleNormal()),
                                                      TextSpan(text: rankOtherClan.toString(), style: ThemeStyles.styleBold(textColors: Colors.red)),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  flex: 2,
                                ),
                              ],
                          ),
                            ),top: 0,right: 0,
                            bottom: 0 ,left: 0,),


                          AnimatedPositioned(
                            top: step == 1 ? 80 :MediaQuery.of(context).size.height/2,
                            bottom: step ==1  ? 80 :MediaQuery.of(context).size.height/2,
                            right: 0,
                            left: 0,
                            child: Image(
                              image: AssetImage('assets/wait_for_the_match_general.png'),
                            ),
                            duration:Duration(milliseconds: 500),
                          ),
                          Positioned(
                            child:  AnimatedOpacity(
                              duration:Duration(milliseconds: 500) ,opacity:step == 1 ? 1.0:0.0,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            top: 20,
                                            right: 40,
                                            bottom: 20,
                                            left: 40,
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/images/bg_guild_arena.png'),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          Positioned(
                                            top: 40,
                                            bottom: 40,
                                            left: 80,
                                            right: 80,
                                            child: Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 8),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                      child: Container(
                                                        alignment: Alignment.center,
                                                        height: 120,
                                                        width: 120,
                                                        child: Stack(
                                                          children: [
                                                            Image(
                                                              image: AssetImage(
                                                                  'assets/images/game_border_avatar_member.png'),
                                                            ),
                                                            Positioned(
                                                              top: 8,
                                                              right: 0,
                                                              bottom: 12,
                                                              left: 0,
                                                              child: Image(
                                                                image: AssetImage(
                                                                    loadAvatarCharacterById(generalClan.characterId)),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      flex: 2

                                                  ),
                                                  Expanded(child:  Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        generalClan.name,
                                                        style: ThemeStyles.styleBold(),
                                                      ),
                                                      Text(
                                                        "General",
                                                        style: ThemeStyles.styleNormal(),
                                                      ),
                                                    ],
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                  ),flex: 3,)
                                                ],
                                              ),
                                              height: 80,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Container(),
                                    flex: 3,
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            top: 20,
                                            right: 40,
                                            bottom: 20,
                                            left: 40,
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/images/bg_guild_arena.png'),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          Positioned(
                                            top: 40,
                                            bottom: 40,
                                            left: 80,
                                            right: 80,
                                            child: Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 8),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                      child: Container(
                                                        alignment: Alignment.center,
                                                        height: 120,
                                                        width: 120,
                                                        child: Stack(
                                                          children: [
                                                            Image(
                                                              image: AssetImage(
                                                                  'assets/images/game_border_avatar_member.png'),
                                                              height: 120,
                                                            ),
                                                            Positioned(
                                                              top: 8,
                                                              right: 0,
                                                              bottom: 12,
                                                              left: 0,
                                                              child: Image(
                                                                image: AssetImage(
                                                                    loadAvatarCharacterById(generalOtherClan.characterId)),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      flex: 2

                                                  ),
                                                  Expanded(child:  Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        generalOtherClan.name,
                                                        style:ThemeStyles.styleBold(),
                                                      ),
                                                      Text(
                                                        "General",
                                                        style:ThemeStyles.styleNormal(),
                                                      ),
                                                    ],
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                  ),flex: 3,)
                                                ],
                                              ),
                                              height: 80,
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              ),
                            ),top: 0 ,right: 0,
                            bottom: 0 ,left: 0,),


                          AnimatedPositioned(
                            top: step == 2 ? 80 :MediaQuery.of(context).size.height/2,
                            bottom: step ==2  ? 80 :MediaQuery.of(context).size.height/2,
                            right: 0,
                            left: 0,
                            child: Image(
                              image: AssetImage('assets/wait_for_the_match_mvp.png'),
                            ),
                            duration:Duration(milliseconds: 500),
                          ),
                          Positioned(
                            child:  AnimatedOpacity(
                              duration:Duration(milliseconds: 500) ,opacity:step == 2 ? 1.0:0.0,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            top: 20,
                                            right: 40,
                                            bottom: 20,
                                            left: 40,
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/images/bg_guild_arena.png'),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          Positioned(
                                            top: 40,
                                            bottom: 40,
                                            left: 80,
                                            right: 80,
                                            child: Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 8),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                      child: Container(
                                                        alignment: Alignment.center,
                                                        height: 120,
                                                        width: 120,
                                                        child: Stack(
                                                          children: [
                                                            Image(
                                                              image: AssetImage(
                                                                  'assets/images/game_border_avatar_member.png'),
                                                              height: 120,
                                                            ),
                                                            Positioned(
                                                              top: 8,
                                                              right: 0,
                                                              bottom: 12,
                                                              left: 0,
                                                              child: Image(
                                                                image: AssetImage(
                                                                    loadAvatarCharacterById(mvpClan.characterId)),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      flex: 2

                                                  ),
                                                  Expanded(child:  Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        mvpClan.name,
                                                        style: ThemeStyles.styleBold(),
                                                      ),
                                                      Text(
                                                        "MVP",
                                                        style: ThemeStyles.styleNormal(),
                                                      ),
                                                    ],
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                  ),flex: 3,)
                                                ],
                                              ),
                                              height: 80,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Container(),
                                    flex: 3,
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            top: 20,
                                            right: 40,
                                            bottom: 20,
                                            left: 40,
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/images/bg_guild_arena.png'),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          Positioned(
                                            top: 40,
                                            bottom: 40,
                                            left: 80,
                                            right: 80,
                                            child: Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 8),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                      child: Container(
                                                        alignment: Alignment.center,
                                                        height: 120,
                                                        width: 120,
                                                        child: Stack(
                                                          children: [
                                                            Image(
                                                              image: AssetImage(
                                                                  'assets/images/game_border_avatar_member.png'),
                                                              height: 120,
                                                            ),
                                                            Positioned(
                                                              top: 8,
                                                              right: 0,
                                                              bottom: 12,
                                                              left: 0,
                                                              child: Image(
                                                                image: AssetImage(
                                                                    loadAvatarCharacterById(mvpOtherClan.characterId)),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      flex: 2

                                                  ),
                                                  Expanded(child:  Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        mvpOtherClan.name,
                                                        style:ThemeStyles.styleBold(),
                                                      ),
                                                      Text(
                                                        "MVP",
                                                        style:ThemeStyles.styleNormal(),
                                                      ),
                                                    ],
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                  ),flex: 3,)
                                                ],
                                              ),
                                              height: 80,
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              ),
                            ),top: 0 ,right: 0,
                            bottom: 0 ,left: 0,),
                        ],
                      )),
                      flex: 6,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Trận đấu sẽ bắt đầu sau ...',
                            style: ThemeStyles.styleNormal(textColors:  Colors.white, font: 20),
                          ),
                          Container(
                            height: 8,
                          ),
                          Countdown(
                            animation: StepTween(
                              begin: timecd, // THIS IS A USER ENTERED NUMBER
                              end: 0,
                            ).animate(_controller),
                          )
                        ],
                      ),
                      flex: 1,
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}

class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation,this.fontSize = 24, this.color = Colors.white,this.isTextBold = false}) : super(key: key, listenable: animation);
  Animation<int> animation;
  double fontSize;
  Color color;
  bool isTextBold;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =clockTimer.inHours > 0 ? '${clockTimer.inHours.remainder(24).toString()}:${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}' : '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    return Text(
      "$timerText",
      style: isTextBold ? ThemeStyles.styleBold(font: fontSize,textColors: color) : ThemeStyles.styleNormal(font: fontSize,textColors: color),
    );
  }
}
