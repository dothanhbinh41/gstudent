// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gstudent/clan/views/find_clan_view.dart';
// import 'package:gstudent/home/cubit/home_cubit.dart';
// import 'package:gstudent/home/cubit/home_state.dart';
// import 'package:gstudent/map/cubit/map_cubit.dart';
// import 'package:gstudent/map/cubit/map_state.dart';
// import 'package:page_view_indicator/page_view_indicator.dart';
//
// import 'create_clan_dialog.dart';
//
// class JoinClanDialog extends StatefulWidget {
//   HomeCubit cubit;
//   int classroomId;
//
//   JoinClanDialog({this.classroomId, this.cubit});
//
//   @override
//   State<StatefulWidget> createState() =>
//       JoinClanDialogState(classroomId: this.classroomId, cubit: this.cubit);
// }
//
// class JoinClanDialogState extends State<JoinClanDialog> {
//   HomeCubit cubit;
//   int classroomId;
//
//   JoinClanDialogState({this.classroomId, this.cubit});
//
//   PageController controller = PageController(
//     initialPage: 0,
//     viewportFraction: 0.8,
//   );
//
//   bool isFindClan = false;
//   int page = 0;
//   final pageIndexNotifier = ValueNotifier<int>(0);
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     loadImage();
//   }
//
//   List<AssetImage> options = [
//     AssetImage("assets/img_create_clan.png"),
//     AssetImage("assets/img_join_clan.png"),
//   ];
//   AssetImage bgDialog;
//
//
//   @override
//   void didChangeDependencies() {
//     // TODO: implement didChangeDependencies
//     super.didChangeDependencies();
//     precacheImage(bgDialog, context);
//     options.forEach((element) {
//       precacheImage(element, context);
//     });
//   }
//
//   loadImage() {
//     bgDialog = AssetImage('assets/game_bg_dialog_create_medium.png');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<HomeCubit, HomeState>(
//       listener: (context, state) {},
//       child: Dialog(
//         child: isFindClan
//             ? FindClanDialog(
//                 cubit: cubit,
//               )
//             : Container(
//                 color: Colors.transparent,
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child: Stack(
//                         children: [
//                           Positioned(
//                             child: Image(
//                               image: bgDialog,
//                               fit: BoxFit.fill,
//                             ),
//                             top: 0,
//                             right: 0,
//                             left: 0,
//                             bottom: 0,
//                           ),
//                           Positioned(
//                             top: 48,
//                             right: 42,
//                             left: 42,
//                             bottom: 36,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.stretch,
//                               children: [
//                                 Container(
//                                   height: MediaQuery.of(context).size.width / 2,
//                                   margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
//                                   child: PageView.builder(
//                                     itemBuilder: (context, index) {
//                                       return item(index);
//                                     },
//                                     itemCount: options.length,
//                                     scrollDirection: Axis.horizontal,
//                                     controller: controller,
//                                     onPageChanged: (value) {
//                                       setState(() {
//                                         page = value;
//                                         pageIndexNotifier.value = value;
//                                       });
//                                     },
//                                   ),
//                                 ),
//                                 Expanded(
//                                     child: ListView(
//                                   children: [
//                                     page == 0
//                                         ? Text(
//                                             "Hành trình thu thập đầy đủ các nguyện liệu, thần khí, đan dược, mảnh bản đồ, ngọc thần,... hay chinh phục những con boss khổng lồ là những hành trình rất là gian nan. Chính vì vậy các bạn - những thần dân thuộc các dòng tộc khác nhau, sở hữu trong mình những năng lực khác nhau cần tập hợp lại với nhau thành một nhóm, cùng nhau kề vai sát cánh vượt qua những thử thách khó khăn trên.",
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',),
//                                           )
//                                         : Text(
//                                             "Tham gia thách đấu và chiến thắng tất cả Team khác để đạt Top rank thách đầu là mục tiêu mà bất cứ Team nào cũng muốn đạt được bởi thứ hạng này không chỉ đem lại cho bạn danh vọng mà còn mang tới rất nhiều phần thưởng giá trị lớn.\nGửi thách đấu tới các Team khác, tham gia thách đầu, cùng đồng đội giành chiến thắng và đánh bại đội đối phương là hành trình bạn khẳng định bản thân trong suốt khóa học tại hòn đảo này",
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',))
//                                   ],
//                                 ))
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                     Container(
//                       child: pageviewIndicator(),
//                       margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
//                     ),
//                     GestureDetector(
//                       onTap: () => checkButton(),
//                       child: Container(
//                         margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
//                         width: 160,
//                         height: 64,
//                         child: Stack(
//                           children: [
//                             Center(
//                               child: Image(
//                                 image: AssetImage(
//                                     'assets/images/button_small_green.png'),
//                               ),
//                             ),
//                             Center(
//                               child: page == 0
//                                   ? Text(
//                                       "XIN GIA NHẬP",
//                                       style: TextStyle(
//                                           fontSize: 20,
//                                           color: Colors.white,
//                                           fontFamily: 'SourceSerifPro',
//                                           fontWeight: FontWeight.w700),
//                                     )
//                                   : Text(
//                                       "TẠO CLAN",
//                                       style: TextStyle(
//                                           fontSize: 20,
//                                           color: Colors.white,
//                                           fontFamily: 'SourceSerifPro',
//                                           fontWeight: FontWeight.w700),
//                                     ),
//                             )
//                           ],
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//         backgroundColor: Colors.transparent,
//       ),
//     );
//   }
//
//   item(index) {
//     return AnimatedBuilder(
//       animation: controller,
//       builder: (context, child) {
//         double value = 1;
//         if (controller.position.haveDimensions) {
//           value = controller.page - index;
//           value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
//         }
//         return Center(
//           child: SizedBox(
//             child: Image(
//               image: options[index],
//               fit: BoxFit.fill,
//             ),
//             height: Curves.easeInOut.transform(value) *
//                 MediaQuery.of(context).size.width /
//                 2,
//             width: Curves.easeInOut.transform(value) *
//                 MediaQuery.of(context).size.width /
//                 2,
//           ),
//         );
//       },
//     );
//   }
//
//   pageviewIndicator() {
//     return PageViewIndicator(
//       pageIndexNotifier: pageIndexNotifier,
//       length: 2,
//       normalBuilder: (animationController, index) => ScaleTransition(
//         scale: CurvedAnimation(
//           parent: animationController,
//           curve: Curves.ease,
//         ),
//         child: Icon(
//           Icons.radio_button_off,
//           color: Colors.white,
//         ),
//       ),
//       highlightedBuilder: (animationController, index) => ScaleTransition(
//         scale: CurvedAnimation(
//           parent: animationController,
//           curve: Curves.ease,
//         ),
//         child: Icon(
//           Icons.radio_button_on,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
//
//   checkButton() async {
//     if (page == 1) {
//       var res = await await showDialog(
//         context: context,
//         builder: (context) => BlocProvider<HomeCubit>.value(
//             value: cubit, //
//             child: CreateClanDialog(
//               classroomId: this.classroomId,
//               cubit: this.cubit,
//             )),
//       );
//       if (res != null) {
//         Navigator.of(context).pop(res);
//       }
//     } else {
//       setState(() {
//         isFindClan = true;
//       });
//     }
//   }
// }
