
import 'package:flutter/cupertino.dart';
import 'package:gstudent/api/dtos/Course/course.dart';

@immutable
abstract class MapState {}

class MapStateInitial extends MapState {}

class ChoiceIsland extends MapState {}

class MapErrorState extends MapState {
  String message;
  MapErrorState({this.message});
}
class LoadRouteIsland extends MapState {
  int classroomId;
  int idIsland;
  int isLongRoute;
  LoadRouteIsland({this.classroomId,this.idIsland,this.isLongRoute});
}

class CreateClan extends MapState {
  int classroomId;
  int idIsland;
  CreateClan({this.classroomId,this.idIsland});
}

class CreateCharacter extends MapState {
  int classroomId;
  int idIsland;
  CreateCharacter({this.classroomId,this.idIsland});
}


class NavigateToHome extends MapState {
  CourseModel data;
  NavigateToHome({this.data});
}

class NavigateToZoom  extends MapState {
  String zoomId;
  String zoomPass;
  NavigateToZoom({this.zoomId , this.zoomPass});
}

class NavigateStory extends MapState {
 int  islandId;
 int  classroomId;
 int id;
  NavigateStory({this.islandId,this.id,this.classroomId});
}

class NavigateStoryWorld extends MapState {

  NavigateStoryWorld();
}


class NavigateStoryMiddle extends MapState {
  int  islandId;
  int id;
  int  classroomId;
  NavigateStoryMiddle({this.islandId,this.id,this.classroomId});
}

class NavigateStoryEnd extends MapState {
  int  islandId;
  int id;
  int  classroomId;
  bool isSuccess;

  NavigateStoryEnd({this.islandId,this.id,this.classroomId,this.isSuccess});
}


class ErrorNoClass extends MapState {}

