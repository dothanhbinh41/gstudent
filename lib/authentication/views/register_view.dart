import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/common/colors/HexColor.dart';

class RegisterView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisterViewState();
}

class RegisterViewState extends State<RegisterView> {

  bool isShowPassword = false;
  bool isShowCfPassword = false;
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController cfpass = TextEditingController();



  @override
  void initState() {
    super.initState();
    loadImage();
  }


  AssetImage bgGame;
  AssetImage bgDialog;

  loadImage(){
    bgGame = AssetImage('assets/bg_login_view.png');
    bgDialog = AssetImage('assets/bg_notification_large.png');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bgGame, context);
    precacheImage(bgDialog, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          imageBackground(),
           component()
        ],
      ),
    );
  }

  imageBackground() {
    return Positioned(
      child: Image(
        image: bgGame,
        fit: BoxFit.fill,
      ),
      top: 0,
      right: 0,
      left: 0,
      bottom: 0,
    );
  }

  component() {
    return  Center(
      child:  Container(
        height: MediaQuery.of(context).size.height*0.8,
        child: Stack(
          children: [
            Positioned(
              child: Image(
                image: bgDialog,
                fit: BoxFit.fill,
              ),
              right: 16,
              left: 16,
              top: 0,
              bottom: 0,
            ),
            Positioned(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 24,
                    ),
                    Center(
                      child: Text(
                        "ĐĂNG KÝ",
                        style: TextStyle(
                            fontSize: 24, fontFamily: "SourceSerifPro",fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      height: 8,
                    ),
                    Image(
                      image: AssetImage('assets/images/eclipse_login.png'),
                      fit: BoxFit.fill,
                    ),
                    Container(
                      height: 8,
                    ),
                    Container(
                      height: 56,
                      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      decoration: BoxDecoration(
                          border: Border.all(color: HexColor("#d5bd8b")),
                          color: HexColor("#fff6d8"),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, -1),
                                color: HexColor("#f0daa4"))
                          ]),
                      child: TextField(
                        controller: email,
                        onChanged: (value) {

                        },
                        decoration: new InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            hintText: 'Họ Tên... ',
                            hintStyle: TextStyle(fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w700)
                        ),
                      ),
                    ),
                    Container(
                      height: 56,
                      margin: EdgeInsets.fromLTRB(16, 8, 16, 16),
                      decoration: BoxDecoration(
                          border: Border.all(color: HexColor("#d5bd8b")),
                          color: HexColor("#fff6d8"),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, -1),
                                color: HexColor("#f0daa4"))
                          ]),
                      child: TextField(
                        controller: phone,
                        onChanged: (value) {
                        },
                        decoration: new InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            hintText: 'Số điện thoại... ',
                            hintStyle: TextStyle(fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w700)
                        ),
                      ),
                    ) ,
                    Container(
                      height: 56,
                      margin: EdgeInsets.fromLTRB(16, 8, 16, 16),
                      decoration: BoxDecoration(
                          border: Border.all(color: HexColor("#d5bd8b")),
                          color: HexColor("#fff6d8"),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, -1),
                                color: HexColor("#f0daa4"))
                          ]),
                      child: TextField(
                        controller: pass,
                        onChanged: (value) {
                        },
                        obscureText:isShowPassword ? false : true,
                        decoration: new InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            hintText: 'Mật khẩu... ',
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isShowPassword =
                                    !isShowPassword;
                                  });
                                },
                                child: isShowPassword
                                    ? Icon(
                                  Icons
                                      .visibility_off_rounded,
                                  color: Colors.black,
                                )
                                    : Icon(Icons.visibility_rounded,
                                    color: Colors.black)),
                            hintStyle: TextStyle(fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w700)
                        ),
                      ),
                    ) ,
                    Container(
                      height: 56,
                      margin: EdgeInsets.fromLTRB(16, 8, 16, 16),
                      decoration: BoxDecoration(
                          border: Border.all(color: HexColor("#d5bd8b")),
                          color: HexColor("#fff6d8"),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, -1),
                                color: HexColor("#f0daa4"))
                          ]),
                      child: TextField(
                        controller: cfpass,
                        onChanged: (value) {
                        },
                        obscureText:isShowCfPassword ? false : true,
                        decoration: new InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            hintText: 'Xác nhận mật khẩu... ',
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isShowCfPassword =
                                    !isShowCfPassword;
                                  });
                                },
                                child: isShowCfPassword
                                    ? Icon(
                                  Icons
                                      .visibility_off_rounded,
                                  color: Colors.black,
                                )
                                    : Icon(Icons.visibility_rounded,
                                    color: Colors.black)),
                            hintStyle: TextStyle(fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w700)
                        ),
                      ),
                    ) ,

                    GestureDetector(
                      onTap: () {
                        // Get.to( VerifyRegisterView(),);
                   //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => VerifyRegisterView(),));
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(16, 8, 16, 24),
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
                                "ĐĂNG KÝ",
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
                      child: Image(
                        image: AssetImage('assets/images/ellipse.png'),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: GestureDetector(
                        onTap: () {
                        //  Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginView(),));
                        },
                        child: Text(
                          "Đăng nhập",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontFamily: 'SourceSerifPro-Bold',
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              top: 0,
              right: 48,
              left: 48,
              bottom: 16,
            )
          ],
        ),
      ),
    );
  }


}
