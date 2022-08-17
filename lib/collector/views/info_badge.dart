import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/common/colors/HexColor.dart';

class InfoBadgeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => InfoBadgeViewState();
}

class InfoBadgeViewState extends State<InfoBadgeView> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height*0.6,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              bottom: 0,
              child: Image(
                image: AssetImage('assets/game_bg_dialog_create_medium.png'),
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              top: 24,
              right: 24,
              left: 24,
              bottom: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      'THÔNG TIN HUY HIỆU',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: 'UTMThanChienTranh'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Image(
                      image: AssetImage('assets/images/ellipse.png'),
                    ),
                  ),
                  Center(
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            border: Border.all(color: HexColor("#31281b"), width: 2)),
                        padding: EdgeInsets.all(2),
                        child: Stack(
                          children: [
                            Image(
                              image: AssetImage('assets/map_master.png'),
                              fit: BoxFit.fill,
                            ),
                            Container(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  'Map Master',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'SourceSerifPro'),
                                ))
                          ],
                        ),
                      )),
               Expanded(
                 child: Column(children: [
                   Container(
                     child: Text('Giới thiệu huy hiệu'),
                     margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
                   ),
                   Container(
                     child: Text('Giới thiệu huy hiệu'),
                     margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
                   ),
                   Container(
                     child: Text('Giới thiệu huy hiệu'),
                     margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
                   ),
                 ],mainAxisAlignment: MainAxisAlignment.center,),
               ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Image(
                      image: AssetImage('assets/images/ellipse.png'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 56,
                      child: Stack(
                        children: [
                          Image(
                            image: AssetImage('assets/images/button_verify_register.png'),
                            fit: BoxFit.fill,
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            left: 0,
                            bottom: 0,
                            child: Center(
                              child: Text(
                                "MỞ KHÓA",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: HexColor("#e3effa"),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "SourceSerifPro"),
                              ),),
                          )
                        ],
                      ),
                    ),
                  )
                ],

              ),
            )
          ],
        ),
      ),
    );
  }
}
