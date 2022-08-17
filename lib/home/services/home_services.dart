import 'package:gstudent/api/Home/home_api.dart';
import 'package:gstudent/api/base/HeaderProvider.dart';
import 'package:gstudent/api/base/dtos_base.dart';
import 'package:gstudent/api/dtos/Home/item_inventory.dart';
import 'package:gstudent/api/dtos/Home/item_store.dart';
import 'package:gstudent/api/dtos/QuestionAnswer/QuestionAndAnswerData.dart';
import 'package:gstudent/api/dtos/Reward/item_reward.dart';
import 'package:gstudent/api/dtos/TestInput/image.dart';
import 'package:gstudent/api/dtos/badge/DataUserBadge.dart';
import 'package:gstudent/api/dtos/badge/data_badge.dart';
import 'package:gstudent/api/dtos/base/message_response.dart';
import 'package:gstudent/api/dtos/support/create_support_dto.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeService {
  HomeApi homeApi;
  HeaderProvider headerProvider;
  ApplicationSettings applicationSettings;

  HomeService(
      {this.homeApi, this.headerProvider, this.applicationSettings});


  @factoryMethod
  Future<QuestionAndAnswerData> getQAndA() async {
    var token = await headerProvider.getAuthorization();
    var res = await homeApi.getAllQAndA(token);
    if (res == null) {
      return null;
    }
    return res;
  }



  @factoryMethod
  Future<List<ItemInventory>> getInventory() async {
    var token = await headerProvider.getAuthorization();
    var res = await homeApi.getAllItemsUser(token);
    if (res == null) {
      return null;
    }
    return res;
  }

  @factoryMethod
  Future<List<ItemStore>> getItemsStore() async {
    var token = await headerProvider.getAuthorization();
    var res = await homeApi.getAllItemsStore(token);
    if (res == null) {
      return null;
    }
    return res;
  }

  @factoryMethod
  Future<MessageResponse> buyItemStore(int itemId) async {
    var token = await headerProvider.getAuthorization();
    var res = await homeApi.buyItem(token,itemId);
    if (res == null) {
      return null;
    }
    return res;
  }

  @factoryMethod
  Future<DataReward> useItemInventory(int userItemId,int userClanId) async {
    var token = await headerProvider.getAuthorization();
    var res = await homeApi.useItemInventory(token,userItemId,userClanId);
    if (res == null) {
      return null;
    }
    return res;
  }

  @factoryMethod
  Future<DataUserBadge> getAllUserBadge() async {
    var token = await headerProvider.getAuthorization();
    var res = await homeApi.getUserBadge(token);
    if (res == null) {
      return null;
    }
    return res;
  }


  @factoryMethod
  Future<DataBadge> getAllBadge() async {
    var token = await headerProvider.getAuthorization();
    var res = await homeApi.getAllBadge(token);
    if (res == null) {
      return null;
    }
    return res;
  }

  @factoryMethod
  Future<DataDtoBase> changePassword(String oldPassword,String password) async {
    var token = await headerProvider.getAuthorization();
    var res = await homeApi.changePassword(oldPassword,password,token);
    if (res == null) {
      return null;
    }
    return res;
  }

  @factoryMethod
  Future<DataDtoBase> signedTreaty(int userClanId) async {
    var token = await headerProvider.getAuthorization();
    var res = await homeApi.signed(userClanId,token);
    if (res == null) {
      return null;
    }
    var user = await applicationSettings.getCurrentUser();
    return res;
  }


  Future<Images> uploadFile(String filename, String path)async {
    var token = await headerProvider.getAuthorization();
    var result = await homeApi.uploadFile(
        filename, path,token);
    if (result == null) {
      return null;
    }
    return result;
  }

  Future<CreateSupportResponse>  sendSupport(String text, String image)  async {
    var token = await headerProvider.getAuthorization();
    var res = await homeApi.sendSupport(text, image, token);
    if(res != null){
      return res;
    }
    return null;
  }


}
