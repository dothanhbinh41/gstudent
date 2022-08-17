import 'package:flutter/material.dart';
import 'package:gstudent/clan/views/arena_waiting_view.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:intl/intl.dart';

class WaitTingZoom extends StatefulWidget {
  bool isTrial;
  DateTime time;
  DateTime timeWait;
  WaitTingZoom({this.time, this.isTrial = false,this.timeWait});
  @override
  State<StatefulWidget> createState() => WaitTingZoomState(time: this.time,isTrial: this.isTrial,timeWait: this.timeWait);
}

class WaitTingZoomState extends State<WaitTingZoom>
    with TickerProviderStateMixin {
  bool isTrial;
  DateTime time;
  DateTime timeWait;

  WaitTingZoomState({this.time,this.isTrial,this.timeWait});
  AnimationController _controller;
  int duration;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      if( (timeWait.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch) ~/ 1000 > 900 ){
        duration = (timeWait.millisecondsSinceEpoch - DateTime.now().add(Duration(seconds: 900)).millisecondsSinceEpoch) ~/ 1000;
      }else{
        duration = (timeWait.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch) ~/ 1000 > 0 ? (timeWait.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch) ~/ 1000 : 5;
      }
    });
    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:  duration
        )
      // gameData.levelClock is a user entered number elsewhere in the applciation
        )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.of(context).pop(true);
        }
      });
    startAnimation();
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
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [
                  0.0,
                  0.5,
                  1.0,
                ],
                colors: [
                  HexColor("#2b5ed1"),
                  HexColor("#5d3570"),
                  HexColor("#920a0b"),
                ],
                tileMode: TileMode.clamp)),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 60,
                child: Stack(
                  children: [
                    Positioned(
                      child: Center(
                          child: Text('PHÒNG CHỜ ZOOM',
                              style: ThemeStyles.styleBold(
                                  textColors: Colors.white, font: 24))),
                      top: 0,
                      right: 0,
                      left: 0,
                      bottom: 0,
                    ),
                    Positioned(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Container(
                          height: 48,
                          width: 48,
                          child: Image(
                            image: AssetImage(
                                'assets/images/game_button_back.png'),
                          ),
                        ),
                      ),
                      top: 0,
                      left: 12,
                      bottom: 0,
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Column(
                children: [
                  Image(
                    image: AssetImage('assets/images/boy.png'),
                    height: 140,
                  ),
                  Container(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Bạn có lịch ',
                              style: ThemeStyles.styleNormal(
                                  textColors: Colors.white)),
                          TextSpan(
                              text: isTrial ?  'Học thử ': 'Kiểm Tra Đầu Vào ',
                              style: ThemeStyles.styleBold(
                                  textColors: Colors.white)),
                          TextSpan(
                              text: 'vào lúc\n',
                              style: ThemeStyles.styleNormal(
                                  textColors: Colors.white)),
                          TextSpan(
                              text: DateFormat('hh:mm:ss dd-MM-yyyy')
                                  .format(time),
                              style: ThemeStyles.styleBold(
                                  textColors: Colors.white)),
                        ],
                      ),
                    ),
                    margin: EdgeInsets.fromLTRB(32, 8, 32, 16),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              )),
              time.day == DateTime.now().day
                  ? Container(
                      height: 60,
                      child: Countdown(
                        animation: StepTween(
                          begin:duration, // THIS IS A USER ENTERED NUMBER
                          end: 0,
                        ).animate(_controller),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
