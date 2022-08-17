import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gstudent/api/base/HeaderProvider.dart';
import 'package:gstudent/api/dtos/Authentication/forgot_password.dart';
import 'package:gstudent/api/dtos/Authentication/login_response.dart';
import 'package:gstudent/api/dtos/Course/course.dart';
import 'package:gstudent/api/dtos/Route/courses.dart';
import 'package:gstudent/api/dtos/noti/notification_model.dart';
import 'package:gstudent/authentication/cubit/login_state.dart';
import 'package:gstudent/authentication/services/authentication_services.dart';
import 'package:gstudent/home/services/notification_service.dart';
import 'package:gstudent/main.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';
import 'package:zoom/zoom.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';

class AuthenticationCubit extends Cubit<LoginState> {
  AuthenticationService service;
  NotificationService notiService;
  ApplicationSettings applicationSettings;
  HeaderProvider headerProvider;

  AuthenticationCubit({this.service,this.applicationSettings,this.headerProvider,this.notiService}) : super(LoginInitial());

  // Future<bool> checkExpiredToken() async {
  //   var token = await service.getToken();
  // // var a = JwtDecoder.decode(token);
  // // print(jsonEncode(a));
  //   return true;
  // }

  Future<bool> isTokenEpire() async {
    if(headerProvider != null){
      var token = await headerProvider.getAuthorization();
      var res = await service.checkTokenExpire(token);
      return res;
    }
  return false;
  }


  Future<LoginResponse> loginClicked(
      String email, String password, String firebase_token, bool isIos, int version) async {
    var res = await service.signInAsync(email, password, firebase_token, isIos,version);
    return res;
  }

  Future<FogotPasswordResponse> forgetPasworrd(
    String email,
  ) async {
    var res = await service.forgotPassword(email);
    return res;
  }

  Future<FogotPasswordResponse> verifyForgetPasworrd(
      String email, String password, String code) async {
    var res = await service.verifyForgotPassword(email, password, code);
    return res;
  }

  Future<List<NotificationModel>> getAllNotification() async {
    var res = await notiService.getAllNoti();
    return res;
  }

  Future<LoginResponse> loginFacebook(String firebase_token, bool isIos) async {
    // showLoading();
    // final _auth = FirebaseAuth.instance;
    // final result = await FacebookAuth.i.login(permissions: ['email', 'public_profile']);
    // if (result.status == LoginStatus.success) {
    //   print('token: ' + result.accessToken.token);
    //   final credential = FacebookAuthProvider.credential(result.accessToken.token);
    //   var user = await _auth.signInWithCredential(credential);
    //   var tk = await user.user.getIdToken();
    //   var res = await service.signInFacebook(tk,isIos);
    //   hideLoading();
    //   return res;
    // }
    // hideLoading();
    // final LoginResult loginResult = await FacebookAuth.instance.login();
    //
    // if (loginResult.status == LoginStatus.success) {
    //   final AccessToken accessToken = loginResult.accessToken;
    //   final OAuthCredential credential = FacebookAuthProvider.credential(accessToken.token);
    //   try {
    //     var u = await FirebaseAuth.instance.signInWithCredential(credential);
    //     print(u.credential.token);
    //   } on FirebaseAuthException catch (e) {
    //     print(e);
    //   } catch (e) {
    //     print(e);
    //   }
    // } else {
    //   // login was not successful, for example user cancelled the process
    // }
  }

  Future<LoginResponse> loginGoogle(String firebase_token, bool isIos) async {
    showLoading();
    final _auth = FirebaseAuth.instance;
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/contacts.readonly',
        ],
      );
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      print(googleUser.email);
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      hideLoading();
      if (googleAuth != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        var user = await _auth.signInWithCredential(credential);
        var tk = await user.user.getIdToken();
        showLoading();
        var res = await service.loginGoogle(tk, isIos);
        hideLoading();
        return res;
      }
    } catch (e) {
      print(e);
      hideLoading();
    }
  }

  bool _isMeetingEnded(String status) {
    if (Platform.isAndroid) {
      return status == "MEETING_STATUS_DISCONNECTING" || status == "MEETING_STATUS_FAILED";
    }
    return status == "MEETING_STATUS_ENDED";
  }

  joinMeeting(ZoomOptions zoomOptions, ZoomMeetingOptions meetingOptions,id) {
    Timer timer;
    var zoom = Zoom();
    zoom.init(zoomOptions).then((results) {
      if(results[0] == 0) {
        zoom.onMeetingStateChanged.listen((status) async  {
          print("[Meeting Status Stream] : " + status[0] + " - " + status[1]);
          if(status[0] == "MEETING_STATUS_CONNECTING"){
            await applicationSettings.saveIsMeetingTestinput(id,true);
          }
          if (_isMeetingEnded(status[0])) {
            print("[Meeting Status] :- Ended");
            timer.cancel();
            // emit(ZoomStateCancelZoom());
          }
        });
        print("listen on event channel");
        zoom.joinMeeting(meetingOptions).then((joinMeetingResult) {
          timer = Timer.periodic(new Duration(seconds: 2), (timer) {
            zoom.meetingStatus(meetingOptions.meetingId)
                .then((status) {
              print("[Meeting Status Polling] : " + status[0] + " - " + status[1]);
            });
          });
        });
      }
    }).catchError((error) {
      print("[Error Generated] : " + error);
    });

  }

 Future initZoomOptions(String idZoom, String passZoom , int idTestInput) async {
    var user = await applicationSettings.getCurrentUser();
    var  zoomOptions = ZoomOptions(
      domain: "zoom.us",
      //https://marketplace.zoom.us/docs/sdk/native-sdks/auth
      //https://jwt.io/
      //--todo from server
      //jwtToken: "your jwtToken",
      appKey: 'NiYtz5xA1H3uIDK7GnUTjgXwADZNIp02WHZn', // Replace with with key got from the Zoom Marketplace ZOOM SDK Section
      appSecret: '6o8zI0xpOG1YM1lRCnZTKC3An2ZpoD7GNAuk', // Replace with with secret got from the Zoom Marketplace ZOOM SDK Section
    );
    var  meetingOptions = ZoomMeetingOptions(
        userId: user.userInfo.name,
        displayName: user.userInfo.name,
        meetingId: idZoom,
        meetingPassword: passZoom,
        disableDialIn: "true",
        disableDrive: "true",
        disableInvite: "true",
        disableShare: "true",
        noAudio: "false",
        noDisconnectAudio: "false");

    joinMeeting(zoomOptions, meetingOptions,idTestInput);
  }

  Future<CourseResponse> getRoute() async {
    var route= await service.getRoute();
    return route;
  }

}
