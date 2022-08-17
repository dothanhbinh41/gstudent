import 'dart:convert';

import 'package:gstudent/api/dtos/Authentication/forgot_password.dart';
import 'package:gstudent/api/dtos/Authentication/login_response.dart';
import 'package:gstudent/api/dtos/Route/courses.dart';
import 'package:injectable/injectable.dart';

import '../base/ApiBase.dart';

@injectable
class AuthenticationApi {
  @factoryMethod
  Future<LoginResponse> logInAsync(String username, String password, String firebase_token, bool isIos) async {
    try {
      print({'email_phone': username, 'password': password, 'access_token': firebase_token, 'device': isIos ? 1 : 0});
      var res = await httpPost('/api/auth/signin', {'email_phone': username, 'password': password, 'access_token': firebase_token, 'device': isIos ? 1 : 0});
      print(res.body);
      var body = LoginResponse.fromJson(jsonDecode(res.body));
      return body;
    } catch (e) {
      print('error api login');
      print(e);
    }
  }

  @factoryMethod
  Future<LoginResponseVer2> logInAsyncVer2(String username, String password, String firebase_token, bool isIos) async {
    try {
      print({'email_phone': username, 'password': password, 'access_token': firebase_token, 'device': isIos ? 1 : 0});
      var res = await httpPost('/api/auth/signin', {'email_phone': username, 'password': password, 'access_token': firebase_token, 'device': isIos ? 1 : 0});
      print(res.body);
      var body = LoginResponseVer2.fromJson(jsonDecode(res.body));
      return body;
    } catch (e) {
      print('error api login ver 2');
      print(e);
    }
  }

  @factoryMethod
  Future<CourseResponse> getRoute(String token) async {
    try {
      var res = await httpHeaderGet('/api/island-learning',token);
      print(res.body);
      var body = CourseResponse.fromJson(jsonDecode(res.body));
      return body;
    } catch (e) {
      print('error api getRoute');
      print(e);
    }
    return null;
  }


  @factoryMethod
  Future<FogotPasswordResponse> forgotPassword(String email) async {
    try {
      var res = await httpPost('/api/users/verification-code', {'verify_input': email});
      print(res.body);
      var body = fogotPasswordResponseFromJson(res.body);
      return body;
    } catch (e) {
      print('error api registerAccountAsync');
      print(e);
    }
  }

  @factoryMethod
  Future<FogotPasswordResponse> verifyForgotPassword(String email, String pass, String verifyCode) async {
    try {
      var res = await httpPost('/api/users/forget-password', {'verify_input': email, 'new_password': pass, 'confirm_new_password': pass, 'verify_code': verifyCode});
      print(res.body);
      var body = fogotPasswordResponseFromJson(res.body);
      return body;
    } catch (e) {
      print('error api registerAccountAsync');
      print(e);
    }
  }

  @factoryMethod
  Future<LoginResponse> logInGoogle(String token, bool isIos) async {
    try {
      var res = await httpPost('/api/auth/signin-google', {'access_token': token, 'device': isIos ? 1 : 0});
      print(res.body);
      var body = LoginResponseFromJson(res.body);
      return body;
    } catch (e) {
      print(e);
      print('error login facebook');
    }
    return null;
  }

  @factoryMethod
  Future<bool> logInApple(String token) async {
    var res = await httpPost('/api/auth/signin-apple', {'access_token': token});

    var body = jsonDecode(res.body);
    return true;
    //  return SignInResultDto.fromJson(body);
  }

  @factoryMethod
  Future<LoginResponse> logInFacebook(String token, bool isIos) async {
    try {
      var res = await httpPost('/api/auth/signin-facebook', {'access_token': token, 'device': isIos ? 1 : 0});
      if (jsonDecode(res.body)['data'] == null) {
        LoginResponse data = LoginResponse(data: null, message: jsonDecode(res.body)['message'], error: jsonDecode(res.body)['error']);
        return data;
      } else {
        var body = LoginResponseFromJson(res.body);
        print(body.data.userInfo.accessToken);
        return body;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  @factoryMethod
  Future<bool> getVerifyPinCode(String email) async {
    var res = await httpPost('/api/users/verification-code', {'verify_input': email});
    if (res.statusCode != 200) {
      return false;
    }
    var body = jsonDecode(res.body);
    return true;
    //  return SignInResultDto.fromJson(body);
  }

  @factoryMethod
  Future<bool> sendVerifyPinCode(String email) async {
    var res = await httpPost('/api/auth/send-verify-phone', {'verify_input': email});
    if (res.statusCode != 200) {
      return false;
    }
    var body = jsonDecode(res.body);
    return true;
    //  return SignInResultDto.fromJson(body);
  }


  @factoryMethod
  Future<bool> checkTokenExpire(String token) async {
    var res = await httpHeaderGet('api/user-badge/list', token );
    if (res.statusCode != 200) {
      return false;
    }
    return true;
    //  return SignInResultDto.fromJson(body);
  }


}
