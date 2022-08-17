
import 'package:gstudent/api/Character/character_api.dart';
import 'package:gstudent/api/base/HeaderProvider.dart';
import 'package:gstudent/api/dtos/Character/character.dart';
import 'package:gstudent/api/dtos/base/message_response.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';
import 'package:injectable/injectable.dart';

@injectable
class CharacterService {
  CharacterApi api;
  HeaderProvider headerProvider;
  ApplicationSettings applicationSettings;

  CharacterService(
      {this.api, this.headerProvider, this.applicationSettings});

  @factoryMethod
  Future<List<Character>> getAllCharacter()async {
    var token  = await headerProvider.getAuthorization();
    var res = await api.getAllCharacter(token);
    return res;
  }


  @factoryMethod
  Future<MessageResponse> createCharacter(int userClanId,int charId,String name) async {
    var token  = await headerProvider.getAuthorization();
    var res = await api.createCharacter(userClanId, charId, name, token);
    return res;
  }

}