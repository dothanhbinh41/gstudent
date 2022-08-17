import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/text_painting.dart';

class UnlockIsLandDialog extends StatefulWidget {
  int idIsland;

  UnlockIsLandDialog({this.idIsland});

  @override
  State<StatefulWidget> createState() =>
      UnlockIsLandDialogState(idIsland: this.idIsland);
}

class UnlockIsLandDialogState extends State<UnlockIsLandDialog> {
  int idIsland;

  UnlockIsLandDialogState({this.idIsland});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadImage();
  }

  AssetImage bgDialog;
  AssetImage bgUnlockIsland;
  AssetImage island;

  loadImage() {
    bgDialog = AssetImage('assets/bg_notification_large.png');
    bgUnlockIsland = AssetImage('assets/bg_unlock_island.png');
    island = AssetImage(localImageByIdIsland(idIsland));
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bgDialog, context);
    precacheImage(bgUnlockIsland, context);
    precacheImage(island, context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Stack(
          children: [
            Positioned(
              child: Image(
                image: bgDialog,
                fit: BoxFit.fill,
              ),
              top: 0,
              right: 1,
              left: 1,
              bottom: 0,
            ),
            Positioned(
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Mở khóa đảo",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "SourceSerifPro",
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Image(
                      image: AssetImage('assets/images/eclipse_login.png'),
                    ),
                  ),
                  Container(
                    height: 200,
                    child: Stack(
                      children: [
                        Positioned(
                          child: Image(
                            image: bgUnlockIsland,
                            fit: BoxFit.fill,
                          ),
                          top: 0,
                          right: 0,
                          left: 0,
                          bottom: 0,
                        ),
                        Positioned(
                          child: Image(
                            image: island,
                            fit: BoxFit.fill,
                          ),
                          top: 0,
                          right: 0,
                          left: 0,
                          bottom: 0,
                        ),
                        Positioned(
                          child: ShaderMask(
                            shaderCallback: (rect) {
                              return LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.transparent,
                                  Colors.black,
                                  Colors.transparent
                                ],
                              ).createShader(
                                  Rect.fromLTRB(rect.width, 0, 0, rect.height));
                            },
                            blendMode: BlendMode.dstIn,

                          ),
                          bottom: 0,
                          height: 24,
                          right: 0,
                          left: 0,
                        ),
                        Positioned(
                          child: Row(
                            children: [
                              Expanded(child: Container()),
                              Container(
                                margin:EdgeInsets.fromLTRB(0, 0, 8, 0),
                                child: Icon(
                                  Icons.check,
                                  color: HexColor("#40ff71"),
                                ),
                              ),
                              textpaintingBoldBase('Bạn đã mở khóa thành công',14,
                                  HexColor("#40ff71"), Colors.black, 3),
                              Expanded(child: Container()),
                            ],
                          ),
                          bottom: 0,
                          height: 24,
                          right: 0,
                          left: 0,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Image(
                      image: AssetImage('assets/images/ellipse.png'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Center(
                      child: Text(
                        'Bạn có muốn xem lại thành tích của mình?',
                        style: TextStyle(
                          fontSize: 12,fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro'
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      width: 160,
                      height: 56,
                      child: Stack(
                        children: [
                          Center(
                            child: Image(
                              image: AssetImage(
                                  'assets/images/button_small_blue.png'),
                            ),
                          ),
                          Center(
                              child: textpaintingBoldBase(
                                  "XEM REPORT", 18,
                                  HexColor("#ffffff"),
                                  HexColor("#457bae"),
                                3
                                 ))
                        ],
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                      )),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Center(
                      child: Text(
                        'Hoặc bạn có thể vào đảo mới ngay',
                        style: TextStyle(
                          fontSize: 12,fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro'
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      width: 160,
                      height: 56,
                      child: Stack(
                        children: [
                          Center(
                            child: Image(
                              image: AssetImage(
                                  'assets/images/button_small_green.png'),
                            ),
                          ),
                          Center(
                              child: textpaintingBoldBase(
                                  "VÀO ĐẢO", 18,
                                  HexColor("#ffffff"),
                                  HexColor("#2a7223"),3
                                 ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
              top: 16,
              bottom: 16,
              right: 24,
              left: 24,
            )
          ],
        ),
      ),
    );
  }


  String localImageByIdIsland(int idIsland) {
    switch (idIsland) {
      case 1:
        return 'assets/athena_land.png';
      case 2:
        return 'assets/amazonica_land.png';
      case 3:
        return 'assets/isukha_land.png';
      case 4:
        return 'assets/arcint_land.png';
      case 5:
        return 'assets/edo_land.png';
      case 6:
        return 'assets/fly_land.png';
    }
  }


}
