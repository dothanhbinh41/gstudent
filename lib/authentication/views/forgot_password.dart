import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gstudent/authentication/cubit/login_cubit.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/common/utils.dart';
import 'package:gstudent/main.dart';

class ForgotPasswordView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ForgotPasswordViewState();
}

class ForgotPasswordViewState extends State<ForgotPasswordView> with SingleTickerProviderStateMixin {
  TextEditingController emailController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  AuthenticationCubit cubit;
  bool isSendCode = false;
  bool _visibleItem = false;
  bool isShowPassword = false;
  bool isShowCfPassword = false;

  @override
  void initState() {
    super.initState();
    loadImage();
    cubit = BlocProvider.of(context);
  }

  AssetImage bgGame;
  AssetImage bgDialog;

  loadImage() {
    bgGame = AssetImage('assets/bg_login_view.png');
    bgDialog = AssetImage('assets/game_bg_login.png');
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
        children: [imageBackground(), component(),   Positioned(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Image(
              image:
              AssetImage('assets/images/game_button_back.png'),
              height: 48,
              width: 48,
            ),
          ),
          top: 8,
          left: 8,
        ),],
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
    return AnimatedPositioned(
      duration: Duration(milliseconds: 500),
      top: isSendCode ? MediaQuery.of(context).size.height * 0.2 : MediaQuery.of(context).size.height * 0.3,
      right: 0,
      left: 0,
      height: isSendCode ? 400 : 200,
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
                  Center(
                    child: Text(
                      "Quên mật khẩu",
                      style: TextStyle(fontSize: 24, fontFamily: "SourceSerifPro", fontWeight: FontWeight.w700),
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
                    margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                            height: 48,
                            decoration:
                                BoxDecoration(border: Border.all(color: HexColor("#d5bd8b")), color: HexColor("#fff6d8"), boxShadow: [BoxShadow(offset: Offset(0, -1), color: HexColor("#f0daa4"))]),
                            child: TextField(
                              controller: emailController,
                              onChanged: (value) {},
                              style: ThemeStyles.styleBold(),
                              decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent),
                                  ),
                                  hintText: 'Email hoặc số điện thoại',
                                  hintStyle: ThemeStyles.styleBold()),
                            ),
                          ),
                          flex: 2,
                        ),
                        Expanded(
                            child: Center(
                          child: GestureDetector(onTap: () => getPinCode(), child: ButtonYellowSmall('Gửi Code', fontSize: 14, )),
                        )),
                      ],
                    ),
                  ),
                  isSendCode
                      ? AnimatedOpacity(
                          opacity: _visibleItem ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 1500),
                          // The green box must be a child of the AnimatedOpacity widget.
                          child: Container(
                            height: 48,
                            margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                            decoration:
                                BoxDecoration(border: Border.all(color: HexColor("#d5bd8b")), color: HexColor("#fff6d8"), boxShadow: [BoxShadow(offset: Offset(0, -1), color: HexColor("#f0daa4"))]),
                            child: TextField(
                              controller: newPassController,
                              onChanged: (value) {},
                              obscureText: isShowPassword ? false : true,
                              decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isShowPassword = !isShowPassword;
                                        });
                                      },
                                      child: isShowPassword
                                          ? Icon(
                                        Icons.visibility_off_rounded,
                                        color: Colors.black,
                                      )
                                          : Icon(Icons.visibility_rounded, color: Colors.black)),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent),
                                  ),
                                  hintText: 'Mật khẩu mới',
                                  hintStyle: TextStyle(fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w700)),
                            ),
                          ))
                      : Container(),
                  isSendCode
                      ? AnimatedOpacity(
                          opacity: _visibleItem ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 1500),
                          // The green box must be a child of the AnimatedOpacity widget.
                          child: Container(
                            height: 48,
                            margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                            decoration:
                                BoxDecoration(border: Border.all(color: HexColor("#d5bd8b")), color: HexColor("#fff6d8"), boxShadow: [BoxShadow(offset: Offset(0, -1), color: HexColor("#f0daa4"))]),
                            child: TextField(
                              controller: confirmPassController,
                              onChanged: (value) {},
                              obscureText: isShowCfPassword ? false : true,
                              decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isShowCfPassword = !isShowCfPassword;
                                        });
                                      },
                                      child: isShowCfPassword
                                          ? Icon(
                                        Icons.visibility_off_rounded,
                                        color: Colors.black,
                                      )
                                          : Icon(Icons.visibility_rounded, color: Colors.black)),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent),
                                  ),
                                  hintText: 'Nhập lại mật khẩu mới',
                                  hintStyle: TextStyle(fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w700)),
                            ),
                          ))
                      : Container(),
                  isSendCode
                      ? AnimatedOpacity(
                          opacity: _visibleItem ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 1500),
                          // The green box must be a child of the AnimatedOpacity widget.
                          child: Container(
                            height: 48,
                            margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                            decoration:
                                BoxDecoration(border: Border.all(color: HexColor("#d5bd8b")), color: HexColor("#fff6d8"), boxShadow: [BoxShadow(offset: Offset(0, -1), color: HexColor("#f0daa4"))]),
                            child: TextField(
                              controller: otpController,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {},
                              decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent),
                                  ),
                                  hintText: 'Mã xác minh',
                                  hintStyle: TextStyle(fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w700)),
                            ),
                          ))
                      : Container(),
                  AnimatedOpacity(
                    opacity: _visibleItem ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 1500),
                    // The green box must be a child of the AnimatedOpacity widget.
                    child: Container(
                      margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      height: 48,
                      child: GestureDetector(
                          onTap: () => changePassword(), child: Container(child: ButtonYellowLarge('Đổi mật khẩu'))),
                    ),
                  )
                ],
              ),
            ),
            top: 12,
            right: 24,
            left: 24,
            bottom: 12,
          ),

        ],
      ),
    );
  }


  getPinCode() async {
    if (emailController.text.isEmpty) {
      toast(context, 'Email không được để trống');
      return;
    }
    if (isEmail(emailController.text) == false && validateMobile(emailController.text) == false) {
      toast(context, 'Không đúng định dạng email hoặc số điện thoại');
      return;
    }

    var res = await cubit.forgetPasworrd(emailController.text);
    if (res.error == false) {
      toast(context, res.message);
      setState(() {
        isSendCode = true;
      });
      Future.delayed(Duration(milliseconds: 1000)).whenComplete(() {
        setState(() {
          _visibleItem = true;
        });
      });
      // await Navigator.of(context).pushReplacement(MaterialPageRoute(
      //   builder: (_) => BlocProvider.value(
      //     value: AuthenticationCubit(service: GetIt.instance.get<AuthenticationService>()),
      //     child: VerifyForgotPasswordView(
      //       email: email.text,
      //     ),
      //   ),
      // ));
    } else {
      toast(context, res.message);
      return;
    }
  }

  changePassword() async {
    if (newPassController.text.isEmpty) {
      toast(context, 'Mật khẩu không được để trống');
      return;
    }
    if (confirmPassController.text.isEmpty) {
      toast(context, 'Nhập lại mật khẩu không được để trống');
      return;
    }
    if (confirmPassController.text != newPassController.text) {
      toast(context, 'Nhập lại mật khẩu không khớp');
      return;
    }
    if (otpController.text.isEmpty) {
      toast(context, 'Mã xác minh không được để trống');
      return;
    }

    var res = await cubit.verifyForgetPasworrd(emailController.text, newPassController.text, otpController.text);
    if (res != null && res.error == false) {
      toast(context, res.message);
      Navigator.of(context).pop();
    } else {
      toast(context, res.message);
    }
  }
}
