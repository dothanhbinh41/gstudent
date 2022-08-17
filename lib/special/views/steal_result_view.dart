import 'package:flutter/material.dart';
import 'package:gstudent/common/colors/HexColor.dart';

class StealResultView extends StatefulWidget {
  bool isSuccess ;
  String mess;
  StealResultView({this.isSuccess,this.mess});

  @override
  State<StatefulWidget> createState() => StealResultViewState(isSuccess: this.isSuccess,mess:this.mess);
}

class StealResultViewState extends State<StealResultView>
    with TickerProviderStateMixin {
  bool isSuccess ;
  String mess ;
  StealResultViewState({this.isSuccess,this.mess});

  AnimationController _animationController;
  AnimationController _animationbgController;
  Animation<double> _fadeInFadeOut;
  bool _visible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 3000))..addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed)
        setState(() {
          _visible = true;
        });
    });
    _animationbgController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 0.5).animate(_animationbgController);

    _startAnimation();
    Future.delayed(Duration(milliseconds: 2000)).whenComplete(() {
      _startAnimationbg();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    _animationbgController.dispose();
    super.dispose();
  }

  Future _startAnimation() async {
    try {
      await _animationController.forward().orCancel;
    } on TickerCanceled {
      print(' animation canceled');
    }
  }

  Future _startAnimationbg() async {
    try {
      await _animationbgController.forward().orCancel;
    } on TickerCanceled {
      print(' animation canceled');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.8),
        body: GestureDetector(
          onTap: () {

            Navigator.of(context).pop();
          },
          child: Stack(
            children: [
              Positioned(   top: 0,
                right: 0,
                left: 0,
                bottom: MediaQuery.of(context).size.height / 6,
                child:    FadeTransition(child: Image(
                  image: AssetImage('assets/img_result_attack.png'),
                ),opacity: _fadeInFadeOut,),),
              Center(
                child: isSuccess ? StealSuccess(
                  controller: _animationController.view,
                  heightItem: MediaQuery.of(context).size.width,
                  widthItem: MediaQuery.of(context).size.width,
                  startPosition: MediaQuery.of(context).size.height,
                  endPosition: MediaQuery.of(context).size.height / 6,
                ) : StealFailed(
                  controller: _animationController.view,
                  heightItem: MediaQuery.of(context).size.width,
                  widthItem: MediaQuery.of(context).size.width,
                  startPosition: MediaQuery.of(context).size.height,
                  endPosition: MediaQuery.of(context).size.height / 6,
                ),
              ),

              Positioned(
                child:   AnimatedOpacity(
                  // If the widget is visible, animate to 0.0 (invisible).
                  // If the widget is hidden, animate to 1.0 (fully visible).
                  opacity: _visible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  // The green box must be a child of the AnimatedOpacity widget.
                  child: Container(
                    height: 56,
                    child: Stack(
                      children: [
                        Positioned(
                          child: Image(
                            image: AssetImage('assets/bg_text_attack_result.png'),
                          ),
                          top: 0,
                          right: 0,
                          left: 0,
                          bottom: 0,
                        ),
                        Positioned(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  isSuccess ?   'Trộm thành công !!!' :'Trộm thất bại!!!' ,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: isSuccess ? HexColor("#ffeb67") :  HexColor("#fd263a"),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'SourceSerifPro'),
                                ),
                              ),
                              Center(
                                child: Text(
                                  mess,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro'),
                                ),
                              ),
                            ],
                          ) ,
                          top: 0,
                          right: 0,
                          left: 0,
                          bottom: 0,
                        ),
                      ],
                    ),
                  ),
                ),
                bottom: 16,
                right: 0,
                left: 0,
              )
            ],
          ),
        ));
  }
}

class StealSuccess extends StatelessWidget {
  StealSuccess(
      {Key key,
        this.controller,
        this.heightItem,
        this.widthItem,
        this.startPosition,
        this.endPosition})
      : opacity = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(
    CurvedAnimation(
      parent: controller,
      curve: Interval(
        0.0,
        0.2,
        curve: Curves.fastOutSlowIn,
      ),
    ),
  ),
        movement = EdgeInsetsTween(
          begin: EdgeInsets.only(top: startPosition, left: 0.0),
          end: EdgeInsets.only(bottom: endPosition, left: 0.0),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.2,
              0.6,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        width = Tween<double>(
          begin: 50.0,
          end: widthItem,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.5,
              0.8,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        height = Tween<double>(
          begin: 50.0,
          end: heightItem,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.5,
              0.8,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        super(key: key);

  final double startPosition;
  final double endPosition;
  final double heightItem;
  final double widthItem;
  final Animation<double> controller;
  final Animation<double> opacity;
  final Animation<double> width;
  final Animation<double> height;
  final Animation<EdgeInsets> movement;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget child) {
        return Container(
          padding: movement.value,
          transform: Matrix4.identity(),
          alignment: Alignment.center,
          child: Opacity(
            opacity: opacity.value,
            child: Container(
              width: width.value/2,
              height: height.value/2,
              child: Image(
                image: AssetImage('assets/images/icon_stolen_small.png'),
              ),
            ),
          ),
        );
      },
    );
  }
}

class StealFailed extends StatelessWidget {
  StealFailed(
      {Key key,
        this.controller,
        this.heightItem,
        this.widthItem,
        this.startPosition,
        this.endPosition})
      : opacity = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(
    CurvedAnimation(
      parent: controller,
      curve: Interval(
        0.0,
        0.2,
        curve: Curves.fastOutSlowIn,
      ),
    ),
  ),
        movement = EdgeInsetsTween(
          begin: EdgeInsets.only(bottom: startPosition, left: 0.0),
          end: EdgeInsets.only(bottom: endPosition, left: 0.0),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.2,
              0.8,
              curve: Curves.slowMiddle,
            ),
          ),
        ),
        width = Tween<double>(
          begin: 50.0,
          end: widthItem,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.6,
              0.9,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        height = Tween<double>(
          begin: 50.0,
          end: heightItem,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.6,
              0.9,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        super(key: key);

  final double startPosition;
  final double endPosition;
  final double heightItem;
  final double widthItem;
  final Animation<double> controller;
  final Animation<double> opacity;
  final Animation<double> width;
  final Animation<double> height;
  final Animation<EdgeInsets> movement;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget child) {
        return Container(
          padding: movement.value,
          transform: Matrix4.identity(),
          alignment: Alignment.center,
          child: Opacity(
            opacity: opacity.value,
            child: Container(
              width: width.value/2,
              height: height.value/2,
              child: Image(
                image: AssetImage('assets/images/icon_steal.png'),
              ),
            ),
          ),
        );
      },
    );
  }
}
