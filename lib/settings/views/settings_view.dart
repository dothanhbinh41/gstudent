import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gstudent/authentication/cubit/login_cubit.dart';
import 'package:gstudent/authentication/services/authentication_services.dart';
import 'package:gstudent/authentication/views/login_view.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/custom_switch.dart';
import 'package:gstudent/common/controls/text_outline.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/home/cubit/home_cubit.dart';
import 'package:gstudent/main.dart';
import 'package:gstudent/settings/views/create_support_view.dart';
import 'package:gstudent/settings/views/dialog_change_password.dart';
import 'package:gstudent/settings/views/pact_view.dart';
import 'package:gstudent/settings/views/q_and_a_view.dart';
import 'package:gstudent/settings/views/support_view.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingDialog extends StatefulWidget {
  int userClanId;
  int classroomId;

  SettingDialog({this.userClanId, this.classroomId});

  @override
  State<StatefulWidget> createState() => SettingDialogState(userClanId: this.userClanId, classroomId: this.classroomId);
}

class SettingDialogState extends State<SettingDialog> with SingleTickerProviderStateMixin {
  int userClanId;
  int classroomId;

  SettingDialogState({this.userClanId, this.classroomId});

  String dropdownValue = 'One';

  AnimationController animationController;
  Animation degOneTranslationAnimation;
  Animation degTwoTranslationAnimation;
  Animation degThreeTranslationAnimation;
  Animation rotationAnimation;
  bool isClicked = false;

  final String urlMessenger = 'http://m.me/115553340359824';

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  AssetImage bgDialog;
  String version = '';
  HomeCubit cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of(context);
    loadImage();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    degOneTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0, end: 1.2), weight: 75.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.2, end: 1.0), weight: 25.0),
    ]).animate(animationController);
    degTwoTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0, end: 1.4), weight: 55.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.4, end: 1.0), weight: 45.0),
    ]).animate(animationController);
    degThreeTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0, end: 1.75), weight: 35.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.75, end: 1.0), weight: 65.0),
    ]).animate(animationController);
    rotationAnimation = Tween<double>(begin: 180.0, end: 0.0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOut));
    animationController.addListener(() {
      setState(() {});
    });
    getVersion();
  }

  getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  loadImage() {
    bgDialog = AssetImage('assets/game_bg_info_clan.png');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bgDialog, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
              child: Stack(
            children: [
              Positioned(
                child: Stack(
                  children: [
                    Positioned(
                      top: 16,
                      right: MediaQuery.of(context).size.width > 800 ? 48 : 16,
                      left: MediaQuery.of(context).size.width > 800 ? 48 : 16,
                      bottom: 0,
                      child: Image(
                        image: bgDialog,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      top: 48,
                      right: MediaQuery.of(context).size.width > 800 ? MediaQuery.of(context).size.width * 0.15 : 48,
                      left: MediaQuery.of(context).size.width > 800 ? MediaQuery.of(context).size.width * 0.15 : 48,
                      bottom: 16,
                      child: content(),
                    ),
                    Positioned(child: Container(
                      height: 60,
                      child:
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                            child: Image(
                              image: AssetImage('assets/images/ellipse.png'),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Phiên bản game: ", style: ThemeStyles.styleNormal()),
                              Text(
                                version,
                                style: ThemeStyles.styleNormal(textColors: Colors.blue),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),bottom: 16,
                      right: MediaQuery.of(context).size.width > 800 ? MediaQuery.of(context).size.width * 0.15 : 48,
                      left: MediaQuery.of(context).size.width > 800 ? MediaQuery.of(context).size.width * 0.15 : 48,),
                    Positioned(
                        child: Container(
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                right: MediaQuery.of(context).size.width > 800 ? 60 : 0,
                                bottom: 8,
                                left: MediaQuery.of(context).size.width > 800 ? 60 : 0,
                                child: Image(
                                  image: AssetImage('assets/images/title_result.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Positioned(
                                child: Center(child: textpainting('Cài đặt', 24)),
                                top: 0,
                                right: 0,
                                bottom: 16,
                                left: 0,
                              )
                            ],
                          ),
                        ),
                        top: 0,
                        height: MediaQuery.of(context).size.width > 800 ? 90 : 60,
                        left: 24,
                        right: 24),
                    Positioned(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Image(
                          image: AssetImage('assets/images/game_close_dialog_clan.png'),
                          height: 48,
                          width: 48,
                        ),
                      ),
                      top: 16,
                      right: MediaQuery.of(context).size.width > 800 ? 60 : 16,
                    ),
                  ],
                ),
                bottom: 0,
                top: 0,
                left: 0,
                right: 0,
              ),
              Positioned(
                child: floatingButton(),
                top: 0,
                right: MediaQuery.of(context).size.width * 0.15,
                left: 0,
                bottom: 60,
              )
            ],
          )),
        ],
      ),
    );
  }

  content() {
    return Container(
      child: ListView(
        children: [
          Container(
            height: 24,
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => BlocProvider<HomeCubit>.value(
                    value: cubit, //
                    child: DialogChangePassword(),
                  ));
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              decoration: BoxDecoration(color: HexColor("#fff6d8"), border: Border.all(color: HexColor("#b39858")), borderRadius: BorderRadius.circular(3)),
              margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
              height: 56,
              child: Row(
                children: [
                  Image(
                    image: AssetImage('assets/images/icon_game_password.png'),
                    height: 24,
                    width: 24,
                  ),
                  Container(
                    child: Text("Đổi mật khẩu", style: TextStyle(fontSize: 16, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400)),
                    margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  ),
                  Expanded(child: Container()),
                  Icon(
                    Icons.chevron_right,
                    color: HexColor("#b39858"),
                    size: 24.0,
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
            decoration: BoxDecoration(color: HexColor("#fff6d8"), border: Border.all(color: HexColor("#b39858")), borderRadius: BorderRadius.circular(3)),
            margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
            height: 56,
            child: Row(
              children: [
                Image(
                  image: AssetImage('assets/images/icon_musical.png'),
                  height: 24,
                  width: 24,
                ),
                Container(
                  child: Text("Âm thanh", style: TextStyle(fontSize: 16, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400)),
                  margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                ),
                Expanded(child: Container()),
                Container(
                  width: 80,
                  height: 36,
                  child: CustomSwitch(
                    activeColor: HexColor("#4c4977"),
                    activeText: "On",
                    inactiveText: "Off",
                    activeTextColor: Colors.white,
                    inactiveTextColor: HexColor("#c0c0c0"),
                    inactiveColor: HexColor("#5e5e5e"),
                    value: false,
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
            decoration: BoxDecoration(color: HexColor("#fff6d8"), border: Border.all(color: HexColor("#b39858")), borderRadius: BorderRadius.circular(3)),
            margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
            height: 56,
            child: Row(
              children: [
                Image(
                  image: AssetImage('assets/images/game_icon_notification.png'),
                  height: 24,
                  width: 24,
                ),
                Expanded(
                  child:Container(
                    child: Text("Nhận thông báo", style: TextStyle(fontSize: 16, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400)),
                    margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  ),
                ),
                Container(
                  width: 80,
                  height: 36,
                  child: CustomSwitch(
                    activeColor: HexColor("#4c4977"),
                    activeText: "On",
                    inactiveText: "Off",
                    activeTextColor: Colors.white,
                    inactiveTextColor: HexColor("#c0c0c0"),
                    inactiveColor: HexColor("#5e5e5e"),
                    value: false,
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              showPact();
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              decoration: BoxDecoration(color: HexColor("#fff6d8"), border: Border.all(color: HexColor("#b39858")), borderRadius: BorderRadius.circular(3)),
              margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
              height: 56,
              child: Row(
                children: [
                  Image(
                    image: AssetImage('assets/images/icon_hiep_uoc.png'),
                    height: 24,
                    width: 24,
                  ),
                  Container(
                    child: Text("Hiệp ước", style: TextStyle(fontSize: 16, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400)),
                    margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  ),
                  Expanded(child: Container()),
                  Icon(
                    Icons.chevron_right,
                    color: HexColor("#b39858"),
                    size: 24.0,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              var res = await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    actions: [
                      TextButton(
                        child: const Text('Hủy'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      TextButton(
                        child: const Text('Đăng xuất'),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                    title: Text(
                      'Đăng xuất',
                      style: ThemeStyles.styleNormal(font: 20),
                    ),
                    content: Text('Bạn có muốn đăng xuất không?', style: ThemeStyles.styleNormal()),
                  );
                },
              );
              if (res != null && res == true) {
                var service = GetIt.instance.get<AuthenticationService>();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: AuthenticationCubit(service: service),
                    child: LoginView(),
                  ),
                ));
              }
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              decoration: BoxDecoration(color: HexColor("#fff6d8"), border: Border.all(color: HexColor("#b39858")), borderRadius: BorderRadius.circular(3)),
              height: 56,
              margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
              child: Row(
                children: [
                  Image(
                    image: AssetImage('assets/images/icon_off.png'),
                    height: 24,
                    width: 24,
                  ),
                  Container(
                    child: Text("Đăng xuất", style: TextStyle(fontSize: 16, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400)),
                    margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  ),
                  Expanded(child: Container()),
                  Icon(
                    Icons.chevron_right,
                    color: HexColor("#b39858"),
                    size: 24.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }

  decoration() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
      height: 1.0,
      decoration: BoxDecoration(color: HexColor("#b0a27b")),
    );
  }

  showPact() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return BlocProvider<HomeCubit>.value(
            value: cubit, //
            child: PactView(
              userClanId: this.userClanId,
              classroomId: this.classroomId,
            ),
          );
        });
  }

  final int Valaldad = 80;

  floatingButton() {
    return Stack(
      children: <Widget>[
        Positioned(
            right: 0,
            bottom: 0,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: <Widget>[
                IgnorePointer(
                  child: Container(
                    color: Colors.transparent,
                    height: 150.0,
                    width: 150.0,
                  ),
                ),
                Transform.translate(
                  offset: Offset.fromDirection(getRadiansFromDegree(270), degOneTranslationAnimation.value * 90),
                  child: Transform(
                    transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))..scale(degOneTranslationAnimation.value),
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => BlocProvider<HomeCubit>.value(
                              value: cubit, //
                              child: QAndAView(),
                            ));
                        // showDialog(
                        //     context: context,
                        //     builder: (context) => BlocProvider<HomeCubit>.value(
                        //           value: cubit, //
                        //           child: SupportView(),
                        //         ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 1.0, color: Colors.black38),
                          ),
                        ),
                        child: Text(
                          'Q&A',
                          style: TextStyle(
                            fontFamily: 'SourceSerifPro',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Transform.translate(
                //   offset: Offset.fromDirection(getRadiansFromDegree(240), degTwoTranslationAnimation.value * 85),
                //   child: Transform(
                //     transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))..scale(degTwoTranslationAnimation.value),
                //     alignment: Alignment.center,
                //     child: GestureDetector(
                //       onTap: () {
                //         // Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlocProvider.value(
                //         //     value : ZoomCubit(),
                //         //   child:ZoomView(idZoom: '75035186453',passZoom:'z6R3sX' ,)),));
                //       },
                //       child: Container(
                //         decoration: BoxDecoration(
                //           border: Border(
                //             bottom: BorderSide(width: 1.0, color: Colors.black38),
                //           ),
                //         ),
                //         child: Text('Zoom',
                //             style: TextStyle(
                //               fontFamily: 'SourceSerifPro',
                //               fontWeight: FontWeight.bold,
                //             )),
                //       ),
                //     ),
                //   ),
                // ),
                Transform.translate(
                  offset: Offset.fromDirection(getRadiansFromDegree(240), degTwoTranslationAnimation.value * 95),
                  child: Transform(
                    transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))..scale(degTwoTranslationAnimation.value),
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () => launchTel(),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 1.0, color: Colors.black38),
                          ),
                        ),
                        child: Text('Gọi tổng đài',
                            style: TextStyle(
                              fontFamily: 'SourceSerifPro',
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset.fromDirection(getRadiansFromDegree(215), degTwoTranslationAnimation.value * 90),
                  child: Transform(
                    transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))..scale(degTwoTranslationAnimation.value),
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () => launchMessenger(),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 1.0, color: Colors.black38),
                          ),
                        ),
                        child: Text('Hỗ trợ trực tuyến',
                            style: TextStyle(
                              fontFamily: 'SourceSerifPro',
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset.fromDirection(getRadiansFromDegree(195), degThreeTranslationAnimation.value * 80),
                  child: Transform(
                    transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))..scale(degThreeTranslationAnimation.value),
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () async {
                        await  showDialog(
                            context: context,
                            builder: (context) => BlocProvider<HomeCubit>.value(
                              value: cubit, //
                              child: CreateSupportView(),
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 1.0, color: Colors.black38),
                          ),
                        ),
                        child: Text('Gửi yêu cầu hỗ trợ',
                            style: TextStyle(
                              fontFamily: 'SourceSerifPro',
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                  ),
                ),
                Transform(
                  transform: Matrix4.rotationZ(getRadiansFromDegree(0)),
                  alignment: Alignment.center,
                  child: Container(
                    child: Column(
                      children: [
                        CircularButton(
                          color: isClicked ? Colors.white : HexColor("#dda386"),
                          width: 48,
                          height: 48,
                          icon: Icon(Icons.headset_mic_rounded, color: isClicked ? HexColor("#dda386") : Colors.white),
                          onClick: () {
                            if (animationController.isCompleted) {
                              animationController.reverse();
                            } else {
                              animationController.forward();
                            }
                            setState(() {
                              isClicked = !isClicked;
                            });
                          },
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                            child: Text(
                              'Hỗ trợ',
                              style: ThemeStyles.styleBold(font: 14),
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ))
      ],
    );
  }

  textpainting(String s, double fontSize) {
    return OutlinedText(
      text: Text(s, textAlign: TextAlign.justify, style: TextStyle(fontSize: fontSize, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.bold, color: HexColor("#f8e9a5"))),
      strokes: [
        OutlinedTextStroke(color: HexColor("#681527"), width: 3),
      ],
    );
  }

  launchMessenger() async {
    try {
      showLoading();
      await launch(urlMessenger);
      hideLoading();
    } catch (e) {
      print(e);
    }
  }

  launchTel() async {
    try {
      showLoading();
      await launch('tel://19004788');
      hideLoading();
    } catch (e) {
      print(e);
    }
  }
}

class CircularButton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Icon icon;
  final Function onClick;

  CircularButton({this.color, this.width, this.height, this.icon, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      width: width,
      height: height,
      child: IconButton(icon: icon, enableFeedback: true, onPressed: onClick),
    );
  }
}
