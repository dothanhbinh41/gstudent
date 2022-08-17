import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/Home/item_inventory.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/common/define_item/item_inventory.dart';
import 'package:gstudent/common/styles/theme_text.dart';

class ItemInventoryTrainingDialog extends StatefulWidget {
  ItemInventory item;
  int userClanId;

  ItemInventoryTrainingDialog({this.item, this.userClanId});

  @override
  State<StatefulWidget> createState() => ItemInventoryTrainingDialogState(item: this.item, userClanId: this.userClanId);
}



class ItemInventoryTrainingDialogState extends State<ItemInventoryTrainingDialog> {
  ItemInventory item;
  int userClanId;
  ItemInventoryTrainingDialogState({this.item, this.userClanId});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/bg_notification.png'),
          fit: BoxFit.fill,
        )),
        height: 340,
        child: Stack(
          children: [
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
                        style: ThemeStyles.styleBold(textColors: HexColor("#2e2e2e"), font: 24),
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
                                image: AssetImage('assets/images/bg_info_item_inven.png'),
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
                                    decoration: BoxDecoration(border: Border.all(color: HexColor("#9a8c93")), color: HexColor("#262626")),
                                    height: 56,
                                    width: 56,
                                    child: Image(
                                      image: AssetImage(inventoryDefineImage(item.itemsId)),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.item.name, style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'SourceSerifPro')),
                                      Container(
                                        child: Row(
                                          children: [
                                            Text(
                                              "Giá: " + item.item.price.toString(),
                                              style: ThemeStyles.styleNormal(font: 12),
                                            ),
                                            Image(
                                              height: 20,
                                              width: 20,
                                              image: AssetImage('assets/images/game_xu.png'),
                                            ),
                                            Expanded(child: Container()),
                                            Text(
                                              "Lượt Sd: " + item.quantity.toString(),
                                              style: ThemeStyles.styleNormal(font: 12),
                                            ),
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
                        child: Text(item.item.description, style: ThemeStyles.styleNormal(font: 12)),
                      ),
                    ),
                    Container(
                      child: Image(
                        image: AssetImage('assets/images/ellipse.png'),
                        fit: BoxFit.fill,
                      ),
                      margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                    ),
                    Container(
                      height: 48,
                      child: GestureDetector(
                          onTap: () => useItem(),
                          child: ButtonYellowSmall(
                            "ÁP DỤNG",
                            textColor: HexColor("#e3effa"),
                          )),
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

  void useItem() async {
    Navigator.of(context).pop(true);
  }
}
