import 'dart:convert';

import 'package:gstudent/api/Authentication/authentication_api.dart';
import 'package:gstudent/api/base/HeaderProvider.dart';
import 'package:gstudent/api/dtos/Authentication/forgot_password.dart';
import 'package:gstudent/api/dtos/Authentication/login_response.dart';
import 'package:gstudent/api/dtos/Route/courses.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';
import 'package:injectable/injectable.dart';

import '../../api/dtos/Course/course.dart';

@injectable
class AuthenticationService {
  AuthenticationApi authenticationApi;
  HeaderProvider headerProvider;
  ApplicationSettings applicationSettings;

  AuthenticationService({this.authenticationApi, this.headerProvider, this.applicationSettings});

  Future<String> getToken() async {
    var token = await headerProvider.getAuthorization();
    return token;
  }

  @factoryMethod
  Future<LoginResponse> signInAsync(String username, String password, String firebase_token, bool isIos, int version) async {
    if(( isIos == false  && version > 82 )||( isIos == true && version > 70)){
      var res = await authenticationApi.logInAsyncVer2(username, password, firebase_token, isIos);
      if (res == null) {
        return null;
      }
      if (res.error == false && res.data != null) {
        await applicationSettings.saveAccount(username);
        await headerProvider.saveAuthorization(res.data.userInfo.accessToken);
        await applicationSettings.saveLocalUser( DataLogin.fromJson(res.data.toJson()));
      }
      return LoginResponse.fromJson(res.toJson());

    }
    else{
      var res = await authenticationApi.logInAsync(username, password, firebase_token, isIos);
      if (res == null) {
        return null;
      }
      if (res.error == false && res.data != null) {
        await applicationSettings.saveAccount(username);
        await headerProvider.saveAuthorization(res.data.userInfo.accessToken);
        await applicationSettings.saveLocalUser(res.data);
        await applicationSettings.saveRoute(res.data.course);
      }
      return res;
    }

    // return true;
  }

  @factoryMethod
  Future<LoginResponse> signInFacebook(String token, bool isIos) async {
    var res = await authenticationApi.logInFacebook(token, isIos);
    if (res == null) {
      return null;
    }
    if (res.error == false && res.data != null) {
      await headerProvider.saveAuthorization(res.data.userInfo.accessToken);
      await applicationSettings.saveLocalUser(res.data);
    }
    return res;
  }

  Future<FogotPasswordResponse> forgotPassword(String email) async {
    var res = await authenticationApi.forgotPassword(email);
    if (res != null) {
      return res;
    }
    return null;
  }

  Future<FogotPasswordResponse> verifyForgotPassword(String email, String password, String verifyCode) async {
    var res = await authenticationApi.verifyForgotPassword(email, password, verifyCode);
    if (res != null) {
      return res;
    }
    return null;
  }

  @factoryMethod
  Future<LoginResponse> loginGoogle(String token, bool isIos) async {
    var res = await authenticationApi.logInGoogle(token, isIos);
    if (res == null) {
      return null;
    }
    if (res.error == false && res.data != null) {
      await headerProvider.saveAuthorization(res.data.userInfo.accessToken);
      await applicationSettings.saveLocalUser(res.data);
    }
    return res;
  }

  @factoryMethod
  Future<bool> loginApple(String token) async {
    var res = await authenticationApi.logInApple(token);
    return res;
  }

  @factoryMethod
  Future<LoginResponse> loginFacebook(String token, bool isIos) async {
    var res = await authenticationApi.logInFacebook(token, isIos);
    return res;
  }

  @factoryMethod
  Future<bool> checkTokenExpire(String token) async {
    var res = await authenticationApi.checkTokenExpire(token);
    return res;
  }

  Future<CourseResponse> getRoute() async {
    var token = await headerProvider.getAuthorization();
    var route = await authenticationApi.getRoute(token);
    return route;
  }
}
