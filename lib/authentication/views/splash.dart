import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:gstudent/authentication/cubit/login_cubit.dart';
import 'package:gstudent/authentication/services/authentication_services.dart';
import 'package:gstudent/authentication/views/login_view.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';

class SplashScreen extends StatefulWidget   {
  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>  with TickerProviderStateMixin{
  final service = GetIt.instance.get<AuthenticationService>();
  final setting = GetIt.instance.get<ApplicationSettings>();
  Timer _timer;
  int percent = 0;
  bool isNavigate = false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {

      final response = await Future.delayed(Duration(milliseconds: 50));
      navigation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: SpinKitFadingCircle(
      color: Colors.black,
      size: 50.0,
    ))

    );
  }

  navigation() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => BlocProvider.value(
        value: AuthenticationCubit(service: service),
        child: LoginView(),
      ),
    ));
  }
}

