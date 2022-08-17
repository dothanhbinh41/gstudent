import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gstudent/api/base/HeaderProvider.dart';
import 'package:gstudent/authentication/cubit/login_cubit.dart';
import 'package:gstudent/authentication/services/authentication_services.dart';
import 'package:gstudent/authentication/views/login_view.dart';
import 'package:gstudent/authentication/views/register_view.dart';
import 'package:gstudent/clan/views/arena_fighting_view.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/home/services/notification_service.dart';
import 'package:gstudent/home/views/home_view.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';
import 'package:gstudent/settings/views/notification_dialog.dart';
import 'package:toast/toast.dart';

import 'injection.dart';

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     description: 'This channel is used for important notifications.', // description
//     importance: Importance.high,
//     playSound: true);
//
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (message != null && message.notification != null) {
    showNotification(message.hashCode, message.notification.title != null ? message.notification.title.replaceAll('ECoach', 'Mentor') : "Mentor",
        message.notification.body != null ? message.notification.body.replaceAll('ECoach', 'Mentor') : "Mentor", 'Mentor');
  }
}

Future<void> showNotification(
  int notificationId,
  String notificationTitle,
  String notificationContent,
  String payload, {
  String channelId = '1234',
  String channelTitle = 'Android Channel',
  String channelDescription = 'Default Android Channel for notifications',
  Priority notificationPriority = Priority.high,
  Importance notificationImportance = Importance.max,
}) async {
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
    channelId,
    channelTitle,
    channelDescription: channelDescription,
    playSound: false,
    importance: notificationImportance,
    priority: notificationPriority,
  );
  var iOSPlatformChannelSpecifics =
      new IOSNotificationDetails(presentSound: false);
  var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    notificationId,
    notificationTitle,
    notificationContent,
    platformChannelSpecifics,
    payload: payload,
  );
}

final flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  configureDependencies();
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();
  var init = await Firebase.initializeApp();
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  noti();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

noti() {
  var initializationSettingsAndroid =
      new AndroidInitializationSettings('@mipmap/ielts_mentor_app');
  var initializationSettingsIOS = new IOSInitializationSettings();
  var initializationSettings = new InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print(
        '------------------------MESSAGE----------------------------------------');
    print(message.notification.title);
    if (message.notification != null) {
      showNotification(message.hashCode, message.notification.title != null ? message.notification.title.replaceAll('ECoach', 'Mentor') : "Mentor",
          message.notification.body != null ? message.notification.body.replaceAll('ECoach', 'Mentor') : "Mentor", 'Mentor');
    }
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        onGenerateTitle: (BuildContext context) =>
            AppLocalizations.of(context).appTitle,
        // onGenerateRoute: (settings) => MaterialPageRoute(
        //   builder: (_) => BlocProvider.value(
        //     value: LoginCubit(),
        //     child: LoginView(),
        //   ),
        // ),
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            scrollbarTheme: ScrollbarThemeData(
                isAlwaysShown: false,
                thickness: MaterialStateProperty.all(6),
                thumbColor: MaterialStateProperty.all(Colors.blue),
                radius: Radius.circular(10))),
        initialRoute: Route.gameLogin,
        routes: {
          Route.gameHome: (context) => HomeGamePage(),
          Route.gameLogin: (context) => BlocProvider.value(
                value: AuthenticationCubit(
                    service: GetIt.instance.get<AuthenticationService>(),
                    notiService: GetIt.instance.get<NotificationService>(),
                    applicationSettings:
                        GetIt.instance.get<ApplicationSettings>(),
                    headerProvider: GetIt.instance.get<HeaderProvider>()),
                child: LoginView(),
              ),
          Route.gameRegister: (context) => RegisterView(),
          Route.gameArenaFight: (context) => ArenaFightingView(),
        },
        builder: EasyLoading.init(),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: Locale('vi', 'VN'),
        supportedLocales: [
          const Locale('vi', 'VN'),
          const Locale('en', 'US'),
        ]);
  }
}

class Route {
  static String gameHome = "/gameHome";
  static String splash = "/";
  static String gameLogin = "/login";
  static String gameRegister = "/gameRegister";
  static String gameArenaFight = "/gameArenaFight";
}

void toast(context, String message) {
  Toast.show(
    message,
    context,
    duration: 3,
    backgroundColor: Colors.black54,
    gravity: Toast.BOTTOM,
  );
}

void showPopup(context, String message) async {
  showDialog(
    context: context,
    builder: (context) {
      return NotificationDialogView(message: message,);
    },
  );
}

void showLoading() {
  EasyLoading.show(maskType: EasyLoadingMaskType.black);
}

void hideLoading() {
  EasyLoading.dismiss(animation: false);
}
