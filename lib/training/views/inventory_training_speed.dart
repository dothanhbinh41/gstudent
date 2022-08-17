
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gstudent/api/dtos/Home/item_inventory.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/define_item/item_inventory.dart';
import 'package:gstudent/home/services/home_services.dart';
import 'package:gstudent/main.dart';
import 'package:gstudent/training/views/speed/detail_item_inventory_training_speed.dart';

enum InvenTraining {vocab,speed}

class InventoryTraining extends StatefulWidget {
  int userClanId;
  InvenTraining type;
  InventoryTraining({this.userClanId,this.type});

  @override
  State<StatefulWidget> createState() => InventoryTrainingState(userClanId: this.userClanId,type:this.type);
}

class InventoryTrainingState extends State<InventoryTraining> {
  int userClanId;
  InvenTraining type;
  InventoryTrainingState({this.userClanId,this.type});
  List<ItemInventory> invens;
  HomeService homeService =GetIt.instance.get<HomeService>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadImage();
    loadInvent();
  }

  AssetImage bgDialog;

  loadImage() {
    bgDialog = AssetImage('assets/game_bg_info_clan.png');
  }

  loadInvent() async {
    showLoading();
    var res = await homeService.getInventory();
    hideLoading();
    if (res != null) {
      setState(() {
        invens = res.where((element) => element.quantity > 0).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned(
            child: Stack(
              children: [
                Positioned(
                  top: 16,
                  right: 16,
                  left: 16,
                  bottom: 0,
                  child: Image(
                    image: bgDialog,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  top: 48,
                  bottom: 36,
                  right: 48,
                  left: 48,
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          height: 24,
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                          child: Image(
                            image: AssetImage('assets/images/ellipse.png'),
                          ),
                        ),
                        Expanded(
                          child: invens != null && invens.length > 0
                              ? contentInvenItem()
                              : Center(
                            child: Text('Chưa có vật phẩm '),
                          ),
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                )
              ],
            ),
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
          ),
          Positioned(
              child: Image(
                image: AssetImage('assets/images/mai.png'),
                fit: BoxFit.fill,
              ),
              top: -0,
              left: -16,
              right: -16),
          Positioned(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Image(
                image: AssetImage('assets/images/game_close_dialog_clan.png'),
                height: 40,
                width: 40,
              ),
            ),
            top: 28,
            right: 16,
          ),
        ],
      ),
    );
  }

  contentInvenItem() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(0, 4, 0, 8),
          child: Text(
            "Vật phẩm của bạn",
            style: TextStyle(fontFamily: 'SourceSerifPro-Bold', color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              // Generate 100 widgets that display their index in the List.
              children: List.generate(invens.length, (index) {
                return GestureDetector(
                  onTap: () => showDialogAsync(ItemInventoryTrainingDialog(
                    item: invens[index],
                    userClanId: this.userClanId,
                  ),index),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: HexColor("#31281b"), width: 3),
                    ),
                    child: Stack(
                      children: [
                        Container(
                            margin: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    HexColor("#33291b"),
                                    HexColor("#67512f"),
                                  ],
                                )),
                            child: Center(
                              child: Container(
                                margin: EdgeInsets.all(4),
                                child: Image(
                                  image: AssetImage(inventoryDefineImage(invens[index].itemsId)),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )),
                        Positioned(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(2, 4, 2, 4),
                            decoration: BoxDecoration(color: HexColor("#99000000")),
                            child: Text(
                              invens[index].item.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: HexColor("#00e6f4"),
                                fontSize: 12,
                                fontFamily: 'SourceSerifPro-Bold',
                              ),
                            ),
                          ),
                          bottom: 0,
                          right: 0,
                          left: 0,
                        )
                      ],
                    ),
                  ),
                );
              }),
            ))
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  void showDialogAsync(view, int index) async {
    if(type == InvenTraining.speed){
      if(invens[index].itemsId == 6 || invens[index].itemsId == 7){
        var res = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return view;
            });
        if (res != null && res == true) {
          var useItem = await homeService.useItemInventory(invens[index].itemsId, userClanId);
          if(useItem != null && useItem.error == false){
            toast(context, useItem.message);
            Navigator.of(context).pop(invens[index].itemsId);
          }else{
            toast(context, useItem.message);
          }
        }
      }
      else{
        toast(context,"Bạn không thể dùng vật phẩm này ở đây");
        return;
      }
    }
    else if(type == InvenTraining.vocab){
      if(invens[index].itemsId == 8 ){
        var res = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return view;
            });
        if (res != null && res == true) {
          var useItem = await homeService.useItemInventory(invens[index].itemsId, userClanId);
          if(useItem != null && useItem.error == false){
            toast(context, useItem.message);
            Navigator.of(context).pop(invens[index].itemsId);
          }else{
            toast(context, useItem.message);
          }
        }
      }else{
        toast(context,"Bạn không thể dùn vật phẩm này ở đây");
        return;
      }
    }
    else{
      toast(context,"Bạn không thể dùn vật phẩm này ở đây");
      return;
    }
  }
}
