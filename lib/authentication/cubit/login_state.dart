import 'package:flutter/material.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginClicked extends LoginState{}

class LoginSuccess extends LoginState {
  final bool success;
  LoginSuccess({this.success});
}

class LoginError extends LoginState {
  final String error;

  LoginError({this.error});
}


class ForgotPasswordClicked extends LoginState{}