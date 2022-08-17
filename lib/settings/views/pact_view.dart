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
                          "HIỆP ƯỚC",
                          style: TextStyle(fontSize: 20, color: HexColor("#2e2e2e"), fontFamily: 'UTMThanChienTranh'),
                        ),
                      ),
                      ellipse(),
                      Container(
                        margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Text(
                          'Tôi bước vào Học viện này với một mong muốn thay đổi bản thân mình, giỏi hơn và xuất sắc hơn chính mình trước đây. Để khóa học hiệu quả nhất, tôi xác nhận sẽ tham gia vào Team và đồng hành, giúp đỡ các đồng đội của mình.\n'
                              'Trong khóa học, có những thành viên cố gắng, nỗ lực cho kết quả của bản thân và của Team. Bên cạnh đó, cũng có những thành viên và có những thời điểm không nghiêm túc, nỗ lực. Vì thế tôi đồng ý với những hình phạt và phần thưởng của Học viện cho tất cả thành viên.\n'
                              'Bằng mong muốn cải thiện bản thân, tôi sẽ thực hiện các nguyên tắc về thời gian, về kết quả, về học nhóm và chấp nhận chịu những hình phạt trong Sách địa ngục khi để HP về bằng 0.\n'
                              'Bằng năng lực đặc biệt mà chỉ tôi có trong team, tôi sẽ sử dụng nó để bảo vệ cho bản thân, cho team và để nhận được nhiều phần quà giá trị.\n'
                              'Bằng năng lực ngoại ngữ mà tôi đã học được, tôi sẽ sử dụng nó để vượt qua những bài Kiểm tra, những buổi ôn luyện tại các Phòng luyện, những trận Thi đấu tại đấu trường và leo lên đỉnh vinh quang tại các Giải đấu sự kiện thường niên và siêu sự kiện trong năm.\n'
                              'Tôi đã sẵn sàng!',
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
                        'ĐỒNG Ý',
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
                  'Thoát',
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
          'Ngày',
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
//             'Kí tên',
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
