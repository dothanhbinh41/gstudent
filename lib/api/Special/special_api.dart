import 'package:gstudent/api/base/ApiBase.dart';
import 'package:gstudent/api/dtos/Special/clan_can_attack.dart';
import 'package:gstudent/api/dtos/Special/clan_steal_data.dart';
import 'package:gstudent/api/dtos/Special/data_member_clan.dart';
import 'package:gstudent/api/dtos/Special/quantity_special.dart';
import 'package:gstudent/api/dtos/base/message_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class SpecialApi {
  @factoryMethod
  Future<ClanCanAttack> getClanCanAttack(int user_clan_id, String token) async {
    try {
      var res = await httpFullGet("/api/user-clan/clan-can-attack",
          {'user_clan_id': user_clan_id.toString()}, token);
      print(res.body);
      if (res.statusCode == 200 && res.body != null) {
        var response = clanCanAttackFromJson(res.body.toString());
        return response;
      }
    } catch (e) {
      print('eror api getClanCanAttack');
      print(e);
    }
    return null;
  }

  @factoryMethod
  Future<DataMemberClan> getMemberClanUser(int clan_id, String token) async {
    try {
      var res = await httpFullGet(
          "/api/user-clan/all-member", {'clan_id': clan_id.toString()}, token);
      print(res.body);
      if (res.statusCode == 200 && res.body != null) {
        var response = dataMemberClanFromJson(res.body.toString());
        return response;
      }
    } catch (e) {
      print('eror api getMemberClanUser');
      print(e);
    }
    return null;
  }

  @factoryMethod
  Future<ClanStealData> getMemberClanCanSteal(int clanId, String token) async {
    try {
      var res = await httpFullGet(
          "/api/user-clan/all-member", {'clan_id': clanId.toString()}, token);
      print(res.body);
      if (res.statusCode == 200 && res.body != null) {
        var response = clanStealDataFromJson(res.body.toString());
        return response;
      }
    } catch (e) {
      print('eror api getMemberClanCanSteal');
      print(e);
    }
    return null;
  }

  @factoryMethod
  Future<ClanCanAttack> getClanSteal(int user_clan_id, String token) async {
    try {
      var res = await httpFullGet(
          "/api/clan/list", {'user_clan_id': user_clan_id.toString()}, token);
      print(res.body);
      if (res.statusCode == 200 && res.body != null) {
        var response = clanCanAttackFromJson(res.body.toString());
        return response;
      }
    } catch (e) {
      print('eror api getClanSteal');
      print(e);
    }
    return null;
  }

  @factoryMethod
  Future<MessageResponse> attackClan(
      int user_clan_id, int clan_id, String token) async {
    try {
      var res = await httpFullPostQueryParams(
          '/api/user-clan/use-special-powers', token, {
        'clan_id': clan_id.toString(),
      }, {
        'user_clan_id': user_clan_id.toString()
      });
      print(res.body);
      if (res.body != null) {
        var response = MessageResponseFromJson(res.body.toString());
        return response;
      }
    } catch (e) {
      print('eror api attackClan');
      print('error: ' + e);
    }
    return null;
  }

  @factoryMethod
  Future<MessageDataResponse> steal(
      int user_clan_id, int enermyClanId, String token) async {
    try {
      var res = await httpFullPostQueryParams(
          '/api/user-clan/use-special-powers', token, {
        'user_clan_id': enermyClanId.toString(),
      }, {
        'user_clan_id': user_clan_id.toString()
      });
      print(res.body);
      if (res.body != null) {
        var response = MessageDataResponseFromJson(res.body.toString());
        return response;
      }
    } catch (e) {
      print('eror api steal');
      print('error: ' + e);
    }
    return null;
  }

  @factoryMethod
  Future<MessageResponse> knitting(
      int user_clan_id, int userId, String token) async {
    try {
      var res = await httpFullPostQueryParams(
          '/api/user-clan/use-special-powers', token, {
        'user_clan_id': userId,
      }, {
        'user_clan_id': user_clan_id.toString()
      });
      print(res.body);
      if (res.body != null) {
        var response = MessageResponseFromJson(res.body.toString());
        return response;
      }
    } catch (e) {
      print('eror api knitting');
    }
    return null;
  }

  @factoryMethod
  Future<MessageResponse> passiveSpecial(int user_clan_id, String token) async {
    try {
      var res = await httpFullPostQueryParams(
          '/api/user-clan/use-special-powers',
          token,
          {},
          {'user_clan_id': user_clan_id.toString()});
      print(res.body);
      if (res.body != null) {
        var response = MessageResponseFromJson(res.body.toString());
        return response;
      }
    } catch (e) {
      print('eror api passiveSpecial');
      print('error: ' + e);
    }
    return null;
  }

  @factoryMethod
  Future<QuantitySpecial> getQuantitySpecial(
      int user_clan_id, String token) async {
    try {
      var res = await httpFullGet("/api/user-clan/quantity-use",
          {'user_clan_id': user_clan_id.toString()}, token);
      print(res.body);
      if (res.statusCode == 200 && res.body != null) {
        var response = quantitySpecialFromJson(res.body.toString());
        return response;
      }
    } catch (e) {
      print('eror api passiveSpecial');
      print('error: ' + e);
    }
    return null;
  }
}
