import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gstudent/api/dtos/Home/item_inventory.dart';
import 'package:gstudent/api/dtos/Home/item_store.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/text_outline.dart';
import 'package:gstudent/common/controls/text_painting.dart';
import 'package:gstudent/common/define_item/item_inventory.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/home/cubit/home_cubit.dart';
import 'package:gstudent/home/views/dialog_buy_item.dart';
import 'package:gstudent/home/views/dialog_info_item.dart';

class InventoryDialog extends StatefulWidget {
  HomeCubit cubit;
  int userClanId;
  InventoryDialog({this.cubit,this.userClanId});

  @override
  State<StatefulWidget> createState() => InventoryDialogState(cubit: this.cubit,userClanId: this.userClanId,);
}

class InventoryDialogState extends State<InventoryDialog> with TickerProviderStateMixin {
  HomeCubit cubit;
  int userClanId;
  InventoryDialogState({this.cubit,this.userClanId});

  List<ItemInventory> invens;
  List<ItemStore> storage;
  TabController _tabController;
  int tab = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    loadImage();
    loadInvent();
    loadStore();
  }

  loadInvent() async {
    var res = await cubit.getInventory();
    if (res != null) {
      setState(() {
        invens = res.where((element) => element.quantity > 0).toList();
      });
    }
  }

  loadStore() async {
    var store = await cubit.getItemsStore();
    if (store != null) {
      setState(() {
        storage = store;
      });
    }
  }

  AssetImage bgDialog;

  loadImage() {
    bgDialog = AssetImage('assets/game_bg_info_clan.png');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bgDialog, context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Positioned(
            child: Stack(
              children: [
                Positioned(
                  top: 16,
                  right: MediaQuery.of(context).size.width > 600 ? 60 : 16,
                  left:MediaQuery.of(context).size.width > 600 ? 60 : 16,
                  bottom: 0,
                  child: Image(
                    image: bgDialog,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.1,
                  bottom: 36,
                  right: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width*0.15: 48,
                  left:  MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width*0.15 :48,
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          height: 12,
                        ),
                      Container(
                        height: 40,
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                                  height: 40,
                                  decoration: tab == 0?  BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            HexColor("#fecd45"),
                                            HexColor("#fba416"),
                                          ],
                                          begin:Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0.0, 1.0],
                                          tileMode: TileMode.clamp),
                                      border: Border.all(width: 0.5)
                                  ) : BoxDecoration(
                                      color: HexColor("f9ce95"),
                                      border: Border.all(width: 0.5)
                                  ),
                                  child:GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          tab = 0;
                                        });
                                      },
                                      child: Center(child:  textpaintingBoldBase('Kho đồ', 14, tab == 0 ? Colors.white : Colors.black, tab == 0 ? Colors.black : Colors.transparent, 2),)),
                                )),
                            Expanded(
                                child: Container(
                                  height: 40,
                                  decoration: tab == 1?  BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            HexColor("#fecd45"),
                                            HexColor("#fba416"),
                                          ],
                                          begin:Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0.0, 1.0],
                                          tileMode: TileMode.clamp),
                                      border: Border.all(width: 0.5)
                                  ) : BoxDecoration(
                                      color: HexColor("f9ce95"),
                                      border: Border.all(width: 0.5)
                                  ),
                                  child:GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          tab = 1;
                                        });
                                      },
                                      child: Center(child:  textpaintingBoldBase('Cửa hàng', 14, tab == 1 ? Colors.white : Colors.black, tab == 1 ? Colors.black : Colors.transparent, 2),)),
                                )),

                          ],
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: HexColor("#ffcd93"),
                        ),
                      ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                          child: Image(
                            image: AssetImage('assets/images/ellipse.png'),
                          ),
                        ),
                        Expanded(
                          child: tab == 0 ?  invens != null && invens.length > 0
                              ? contentInvenItem()
                              : Center(
                            child: Text('Chưa có vật phẩm',style: ThemeStyles.styleNormal(),),
                          ) :
                            storage != null && storage.length > 0
                                ? contentStoreItem()
                                : Center(
                              child: Text('Chưa có vật phẩm',style: ThemeStyles.styleNormal()),
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
              height: MediaQuery.of(context).size.height * 0.1,
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
                height: 48,
                width: 48,
              ),
            ),
            top:  32,
            right:MediaQuery.of(context).size.width > 600 ? 60: 16,
          ),
        ],
      ),
    );
  }

  contentInvenItem() {
    return Column(
      children: [
        Text('Vật phẩm của bạn',style: ThemeStyles.styleBold(),),
        Expanded(
            child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(invens.length, (index) {
            return GestureDetector(
              onTap: () => showDialogAsync(ItemInventoryDialog(
                item: invens[index],
                userClanId: this.userClanId,
                isInventory: true
              )),
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
                        child: textpaintingNormal(
                          invens[index].item.name, invens[index].item.name.length > 18 ?10 :  12,
                             HexColor("#00e6f4"),
                            Colors.black,
                           2,
                          textAlign: TextAlign.center
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

  contentStoreItem() {
    return Column(
      children: [
        Expanded(
            child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(storage.length, (index) {
            return GestureDetector(
              onTap: () => showDialogAsync(BuyItemInventoryDialog(
                item: storage[index],
              )),
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
                              image: AssetImage(inventoryDefineImage(storage[index].id)),
                              fit: BoxFit.fill,
                            ),
                          ),
                        )),
                    Positioned(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(2, 4, 2, 4),
                        decoration: BoxDecoration(color: HexColor("#99000000")),
                        child:
                        textpaintingBase(
                            storage[index].name,12,
                            HexColor("#00e6f4"),
                            Colors.black,
                            2,
                            textAlign: TextAlign.center
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

  void showDialogAsync(view) async {
    var res = await showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
            alignment: Alignment.center,
            child: BlocProvider<HomeCubit>.value(
              value: cubit,
              child: view,
            ));
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );

    if (res != null && res == true) {
      loadInvent();
    }
  }

  decoration() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
      height: 1.0,
      decoration: BoxDecoration(color: HexColor("#b0a27b")),
    );
  }

  textpaintingNormal(String s, double fontSize, Color textColor, Color borderColors,double borderSize, {TextAlign textAlign = TextAlign.justify }) {
    return OutlinedText(
      text: Text(s,
        overflow: TextOverflow.fade,
        textAlign: textAlign,
        style: ThemeStyles.styleNormal(textColors: textColor,font: fontSize),

      ),
      strokes: [
        OutlinedTextStroke(color: borderColors, width: borderSize),
      ],
    );
  }
}
