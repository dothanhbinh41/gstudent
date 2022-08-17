import 'dart:convert';

import 'package:gstudent/api/dtos/Authentication/login_response.dart';
import 'package:gstudent/api/dtos/Course/course.dart';
import 'package:gstudent/api/dtos/Exam/GroupQuestionExam.dart';
import 'package:gstudent/api/dtos/TestInput/ielts.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';
import 'package:gstudent/authentication/model/account_login.dart';
import 'package:gstudent/character/model/UserCharacter.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class ApplicationSettings {
  final String keyExam = "save_exam_local_";
  final String keyCurrentCharacterUser = "current_character_user";
  final String keyCurrentUser = "current_user";
  final String keyRoute = "route";
  final String keyCheckFirstTimeLogin = "first_time_login";
  final String keyCheckFirstTimeTest = "first_time_test";
  final String keyCheckFirstTimeStudy = "first_time_study";
  final String keySaveAccount = "save_account";
  final String keyStoryWorld = "story_world";
  final String keyIsland = "start_island_";
  final String keyIslandMiddle = "middle_island_";
  final String keyIslandEnd = "end_island_";
  final String keyLuckyStar = "lucky_start";
  final String keyMeeting = "meeting_";
  final String keyTestInput = "test_input";
  final String keyTimeTest = "time_test";
  final String keyDurationTest = "duration_test";
  final String keyQuestionExam = "question_todo_";
  SharedPreferences current;

  Future init() async {
    if (current == null) {
      current = await SharedPreferences.getInstance();
    }
  }

  Future<bool> saveQuestionTodo(List<GroupQuestion> data, int classroomId,
      int lesson, bool isTest,int time) async {
    await init();
    try {
      String type = isTest ? 'test' : 'homework';
      final dataLogin = current.getString(keyCurrentUser);
      var user = DataLogin.fromJson(jsonDecode(dataLogin));
      SaveQuestionTodo(data: data,time: time);
      var a = SaveQuestionTodo(data: data,time: time);
      await current.setString(
          keyQuestionExam +
              type +
              '_$classroomId ' +
              '_$lesson' +
              '_' +
              user.userInfo.id.toString(),
          jsonEncode(a.toJson()));
      if (current.getString(keyQuestionExam +
              type +
              '_$classroomId ' +
              '_$lesson' +
              '_' +
              user.userInfo.id.toString()) !=
          null) {
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<SaveQuestionTodo> getQuestionTodo(
      int classroomId, int lesson, bool isTest) async {
    await init();
    String type = isTest ? 'test' : 'homework';
    final dataLogin = current.getString(keyCurrentUser);
    var user = DataLogin.fromJson(jsonDecode(dataLogin));
    if (current.containsKey(keyQuestionExam +
        type +
        '_$classroomId ' +
        '_$lesson' +
        '_' +
        user.userInfo.id.toString())) {
      try {
        var js = current.getString(keyQuestionExam +
            type +
            '_$classroomId ' +
            '_$lesson' +
            '_' +
            user.userInfo.id.toString());

        var data =  SaveQuestionTodo.fromJson( jsonDecode(js));
        return data;
      } catch (e) {
        print(e);
      }
    }
    return null;
  }

  Future<bool> deleteLocalQuestionTodo(int classroomId, int lesson, bool isTest) async {
    await init();
    String type = isTest ? 'test' : 'homework';
    final dataLogin = current.getString(keyCurrentUser);
    var user = DataLogin.fromJson(jsonDecode(dataLogin));
    if (current.containsKey(keyQuestionExam +
        type +
        '_$classroomId ' +
        '_$lesson' +
        '_' +
        user.userInfo.id.toString())) {
      var res = await current
          .remove(keyQuestionExam +
          type +
          '_$classroomId ' +
          '_$lesson' +
          '_' +
          user.userInfo.id.toString());
      return res;
    }
  }

  Future<bool> saveTestInput(
      String typeExam, List<QuestionTestInputDto> data, int idUser) async {
    await init();
    SaveQuestionTest json = SaveQuestionTest(data: data);
    // print( jsonEncode(List<dynamic>.from(data.map((x) => x.toJson()))));
    try {
      var j = jsonEncode(data.toList());
      print(j);
      await current.setString(
          keyTestInput + '_' + typeExam + '_' + idUser.toString(), j);
      if (current.getString(
              keyTestInput + '_' + typeExam + '_' + idUser.toString()) !=
          null) {
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<QuestionTestInputDto>> getTestInput(
      String typeExam, int idUser) async {
    await init();
    if (current
        .containsKey(keyTestInput + '_' + typeExam + '_' + idUser.toString())) {
      try {
        var str = current
            .getString(keyTestInput + '_' + typeExam + '_' + idUser.toString());
        print(str);
        var data = List<QuestionTestInputDto>.from(
            jsonDecode(str).map((x) => QuestionTestInputDto.fromJson(x)));
        return data;
      } catch (e) {
        print(e);
      }
    }
    return null;
  }

  Future<bool> deleteLocalQuestion(String typeExam, int idUser) async {
    await init();
    if (current
        .containsKey(keyTestInput + '_' + typeExam + '_' + idUser.toString())) {
      var res = await current
          .remove(keyTestInput + '_' + typeExam + '_' + idUser.toString());
      return res;
    }
  }

  Future<bool> saveExamById(
      int idExam, List<PracticeGroupQuestion> dto, int idUser) async {
    await init();
    print(jsonEncode(dto));
    await current.setString(
        keyExam + idExam.toString() + '_' + idUser.toString(), jsonEncode(dto));
    if (current
            .getString(keyExam + idExam.toString() + '_' + idUser.toString()) !=
        null) {
      return true;
    }
    return false;
  }

  Future<bool> deleteExamById(int idExam, int idUser) async {
    await init();
    if (current
            .getString(keyExam + idExam.toString() + '_' + idUser.toString()) !=
        null) {
      return current
          .remove(keyExam + idExam.toString() + '_' + idUser.toString());
    }
    return false;
  }

  Future<List<PracticeGroupQuestion>> getExamById(
      int idExam, int idUser) async {
    await init();
    if (current
        .containsKey(keyExam + idExam.toString() + '_' + idUser.toString())) {
      try {
        var str = current
            .getString(keyExam + idExam.toString() + '_' + idUser.toString());
        print(str);
        var data = List<PracticeGroupQuestion>.from(
            jsonDecode(str).map((x) => PracticeGroupQuestion.fromJson(x)));
        return data;
      } catch (e) {
        print(e);
      }
    }
    return null;
  }

  Future<bool> saveIsland(int islandId, String id) async {
    await init();
    await current.setBool(
        keyIsland + islandId.toString() + '_' + id.toString(), true);
    if (current
            .getBool(keyIsland + islandId.toString() + '_' + id.toString()) !=
        null) {
      return false;
    }
    return true;
  }

  Future<bool> saveIslandMiddle(int islandId, String id) async {
    await init();
    await current.setBool(
        keyIslandMiddle + islandId.toString() + '_' + id.toString(), true);
    if (current.getBool(
            keyIslandMiddle + islandId.toString() + '_' + id.toString()) !=
        null) {
      return false;
    }
    return true;
  }

  Future<bool> saveStoryWorld() async {
    await init();
    await current.setBool(keyStoryWorld, true);
    if (current.getBool(keyStoryWorld) != null) {
      return false;
    }
    return true;
  }

  Future<bool> getStoryWorld() async {
    await init();
    if (current.getBool(keyStoryWorld) != null) {
      var a = current.getBool(keyStoryWorld);
      return a;
    }
    return false;
  }

  Future<bool> saveIslandEnd(int islandId, String id) async {
    await init();
    await current.setBool(
        keyIslandEnd + islandId.toString() + '_' + id.toString(), true);
    if (current.getBool(
            keyIslandEnd + islandId.toString() + '_' + id.toString()) !=
        null) {
      return false;
    }
    return true;
  }

  Future<bool> getIsland(int islandId, String id) async {
    await init();
    if (current
        .containsKey(keyIsland + islandId.toString() + '_' + id.toString()))
      return current.getBool(
                  keyIsland + islandId.toString() + '_' + id.toString()) !=
              null
          ? true
          : false;
  }

  Future<bool> getIslandMiddle(int islandId, String id) async {
    await init();
    if (current.containsKey(
        keyIslandMiddle + islandId.toString() + '_' + id.toString()))
      return current.getBool(keyIslandMiddle +
                  islandId.toString() +
                  '_' +
                  id.toString()) !=
              null
          ? true
          : false;
  }

  Future<bool> getIslandEnd(int islandId, String id) async {
    await init();
    if (current
        .containsKey(keyIslandEnd + islandId.toString() + '_' + id.toString()))
      return current.getBool(
                  keyIslandEnd + islandId.toString() + '_' + id.toString()) !=
              null
          ? true
          : false;
  }

  Future<bool> saveAccount(String email) async {
    await init();
    String jsonUser = jsonEncode(AccountLogin(email: email));
    current.setString(keySaveAccount, jsonUser);
    if (current.getString(keySaveAccount).isEmpty) {
      return false;
    }
    return true;
  }

  Future<AccountLogin> getAccount() async {
    await init();
    if (current.containsKey(keySaveAccount)) {
      final value = current.getString(keySaveAccount);
      if (value != null) {
        Map userMap = jsonDecode(value);
        var user = AccountLogin.fromJson(userMap);
        return user;
      } else {
        return null;
      }
    }
    return null;
  }

  Future<DataLogin> getCurrentUser() async {
    await init();
    if (current.containsKey(keyCurrentUser)) {
      final value = current.getString(keyCurrentUser);
      Map userMap = jsonDecode(value);
      var user = DataLogin.fromJson(userMap);
      return user;
    }
    return null;
  }

  Future<bool> saveLocalUser(DataLogin user) async {
    await init();
    String jsonUser = jsonEncode(user.toJson());
    current.setString(keyCurrentUser, jsonUser);
    if (current.getString(keyCurrentUser).isEmpty) {
      return false;
    }
    return true;
  }

  Future<List<CourseModel>> getRoute() async {
    await init();
    if (current.containsKey(keyRoute)) {
      print(current.getString(keyRoute));
      final value = current.getString(keyRoute);
      var route = value != null && value != "null"
          ? List<CourseModel>.from(
              jsonDecode(value).map((x) => CourseModel.fromJson(x)))
          : null;
      return route;
    }
    return null;
  }

  Future<bool> saveRoute(List<CourseModel> data) async {
    await init();
    String jsonUser = jsonEncode(data);
    current.setString(keyRoute, jsonUser);
    if (current.getString(keyRoute).isEmpty) {
      return false;
    }
    return true;
  }

  Future<UserCharacter> getCurrentCharacterUser() async {
    await init();
    if (current.containsKey(keyCurrentCharacterUser)) {
      final value = current.getString(keyCurrentCharacterUser);
      Map userMap = jsonDecode(value);
      var user = UserCharacter.fromJson(userMap);
      return user;
    }
    return null;
  }

  Future<bool> saveLocalCharacterUser(UserCharacter user) async {
    await init();
    String jsonUser = jsonEncode(user.toJson());
    current.setString(keyCurrentCharacterUser, jsonUser);
    if (current.getString(keyCurrentCharacterUser).isEmpty) {
      return false;
    }
    return true;
  }

  Future<bool> saveFirstTimeLogin(bool check) async {
    await init();
    String jsonUser = jsonEncode(check);
    current.setString(keyCheckFirstTimeLogin, jsonUser);
    if (current.getString(keyCheckFirstTimeLogin).isEmpty) {
      return false;
    }
    return true;
  }

  Future<bool> getFirstTimeLogin() async {
    await init();
    if (current.containsKey(keyCheckFirstTimeLogin)) {
      final value = current.getString(keyCheckFirstTimeLogin);
      if (value == null) {
        return false;
      }
      bool c = jsonDecode(value);
      return c;
    }
    return false;
  }

  Future<bool> getFirstTimeTest() async {
    await init();
    if (current.containsKey(keyCheckFirstTimeTest)) {
      final value = current.getBool(keyCheckFirstTimeTest);
      if (value == null) {
        return false;
      } else {
        return value;
      }
    }
    return false;
  }

  Future<bool> saveFirstTimeTest(bool check) async {
    await init();
    var set = await current.setBool(keyCheckFirstTimeTest, check);
    if (current.getBool(keyCheckFirstTimeTest) == null) {
      return false;
    }
    return set;
  }

  Future<bool> saveFirstTimeStudy(bool check) async {
    await init();
    var set = await current.setBool(keyCheckFirstTimeStudy, check);
    if (current.getBool(keyCheckFirstTimeStudy) == null) {
      return false;
    }
    return set;
  }

  Future<bool> getFirstTimeStudy() async {
    await init();
    if (current.containsKey(keyCheckFirstTimeStudy)) {
      final value = current.getBool(keyCheckFirstTimeStudy);
      if (value == null) {
        return false;
      }

      return value;
    }
    return false;
  }

  Future<bool> saveUsedLuckyStar(int arenaId, int userId) async {
    await init();
    String jsonUser = jsonEncode(true);
    current.setString(
        keyLuckyStar + '_' + arenaId.toString() + '_' + userId.toString(),
        jsonUser);
    if (current
        .getString(
            keyLuckyStar + '_' + arenaId.toString() + '_' + userId.toString())
        .isEmpty) {
      return false;
    }
    return true;
  }

  Future<bool> getUsedLuckyStar(int arenaId, int userId) async {
    await init();
    if (current.containsKey(
        keyLuckyStar + '_' + arenaId.toString() + '_' + userId.toString())) {
      final value = current.getString(
          keyLuckyStar + '_' + arenaId.toString() + '_' + userId.toString());
      if (value == null) {
        return false;
      }
      bool c = jsonDecode(value);
      return c;
    }
    return false;
  }

  Future<bool> saveIsMeetingTestinput(int idTestInput, bool isMeet) async {
    await init();
    var r = await current.setBool(keyMeeting + idTestInput.toString(), isMeet);
    if (current.getBool(keyMeeting + idTestInput.toString()) == null) {
      return false;
    }
    return r;
  }

  Future<bool> getMeetingTestinput(int idTestInput) async {
    await init();
    if (current.containsKey(keyMeeting + idTestInput.toString())) {
      final value = current.getBool(keyMeeting + idTestInput.toString());
      if (value == null) {
        return false;
      }
      return value;
    }
    return false;
  }

  Future<bool> deleteMeetingTestinput(int idTestInput) async {
    await init();
    if (current.containsKey(keyMeeting + idTestInput.toString())) {
      final value = await current.remove(keyMeeting + idTestInput.toString());
      return value;
    }
    return false;
  }

  Future<bool> saveIsMeetingTestRoute(
      int classroomId, int lesson, bool isMeet) async {
    await init();
    var r = await current.setBool(
        keyMeeting + classroomId.toString() + '_' + lesson.toString(), isMeet);
    if (current.getBool(
            keyMeeting + classroomId.toString() + '_' + lesson.toString()) ==
        null) {
      return false;
    }
    return r;
  }

  Future<bool> getMeetingTestRoute(int classroomId, int lesson) async {
    await init();
    if (current.containsKey(
        keyMeeting + classroomId.toString() + '_' + lesson.toString())) {
      final value = current.getBool(
          keyMeeting + classroomId.toString() + '_' + lesson.toString());
      if (value == null) {
        return false;
      }
      return value;
    }
    return false;
  }

  Future<bool> deleteMeetingTestRoute(int classroomId, int lesson) async {
    await init();
    if (current.containsKey(
        keyMeeting + classroomId.toString() + '_' + lesson.toString())) {
      final value = await current.remove(
          keyMeeting + classroomId.toString() + '_' + lesson.toString());
      return value;
    }
    return false;
  }

  // Future<bool> saveTimeTest(int milisecond, int classroomId, int lesson) async {
  //   await init();
  //   var account = await getCurrentUser();
  //   await current.setInt(
  //       keyTimeTest +
  //           '_' +
  //           classroomId.toString()+
  //           '_' +
  //           lesson.toString() +
  //           '_' +
  //           account.userInfo.id.toString(),
  //       milisecond);
  //   if (current.containsKey(keyTimeTest +
  //       '_' +
  //       classroomId.toString()+
  //       '_' +
  //       lesson.toString() +
  //       '_' +
  //       account.userInfo.id.toString())) {
  //     return true;
  //   }
  //   return false;
  // }
  //
  // Future<int> getTimeTest(int classroomId, int lesson) async {
  //   await init();
  //   var account = await getCurrentUser();
  //   if (current.containsKey(keyTimeTest +
  //       '_' +
  //       classroomId.toString()+
  //       '_' +
  //       lesson.toString() +
  //       '_' +
  //       account.userInfo.id.toString())) {
  //     var time = current.getInt(keyTimeTest +
  //         '_' +
  //         classroomId.toString()+
  //         '_' +
  //         lesson.toString() +
  //         '_' +
  //         account.userInfo.id.toString());
  //     return time != null ? time : null;
  //   }
  //   return null;
  // }


  Future<bool> saveDurationTest(int sec, int classroomId, int lesson) async {
    await init();
    var account = await getCurrentUser();
    await current.setInt(
        keyDurationTest +
            '_' +
            classroomId.toString()+
            '_' +
            lesson.toString() +
            '_' +
            account.userInfo.id.toString(),
        sec);
    if (current.containsKey(keyDurationTest +
        '_' +
        classroomId.toString()+
        '_' +
        lesson.toString() +
        '_' +
        account.userInfo.id.toString())) {
      return true;
    }
    return false;
  }

  Future<int> getDurationTest(int classroomId, int lesson) async {
    await init();
    var account = await getCurrentUser();
    if (current.containsKey(keyDurationTest +
        '_' +
        classroomId.toString()+
        '_' +
        lesson.toString() +
        '_' +
        account.userInfo.id.toString())) {
      var time = current.getInt(keyDurationTest +
          '_' +
          classroomId.toString()+
          '_' +
          lesson.toString() +
          '_' +
          account.userInfo.id.toString());
      return time != null ? time : null;
    }
    return null;
  }

  Future<bool> deleteTimeTest(int classroomId,int lesson) async {
    await init();
    var account = await getCurrentUser();
    if (current.containsKey(keyTimeTest +
        '_' +
        classroomId.toString()+
        '_' +
        lesson.toString() +
        '_' +
        account.userInfo.id.toString())) {
      var res = await current.remove(keyTimeTest +
          '_' +
          lesson.toString() +
          '_' +
          account.userInfo.id.toString());
      return res;
    }
    return false;
  }
}
