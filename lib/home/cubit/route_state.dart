import 'package:flutter/cupertino.dart';
import 'package:gstudent/api/dtos/Route/route.dart';
import 'package:gstudent/api/dtos/homework/result_homework.dart';

@immutable
abstract class RouteState {}

class RouteStateInitial extends RouteState {}

class ShowDialogLesson extends RouteState {
  Routes lesson;

  ShowDialogLesson({this.lesson});
}

class ShowDialogFeedback extends RouteState {
  Routes lesson;

  ShowDialogFeedback({this.lesson});
}

class DoHomeworkState extends RouteState {
  int lesson;
  int classroomid;
  int timeDoTest;
  bool isTest;
  DateTime endTime;
  ResultHomeworkData resultHomework;
  DoHomeworkState({this.lesson, this.classroomid, this.isTest, this.timeDoTest,this.resultHomework,this.endTime});
}

class DoTestState extends RouteState {
  Routes routeLesson;
  ResultHomeworkData result;
  bool isLast;

  DoTestState( {this.routeLesson, this.result,this.isLast });
}

class ReadDetailLessonState extends RouteState {
  Routes lesson;

  ReadDetailLessonState({this.lesson});
}

class StudyOnlineState extends RouteState {
  Routes lesson;
  bool isTest;
  bool isLast;

  StudyOnlineState({this.lesson, this.isTest,this.isLast});
}
