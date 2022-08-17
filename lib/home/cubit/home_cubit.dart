import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gstudent/api/base/dtos_base.dart';
import 'package:gstudent/api/dtos/Arena/calendar.dart';
import 'package:gstudent/api/dtos/Character/character.dart';
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
import 'package:gstudent/api/dtos/Home/item_inventory.dart';
import 'package:gstudent/api/dtos/Home/item_store.dart';
import 'package:gstudent/api/dtos/QuestionAnswer/QuestionAndAnswerData.dart';
import 'package:gstudent/api/dtos/Reward/item_reward.dart';
import 'package:gstudent/api/dtos/Special/clan_can_attack.dart';
import 'package:gstudent/api/dtos/Special/clan_steal_data.dart';
import 'package:gstudent/api/dtos/Special/data_member_clan.dart';
import 'package:gstudent/api/dtos/Special/quantity_special.dart';
import 'package:gstudent/api/dtos/TestInput/image.dart';
import 'package:gstudent/api/dtos/badge/DataUserBadge.dart';
import 'package:gstudent/api/dtos/badge/data_badge.dart';
import 'package:gstudent/api/dtos/base/message_response.dart';
import 'package:gstudent/api/dtos/mission/mission_data.dart';
import 'package:gstudent/api/dtos/noti/notification_model.dart';
import 'package:gstudent/api/dtos/support/create_support_dto.dart';
import 'package:gstudent/character/services/character_services.dart';
import 'package:gstudent/clan/services/clan_services.dart';
import 'package:gstudent/home/cubit/home_state.dart';
import 'package:gstudent/home/services/home_services.dart';
import 'package:gstudent/home/services/notification_service.dart';
import 'package:gstudent/mission/services/MissionService.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';
import 'package:gstudent/special/services/special_service.dart';

class HomeCubit extends Cubit<HomeState> {
  CharacterService characterService;
  ClanService clanService;
  MissionService missionService;
  HomeService homeService;
  ApplicationSettings settings;
  SpecialService specialService;
  NotificationService notiService;

  HomeCubit({this.characterService, this.clanService, this.homeService, this.missionService, this.settings, this.specialService,this.notiService}) : super(HomeStateInitial());

  showDialogCreateCharacter() {
    emit(ShowDialogCreatCharacter());
  }

  Future<DataDtoBase> changePassword(String oldPassword,String pass) async {
    var res = await homeService.changePassword(oldPassword,pass);
    if (res != null) {
      return res;
    }
    return null;
  }

  Future<QuestionAndAnswerData> getAllQAndA() async {
    var res = await homeService.getQAndA();
    if (res != null) {
      return res;
    }
    return null;
  }

  Future<DataDtoBase> signed(int userClanId) async {
    var res = await homeService.signedTreaty(userClanId);
    if (res != null) {
      return res;
    }
    return null;
  }

  Future<SearchClanResponse> findClan(int clanId) async {
    var response = await clanService.findClan(clanId);
    return response;
  }

  Future<JoinClanResponse> joinClan(String codeClan) async {
    var response = await clanService.requestJoinClan(codeClan);
    return response;
  }

  Future<CreateClanReponse> createClan(int classroomId, String nameClan) async {
    var user = await settings.getCurrentUser();
    var res = await clanService.createClan(user.userInfo.id, nameClan, classroomId);
    return res;
  }

  Future<List<Character>> getAllCharacter() async {
    var res = await characterService.getAllCharacter();
    return res;
  }

  Future<MessageResponse> createCharacter(int userClanId, int charId, String name) async {
    var res = await characterService.createCharacter(userClanId, charId, name);
    return res;
  }

  Future<ClanDetail> getDetailCLan(int clanId) async {
    var res = await clanService.getDetailClan(clanId);
    return res;
  }

  Future<DiaryClanData> getDiaryClan(int clanId) async {
    var res = await clanService.diaryArena(clanId);
    return res;
  }

  Future<List<ItemInventory>> getInventory() async {
    var res = await homeService.getInventory();
    return res;
  }

  Future<List<ItemStore>> getItemsStore() async {
    var res = await homeService.getItemsStore();
    return res;
  }

  Future<MessageResponse> buyItemStore(int itemId) async {
    var res = await homeService.buyItemStore(itemId);
    return res;
  }

  Future<DataReward> useItemInventory(int userItemId, int userClanId) async {
    var res = await homeService.useItemInventory(userItemId, userClanId);
    return res;
  }

  Future<UserClanInfo> getInfoUser(int userClanId) async {
    var res = await clanService.getInfoUserClan(userClanId);
    return res;
  }

  Future<MessageResponse> changeStatusClan(int clanId, int status) async {
    var res = await clanService.changeStatusClan(status, clanId);
    return res;
  }

  Future<ListRequestJoinData> getListRequestJoin(int clanId) async {
    var res = await clanService.getListUserRequestJoin(clanId);
    return res;
  }

  Future<MessageResponse> approveUser(
    int clanId,
    int studentId,
    int status,
  ) async {
    var res = await clanService.approveUserClan(clanId, studentId, status);
    return res;
  }

  Future<ListClanData> getListClanCanFight(
    int clanId,
  ) async {
    var res = await clanService.getListClanCanFight(clanId);
    return res;
  }

  Future<ListClanData> getRanking(
    int courseId,
  ) async {
    var res = await clanService.getRankingClan(courseId);
    return res;
  }

  Future<MessageResponse> sendInviteArena(
    int fromClanId,
    int toClanId,
    String letter,
    String date,
  ) async {
    var res = await clanService.sendInviteArena(fromClanId, toClanId, letter, date);
    return res;
  }

  Future<ListClanInviteArena> getListInviteArena(int clanId) async {
    var res = await clanService.listInviteArena(clanId);
    return res;
  }

  Future<AcceptInviteArena> acceptInviteArena(int arenaId) async {
    var res = await clanService.acceptInviteArena(arenaId);
    return res;
  }

  Future<CalendarArenaResponse> calendarArena(int clanId) async {
    var res = await clanService.calendarArena(clanId);
    return res;
  }

  Future<MissionDataResponse> getMissionDaily(int classroomId) async {
    var res = await missionService.getMissionDaily(classroomId);
    return res;
  }

  Future<MissionDataResponse> getMissionProgress(int clanId) async {
    var res = await missionService.getMissionProgress(clanId);
    return res;
  }

  Future<DataReward> receiveRewardMission(int missionUserId) async {
    var res = await missionService.receiveRewardMission(missionUserId);
    return res;
  }

  Future<QuantitySpecial> getQuantitySpecial(int user_clan_id) async {
    var res = await specialService.getQuantitySpecial(user_clan_id);
    return res;
  }

  Future<ClanCanAttack> getClanCanAttack(int user_clan_id) async {
    var res = await specialService.getClanCanAttack(user_clan_id);
    return res;
  }

  Future<MessageResponse> attackClan(int user_clan_id, int clan_id) async {
    var res = await specialService.attackClan(clan_id, user_clan_id);
    return res;
  }

  Future<ClanCanAttack> getClanCanSteal(int user_clan_id) async {
    var res = await specialService.getClanCanSteak(user_clan_id);
    return res;
  }

  Future<ClanStealData> getMemberClanCanSteal(int clan_id) async {
    var res = await specialService.getMemberClanCanSteal(clan_id);
    return res;
  }

  Future<DataMemberClan> getMemberUserClan(int ClanId) async {
    var res = await specialService.getMemberUserClan(ClanId);
    return res;
  }

  Future<MessageDataResponse> steal(int user_clan_id, int userId) async {
    var res = await specialService.stealClanMember(userId, user_clan_id);
    return res;
  }

  Future<MessageResponse> knitting(int user_clan_id, int userId) async {
    var res = await specialService.knittingForMember(userId, user_clan_id);
    return res;
  }

  Future<MessageResponse> passiveSpecial(int user_clan_id) async {
    var res = await specialService.passiveSpecial(user_clan_id);
    return res;
  }

  Future<DataUserBadge> getAllUserBadge() async {
    var res = await homeService.getAllUserBadge();
    if (res == null) {
      return null;
    }
    return res;
  }

  Future<DataBadge> getAllBadge() async {
    var res = await homeService.getAllBadge();
    if (res == null) {
      return null;
    }
    return res;
  }


  Future<Images> uploadFile(  String filename, String path)async {
    var result = await homeService.uploadFile(
        filename, path);
    if (result == null) {
      return null;
    }
    return result;
  }

  Future<CreateSupportResponse> sendSupport(String text, String image) async  {
    var result = await  homeService.sendSupport(text,image);
    if(result != null){
      return result;
    }
    return null;
  }

  Future<List<NotificationModel>> getAllNotification() async {
    var res = await notiService.getAllNoti();
    if(res != null ){
      return res;
    }
    return null;
  }
}
