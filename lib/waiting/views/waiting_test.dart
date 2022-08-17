import 'package:flutter/material.dart';
import 'package:gstudent/clan/views/arena_waiting_view.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/styles/theme_text.dart';

class TestWaiting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TestWaitingState();
}

class TestWaitingState extends State<TestWaiting>
    with TickerProviderStateMixin {
  int timecd = 5;
  AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:
                timecd) // gameData.levelClock is a user entered number elsewhere in the applciation
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
                          child: Text('Luyện từ vựng',
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
                              text: 'Đừng xem nó như một bài thi thử. Hãy ',
                              style: ThemeStyles.styleNormal(
                                  textColors: Colors.white)),
                          TextSpan(
                              text: 'Cố Gắng ',
                              style: ThemeStyles.styleBold(
                                  textColors: Colors.white)),
                          TextSpan(
                              text: 'hết mình',
                              style: ThemeStyles.styleNormal(
                                  textColors: Colors.white)),
                        ],
                      ),
                    ),
                    margin: EdgeInsets.fromLTRB(32, 8, 32, 16),
                  ),
                  Image(
                    image: AssetImage('assets/images/waiting_target.png'),
                    height: 100,
                  ),
                  Container(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Đây là một ',
                              style: ThemeStyles.styleNormal(
                                  textColors: Colors.white)),
                          TextSpan(
                              text: 'Thử Thách ',
                              style: ThemeStyles.styleBold(
                                  textColors: Colors.white)),
                          TextSpan(
                              text:
                                  'cho những nỗ lực của bạn trong những tháng qua',
                              style: ThemeStyles.styleNormal(
                                  textColors: Colors.white)),
                        ],
                      ),
                    ),
                    margin: EdgeInsets.fromLTRB(32, 16, 32, 8),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              )),
              Container(
                height: 60,
                child: Countdown(
                  animation: StepTween(
                    begin: timecd, // THIS IS A USER ENTERED NUMBER
                    end: 0,
                  ).animate(_controller),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
