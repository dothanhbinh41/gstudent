
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gstudent/api/dtos/Home/item_store.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/common/controls/text_painting.dart';
import 'package:gstudent/common/define_item/item_inventory.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/home/cubit/home_cubit.dart';
import 'package:gstudent/main.dart';

class BuyItemInventoryDialog extends StatefulWidget {
  ItemStore item;

  BuyItemInventoryDialog({this.item, });

  @override
  State<StatefulWidget> createState() =>
      BuyItemInventoryDialogState(item: this.item,);
}

class BuyItemInventoryDialogState extends State<BuyItemInventoryDialog> {
  ItemStore item;

  BuyItemInventoryDialogState({this.item});

  HomeCubit cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of<HomeCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 320,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              left: 0,
              child: Image(
                image: AssetImage('assets/bg_notification.png'),
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
                top: 8,
                bottom: 16,
                right: 8,
                left: 8,
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'VẬT PHẨM',
                        style: ThemeStyles.styleBold(font: 24,textColors: HexColor("#2e2e2e"))

                      ),
                    ),
                    Container(
                      child: Image(
                        image: AssetImage('assets/images/eclipse_login.png'),
                        fit: BoxFit.fill,
                      ),
                      margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                    ),
                    Container(
                        height: 60,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              bottom: 0,
                              right: 0,
                              child: Image(
                                image: AssetImage(
                                    'assets/images/bg_info_item_inven.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(24, 0, 24, 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(4, 4, 4, 4),
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: HexColor("#9a8c93")),
                                        color: HexColor("#262626")),
                                    height: 56,
                                    width: 56,
                                    child: Image(
                                      image: AssetImage(
                                          inventoryDefineImage(item.id)),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(item.name,
                                              style: ThemeStyles.styleBold(font: 12)),
                                          Container(
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Giá: " +
                                                      item.price.toString(),
                                                  style: ThemeStyles.styleNormal(font: 12),
                                                ),
                                                Image(
                                                  height: 20,
                                                  width: 20,
                                                  image: AssetImage(
                                                      'assets/images/game_xu.png'),
                                                ),
                                                Expanded(child: Container()),
                                                // Text(
                                                //   "Lượt Sd: "+item.canSell.toString(),
                                                //   style: TextStyle(
                                                //       color: Colors.black,
                                                //       fontSize: 12,
                                                //       fontFamily:
                                                //       'SourceSerifPro-Bold'),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            ),
                          ],
                        )),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
                        child: Text(item.description,
                            style: ThemeStyles.styleNormal(font: 12)),
                      ),
                    ),
                    Container(
                      child: Image(
                        image: AssetImage('assets/images/ellipse.png'),
                        fit: BoxFit.fill,
                      ),
                      margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                    ),
                    GestureDetector(
                      onTap: () {
                          buyItem();
                      },
                      child: Container(
                        height: 48,
                        child: ButtonYellowSmall('MUA'),
                      ),
                    )
                  ],
                )),
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
              top: 16,
              right: 4,
            ),
          ],
        ),
      ),
    );
  }


  void buyItem() async {
    var res = await cubit.buyItemStore(item.id);
    if (res != null) {
      toast(context, res.message);
      Navigator.of(context).pop(true);
    } else {
      toast(context, res.message);
    }
  }
}
