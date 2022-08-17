import 'package:gstudent/api/Clan/clan_api.dart';
import 'package:gstudent/api/base/HeaderProvider.dart';
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
import 'package:gstudent/settings/helper/ApplicationSettings.dart';
import 'package:injectable/injectable.dart';

@injectable
class ClanService {
  ClanApi api;
  HeaderProvider headerProvider;
  ApplicationSettings applicationSettings;

  ClanService(
      {this.api, this.headerProvider, this.applicationSettings});


  @factoryMethod
  Future<JoinClanResponse> requestJoinClan(String codeClan) async {
    var token =await  headerProvider.getAuthorization();
    var res = await  api.requestJoinClan(codeClan, token);
    return res;
  }

  @factoryMethod
  Future<SearchClanResponse> findClan(int clanId) async {
    var token =await  headerProvider.getAuthorization();
    var res = await  api.findClan(clanId, token);
    return res;
  }


  @factoryMethod
  Future<CreateClanReponse> createClan(int generalId,String name,int classroomId) async {
    var token =await  headerProvider.getAuthorization();
    var res = await  api.createClan(name,classroomId,generalId, token);
    return res;
  }


  @factoryMethod
  Future<ClanDetail> getDetailClan(int clanId) async {
    var token =await  headerProvider.getAuthorization();
    var res = await  api.getDetailClan(clanId, token);
    return res;
  }


  @factoryMethod
  Future<UserClanInfo> getInfoUserClan(int userClanId) async {
    var token =await  headerProvider.getAuthorization();
    var res = await  api.getInfoUserClan(userClanId, token);
    return res;
  }

  @factoryMethod
  Future<MessageResponse> changeStatusClan(int status,int clanId) async {
    var token =await  headerProvider.getAuthorization();
    var res = await  api.changeStatusClan(clanId,status, token);
    return res;
  }

  @factoryMethod
  Future<ListRequestJoinData> getListUserRequestJoin(
      int clanId) async {
    var token =await  headerProvider.getAuthorization();
    var res = await  api.getListUserRequestJoin(clanId, token);
    return res;
  }

  @factoryMethod
  Future<MessageResponse> approveUserClan(
      int clanId, int studentId,int status)async {
    var token =await  headerProvider.getAuthorization();
    var res = await  api.approveUserClan(clanId, studentId,status, token);
    return res;
  }


  @factoryMethod
  Future<ListClanData> getListClanCanFight(
      int clanId)async {
    var token =await  headerProvider.getAuthorization();
    var res = await  api.getListClanCanFight(clanId,  token);
    return res;
  }


  @factoryMethod
  Future<ListClanData> getRankingClan(
      int courseId)async {
    var token =await  headerProvider.getAuthorization();
    var res = await  api.getRankingClan(courseId,  token);
    return res;
  }


  @factoryMethod
  Future<MessageResponse> sendInviteArena(
      int fromClanId, int toClanId,String letter,String date)async {
    var token =await  headerProvider.getAuthorization();
    var res = await  api.sendInviteArena(fromClanId,toClanId,letter,date,  token);
    return res;
  }


  @factoryMethod
  Future<ListClanInviteArena> listInviteArena(int  clanId)async {
    var token =await  headerProvider.getAuthorization();
    var res = await  api.listInviteArena(clanId,  token);
    return res;
  }



  @factoryMethod
  Future<AcceptInviteArena> acceptInviteArena(
       int arenaId)async {
    var token =await  headerProvider.getAuthorization();
    var res = await  api.acceptInviteArena(arenaId, token);
    return res;
  }

  @factoryMethod
  Future<ArenaDetailReponse> getInfoArena(int arenaId) async {
    var token =await  headerProvider.getAuthorization();
    var res = await  api.arenaDetail(arenaId, token);
    return res;
  }

 @factoryMethod
  Future<CalendarArenaResponse> calendarArena(int clanId) async {
    var token =await  headerProvider.getAuthorization();
    var res = await  api.calendarArena(clanId, token);
    return res;
  }


 @factoryMethod
  Future<DiaryClanData> diaryArena(int clanId) async {
    var token =await  headerProvider.getAuthorization();
    var res = await  api.diaryClan(clanId, token);
    return res;
  }



}