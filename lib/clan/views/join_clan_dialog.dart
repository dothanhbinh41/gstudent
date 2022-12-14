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
//                                             "H??nh tr??nh thu th???p ?????y ????? c??c nguy???n li???u, th???n kh??, ??an d?????c, m???nh b???n ?????, ng???c th???n,... hay chinh ph???c nh???ng con boss kh???ng l??? l?? nh???ng h??nh tr??nh r???t l?? gian nan. Ch??nh v?? v???y c??c b???n - nh???ng th???n d??n thu???c c??c d??ng t???c kh??c nhau, s??? h???u trong m??nh nh???ng n??ng l???c kh??c nhau c???n t???p h???p l???i v???i nhau th??nh m???t nh??m, c??ng nhau k??? vai s??t c??nh v?????t qua nh???ng th??? th??ch kh?? kh??n tr??n.",
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',),
//                                           )
//                                         : Text(
//                                             "Tham gia th??ch ?????u v?? chi???n th???ng t???t c??? Team kh??c ????? ?????t Top rank th??ch ?????u l?? m???c ti??u m?? b???t c??? Team n??o c??ng mu???n ?????t ???????c b???i th??? h???ng n??y kh??ng ch??? ??em l???i cho b???n danh v???ng m?? c??n mang t???i r???t nhi???u ph???n th?????ng gi?? tr??? l???n.\nG???i th??ch ?????u t???i c??c Team kh??c, tham gia th??ch ?????u, c??ng ?????ng ?????i gi??nh chi???n th???ng v?? ????nh b???i ?????i ?????i ph????ng l?? h??nh tr??nh b???n kh???ng ?????nh b???n th??n trong su???t kh??a h???c t???i h??n ?????o n??y",
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
//                                       "XIN GIA NH???P",
//                                       style: TextStyle(
//                                           fontSize: 20,
//                                           color: Colors.white,
//                                           fontFamily: 'SourceSerifPro',
//                                           fontWeight: FontWeight.w700),
//                                     )
//                                   : Text(
//                                       "T???O CLAN",
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
