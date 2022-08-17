import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/common/colors/HexColor.dart';

class VerifyRegisterView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => VerifyRegisterViewState();
}

class VerifyRegisterViewState extends State<VerifyRegisterView> {
  Timer _timer;
  int timeResend = 60;
  bool canSend = true;
  TextEditingController code = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadImage();
  }
  AssetImage bgDialog;

  loadImage(){
    bgDialog = AssetImage('assets/game_bg_login.png');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bgDialog, context);
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  void startTimer() {
    const oneSec = const Duration(milliseconds: 1000);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          timeResend = timeResend - 1;

          if (timeResend == 0) {
            timer.cancel();
            setState(() {
              timeResend = 60;
              canSend = true;
            });
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          imageBackground(),
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Stack(
                  children: [
                    Positioned(
                      child: Image(
                        image: bgDialog,
                        fit: BoxFit.fill,
                      ),
                      right: 16,
                      top: 0,
                      bottom: 0,
                      left: 16,
                    ),
                    Positioned(
                      child: Column(
                        children: [
                          Container(
                            height: 16,
                          ),
                          Center(
                            child: Text(
                              "ĐĂNG KÝ",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: "SourceSerifPro",
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          Container(
                            height: 8,
                          ),
                          Image(
                            image:
                                AssetImage('assets/images/eclipse_login.png'),
                            fit: BoxFit.fill,
                          ),
                          Container(
                            height: 8,
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Text(
                              'Mã xác nhận được gửi vào số điện thoại 0999379999',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "SourceSerifPro-Bold"),
                            ),
                          ),
                          Container(
                            height: 56,
                            margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: HexColor("#d5bd8b")),
                                        color: HexColor("#fff6d8"),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(0, -1),
                                              color: HexColor("#f0daa4"))
                                        ]),
                                    child: TextField(
                                      controller: code,
                                      onChanged: (value) {},
                                      keyboardType: TextInputType.number,
                                      decoration: new InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                        ),
                                        hintText: 'Mã xác nhận... ',
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 8,
                                ),
                                Expanded(
                                    child: canSend
                                        ? GestureDetector(
                                            onTap: () {
                                              canSend = false;
                                              startTimer();
                                            },
                                            child: Stack(
                                              children: [
                                                Image(
                                                  image: AssetImage(
                                                      'assets/images/button_small_green.png'),
                                                  fit: BoxFit.fill,
                                                ),
                                                Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  left: 0,
                                                  bottom: 0,
                                                  child: Center(
                                                    child: Text(
                                                      "GỬI MÃ",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: HexColor(
                                                              "#e3effa"),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontFamily:
                                                              "SourceSerifPro"),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        : Stack(
                                            children: [
                                              Image(
                                                image: AssetImage(
                                                    'assets/images/button_small_green.png'),
                                                fit: BoxFit.fill,
                                              ),
                                              Positioned(
                                                top: 0,
                                                right: 0,
                                                left: 0,
                                                bottom: 0,
                                                child: Center(
                                                  child: Text(
                                                    "GỬI LẠI (" +
                                                        timeResend.toString() +
                                                        ")",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color:
                                                            HexColor("#e3effa"),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontFamily:
                                                            "SourceSerifPro"),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (code.text.isEmpty) {

                              } else {

                            //    Navigator.of(context).pop();
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(16, 8, 16, 16),
                              height: 56,
                              child: Stack(
                                children: [
                                  Positioned(
                                    child: Image(
                                      image: AssetImage(
                                          'assets/images/game_button_login.png'),
                                      fit: BoxFit.fill,
                                    ),
                                    top: 0,
                                    right: 0,
                                    left: 0,
                                    bottom: 0,
                                  ),
                                  Center(
                                    child: Text(
                                      "XÁC THỰC",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: HexColor("#e3effa"),
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "SourceSerifPro"),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 8, 0, 16),
                            child: Image(
                              image: AssetImage('assets/images/ellipse.png'),
                            ),
                          ),
                        ],
                      ),
                      right: 48,
                      left: 48,
                    )
                  ],
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          )
        ],
      ),
    );
  }

  imageBackground() {
    return Positioned(
      child: Image(
        image: AssetImage('assets/bg_login_view.png'),
        fit: BoxFit.fill,
      ),
      top: 0,
      right: 0,
      left: 0,
      bottom: 0,
    );
  }
}
