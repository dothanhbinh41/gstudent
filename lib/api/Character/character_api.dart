import 'dart:convert';

import 'package:gstudent/api/base/ApiBase.dart';
import 'package:gstudent/api/dtos/Character/character.dart';
import 'package:gstudent/api/dtos/base/message_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class CharacterApi {
  @factoryMethod
  Future<List<Character>> getAllCharacter(String token) async {
    try {
      var res = await httpHeaderGet('/api/character/list', token);
      print(res.body);
      if (res.statusCode != 200) {
        return null;
      }
      var response = CharacterFromJson(res.body);
      return response;
    } catch (e) {
      print('error api getAllCharacter');
      print(e);
      return null;
    }
  }

  @factoryMethod
  Future<MessageResponse> createCharacter(int userClanId, int charId, String name, String token) async {
    try {
      var res = await httpFullPut('/api/user-clan/add-character',  {"id": userClanId, "character_id": charId, "nick_name": name}, token);
      print(res.body);
      var response = MessageResponse.fromJson(jsonDecode(res.body));
      return response;
    } catch (e) {
      print('error api createCharacter');
      print(e);
      return null;
    }
  }
}
