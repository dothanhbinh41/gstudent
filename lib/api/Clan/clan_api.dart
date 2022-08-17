import 'dart:convert';

import 'package:gstudent/api/base/ApiBase.dart';
import 'package:gstudent/api/dtos/Arena/arena_detail_response.dart';
import 'package:gstudent/api/dtos/Arena/calendar.dart';
import 'package:gstudent/api/dtos/Clan/accept_arena_invite.dart';
import 'package:gstudent/api/dtos/Clan/clan_detail_response.dart';
import 'package:gstudent/api/dtos/Clan/clan_invite_arena.dart';
import 'package:gstudent/api/dtos/Clan/create_clan_reponse.dart';
import 'package:gstudent/api/dtos/Clan/diary_clan_dtos.dart';
import 'package:gstudent/api/dtos/Clan/info_user_clan.dart';
import 'package:gstudent/api/dtos/Clan/join_clan_response.dart';
import 'package:gstudent/api/dtos/Clan/list_clan_fight.dart';
import 'package:gstudent/api/dtos/Clan/list_request_join.dart';
import 'package:gstudent/api/dtos/Clan/search_clan_response.dart';
import 'package:gstudent/api/dtos/base/message_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class ClanApi {
  @factoryMethod
  // Future<bool> getListClanFollowCourse(int courseId, String token) async {
  //   var res = await httpFullGet('/api/clan/list-clan-fl-course',
  //       {"course_id": courseId.toString()}, token);
  //
  //   return true;
  // }

  @factoryMethod
  Future<JoinClanResponse> requestJoinClan(String codeClan, String token) async {
    try {
      var res = await httpFullPost('/api/clan/request-join', token, {"code": codeClan});
      print(res.body);
      var response = joinClanResponseFromJson(res.body);
      return response;
    } catch (e) {
      print('eror api requestJoinClan');
      print(e);
    }
    return null;
  }

  @factoryMethod
  Future<SearchClanResponse> findClan(int clanId, String token) async {
    try {
      var res = await httpFullGet('/api/clan/search-id', {"clan_id": clanId.toString()}, token);
      print(res.body);
      var a = SearchClanResponse.fromJson(jsonDecode(res.body));
      return a;
    } catch (e) {
      print('eror api findClan');
      print(e);
    }
    return null;
  }

  @factoryMethod
  Future<MessageResponse> leaveClan(int courseId, String token) async {
    try {
      var res = await httpFullGet('/api/clan/leave-clan?clan_id=1', {"course_id": courseId.toString()}, token);
      var response = MessageResponse.fromJson(jsonDecode(res.body));
      return response;
    } catch (e) {
      print('eror api leaveClan');
      print(e);
    }
    return null;
  }

  @factoryMethod
  Future<CreateClanReponse> createClan(String name, int classroomId, int generalId, String token) async {
    try {
      var res = await httpFullPost('/api/clan/create', token, {
        "classroom_id": classroomId,
        "name": name,
        "general_id": generalId,
      });
      print(res.body);
      var response = CreateClanReponse.fromJson(jsonDecode(res.body));
      return response;
    } catch (e) {
      print('eror api createClan');
      print(e);
    }
    return null;
  }

  @factoryMethod
  Future<ClanDetail> getDetailClan(int clanId, String token) async {
    try {
      var res = await httpFullGet(
          '/api/clan/clan-detail',
          {
            "clan_id": clanId.toString(),
          },
          token);
      print(res.body);
      var response = clanDetailResponseFromJson(res.body);
      return response.data;
    } catch (e) {
      print('eror api getDetailClan');
      print(e);
    }
    return null;
  }

  @factoryMethod
  Future<UserClanInfo> getInfoUserClan(int userClanId, String token) async {
    try {
      var res = await httpHeaderGet('/api/user-clan/' + userClanId.toString() + '/detail', token);
      print(res.body);
      var response = userClanInfoFromJson(res.body);
      return response.data;
    } catch (e) {
      print('eror api getInfoUserClan');
      print(e);
    }
    return null;
  }

  @factoryMethod
  Future<MessageResponse> changeStatusClan(int clanId, int status, String token) async {
    try {
      var res = await httpFullPost('/api/clan/attack-status-change', token, {"status": status, "clan_id": clanId});
      print(jsonDecode(res.body));
      var response = MessageResponseFromJson(res.body);
      return response;
    } catch (e) {
      print('eror api changeStatusClan');
      print(e);
    }
    return null;
  }

  @factoryMethod
  Future<ListRequestJoinData> getListUserRequestJoin(int clanId, String token) async {
    try {
      var res = await httpFullGet('/api/clan/list-request-to-join', {"clan_id": clanId.toString()}, token);
      print(res.body);
      var response = listRequestJoinDataFromJson(res.body);
      return response;
    } catch (e) {
      print('eror api getListUserRequestJoin');
      print(e);
    }
    return null;
  }

  @factoryMethod
  Future<MessageResponse> approveUserClan(int clanId, int studentId, int status, String token) async {
    try {
      var res = await httpFullPost('/api/clan/approve-member', token, {'clan_id': clanId.toString(), 'student_id': studentId.toString(), 'status': status.toString()});
      print(res.body);
      var response = MessageResponseFromJson(res.body);
      return response;
    } catch (e) {
      print('eror api approveUserClan');
      print(e);
    }
    return null;
  }

  @factoryMethod
  Future<ListClanData> getListClanCanFight(int clanId, String token) async {
    try {
      var res = await httpFullGet(
          '/api/clan/list-attack-clan',
          {
            'clan_id': clanId.toString(),
          },
          token);
      print(res.body);
      var response = listClanDataFromJson(res.body);
      return response;
    } catch (e) {
      print('eror api getListClanCanFight');
      print(e);
    }
    return null;
  }

  @factoryMethod
  Future<MessageResponse> sendInviteArena(int from_clan, int to_clan, String letter, String date, String token) async {
    try {
      print({'from_clan': from_clan.toString(), 'to_clan': to_clan.toString(), 'letter': letter, 'date_time_start': date});

      var res = await httpFullPost('/api/arena/invite', token, {'from_clan': from_clan, 'to_clan': to_clan, 'letter': letter, 'date_time_start': date});
      print(res.body);
      print(res.body);
      var response = MessageResponseFromJson(res.body);
      return response;
    } catch (e) {
      print('eror api sendInviteArena');
      print(e);
    }
    return null;
  }

  @factoryMethod
  Future<ListClanData> getRankingClan(int courseId, String token) async {
    try {
      var res = await httpFullGet(
          '/api/clan/ranking',
          {
            'course_id': courseId.toString(),
          },
          token);
      print(res.body);
      var response = listClanDataFromJson(res.body);
      return response;
    } catch (e) {
      print('eror api getRankingClan');
      print(e);
    }
    return null;
  }

  @factoryMethod
  Future<ListClanInviteArena> listInviteArena(int clanId, String token) async {
    try {
      var res = await httpFullGet(
          '/api/arena/list',
          {
            'clan_id': clanId.toString(),
          },
          token);
      print(res.body);
      var response = listClanInviteArenaFromJson(res.body);
      return response;
    } catch (e) {
      print('eror api listInviteArena');
      print(e);
    }
    return null;
  }

  @factoryMethod
  Future<AcceptInviteArena> acceptInviteArena(int arenaId, String token) async {
    try {
      var res = await httpFullPut('/api/arena/' + arenaId.toString() + '/accept', {}, token);
      print(res.body);
      var response = acceptInviteArenaFromJson(res.body);
      return response;
    } catch (e) {
      print('eror api acceptInviteArena');
      print(e);
    }
    return null;
  }

  @factoryMethod
  Future<ArenaDetailReponse> arenaDetail(int arenaId, String token) async {
    try {
      var res = await httpFullGet('/api/arena/' + arenaId.toString() + '/detail', {}, token);
      print(res.body);
      var response = arenaDetailReponseFromJson(res.body);
      return response;
    } catch (e) {
      print('eror api arenaDetail');
      print(e);
    }
    return null;
  }

  @factoryMethod
  Future<CalendarArenaResponse> calendarArena(int clan_id, String token) async {
    try {
      var res = await httpFullGet('/api/arena/list-waiting', {'clan_id': clan_id.toString()}, token);
      print(res.body);
      var response = calendarArenaResponseFromJson(res.body);
      return response;
    } catch (e) {
      print('eror api calendarArena');
      print(e);
    }
    return null;
  }


  @factoryMethod
  Future<DiaryClanData> diaryClan(int clan_id, String token) async {
    try {
      var res = await httpFullGet('/api/user-clan/diary', {'clan_id': clan_id.toString()}, token);
      print(res.body);
      var response = diaryClanDataFromJson(res.body);
      return response;
    } catch (e) {
      print('eror api diary');
      print(e);
    }
    return null;
  }
}
