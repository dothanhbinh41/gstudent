import 'package:gstudent/api/Special/special_api.dart';
import 'package:gstudent/api/base/HeaderProvider.dart';
import 'package:gstudent/api/dtos/Special/clan_can_attack.dart';
import 'package:gstudent/api/dtos/Special/clan_steal_data.dart';
import 'package:gstudent/api/dtos/Special/data_member_clan.dart';
import 'package:gstudent/api/dtos/Special/quantity_special.dart';
import 'package:gstudent/api/dtos/base/message_response.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';
import 'package:injectable/injectable.dart';

@injectable
class SpecialService{
  SpecialApi api;
  HeaderProvider headerProvider;
  ApplicationSettings settings;
  SpecialService({this.settings,this.api,this.headerProvider});

  Future<ClanCanAttack> getClanCanAttack(int user_clan_id) async {
    var token = await headerProvider.getAuthorization();
    var res = api.getClanCanAttack( user_clan_id,token);
    return res;
  }

  Future<ClanCanAttack> getClanCanSteak(int user_clan_id) async {
    var token = await headerProvider.getAuthorization();
    var res = api.getClanSteal( user_clan_id,token);
    return res;
  }

  Future<DataMemberClan> getMemberUserClan(int ClanId) async {
    var token = await headerProvider.getAuthorization();
    var res = api.getMemberClanUser(ClanId,token);
    return res;
  }

  Future<ClanStealData> getMemberClanCanSteal(int clan_id) async {
    var token = await headerProvider.getAuthorization();
    var res = api.getMemberClanCanSteal(clan_id,token);
    return res;
  }




  Future<QuantitySpecial> getQuantitySpecial(int user_clan_id) async {
    var token = await headerProvider.getAuthorization();
    var res = api.getQuantitySpecial( user_clan_id,token);
    return res;
  }

  Future<MessageResponse> attackClan(int clanId,int user_clan_id) async {
    var token = await headerProvider.getAuthorization();
    var res = api.attackClan(user_clan_id, clanId,token);
    return res;
  }


  Future<MessageDataResponse> stealClanMember(int userId,int user_clan_id) async {
    var token = await headerProvider.getAuthorization();
    var res = api.steal(user_clan_id, userId,token);
    return res;
  }

  Future<MessageResponse> knittingForMember(int userId,int user_clan_id) async {
    var token = await headerProvider.getAuthorization();
    var res = api.knitting(user_clan_id, userId,token);
    return res;
  }


  Future<MessageResponse> passiveSpecial(int user_clan_id) async {
    var token = await headerProvider.getAuthorization();
    var res = api.passiveSpecial(user_clan_id,token);
    return res;
  }
}