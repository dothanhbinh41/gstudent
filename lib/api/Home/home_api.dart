import 'dart:convert';
import 'dart:io';

import 'package:gstudent/api/base/ApiBase.dart';
import 'package:gstudent/api/base/dtos_base.dart';
import 'package:gstudent/api/dtos/Home/item_inventory.dart';
import 'package:gstudent/api/dtos/Home/item_store.dart';
import 'package:gstudent/api/dtos/QuestionAnswer/QuestionAndAnswerData.dart';
import 'package:gstudent/api/dtos/Reward/item_reward.dart';
import 'package:gstudent/api/dtos/TestInput/image.dart';
import 'package:gstudent/api/dtos/UploadFile/image_response.dart';
import 'package:gstudent/api/dtos/badge/DataUserBadge.dart';
import 'package:gstudent/api/dtos/badge/data_badge.dart';
import 'package:gstudent/api/dtos/base/message_response.dart';
import 'package:gstudent/api/dtos/support/create_support_dto.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeApi {
  @factoryMethod
  Future<List<ItemInventory>> getAllItemsUser(String token) async {
    try {
      var res = await httpHeaderGet('/api/user_items/get-list', token);
      print(res.body);
      if (res.statusCode != 200) {
        return null;
      }
      var response = itemsFromJson(res.body);
      return response;
    } catch (e) {
      print('eror api getAllItemsUser');
      print(e);
      return null;
    }
  }

  @factoryMethod
  Future<QuestionAndAnswerData> getAllQAndA(String token) async {
    try {
      var res = await httpHeaderGet('/api/users/qanda', token);
      print(res.body);
      if (res.statusCode != 200) {
        return null;
      }
      var response = questionAndAnswerDataFromJson(res.body);
      return response;
    } catch (e) {
      print('eror api getAllItemsUser');
      print(e);
      return null;
    }
  }

  @factoryMethod
  Future<List<ItemStore>> getAllItemsStore(String token) async {
    try {
      var res = await httpHeaderGet('/api/items/can-buy', token);
      print(res.body);
      if (res.statusCode != 200) {
        return null;
      }
      print(res.body);
      var response = itemStoreFromJson(res.body);
      return response;
    } catch (e) {
      print('eror api getAllItemsStore');
      print(e);
      return null;
    }
  }

  @factoryMethod
  Future<MessageResponse> buyItem(String token, int itemId) async {
    try {
      var res = await httpFullPost('/api/user_items/buy', token, {'item_id': itemId});
      print(res.body);
      var response = MessageResponseFromJson(res.body);
      return response;
    } catch (e) {
      print('eror api buyItem');
      print(e);
      return null;
    }
  }

  @factoryMethod
  Future<DataReward> useItemInventory(String token, int userItemId, int userClanId) async {
    try {
      print(userItemId);
      var res = await httpFullPost('/api/user_items/use', token, {'item_id': userItemId, 'user_clan_id' : userClanId});
      print(res.body);
      var response = dataRewardFromJson(res.body);
      return response;
    } catch (e) {
      print('eror api useItemInventory');
      print(e);
      return null;
    }
  }

  @factoryMethod
  Future<DataUserBadge> getUserBadge(String token) async {
    try {
      var res = await httpFullGet('/api/user-badge/list', {}, token);
      print(res.body);
      if (res.statusCode != 200) {
        return null;
      }
      var response = dataUserBadgeFromJson(res.body);
      return response;
    } catch (e) {
      print('eror api getUserBadge');
      print(e);
      return null;
    }
  }

  @factoryMethod
  Future<DataBadge> getAllBadge(String token) async {
    try {
      var res = await httpFullGet('/api/user-badge/all', {}, token);
      print(res.body);
      if (res.statusCode != 200) {
        return null;
      }
      var response = dataBadgeFromJson(res.body);
      return response;
    } catch (e) {
      print('eror api getAllBadge');
      print(e);
      return null;
    }
  }

  @factoryMethod
  Future<DataDtoBase> changePassword(String oldPassword,String password,String token) async {
    try {
      var res = await httpFullPost('/api/users/change-password',  token, {
        'password' : password,
        'old_password' : oldPassword,
        'confirm_password' : password
      },);
      print(res.body);
      var response = fromJson(res.body);
      return response;
    } catch (e) {
      print('eror api getAllBadge');
      print(e);
      return null;
    }
  }


  @factoryMethod
  Future<DataDtoBase> signed(int userClanId,String token) async {
    try {
      var res = await httpFullPut('/api/user-clan/signed-treaty', {
        'user_clan_id' : userClanId
      }, token,);
      print(res.body);
      var response = fromJson(res.body);
      return response;
    } catch (e) {
      print('eror api signed');
      print(e);
      return null;
    }
  }

  @factoryMethod
  Future<Images> uploadFile(String filename, String path,String token) async {
    Map<String, String> headers = {"Authorization": "Bearer "+token};
    try {
      var req = MultipartRequest('POST', Uri.http("socket.edutalk.edu.vn", "api/classroom/upload-audio"));
      req.headers.addAll(headers);
      var file = MultipartFile.fromBytes('myFile', File(path).readAsBytesSync(), filename: filename);
      req.files.add(file);
      var res = await req.send();
      if (res.statusCode == 200) {
        var str = await res.stream.transform(utf8.decoder).firstWhere((element) => element != null);
        print(str);
        var body = jsonDecode(str);
        var response = ImagesResultDto.fromJson(body);

        return response.data[0];
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  @factoryMethod
  Future<CreateSupportResponse> sendSupport(String content ,String image,String token) async {
    try {
      var res = await httpFullPost('/api/users/support', token,{
      "content": content,
      "title": " ",
      "myFile": image
      });
      print(res.body);
      var response = createSupportResponseFromJson(res.body);
      return response;
    } catch (e) {
      print('eror api signed');
      print(e);
      return null;
    }
  }
}
