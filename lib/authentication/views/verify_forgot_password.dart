import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gstudent/authentication/cubit/login_cubit.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/main.dart';

class VerifyForgotPasswordView extends StatefulWidget {
  String email;

  VerifyForgotPasswordView({this.email});

  @override
  State<StatefulWidget> createState() => VerifyForgotPasswordViewState(email: this.email);
}

class VerifyForgotPasswordViewState extends State<VerifyForgotPasswordView> {
  String email;

  VerifyForgotPasswordViewState({this.email});

  TextEditingController otpController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  AuthenticationCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of(context);
    loadImage();
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
        children: [imageBackground(), component()],
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
    return Positioned(
      top: 0,
      right: 0,
      left: 0,
      bottom: 0,
      child: Center(
        child: Container(
          height: 320,
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
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "Qu??n m???t kh???u",
                        style: TextStyle(fontSize: 24, fontFamily: "SourceSerifPro", fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      height: 4,
                    ),
                    Image(
                      image: AssetImage('assets/images/eclipse_login.png'),
                      fit: BoxFit.fill,
                    ),
                    Container(
                      height: 48,
                      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      decoration: BoxDecoration(border: Border.all(color: HexColor("#d5bd8b")), color: HexColor("#fff6d8"), boxShadow: [BoxShadow(offset: Offset(0, -1), color: HexColor("#f0daa4"))]),
                      child: TextField(
                        controller: newPassController,
                        onChanged: (value) {},
                        decoration: new InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            hintText: 'M???t kh???u m???i',
                            hintStyle: TextStyle(fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w700)),
                      ),
                    ),
                    Container(
                      height: 48,
                      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      decoration: BoxDecoration(border: Border.all(color: HexColor("#d5bd8b")), color: HexColor("#fff6d8"), boxShadow: [BoxShadow(offset: Offset(0, -1), color: HexColor("#f0daa4"))]),
                      child: TextField(
                        controller: confirmPassController,
                        onChanged: (value) {},
                        decoration: new InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            hintText: 'Nh???p l???i m???t kh???u m???i',
                            hintStyle: TextStyle(fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w700)),
                      ),
                    ),
                    Container(
                      height: 48,
                      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      decoration: BoxDecoration(border: Border.all(color: HexColor("#d5bd8b")), color: HexColor("#fff6d8"), boxShadow: [BoxShadow(offset: Offset(0, -1), color: HexColor("#f0daa4"))]),
                      child: TextField(
                        controller: otpController,
                        onChanged: (value) {},
                        decoration: new InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            hintText: 'M?? OTP',
                            hintStyle: TextStyle(fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w700)),
                      ),
                    ),

                  ],
                ),
                top: 12,
                right: 48,
                left: 48,
                bottom: 12,
              )
            ],
          ),
        ),
      ),
    );
  }

  changePassword() async {
    if(newPassController.text.isEmpty){
      toast(context, 'M???t kh???u kh??ng ???????c ????? tr???ng');
      return;
    }
    if(confirmPassController.text.isEmpty){
      toast(context, 'Nh???p l???i m???t kh???u kh??ng ???????c ????? tr???ng');
      return;
    }
    if(confirmPassController.text != newPassController.text){
      toast(context, 'Nh???p l???i m???t kh???u kh??ng kh???p');
      return;
    }
    if(otpController.text.isEmpty){
      toast(context, 'M?? Code kh??ng ???????c ????? tr???ng');
      return;
    }

    var res = await  cubit.verifyForgetPasworrd(email, newPassController.text,otpController.text.toString());



  }
}
