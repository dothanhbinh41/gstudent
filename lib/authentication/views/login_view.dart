import 'dart:io' show Platform;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gstudent/api/dtos/noti/notification_model.dart';
import 'package:gstudent/api/dtos/trial_class/trial_class_dto.dart';
import 'package:gstudent/authentication/cubit/login_cubit.dart';
import 'package:gstudent/authentication/cubit/login_state.dart';
import 'package:gstudent/authentication/services/authentication_services.dart';
import 'package:gstudent/authentication/services/trial_class_service.dart';
import 'package:gstudent/authentication/views/forgot_password.dart';
import 'package:gstudent/authentication/views/loading_screen.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/common/controls/running_text.dart';
import 'package:gstudent/common/controls/text_painting.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/common/utils.dart';
import 'package:gstudent/main.dart';
import 'package:gstudent/result/views/result_test_input.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';
import 'package:gstudent/settings/views/notification_dialog.dart';
import 'package:gstudent/settings/views/notification_view.dart';
import 'package:gstudent/story/test_input/StoryTestInput.dart';
import 'package:gstudent/testinput/cubit/testinput_cubit.dart';
import 'package:gstudent/testinput/services/testinput_services.dart';
import 'package:gstudent/testinput/views/do_test_input_view.dart';
import 'package:gstudent/waiting/views/waiting_zoom.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LoginView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  bool isLoadingScreen = false;
  bool isShowPassword = false;
  TextEditingController email = TextEditingController();

  TextEditingController pass = TextEditingController();
  AuthenticationCubit cubit;
  PackageInfo packageInfo;
  String version = '';
  ApplicationSettings applicationSettings;
  bool isIos = false;
  String firebaseToken;
  FocusNode _focusEmail = new FocusNode();
  FocusNode _focusPassword = new FocusNode();
  int userId;
  TestInputService testinputService;
  TrialClass trialClass;
  bool isHaveTestInput = false;
  String messageNoti;
  List<NotificationModel> notifications;

  int idTestinput;

  @override
  void initState() {
    super.initState();
    loadImage();
    cubit = BlocProvider.of<AuthenticationCubit>(context);
    applicationSettings = GetIt.instance.get<ApplicationSettings>();
    checkTokenExpire();
    getVersion();
    isIos = Platform.isIOS;
    _focusPassword.addListener(_onFocusChangePass);
    _focusEmail.addListener(_onFocusChangeEmail);
    testinputService = GetIt.instance.get<TestInputService>();
    FirebaseMessaging.instance.getToken().then((token) {
      print('firebase_token');
      print(token);
      firebaseToken = token;
    });
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        setState(() {
          messageNoti = message.notification.title;
        });
      } else {
        if (message.data != null && message.data.values.isNotEmpty) {
          setState(() {
            messageNoti = message.data.values.first ?? message.data.values.last;
          });
        }
      }
      loadNoti();
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print(event.data.values.first);
      setState(() {
        // messageNoti = event.data.values.first.toString();
      });
    });

    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('A new onMessageOpenedApp event was published!');
    //   print(message);
    //   RemoteNotification notification = message.notification;
    //   AndroidNotification android = message.notification?.android;
    //   if (notification != null && android != null) {
    //     showDialog(
    //         context: context,
    //         builder: (_) {
    //           return AlertDialog(
    //             title: Text(notification.title),
    //             content: SingleChildScrollView(
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [Text(notification.body)],
    //               ),
    //             ),
    //           );
    //         });
    //   }
    // });
  }

  // Future<dynamic> onSelectNotification(String payload) async {
  //   /*Do whatever you want to do on notification click. In this case, I'll show an alert dialog*/
  //   showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: Text(payload),
  //       content: Text("Payload: $payload"),
  //     ),
  //   );
  // }

  void _onFocusChangeEmail() {
    if (_focusEmail.hasFocus) {
      setState(() {
        _focusPassword.unfocus();
      });
    } else {
      // disableFocus();
    }
  }

  void _onFocusChangePass() {
    if (_focusPassword.hasFocus) {
      setState(() {
        _focusEmail.unfocus();
      });
    } else {
      // disableFocus();
    }
  }

  disableFocus() {
    SystemChannels.textInput.invokeListMethod("TextInput.hide");
    _focusEmail.unfocus();
    _focusPassword.unfocus();
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    print(message);

    if (message.data['type'] == 'chat') {}
  }

  loadAccount() async {
    // var check = await cubit.checkExpiredToken();
    var account = await applicationSettings.getAccount();
    if (account != null) {
      setState(() {
        email.text = account.email;
      });
    }
    // checkTokenExpire();
  }

  checkTokenExpire() async {
    if (cubit != null) {
      var check = await cubit.isTokenEpire();
      if (check) {
        var dataLogin = await applicationSettings.getCurrentUser();
        setState(() {
          this.userId = dataLogin.userInfo.id;
        });
        cubit.emit(LoginSuccess(success: true));
      }
    }
  }

  getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
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
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: BlocListener<AuthenticationCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                loadDataTestAndTrial(state.success);
              } else if (state is LoginError) {
                toast(context, state.error);
              } else if (state is ForgotPasswordClicked) {
                navigateToForgotPassword();
              }
            },
            child: Stack(
              children: [
                imageBackground(),
                Positioned(
                    width: 56,
                    top: 16,
                    right: 16,
                    child: SafeArea(
                      child: isLoadingScreen
                          ? GestureDetector(
                              child: iconNotification(),
                            )
                          : Container(),
                    )),
                Positioned(
                    width: 180,
                    top: 16,
                    left: 16,
                    child: SafeArea(
                        child: Row(
                      children: [
                        isLoadingScreen
                            ? (trialClass != null
                                ? GestureDetector(
                                    onTap: () => navigateTrialClass(),
                                    child: Container(
                                      width: 60,
                                      height: 80,
                                      child: Column(
                                        children: [
                                          Image(
                                            image: AssetImage(
                                                'assets/images/girl.png'),
                                            height: 60,
                                          ),
                                          Container(
                                            child: Text(
                                              'Học thử',
                                              style: ThemeStyles.styleBold(
                                                  font: 14,
                                                  textColors: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                : Container())
                            : Container(),
                        isLoadingScreen
                            ? (isHaveTestInput
                                ? GestureDetector(
                                    onTap: () => testinput(),
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      child: Column(
                                        children: [
                                          Image(
                                            image: AssetImage(
                                                'assets/images/boy.png'),
                                            height: 60,
                                          ),
                                          Container(
                                            child: Text(
                                              'Test đầu vào',
                                              style: ThemeStyles.styleBold(
                                                  font: 12,
                                                  textColors: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                : Container())
                            : Container(),
                      ],
                    ))),
                Positioned(
                  child: isLoadingScreen
                      ? (messageNoti != null ? notify() : Container())
                      : Container(),
                  top: MediaQuery.of(context).size.height * 0.31,
                  right: 0,
                  left: 0,
                ),
                isLoadingScreen
                    ? LoadingScreen(
                        isBackLogin: (b) {
                          if (b == true) {
                            setState(() {
                              isLoadingScreen = false;
                            });
                          }
                        },
                      )
                    : component(),
                Positioned(
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        right: 0,
                        left: 0,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.8)),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        left: 0,
                        bottom: 0,
                        child: Center(
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text:
                                        'Sản xuất bởi Edutalk - 2021. Version ',
                                    style: ThemeStyles.styleNormal(
                                        font: 14, textColors: Colors.white)),
                                TextSpan(
                                    text: version,
                                    style: ThemeStyles.styleBold(
                                        font: 14, textColors: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  height: 24,
                  bottom: 0,
                  left: 0,
                  right: 0,
                )
              ],
            ),
          )),
    );
  }

  iconNotification() {
    return notifications != null && notifications.isNotEmpty
        ? GestureDetector(
            onTap: () async {
              if (notifications == null || notifications.isEmpty) {
                toast(context, 'Không có thông báo.');
                return;
              }
              await showDialog(
                  context: context,
                  builder: (buildContext) {
                    return NotificationView(
                      notifications: notifications,
                    );
                  });
            },
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color: HexColor("#B3471a11"), offset: Offset(1, 1))
                    ],
                  ),
                  child: Image(
                    image: AssetImage('assets/images/game_loa_icon.png'),
                  ),
                ),
                Positioned(
                  child: Container(
                    child: Image(
                      image: AssetImage('assets/images/game_noti_icon.png'),
                      height: 28,
                      width: 28,
                    ),
                  ),
                  right: 0,
                )
              ],
            ),
          )
        : Container();
  }

  notify() {
    return Stack(
      children: [
        Container(
          height: 48,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: HexColor("#66000000"),
          ),
          child: Center(
            child: RunningText(
              text: messageNoti != null ? messageNoti : "",
              marqueeDirection: RunningTextDirection.rtl,
              speed: 20,
              style: TextStyle(
                  color: Colors.white, fontFamily: 'SourceSerifPro-Bold'),
              alwaysScroll: true,
              onEnd: (value) {
                setState(() {
                  messageNoti = null;
                });
              },
            ),
          ),
          margin: EdgeInsets.fromLTRB(32, 8, 16, 8),
        ),
        Container(
          child: Stack(
            children: [
              Container(
                height: 60,
                width: 60,
                child: Stack(
                  children: [
                    Image(
                      image:
                          AssetImage('assets/images/game_bg_notification.png'),
                    ),
                    Center(
                      child: Image(
                        image: AssetImage('assets/images/game_loa_icon.png'),
                        height: 48,
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                child: Image(
                  image: AssetImage('assets/images/game_noti_icon.png'),
                  height: 24,
                  width: 24,
                ),
                top: 0,
                right: 0,
              )
            ],
          ),
        ),
      ],
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
    return GestureDetector(
      onTap: () => disableFocus(),
      child: Column(children: [
        Expanded(child: Container(), flex: 5),
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(image: bgDialog, fit: BoxFit.fill)),
          height: 420,
          width: MediaQuery.of(context).size.width * 0.9 > 400
              ? 400
              : MediaQuery.of(context).size.width * 0.9,
          child: Stack(
            children: [
              Positioned(
                child: Column(
                  children: [
                    Container(
                      height: 16,
                    ),
                    Center(
                      child: textpaintingBoldBase(
                          "Đăng nhập", 24, Colors.black, Colors.transparent, 2),
                    ),
                    Container(
                      height: 16,
                    ),
                    Image(
                      image: AssetImage('assets/images/eclipse_login.png'),
                      fit: BoxFit.fill,
                    ),
                    Container(
                      height: 8,
                    ),
                    textfieldEmail(),
                    textfieldPassword(),
                    buttonLogin(),
                    GestureDetector(
                      onTap: () {
                        cubit.emit(ForgotPasswordClicked());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: HexColor("#495a94")))),
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                        child: Text(
                          "Quên mật khẩu",
                          style: TextStyle(
                              color: HexColor("#495a94"),
                              fontSize: 18,
                              fontFamily: 'SourceSerifPro'),
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                    // anotherLogin(),
                    Expanded(child: Container()),
                    Container(
                      child: Image(
                        image: AssetImage('assets/images/ellipse.png'),
                      ),
                    ),
                  ],
                ),
                top: 0,
                right: 16,
                left: 16,
                bottom: 16,
              )
            ],
          ),
        ),
        Expanded(
          child: Container(),
          flex: 4,
        ),
      ]),
    );
  }

  facebook() {
    return GestureDetector(
      onTap: () async {
        showLoading();
        var res = await cubit.loginFacebook(firebaseToken, isIos);
        hideLoading();
        if (res != null && res.error == false) {
          setState(() {
            this.userId = res.data.userInfo.id;
          });
          cubit.emit(LoginSuccess(success: true));
        } else {
          cubit.emit(LoginError(error: res.message));
        }
      },
      child: Container(
        height: 32,
        width: 32,
        child: Center(
            child: Image(
          image: AssetImage('assets/images/icon_fb.png'),
          fit: BoxFit.fill,
        )),
      ),
    );
  }

  google() {
    return GestureDetector(
      onTap: () => loginGoogle(firebaseToken),
      child: Container(
        height: 32,
        width: 32,
        child: Center(
            child: Image(
          image: AssetImage('assets/images/icon_google.png'),
          fit: BoxFit.fill,
        )),
      ),
    );
  }

  apple() {
    return Container(
      height: 32,
      width: 32,
      child: Center(
          child: Image(
        image: AssetImage('assets/images/icon_apple.png'),
        fit: BoxFit.fill,
      )),
    );
  }

  anotherLogin() {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Row(
        children: [
          Expanded(child: Container()),
          Expanded(child: facebook()),
          Expanded(child: Container()),
          Expanded(child: google()),
          Expanded(child: Container()),
          isIos ? Expanded(child: apple()) : Container(),
          isIos ? Expanded(child: Container()) : Container(),
        ],
      ),
    );
  }

  login() async {
    disableFocus();
    // isLoading(context);
    if (email.text.isEmpty || pass.text.isEmpty) {
      // showMessage("Error", "Email or Password can not empty");
      toast(context, 'Email và mật khẩu không được để trống');
      return;
    }
    if (isEmail(email.text) == false && validateMobile(email.text) == false) {
      toast(context, 'Không đúng định dạng email hoặc số điện thoại');
      return;
    }
    showLoading();
    var res = await cubit.loginClicked(email.text, pass.text, firebaseToken,
        isIos, int.parse(version.split('.').last));
    hideLoading();

    if (res != null && res.data != null) {
      setState(() {
        this.userId = res.data.userInfo.id;
      });
      cubit.emit(LoginSuccess(success: true));
    } else {
      cubit.emit(LoginError(error: res.message ?? ""));
    }
    hideLoading();
  }

  textfieldEmail() {
    return Container(
      height: 48,
      margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
      decoration: BoxDecoration(
        border: Border.all(color: HexColor("#ad9958"), width: 2),
        color: HexColor("#fff6d8"),
      ),
      child: TextField(
        style: TextStyle(
            fontFamily: "SourceSerifPro",
            color: Colors.black,
            fontWeight: FontWeight.w400),
        controller: email,
        onChanged: (value) {
          //  loginHelper.checkEmail(value);
        },
        decoration: new InputDecoration(
            contentPadding: EdgeInsets.all(10),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            hintText: 'Email hoặc số điện thoại',
            hintStyle: TextStyle(
                fontFamily: "SourceSerifPro",
                color: Colors.black,
                fontWeight: FontWeight.w400)),
      ),
    );
  }

  textfieldPassword() {
    return Container(
      height: 48,
      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        border: Border.all(color: HexColor("#ad9958"), width: 2),
        color: HexColor("#fff6d8"),
      ),
      child: TextField(
        controller: pass,
        style: TextStyle(
            fontFamily: "SourceSerifPro",
            color: Colors.black,
            fontWeight: FontWeight.w400),
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
            hintText: 'Mật khẩu',
            labelStyle: TextStyle(
                fontFamily: "SourceSerifPro",
                color: Colors.black,
                fontWeight: FontWeight.w400),
            hintStyle: TextStyle(
                fontFamily: "SourceSerifPro",
                color: Colors.black,
                fontWeight: FontWeight.w400)),
      ),
    );
  }

  buttonLogin() {
    return GestureDetector(
        onTap: () => login(),
        child: Container(
            margin: EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: ButtonYellowLarge('ĐĂNG NHẬP')));
  }

  navigateToForgotPassword() async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => BlocProvider.value(
        value: AuthenticationCubit(
            service: GetIt.instance.get<AuthenticationService>()),
        child: ForgotPasswordView(),
      ),
    ));
  }

  loginGoogle(String firebaseToken) async {
    var res = await cubit.loginGoogle(firebaseToken, isIos);
    if (res != null && res.data != null) {
      setState(() {
        this.userId = res.data.userInfo.id;
      });
      cubit.emit(LoginSuccess(success: true));
    } else {
      cubit.emit(LoginError(error: res.message));
    }
  }

  testinput() async {
    showLoading();
    var resultTestInput = await testinputService.getResultTest(this.userId);
    var r = await testinputService.checkZoomTestInput(this.userId);
    hideLoading();
    var firstTimeInApp = await applicationSettings.getFirstTimeTest();
    if (resultTestInput != null && resultTestInput.data != null  ) {
      if(resultTestInput.data.statusMark == true ){
        await showDialog(
            context: context,
            builder: (context) => ResultTestInputView(
              data: resultTestInput.data,
            ),
            useSafeArea: false);
      }else{
        toast(context, 'Đang chờ chấm điểm');
      }
    }
    else {
      if( r != null && r.data != null){
        if(r.data.timeZoom.day == DateTime.now().day){
          if (r.data.zoomId != null && r.data.zoomId.isNotEmpty && r.data.zoomPassword != null && r.data.zoomPassword.isNotEmpty  ){
            if( DateTime.now().isBefore(r.data.timeZoom.add(Duration(minutes: 15)))){
              if (firstTimeInApp) {
                var story = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => StoryTestInput(),
                ));
                if (story != null && story == true) {
                  await applicationSettings.saveFirstTimeTest(story);
                }
              }
              var firstTimeCheckMeet =
              await applicationSettings.getMeetingTestinput(this.idTestinput);
              if (r.data.typeTest == null || firstTimeCheckMeet == false) {
                if (r.data != null &&
                    r.data.zoomId != null &&
                    r.data.zoomPassword != null) {
                  var z = await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        WaitTingZoom(
                            timeWait:DateTime.now().add(Duration(seconds: 10)) ,
                            time:r.data.timeZoom ),
                  ));
                  if (z == true) {
                    await cubit.initZoomOptions(r.data.zoomId.replaceAll(' ', ''),
                        r.data.zoomPassword.replaceAll(' ', ''), this.idTestinput);
                    var checkMeet = await applicationSettings
                        .getMeetingTestinput(this.idTestinput);
                    if (checkMeet == true) {
                      showLoading();
                      var a = await testinputService.checkZoomTestInput(this.userId);
                      hideLoading();
                      if (a.data.typeTest == null) {
                        toast(context,
                            'Tester vẫn chưa nhập đề cho bạn. Xin vui lòng vào lại zoom');
                        await Future.delayed(Duration(seconds: 2));
                        await cubit.initZoomOptions(
                            r.data.zoomId.replaceAll(' ', ''),
                            r.data.zoomPassword.replaceAll(' ', ''),
                            this.idTestinput);
                        return;
                      }
                      var resTesst = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: TestInputCubit(
                              settings: applicationSettings,
                              services: testinputService,
                            ),
                            child: DoTestInputView(
                              id: this.userId,
                              type: a.data.typeTest,
                            ),
                          ),
                        ),
                      );
                      if (resTesst != null && resTesst == true) {
                        await applicationSettings.deleteMeetingTestinput(this.userId);
                      }
                    }
                  }
                } else {
                  if (firstTimeCheckMeet == true) {
                    showLoading();
                    var a = await testinputService.checkZoomTestInput(this.userId);
                    hideLoading();
                    if (a.data.typeTest == null) {
                      toast(context, 'Tester vẫn chưa nhập đề cho bạn.');
                      return;
                    }
                    var resTesst = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: TestInputCubit(
                            settings: applicationSettings,
                            services: testinputService,
                          ),
                          child: DoTestInputView(
                            id: this.userId,
                            type: a.data.typeTest,
                          ),
                        ),
                      ),
                    );
                    if (resTesst != null && resTesst == true) {
                      await applicationSettings.deleteMeetingTestinput(this.userId);
                    }
                  }
                }
              } else {
                showLoading();
                var a = await testinputService.checkZoomTestInput(this.userId);
                hideLoading();
                var resTesst = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: TestInputCubit(
                        settings: applicationSettings,
                        services: testinputService,
                      ),
                      child: DoTestInputView(
                        id: this.userId,
                        type: a.data.typeTest,
                      ),
                    ),
                  ),
                );
                if (resTesst != null && resTesst == true) {
                  await applicationSettings.deleteMeetingTestinput(this.userId);
                }
              }
            }
            else{
              if(r.data.typeTest != null && r.data.typeTest.isNotEmpty){
                var resTesst = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: TestInputCubit(
                        settings: applicationSettings,
                        services: testinputService,
                      ),
                      child: DoTestInputView(
                        id: this.userId,
                        type: r.data.typeTest,
                      ),
                    ),
                  ),
                );
                if (resTesst != null && resTesst == true) {
                  await applicationSettings.deleteMeetingTestinput(this.userId);
                }
              }
              else{
                toast(context, 'Bạn chưa được chọn đề để kiểm tra');
              }
            }
          }
          else{
            if(r.data.typeTest != null && r.data.typeTest.isNotEmpty){
              var resTesst = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: TestInputCubit(
                      settings: applicationSettings,
                      services: testinputService,
                    ),
                    child: DoTestInputView(
                      id: this.userId,
                      type: r.data.typeTest,
                    ),
                  ),
                ),
              );
              if (resTesst != null && resTesst == true) {
                await applicationSettings.deleteMeetingTestinput(this.userId);
              }
            }
            else{
              toast(context, 'Bạn chưa được chọn đề để kiểm tra');
            }
          }

        }
      }

    }
  }

  navigateTrialClass() async {
    if (trialClass != null) {
      if (trialClass.zoomPassword.isNotEmpty && trialClass.zoomId.isNotEmpty) {
        if (DateTime.now()
            .isBefore(DateTime.parse(trialClass.scheduleStartDate))) {
          var z = await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => WaitTingZoom(
                time: DateTime.parse(trialClass.scheduleStartDate),
                isTrial: true),
          ));
          if (z == true) {
            await cubit.initZoomOptions(trialClass.zoomId.replaceAll(' ', ''),
                trialClass.zoomPassword.replaceAll(' ', ''), this.idTestinput);
          }
        } else if (DateTime.now()
                .isAfter(DateTime.parse(trialClass.scheduleStartDate)) &&
            DateTime.now()
                .isBefore(DateTime.parse(trialClass.scheduleEndDate))) {
          await cubit.initZoomOptions(trialClass.zoomId.replaceAll(' ', ''),
              trialClass.zoomPassword.replaceAll(' ', ''), this.idTestinput);
        } else {
          toast(context, 'Đã quá thời gian');
        }
      } else {}
    }
  }

  void loadDataTestAndTrial(bool isSuccess) async {
    var service = GetIt.instance.get<TrialService>();
    showLoading();
    if ((isIos == false && int.parse(version.split('.').last) > 82) ||( isIos == true && int.parse(version.split('.').last) > 70)) {
      var course = await cubit.getRoute();
      if (course != null && course.data != null) {
        await applicationSettings.saveRoute(course.data.course);
      }
    }
    loadNoti();
    var res = await service.getTrialClass();
    var resultTestInput =
        await testinputService.checkZoomTestInput(this.userId);
    hideLoading();

    setState(() {
      isHaveTestInput = resultTestInput != null && resultTestInput.data != null;
      idTestinput = resultTestInput != null ? resultTestInput.data.id : null;
      trialClass = res != null && res.data.isNotEmpty ? res.data.first : null;
      isLoadingScreen = isSuccess;
    });
  }

  loadNoti() async {
   try{
     showLoading();
     var noti = await cubit.getAllNotification();
     hideLoading();
     setState(() {
       notifications = noti != null && noti.isNotEmpty ? noti : null;
     });
   }catch(e){

   }
  }
}
