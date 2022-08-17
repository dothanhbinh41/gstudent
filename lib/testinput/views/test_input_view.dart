import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/testinput/cubit/testinput_cubit.dart';
import 'package:gstudent/testinput/cubit/testinput_state.dart';
import 'package:gstudent/testinput/services/testinput_services.dart';
import 'package:gstudent/testinput/views/do_test_input_view.dart';

class TestInputView extends StatefulWidget {
  int id;
  TestInputView({this.id});

  @override
  State<StatefulWidget> createState() => TestInputViewState(id: this.id);
}

class TestInputViewState extends State<TestInputView> {
  int id;
  TestInputViewState({this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<TestInputCubit, TestInputState>(
      listener: (context, state) {
        if (state is IeltsState) {
          navigateDoTest("ielts");
        } else if (state is ToeicState) {
          navigateDoTest("toeic");
        } else if (state is CommunicateState) {
          navigateDoTest("giaotiep");
        }
      },
      child: Stack(
        children: [
          Positioned(
              top: 0,
              right: 0,
              left: 0,
              bottom: 0,
              child: Image(
                image: AssetImage('assets/game_bg_arena.png'),
                fit: BoxFit.fill,
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  'KIỂM TRA ĐẦU VÀO',
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
              Expanded(child: Container()),
              ielts(),
              Expanded(child: Container()),
              toeic(),
              Expanded(child: Container()),
              communicate(),
              Expanded(child: Container()),
            ],
          ),
          Positioned(child:    GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              child: Image(
                image: AssetImage(
                    'assets/images/game_button_back.png'),
                height: 48,
                width: 48,
              ),
            ),
          ),top: 8,
            left: 8,),
        ],
      ),
    ));
  }

  infoType() async {
    // await showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return ResultTestInput();
    //     });
  }

  ielts() {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<TestInputCubit>(context).emit(IeltsState());
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
        height: 100,
        decoration: BoxDecoration(
            color: HexColor("#fff6d8"),
            border: Border.all(color: HexColor("#e0bf8d"))),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
              width: 100,
              child: Center(
                child: Text(
                  'IELTS',
                  style: TextStyle(
                      color: HexColor("#b20009"),
                      fontFamily: 'SourceSerifPro',
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Container(
              width: 1,
              margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
              decoration: BoxDecoration(color: Colors.black),
            ),
            Expanded(
                child: Container(
              child: Column(
                children: [
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
                      child: Text(
                        'Listening',
                        style: TextStyle(
                            fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400 ,fontSize: 14),
                      )),
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
                      child: Text(
                        'Reading',
                        style: TextStyle(
                            fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400, fontSize: 14),
                      )),
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
                      child: Text(
                        'Speaking',
                        style: TextStyle(
                            fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400,fontSize: 14),
                      )),
                  Container(
                      child: Text(
                    'Writing',
                    style: TextStyle(
                        fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400 ,fontSize: 14),
                  ))
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ))
          ],
        ),
      ),
    );
  }

  toeic() {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<TestInputCubit>(context).emit(ToeicState());
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
        height: 100,
        decoration: BoxDecoration(
            color: HexColor("#fff6d8"),
            border: Border.all(color: HexColor("#e0bf8d"))),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
              width: 100,
              child: Center(
                child: Text(
                  'TOEIC',
                  style: TextStyle(
                      color: HexColor("#b20009"),
                      fontFamily: 'SourceSerifPro',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              width: 1,
              margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
              decoration: BoxDecoration(color: Colors.black),
            ),
            Expanded(
                child: Container(
              child: Column(
                children: [
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
                      child: Text(
                        'Listening',
                        style: TextStyle(
                            fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400, fontSize: 14),
                      )),
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
                      child: Text(
                        'Reading',
                        style: TextStyle(
                            fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400, fontSize: 14),
                      )),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ))
          ],
        ),
      ),
    );
  }

  communicate() {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<TestInputCubit>(context).emit(CommunicateState());
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
        height: 100,
        decoration: BoxDecoration(
            color: HexColor("#fff6d8"),
            border: Border.all(color: HexColor("#e0bf8d"))),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
              width: 120,
              child: Center(
                child: Text(
                  'Communication',
                  style: TextStyle(
                      color: HexColor("#b20009"),
                      fontFamily: 'SourceSerifPro',
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              width: 1,
              margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
              decoration: BoxDecoration(color: Colors.black),
            ),
            Expanded(
                child: Container(
              child: Column(
                children: [
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
                      child: Text(
                        'Listening',
                        style: TextStyle(
                            fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400, fontSize: 14),
                      )),
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
                      child: Text(
                        'Reading',
                        style: TextStyle(
                            fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400, fontSize: 14),
                      )),
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
                      child: Text(
                        'Speaking',
                        style: TextStyle(
                            fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400, fontSize: 14),
                      )),
                  Container(
                      child: Text(
                    'Writing',
                    style: TextStyle(
                        fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400, fontSize: 14),
                  ))
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ))
          ],
        ),
      ),
    );
  }

  navigateDoTest(String type) {
    var service = GetIt.instance.get<TestInputService>();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => BlocProvider.value(
        value: TestInputCubit(services: service),
        child: DoTestInputView(
          type: type,id: this.id,
        ),
      ),
    ));
  }
}
