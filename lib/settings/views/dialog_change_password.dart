import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/common/controls/text_painting.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/home/cubit/home_cubit.dart';
import 'package:gstudent/main.dart';

class DialogChangePassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DialogChangePasswordState();
}

class DialogChangePasswordState extends State<DialogChangePassword> {
  HomeCubit cubit;

  TextEditingController oldController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cfPasswordController = TextEditingController();
  AssetImage bgDialog;
  bool isShowOldPass = false;
  bool isShowPass = false;
  bool isShowCfPass = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of(context);
    bgDialog = AssetImage('assets/game_bg_login.png');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bgDialog, context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 300,
        child: Stack(
          children: [
            Positioned(
              child: Image(
                image: bgDialog,
                fit: BoxFit.fill,
              ),
              top: 0,
              right: 0,
              left: 0,
              bottom: 0,
            ),
            Positioned(
              child: Column(
                children: [
                  Text('Đổi mật khẩu', style: ThemeStyles.styleBold(font: 20),),
                  Container(
                    height: 48,
                    margin: EdgeInsets.fromLTRB(16, 8, 16, 4),
                    decoration: BoxDecoration(border: Border.all(color: HexColor("#d5bd8b")), color: HexColor("#fff6d8"), boxShadow: [BoxShadow(offset: Offset(0, -1), color: HexColor("#f0daa4"))]),
                    child: TextField(
                      controller: oldController,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {},
                      obscureText: isShowOldPass ? false : true,
                      style: ThemeStyles.styleNormal(),
                      decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isShowOldPass = !isShowOldPass;
                                });
                              },
                              child: isShowOldPass
                                  ? Icon(
                                Icons.visibility_off_rounded,
                                color: Colors.black,
                              )
                                  : Icon(Icons.visibility_rounded, color: Colors.black)),
                          hintText: 'Mật khẩu cũ',
                          hintStyle: TextStyle(fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400)),
                    ),
                  ),
                  Container(
                    height: 48,
                    margin: EdgeInsets.fromLTRB(16, 8, 16, 4),
                    decoration: BoxDecoration(border: Border.all(color: HexColor("#d5bd8b")), color: HexColor("#fff6d8"), boxShadow: [BoxShadow(offset: Offset(0, -1), color: HexColor("#f0daa4"))]),
                    child: TextField(
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {},
                      obscureText: isShowPass ? false : true,
                      style: ThemeStyles.styleNormal(),
                      decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isShowPass = !isShowPass;
                                });
                              },
                              child: isShowPass
                                  ? Icon(
                                Icons.visibility_off_rounded,
                                color: Colors.black,
                              )
                                  : Icon(Icons.visibility_rounded, color: Colors.black)),
                          hintText: 'Mật khẩu mới',
                          hintStyle: TextStyle(fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400)),
                    ),
                  ),
                  Container(
                    height: 48,
                    margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: BoxDecoration(border: Border.all(color: HexColor("#d5bd8b")), color: HexColor("#fff6d8"), boxShadow: [BoxShadow(offset: Offset(0, -1), color: HexColor("#f0daa4"))]),
                    child: TextField(
                      controller: cfPasswordController,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {},
                      style: ThemeStyles.styleNormal(),
                      obscureText: isShowCfPass ? false : true,
                      decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isShowCfPass = !isShowCfPass;
                                });
                              },
                              child: isShowCfPass
                                  ? Icon(
                                Icons.visibility_off_rounded,
                                color: Colors.black,
                              )
                                  : Icon(Icons.visibility_rounded, color: Colors.black)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          hintText: 'Nhập lại mật khẩu mới',
                          hintStyle: TextStyle(fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400)),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: ButtonGraySmall(
                                'HỦY',
                                fontSize: 12,
                              )),
                        ),
                        Container(
                          width: 8,
                        ),
                        Expanded(
                            child: GestureDetector(onTap: () => changePassword(), child: ButtonYellowSmall('ĐỔI MẬT KHẨU', fontSize: 12,  ))),
                      ],
                    ),
                    margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  )
                ],
              ),
              top: 16,
              right: 8,
              left: 8,
              bottom: 8,
            )
          ],
        ),
      ),
    );
  }

  changePassword() async {

    if(oldController.text.isEmpty){
      toast(context, 'Mật khẩu mới không được để trống');
      return;
    }
    if(passwordController.text.isEmpty){
      toast(context, 'Mật khẩu mới không được để trống');
      return;
    }
    if(cfPasswordController.text.isEmpty){
      toast(context, 'Nhập lại mật khẩu mới không được để trống');
      return;
    }
    if(oldController.text.length <6 ){
      toast(context, 'Mật khẩu cũ không được nhỏ hơn 6 kí tự');
      return;
    }

    if(passwordController.text.length <6 && cfPasswordController.text.length < 6){
      toast(context, 'Mật khẩu mới không được nhỏ hơn 6 kí tự');
      return;
    }
    if(cfPasswordController.text !=passwordController.text ){
      toast(context, 'Nhập lại mật khẩu mới không đúng');
      return;
    }

    var res = await cubit.changePassword(oldController.text,passwordController.text);
    if(res.error == false){
      toast(context, res.message);
      Navigator.of(context).pop();
    }else{
      toast(context, res.message);
      return;
    }

  }
}
