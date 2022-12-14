import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gstudent/api/dtos/Authentication/login_response.dart';
import 'package:gstudent/api/dtos/Course/course.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/home/cubit/home_cubit.dart';
import 'package:gstudent/main.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';
// import 'package:signature/signature.dart';

class PactView extends StatefulWidget {
  int userClanId;
  int classroomId;

  PactView({this.userClanId, this.classroomId});

  @override
  State<StatefulWidget> createState() => PactViewState(userClanId: this.userClanId, classroomId: this.classroomId);
}

class PactViewState extends State<PactView> {
  int userClanId;
  int classroomId;

  PactViewState({this.userClanId, this.classroomId});

  bool isSignature = false;
  ApplicationSettings applicationSettings;
  // SignatureController _controller;
  HomeCubit cubit;
  List<CourseModel> data;

  CourseModel currentCourse;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of(context);
    applicationSettings = GetIt.instance.get<ApplicationSettings>();
    // _controller = SignatureController(
    //   penStrokeWidth: 1,
    //   penColor: Colors.black,
    //   exportBackgroundColor: Colors.transparent,
    //   onDrawStart: () {
    //     setState(() {
    //       isSignature = true;
    //     });
    //   },
    //   onDrawEnd: () => print('onDrawEnd called!'),
    // );
    loadUser();
  }

  loadUser() async {
    showLoading();
    data = await applicationSettings.getRoute();
    hideLoading();
    if(data.where((element) => element.classroomId == this.classroomId).isNotEmpty){
      setState(() {
        currentCourse = data.where((element) => element.classroomId == this.classroomId).first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Container(
          child: Stack(
            children: [
              Positioned(
                child: Image(
                  image: AssetImage('assets/game_bg_dialog_create_long.png'),
                  fit: BoxFit.fill,
                ),
                top: 0,
                right: 8,
                left: 8,
                bottom: 0,
              ),
              Positioned(
                top: 36,
                right: 56,
                left: 56,
                bottom: 32,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Text(
                          "HI???P ?????C",
                          style: TextStyle(fontSize: 20, color: HexColor("#2e2e2e"), fontFamily: 'UTMThanChienTranh'),
                        ),
                      ),
                      ellipse(),
                      Container(
                        margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Text(
                          'T??i b??????c va??o Ho??c vi????n na??y v????i m????t mong mu????n thay ??????i ba??n th??n mi??nh, gio??i h??n va?? xu????t s????c h??n chi??nh mi??nh tr??????c ????y. ?????? kho??a ho??c hi????u qua?? nh????t, t??i xa??c nh????n se?? tham gia va??o Team va?? ??????ng ha??nh, giu??p ?????? ca??c ??????ng ??????i cu??a mi??nh.\n'
                              'Trong kho??a ho??c, co?? nh????ng tha??nh vi??n c???? g????ng, n???? l????c cho k????t qua?? cu??a ba??n th??n va?? cu??a Team. B??n ca??nh ??o??, cu??ng co?? nh????ng tha??nh vi??n va?? co?? nh????ng th????i ??i????m kh??ng nghi??m tu??c, n???? l????c. Vi?? th???? t??i ??????ng y?? v????i nh????ng hi??nh pha??t va?? ph????n th??????ng cu??a Ho??c vi????n cho t????t ca?? tha??nh vi??n.\n'
                              'B????ng mong mu????n ca??i thi????n ba??n th??n, t??i se?? th????c hi????n ca??c nguy??n t????c v???? th????i gian, v???? k????t qua??, v???? ho??c nho??m va?? ch????p nh????n chi??u nh????ng hi??nh pha??t trong Sa??ch ??i??a ngu??c khi ?????? HP v???? b????ng 0.\n'
                              'B????ng n??ng l????c ??????c bi????t ma?? chi?? t??i co?? trong team, t??i se?? s???? du??ng no?? ?????? ba??o v???? cho ba??n th??n, cho team va?? ?????? nh????n ????????c nhi????u ph????n qua?? gia?? tri??.\n'
                              'B????ng n??ng l????c ngoa??i ng???? ma?? t??i ??a?? ho??c ????????c, t??i se?? s???? du??ng no?? ?????? v??????t qua nh????ng ba??i Ki????m tra, nh????ng bu????i ??n luy????n ta??i ca??c Pho??ng luy????n, nh????ng tr????n Thi ??????u ta??i ??????u tr??????ng va?? leo l??n ??i??nh vinh quang ta??i ca??c Gia??i ??????u s???? ki????n th??????ng ni??n va?? si??u s???? ki????n trong n??m.\n'
                              'T??i ??a?? s????n sa??ng!',
                          style: TextStyle(fontFamily: 'UTMThanChienTranh', fontWeight: FontWeight.w400, fontSize: 14, color: Colors.black),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                        height: 120,
                        child: Row(
                          children: [
                            Expanded(child: Container()),
                            Expanded(
                                child: Container(
                              child: Image(
                                image: AssetImage('assets/images/icon_edutalk_pact.png'),
                                fit: BoxFit.fitHeight,
                              ),
                            )),
                            Expanded(child: time()),
                          ],
                        ),
                      ),
                      ellipse(),
                    ],
                  ),
                ),
              )
            ],
          ),
        )),
        Container(
          child: Center(
            child: currentCourse != null && currentCourse.clan.isSigned == false
                ? GestureDetector(
                    onTap: () => sign(),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                      height: 48,
                      child: ButtonYellowSmall(
                        '?????NG ??',
                      ),
                    ),
                  )
                : GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                height: 48,
                child: ButtonGraySmall(
                  'Tho??t',
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  ellipse() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Image(
        image: AssetImage('assets/images/ellipse.png'),
      ),
    );
  }

  time() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          'Ng??y',
          style: TextStyle(fontFamily: 'SourceSerifPro', color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
        ),
      FittedBox(child:   Text(
        DateTime.now().day.toString() + '/' + DateTime.now().month.toString() + '/' + DateTime.now().year.toString(),
        style: TextStyle(fontFamily: 'SourceSerifPro', color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16),
      ),)
      ],
    );
  }

  sign() async {
    showLoading();
    var res = await cubit.signed(userClanId);
    hideLoading();
    if (res != null && res.error == false) {
      setState(() {
        currentCourse.clan.isSigned = true;
      });
      data.forEach((element) {
        if (element.classroomId == this.classroomId) {
          element = currentCourse;
        }
      });
      applicationSettings.saveRoute(data);
      toast(context, res.message);
      Navigator.of(context).pop();
    }
  }

// sign() {
//   return Stack(
//     children: [
//       Column(
//         children: [
//           Text(
//             'K?? t??n',
//             style: TextStyle(
//                 fontFamily: 'SourceSerifPro',
//                 fontWeight: FontWeight.w700,
//                 color: Colors.black,
//                 fontSize: 18),
//           ),
//           Signature(
//             height: 90,
//             width: MediaQuery.of(context).size.width / 4,
//             controller: _controller,
//             backgroundColor: Colors.transparent,
//           ),
//         ],
//       ),
//       Positioned(
//         child: Visibility(
//             visible: isSignature,
//             child: GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     isSignature = false;
//                     _controller.clear();
//                   });
//                 },
//                 child: Icon(
//                   Icons.close,
//                   color: Colors.red,
//                   size: 24,
//                 ))),
//         top: 0,
//         left: 0,
//       ),
//     ],
//   );
// }
}
