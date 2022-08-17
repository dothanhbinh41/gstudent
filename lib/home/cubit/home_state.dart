import 'package:flutter/cupertino.dart';
import 'package:gstudent/api/dtos/Character/character.dart';

@immutable
abstract class HomeState {}

class HomeStateInitial extends HomeState {}

class ShowDialogCreatCharacter extends HomeState {}

class LoadedCharacter extends HomeState {
  List<Character> data;
  LoadedCharacter({this.data});
}

class CreateCharacterSuccess extends HomeState {

}

class CreateCharacterError extends HomeState {}


class GetAllCharacter extends HomeState {}

class GetAllCharacterResponse extends HomeState {}


class LoadingData extends HomeState {}

class LoadDataSuccess extends HomeState {}

class LoadDataError extends HomeState {}


class CreateClan extends HomeState {

}







