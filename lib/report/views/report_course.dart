import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/common/colors/HexColor.dart';

class ReportCourseView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ReportCourseViewState();
}

class ReportCourseViewState extends State<ReportCourseView> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          Container(height: 56,),
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  child: Image(
                    image: AssetImage(
                        'assets/images/game_bg_dialog_create_char.png'),
                    fit: BoxFit.fill,
                  ),
                  top: 8,
                  right: 16,
                  left: 16,
                  bottom: 8,
                ),
                Positioned(
                  top: 48,
                  right: 64,
                  left: 64,
                  bottom: 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Text(
                          "ĐẢO THÔNG THÁI",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'UTMThanChienTranh'),
                        ),
                      ),
                      Center(
                        child: Text(
                          "IELTS 3.5",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontFamily: 'UTMThanChienTranh'),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
                        child: Image(
                          image: AssetImage('assets/images/ellipse.png'),
                        ),
                      ),
                      Container(
                        child: Text('Điểm Kiểm Tra',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SourceSerifPro',
                              fontWeight: FontWeight.w700,
                            )),
                      ),
                      Container(
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: 'Giữa kỳ:',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',color: Colors.black87)),
                            TextSpan(
                                text: '100/100',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',
                                    color: Colors.red)),
                          ]),
                        ),
                      ),
                      Container(
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: 'Cuối kỳ:',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',color: Colors.black87)),
                            TextSpan(
                                text: '100/100',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',
                                    color: Colors.red)),
                          ]),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                        height: 1,
                        color: Colors.black87,
                      ),
                      Row(children: [
                        Column(
                          children: [
                            Text(
                              "Học hành hội",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: "SourceSerifPro",
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Text(
                                  "Chức danh: ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  "General",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Tỉ lệ thắng đấu trường: ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',
                                  ),
                                ),
                                Text(
                                  "16%",
                                  style: TextStyle(
                                      color: HexColor("#335fa0"),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,  fontFamily: 'SourceSerifPro',
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Số MVP: ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',
                                  ),
                                ),
                                Text(
                                  "80%",
                                  style: TextStyle(
                                      color: HexColor("#335fa0"),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "SourceSerifPro"
                                  ),
                                )
                              ],
                            ),
                          ],
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                        ),
                        Expanded(child: Container()),
                        Container(
                          height: 56,
                          width: 56,
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration(
                              border: Border.all(color: HexColor("#241c13"),width: 1),
                              borderRadius: BorderRadius.circular(28)
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                color: HexColor("#49331e"),
                                borderRadius: BorderRadius.circular(26)
                            ),
                            child: Center(child: Text('122/200',style: TextStyle(color: Colors.white,fontSize: 12,  fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',),),),
                          ),
                        )
                      ],),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                        height: 1,
                        color: Colors.black87,
                      ),

                      Container(
                        margin: EdgeInsets.fromLTRB(0, 4, 0, 8),
                        child: Text("Số liệu tại đảo thông thái",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'SourceSerifPro',
                                fontWeight: FontWeight.bold)),
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                                height: 72,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                      color: HexColor("#31281b"),
                                      width: 3),
                                ),
                                child: Container(
                                    margin: EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            HexColor("#33291b"),
                                            HexColor("#67512f"),
                                          ],
                                        )
                                    ),
                                    child: Column(
                                      children: [
                                        Text("Đi học",style:TextStyle(color: HexColor("#aba079") ,fontSize: 14,     fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',)),
                                        Text("5/6",style:TextStyle(color: HexColor("#f8e8b0"),fontWeight: FontWeight.bold,fontSize: 16,    fontFamily: 'SourceSerifPro',))
                                      ],
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                    )
                                ),
                              )),
                          Container(width: 4.0,),
                          Expanded(
                              child: Container(
                                height: 72,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                      color: HexColor("#31281b"),
                                      width: 3),
                                ),
                                child: Container(
                                    margin: EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            HexColor("#33291b"),
                                            HexColor("#67512f"),
                                          ],
                                        )
                                    ),
                                    child: Column(
                                      children: [
                                        Text("Bài tập",style:TextStyle(color: HexColor("#aba079") ,fontSize: 14,    fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',)),
                                        Text("15/16",style:TextStyle(color: HexColor("#f8e8b0"),fontWeight: FontWeight.bold,fontSize: 16,    fontFamily: 'SourceSerifPro',))
                                      ],
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                    )
                                ),
                              )),
                          Container(width: 4.0,),
                          Expanded(
                              child: Container(
                                height: 72,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                      color: HexColor("#31281b"),
                                      width: 3),
                                ),
                                child: Container(
                                    margin: EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            HexColor("#33291b"),
                                            HexColor("#67512f"),
                                          ],
                                        )
                                    ),
                                    child: Column(
                                      children: [
                                        Text("Something",style:TextStyle(color: HexColor("#aba079"), fontSize: 14 ,    fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',)),
                                        Text("15/16",style:TextStyle(color: HexColor("#f8e8b0"),fontWeight: FontWeight.bold,fontSize: 16  ,  fontFamily: 'SourceSerifPro',))
                                      ],
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                    )
                                ),
                              ))
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                        height: 1,
                        color: Colors.black87,
                      ),
                      Row(
                        children: [
                          Text(
                            "Luyện từ vựng",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: 'SourceSerifPro',
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(child: Container()),
                          Text("Xem tất cả",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: HexColor("#335fa0"),
                                  fontFamily: 'SourceSerifPro',
                                  fontWeight: FontWeight.bold,
                                  decoration:
                                  TextDecoration.underline)),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Tổng số từ thu tập được :",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',
                              color: Colors.black, ),
                          ),

                          Text("120",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',
                                color: HexColor("#335fa0"),  )),
                        ],
                      ),
                      Expanded(child: Container()),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
                        child: Image(
                          image: AssetImage('assets/images/ellipse.png'),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            flex: 9,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
              height: 56,
              child: Center(
                child: Stack(
                  children: [
                    Positioned(
                      child: Image(
                        image: AssetImage('assets/images/button_small_green.png'),
                      ),
                      top: 0,
                      right: 0,
                      left: 0,
                      bottom: 0,
                    ),
                    Center(
                      child: Text(
                        "Đóng",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'SourceSerifPro'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(height: 24,),
        ],
      ),
    );
  }
}
