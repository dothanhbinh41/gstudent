import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gstudent/api/dtos/Home/item_inventory.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/define_item/item_inventory.dart';
import 'package:gstudent/home/cubit/home_cubit.dart';
import 'package:gstudent/home/views/dialog_info_item.dart';
import 'package:gstudent/main.dart';

class InventoryArena extends StatefulWidget {
  int userClanId;
  int isUseLuckyStar;

  InventoryArena({this.userClanId, this.isUseLuckyStar});

  @override
  State<StatefulWidget> createState() => InventoryArenaState(
      userClanId: this.userClanId, isUseLuckyStar: this.isUseLuckyStar);
}

class InventoryArenaState extends State<InventoryArena> {
  int userClanId;
  int isUseLuckyStar;

  InventoryArenaState({this.userClanId, this.isUseLuckyStar});

  List<ItemInventory> invens = [];
  HomeCubit cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of<HomeCubit>(context);
    loadImage();
    loadInvent();
  }

  AssetImage bgDialog;

  loadImage() {
    bgDialog = AssetImage('assets/game_bg_info_clan.png');
  }

  loadInvent() async {
    var res = await cubit.getInventory();
    if (res != null) {
      setState(() {
        invens = res.where((element) => element.quantity > 0).toList();
      });
    }
    setState(() {
      invens.add(ItemInventory(
          id: -1,
          quantity: isUseLuckyStar,
          itemsId: -1,
          item: Item(
              name: 'Ngôi Sao Hi Vọng',
              description:
                  'Sử dụng để được gấp đôi điểm nếu như trả lời đúng câu hỏi.',
              price: 0)));
    });
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
            style: TextStyle(
                fontFamily: 'SourceSerifPro-Bold',
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold),
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
              onTap: () => showDialogAsync(
                  ItemInventoryDialog(
                    item: invens[index],
                    userClanId: this.userClanId,
                    isInventory: false,
                  ),
                  index),
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
                              image: AssetImage(
                                  inventoryDefineImage(invens[index].itemsId)),
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
    var res = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return BlocProvider<HomeCubit>.value(
            value: cubit,
            child: view,
          );
        });
    if (res != null) {
      if (invens[index].itemsId != -1) {
        var useItem =
            await cubit.useItemInventory(invens[index].itemsId, userClanId);
        if (useItem != null && useItem.error == false) {
          toast(context, useItem.message);
          Navigator.of(context).pop(invens[index].itemsId);
        } else {
          toast(context, useItem.message);
        }
      } else {
        Navigator.of(context).pop(invens[index].itemsId);
      }
    }
  }
}
